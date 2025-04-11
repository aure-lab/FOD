program ej7;
const valoralto= 9999;
type

alumno = record
    cod:integer;
    ape:String;
    nom:String;
    cursadas:integer;
    finales:integer;
end;

cursadas = record
    codAlum:integer;
    codMat:integer;
    anio:integer;
    resul:boolean;
end;

dias = 1..31;
meses = 1..12;

fecha = record
    dia:dias;
    mes:meses;
    anio:integer;
end;

finales = record
    codAlum:integer;
    codMat:integer;
    fec:fecha;
    nota:integer;
end;

maestro = file of alumno;
detaleCursada = file of cursadas;
detalleFinal = file of finales;

procedure leerCursada(var det:detaleCursada; var rdet:cursadas);
begin
    if(not eof(maestro))then
        read(det,rdet)
    else
        rdet.codAlum:=valoralto;
end;

procedure leerFinal(var det:detalleFinal; var rdet:finales);
begin
    if(not eof(maestro))then
        read(det,rdet)
    else
        rdet.codAlum:=valoralto;
end;

function minimo (cod1,cod2:integer):integer;
begin
    if(cod1<cod2)then
        return cod1
    else
        return cod2;
end;

procedure buscarCursada (var det:detallecursada; var rdet:cursadas; var cursadas:integer; codAlum:integer);
begin
    cursadas:=0;               
    while((rdet.codAlum=codAlum)) do begin
        if(det.resul)then
            cursadas:= cursadas+1;
        leerCursada(det,rdet);
    end;
end;

procedure buscarFinal (var det:detalleFinal; var rdet:finales; var finales:integer; codAlum:integer);
begin
    finales:=0;
    while(rdet.codAlum=codAlum)do begin
        if(rdet.nota>=4)then
            finales:= finales + 1;
        leerFinal(det,rdet);
    end;
end;

procedure actualizarMae (var mae:maestro; var detCur:detaleCursada; var detFin:detalleFinal);
var
    codAlum:integer;
    rdetFin:finales;
    rdetCur:cursadas;
    cusadas,finales:integer;
begin
    reset(mae); reset(detCur); reset(detFin);
    leerCursada(detCur,rdetCur);
    leerFinal(detCur,rdetCur);
    codAlum:=minimo(rdetCur.codAlum,rdetFin.codAlum);
    while((codAlum<>valoralto))do begin
        leerMae(mae,rmae);
        while(rmae.codAlum<>codAlum)do
            read(mae,rmae);
        buscarCursada(detCur,rdetCur,cursadas,codAlum);
        buscarFinal(detFin,rdetFin,finales,codAlum);
        seek(mae,filepos(mae)-1);
        rmae.cursadas:= rmae.cursadas + cursadas;
        rmae.finales:= rmae.finales + finales;
        write(mae,rmae);
        minimo(rdetCur.codAlum,rdetFin.codAlum);
    end;
    close(mae); close(detCur); close(detFin);
end;

        