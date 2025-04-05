program ej6;
const valoralto = 9999;
type

rango = 1..10;

casos = record 
    codLoc:integer;
    codCepa:integer;
    act:integer;
    nue:integer;
    recu:integer;
    fall:integer;
end;

info = record
    cas:casos;
    nomLoc:String;
    nomCepa:String;
end;

maestro: file of info;
detalle: file of casos;

vdetalle = array [rango] of detalle;
vregistro = array [rango] of casos;

procedure leer (var det:detalle; var rdet:casos);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet:=valoralto;
end;

function esMinimo (codLocMin, codCepaMin, codLoc, codCepa:integer):boolean;
begin
    if(codCepaMin<codLoc)then
        return false
    else if (codCepaMin<codCepa)then
        return false;
    return true;
end;

procedure minimo (var det:vdetalle; var rdet:vregistro; var min:casos);
var
    i,j:rango;
    minLoc,minCepa:integer;
begin
    minLoc:=valoralto;
    for i:= 1 to 10 do begin
        if(esMinimo(minLoc, minCepa, rdet[i].codLoc, rdet[i].codCepa)) then begin
            j:=i;
            minLoc:=rdet[i].codLoc;
            minCepa:=rdet[i].codCepa;
        end;
    end;
    min:= rdet[j];
    leer(det[i],rdet[i]);
end;

procedure iniciar (var cas,rdet:casos);
begin
    cas.codLoc:=rdet.codLoc;
    cas.codCepa:=cas.codCepa;
    cas.nue:=0;
    cas.recu:=0;
    cas.fall:=0;
end;

procedure actualizarMae (var mae:maestro; var det:vdetalle);
var
    rdet:vregistro;
    rmae:maestro;
    i:rango;
    min:info;
    total:integer;
    cas:casos;
begin
    reset(mae);
    for i:= 1 to 10 do begin
        reset(det[i]);
        leer(det[i],rdet[i]);
    end;

    minimo(det,rdet,min);
    total:=0;
    while(min.codLoc<>valoralto) do begin
        read(mae,rmae);
        iniciar(cas,min);
        while((cas.codLoc=min.codLoc)and(cas.codCepa=min.codCepa))do begin
            cas.fall:= cas.fall + min.fall;
            cas.recu:= cas.recu + min.recu;
            cas.nue:= cas.nue + min.nue;
            cas.act:= min.act; //tiene que ir actualizandose siempre??
            minimo(det,rdet,min);
        end;
        while((mae.codLoc<>cas.codLoc)and(mae.codCepa<>min.codCepa))do //tengo que evaluar si existe en el detalle??
            read(mae,rmae);
        seek(mae,filepos(mae)-1);
        write(mae,cas);
    end;
    close(mae);
    for i:= 1 to 10 do
        close(rdet[i]);
end;