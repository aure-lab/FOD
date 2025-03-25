program ej7;

type
novelas = record
    cod:integer;
    nom:String;
    gen:String;
    pre: real;
end;

archivo = file of novelas;

procedure copiarABinario (var arch:archivo; var texto: text);
var
    nov:novelas;
begin
    rewrite(arch);
    reset(texto);
    while(not(eof(texto)))do begin
        with nov do begin 
            readln(texto, cod,pre,gen);
            readln(texto, nom);
        end;
        write(arch,nov);
    end;
    close(arch);
    close(texto);
end;

procedure leer (var nov:novelas);
begin
    write('ingrese el codigo de la novela: ');
    readln(nov.cod);
    write('ingrese el nombre de la novela: ');
    readln(nov.nom);
    write('ingrese el genero de la novela: ');
    readln(nov.gen);
    write('ingrese el precio de la novela: ');
    readln(nov.pre);
end;

procedure agregar (var arch:archivo);
var
    nov: novelas;
begin
    reset(arch);
    seek(arch, filesize(arch));
    leer(nov);
    write(arch,nov);
    close(arch);
end;

procedure modificar (var arch:archivo; codigo:integer; precio: real);
var
    nov:novelas;
begin
    reset(arch);
    if(not(eof(arch)))then begin
        read(arch,nov);
        while((not(eof(arch))) and (codigo<>nov.cod))do
            read(arch,nov);
        if(nov.cod=codigo)then begin
            nov.pre := precio;
            seek(arch,filepos(arch)-1);
            write(arch,nov);
        end;
    end;
    close(arch);
end;

procedure imprimir (var arch:archivo);
var
    nov:novelas;
begin
    reset(arch);
    while(not(eof(arch)))do begin
        read(arch,nov);
        writeln('------> CODIGO: ', nov.cod);
        writeln('Nombre: ', nov.nom);
        writeln('Genero: ',nov.gen);
        writeln('Precio: ', nov.pre);
    end;
    close(arch);
end;

var
    texto:text;
    arch:archivo;
    op:integer;
    precio:real;
    codigo:integer;
    nombre:String;
begin
    write('ingrese el nombre del archivo: ');
    readln(nombre);
    assign(arch,nombre);
    assign(texto,'novelas.txt');
    copiarABinario(arch,texto);
    writeln('seleccione que operacion desea realizar: ');
    writeln('1. modificar una novela');
    writeln('2. agregar una novela');
    writeln('3. imprimir el archivo');
    writeln('0. salir');
    readln(op);
    while (op <> 0) do begin
        case op of
            1: begin
                write('ingrese el codigo de la novela a modificar: ');
                readln(codigo);
                write('ingrese el nuevo precio: ');
                readln(precio);
                modificar(arch,codigo,precio);
                end;
            2:
                agregar(arch);
            3:
                imprimir(arch);
            else
                writeln('debe introducir una opcion valida');
        end;
        writeln('seleccione que operacion desea realizar: ');
        writeln('1. modificar una novela');
        writeln('2. agregar una novela');
        writeln('0. salir');
        readln(op);
    end;
end.
            