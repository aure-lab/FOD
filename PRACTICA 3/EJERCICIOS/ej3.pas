program ej3;
const valoralto = 9999;

type
string20 = string[20];
novelas = record
    cod:integer;
    gen:string20;
    nom:string20;
    dur:string[8]; //ej: 03:20:14
    dir:string20;
    pre:real;
end;

archivo = file of novelas;

procedure leerArch (var arch:archivo; var nov:novelas);
begin
    if (not eof(arch))then
        read(arch,nov)
    else
        nov.cod:=valoralto;
end;

procedure leer (var nov:novelas);
begin
    with nov do begin
        write('Ingrese el codigo de la novela: ');
        readln(cod);
        write('Ingrese el genero: ');
        readln(gen);
        write('Ingrese el nombre: ');
        readln(nom);
        write('Ingrese la duracion en el siguente formato-->(hor:min:seg): ');
        readln(dur);
        write('Ingrese el director: ');
        readln(dir);
        write('Ingrese el precio: ');
        readln(pre);
    end;
end;

procedure cargar (var arch:archivo);
var
    seguir:char;
    nov:novelas;
begin
    rewrite(arch);
    seguir:= 'y';
    nov.cod:=0;
    write(arch,nov);
    while(seguir = 'y')do begin
        leer(nov);
        write(arch,nov);
        write('Desea seguir con la carga? (y/n)');
        readln(seguir);
    end;
    close(arch);
end;

procedure alta (var arch:archivo; nov2:novelas);
var
    nov:novelas;
begin
    reset(arch);
    leerArch(arch, nov);
    if((nov.cod<>0)and(nov.cod<>valoralto))then begin
        seek(arch,(nov.cod*-1));
        leerArch(arch,nov);
        seek(arch,filepos(arch)-1);
        write(arch,nov2);
        seek(arch,0);
        write(arch,nov)
    end
    else begin
        seek(arch, filesize(arch));
        write(arch,nov2);
    end;
end;

procedure modificar (var arch:archivo; nov:novelas);
var
    rarch:novelas;
begin
    reset(arch);
    leerArch(arch,rarch);
    while((rarch.cod<>valoralto)and(rarch.cod<>nov.cod))do
        leerArch(arch,rarch);
    if(rarch.cod = nov.cod)then begin
        seek(arch,filepos(arch)-1);
        write(arch,nov);
    end;
    close(arch);
end;

procedure baja (var arch:archivo; cod:integer);
var
    nov,aux:novelas;
begin
    reset(arch);
    leerArch(arch,aux);
    leerArch(arch,nov);
    while((nov.cod<>valoralto) and (nov.cod<>cod))do
        leerArch(arch,nov);
    if(nov.cod = cod)then begin
        seek(arch,filepos(arch)-1);
        nov.cod:= filepos(arch)*-1;
        write(arch,aux);
        seek(arch,0);
        write(arch,nov);
    end;
end;

procedure menu ();
begin
    writeln('///////////////////MENU DE OPCIONES///////////////////');
    writeln('-Ingrese que accion desea realizar:');
    writeln('1. Crear un archivo de novelas.');
    writeln('2. Dar de alta una novela.');
    writeln('3. Modificar una novela.');
    writeln('4. Dar de baja una novela.');
    writeln('5. Exportar el archivo a formato .TXT.');
    writeln('0. Cerrar.')
end;

procedure exportarTXT (var arch:archivo; var texto:text);
var nov:novelas;
begin
    reset(arch);
    rewrite(texto);
    leerArch(arch,nov);
    while(nov.cod<>valoralto)do begin
        with nov do begin
            writeln(texto, cod,' ',gen);
            writeln(texto, nom);
        end;
        leerArch(arch,nov);
    end;
    close(texto);
    close(arch);
end;

var
    arch:archivo;
    texto:text;
    nom:string;
    op:byte;
    nov:novelas;
    cod:integer;
begin
    write('Introduzca el nombre del archivo: ');
    readln(nom);
    assign(arch,nom);
    menu();
    readln(op);
    while(op<>0)do begin
        case op of
            1: cargar(arch);
            2:
                begin
                    leer(nov);
                    alta(arch,nov);
                end;
            3:
                begin
                    leer(nov);
                    modificar(arch,nov);
                end;
            4:
                begin
                    write('Ingrese el codigo de la novela a eliminar: ');
                    readln(cod);
                    baja(arch, cod);
                end;
            5:
                begin
                    write('Ingrese el nombre del texto: ');
                    readln(nom);
                    assign(texto, nom);
                    exportarTXT(arch,texto);
                end
            else
                writeln('Opcion invalida');
        end;
        menu();
        readln(op);
    end;
end.