program ej4;
const valoralto = 9999;
type
reg_flor = record
    nombre: String[45];
    codigo: integer;
end;

tArchFlores = file of reg_flor;

procedure leer (var a:tArchFlores; var ra:reg_flor);
begin
    if(not eof(a))then  
        read(a,ra)
    else
        ra.codigo:= valoralto;
end;

procedure agregarFlor (var a: tArchFlores ; ra: reg_flor);
var
    aux,ra1:reg_flor;
begin
    reset(a);
    leer(a,ra1);
    if(ra1.codigo<>0)then begin
        seek(a,(ra1.codigo*-1));
        read(a,ra1);
        aux:=ra1;
        seek(a,filepos(a)-1);
        write(a,ra);
        seek(a,0);
        write(a,aux)
    end
    else begin
        seek(a,filesize(a));
        write(a,ra);
    end;
    close(a);
end;

procedure listar (var a:tArchFlores; var texto:text);
var
    ra:reg_flor;
    codigo:integer;
begin
    reset(a);
    rewrite(texto);
    leer(a,ra);
    while(ra.codigo<>valoralto)do begin
        if(ra.codigo>0)then 
            with ra do writeln(texto,codigo,' ', nombre);
        leer(a,ra);
    end;
    close(a);
    close(texto);
end;

function iguales (flor1,flor2:reg_flor):boolean;
begin
    iguales:= (flor1.codigo=flor2.codigo) and (flor1.nombre = flor2.nombre);
end;

procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var ra,aux:reg_flor;
begin
    reset(a);
    leer(a,aux);
    leer(a,ra);
    while((ra.codigo<>valoralto)and (not(iguales(ra,flor))))do
        leer(a,ra); 
    if(iguales(ra,flor))then begin
        seek(a,filepos(a)-1);
        ra.codigo:= filepos(a)*-1;
        write(a,aux);
        seek(a,0);
        write(a,ra);
    end;
    close(a);
end;

procedure leerReg (var ra:reg_flor);
begin
    readln(ra.nombre);
    readln(ra.codigo);
end;

var
    a:tArchFlores; texto:text;
    ra:reg_flor;
begin
    assign(a,'archivo');
    assign(texto, 'algo.txt');
    rewrite(a);
    ra.codigo:=0;
    write(a,ra);
    close(a);
    leerReg(ra);
    while(ra.codigo<>777)do begin
        agregarFlor(a,ra);
        leerReg(ra);
    end;
    leerReg(ra);
    eliminarFlor(a,ra);
    leerReg(ra);
    agregarFlor(a,ra);
    leerReg(ra);
    eliminarFlor(a,ra);
    listar(a,texto);
end.