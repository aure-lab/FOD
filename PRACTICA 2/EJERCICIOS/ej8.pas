program ej8;
const valoralto=9999;
type
yerba = record
    cod:integer;
    nom:String[21];
    cantHab:integer;
    cantKg:integer;
end;

mes = record
    cod:integer;
    cantKg:integer;
end;

maestro = file of yerba;
detalle = file of mes;

rango = 1..16;
vdetalle = array [rango] of detalle;
vregistro= array [rango] of mes;

procedure leer(var det:detalle; var rdet:mes);
begin
    if(not eof(det))then
        read(det,rdet);
    else
        rdet.cod:=valoralto;
end;

procedure minimo (var det:vdetalle; var rdet:vregistro; var min:mes);
var
    i,j:rango;
    codMin:integer;
begin
    codMin:=valoralto;
    for i:= 1 to 16 do begin
        if (codMin>rdet[i].cod)then begin
            codMin:=rdet[i].cod;
            j:=i;
        end;
    end;
    min:=rdet[j];
    leer(det[j],rdet[j]);
end;

procedure actualizarMaestro (var mae:maestro; var det:vdetalle);
var
    rdet:vregistro;
    total:integer;
    i:rango;
    min:mes;
    cod:integer;
begin
    for i:= 1 to 16 do begin
        reset(det[i]);
        leer(det[i],rdet[i]);
    end;
    reset(mae);
    minimo(det,rdet,min);
    while(min.cod<>valoralto)do
        read(mae,rmae);
        total:=0;
        cod:= min.cod;
        while(min.cod = cod)do begin
            total:= total + min.cantKg;
            minimo(det,rdet,min);
        end;
        while(rmae.cod<>cod)do
            read(mae,rmae);
        rmae.cantKg:= rmae.cantKg + total;
        if(rmae.cantKg>10000)then begin
            writeln('la provincia',rmae.nom, ' nro ', rmae.cod,' ha consumido mas de 10000 kg historicamente');
            writeln('el promedio de yerba consumida es ', (rmae.cantKg/rmae.cantHab));
        end;
        seek(mae, filepos(mae)-1);
        write(mae, rmae);
end;
