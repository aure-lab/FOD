program ONG;
const valoralto = 9999;

carencias = record
    codPcia:integer;
    nomPcia:string[21];
    codLoc:integer;
    nomLoc:string[30];
    sinLuz:integer;
    sinGas:integer;
    chapa:integer;
    sinAgua:integer;
    sinSani:integer;
end;

avances = record
    codPcia:integer;
    codLoc:integer;
    conLuz:integer;
    construidas:integer;
    conAgua:integer;
    conGas:integer;
    sani:integer;
end;

maestro = file of carencias;
detalle = file of avances;

rango = 1..10;
vdetalle = array [rango] of detalle;
vregistro = array [rango] of avances;

procedure leer (var det:detalle; var rdet:avances);
begin
    if(not eof(det))then
        read(det,rdet)
    else begin
        rdet.codLoc:=valoralto;
        rdet.codPcia:=valoralto;
    end;
end;

procedure minimo (var det:vdetalle; var rdet:vregistro; var min:avances);
var
    codMinLoc,codMinPcia:integer;
    i,j:rango;
begin
    codMinLoc:=valoralto;
    codMinPcia:=valoralto;
    for i:= 1..10 do begin
        if((codMinPcia>rdet[i].codPcia)or((codMinPcia=rdet[i].codMinPcia)and(codMinLoc>rdet[i].codLoc))) then begin
            codMinLoc:=rdet[i].codLoc;
            codMinPcia:=rdet.codPcia;
            j:=i;
        end;
    end;
    min:=rdet[j];
    leer(det[j],rdet[j])
end;

procedure actualizar (var mae:maestro; var det:vdetalle; var tot:integer);
var
    rdet:vregistro;
    min:avances;
    rmae:carencias;
    i:rango;
begin
    reset(mae);
    fot i:= 1 to 10 do begin
        reset(det[i]);
        leer(det[i],rdet[i]);
    end;
    minimo(det,rdet,min);
    while(not eof(mae))do begin
        read(mae,rmae);
        if((rmae.codLoc=min.codLoc)and(rmae.codPcia=min.codPcia))then begin
            rmae.sinLuz:= rmae.sinLuz-min.conLuz;
            rmae.sinGas:= rmae.sinGas-min.conLuz;
            rmae.sinAgua:= rmae.sinAgua-min.sinAgua;
            rmae.sinSani:= rmae.sinSani-min.sani;
            rmae.chapa:= rmae.chapa-min.construidas;
            minimo(det,rdet,min);
        end;
        if(rmae.chapa=0)then
            tot:= tot + 1;
        seek(mae,filepos(mae)-1);
        write(mae,rmae);
    end;
    close(mae);
    for i:= 1 to 10 do
        close(det[i]);
end;

var
    tot:integer;
    mae:maestro;
    det:vdetalle;
    i:rango;
begin
    tot:=0;
    assign(mae,'maestro');
    for i := 1 to 10 do
        assign(det[i], 'det'+str(i));
    actualizar(mae,det,tot);
    write('la cantiadad de localidades sin viviendas de chapa son: ', tot);
end.


