program ej2;
const valoralto = 9999;
type
string30 = string[30];
asistente = record
    nro:integer;
    apeYNom:string30;
    email:string30;
    tel:integer;
    dni:longint;
end;

archivo = file of asistente;

procedure leerArch (var arch:archivo; var asis:asistente);
begin
    if(not eof(arch))then
        read(arch,asis)
    else
        asis.nro:=valoralto;
end;

procedure leer (var asis:asistente);
begin
    write('Ingrese el nro de asistente: ');
    readln(asis.nro);
    write('Ingrese el apellido y nombre (Maximo 30 caracteres): ');
    readln(asis.apeYNom);
    write('Ingrese el e-mail(Maximo 30 caracteres): ');
    readln(asis.email);
    write('Ingrese el telefono: ');
    readln(asis.tel);
    write('Ingrese el DNI: ');
    readln(asis.dni);
end;

procedure generar (var arch:archivo);
var
    asis:asistente;
    seguir:char;
begin
    rewrite(arch);
    seguir:='y';
    while(seguir = 'y')do begin
        leer(asis);
        write(arch,asis);
        write('Desea seguir agregando asistentes? (y/n)');
        readln(seguir);
    end;
    close(arch);
end;

procedure imprimir (var arch:archivo);
var
    asis:asistente;
begin
    reset(arch);
    leerArch(arch,asis);
    while(asis.nro <> valoralto) do begin
        if(asis.apeYNom[1]<>'@')then begin
            writeln('--------->NRO: ', asis.nro);
            writeln('Apellido y nombre: ',asis.apeYNom);
        end;
        leerArch(arch,asis);
    end;
    close(arch);
end;

procedure eliminar (var arch:archivo);
var
    asis:asistente;
begin
    reset(arch);
    leerArch(arch,asis);
    while(asis.nro <> valoralto)do begin
        if(asis.nro < 1000) then begin
            asis.apeYNom:='@'+asis.apeYNom;
            seek(arch,filepos(arch)-1);
            write(arch,asis);
        end;
        leerArch(arch,asis);
    end;
    close(arch);
end;

var
    arch:archivo;
begin
    assign(arch, 'archivo.dat');
    generar(arch);
    imprimir(arch);
    eliminar(arch);
    imprimir(arch);
end.