program ej13;

const valoralto = 9999;
type
string30 = string[30];

logs = record
    nro:integer;
    nomUsu:string30;
    nom:string30;
    ape:string30;
    cant:integer;
end;

correo = record
    nro:integer;
    dest:string30;
    cuer:string;
end;

maeestro = file of logs;
detalle = file of correo;

procedure leer (var det:detalle; var rdet:correo);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet.nro:=valoralto;
end;

procedure actualizarYExportar(var mae:maeestro; var det:detalle; var texto:text);
var
    rmae:logs;
    rdet:correo;
    cant:integer;
    nro:integer;
begin
    reset(det); reset(mae); rewrite(texto);
    leer(det,rdet);
    while(not eof(mae))do begin
        read(mae,rmae);
        nro:=rmae.nro;
        cant:=0;
        while(rdet.nro = nro)do begin
            cant:= cant + 1;
            leer(det,rdet);
        end;
        if(cant<>0)then begin
            rmae.cant:= rmae.cant + cant;
            seek(mae,filepos(mae)-1);
            write(mae,rmae);
        end;
        with rmae do 
            writeln(texto,nro,' ', cant);
    end;
    close(det); close(mae); close(texto);     
end;