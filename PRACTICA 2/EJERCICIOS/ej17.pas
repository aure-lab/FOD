program Chacomus;
const valoralto=9999;
type 
motos = record
    cod:integer;
    nom:string[20];
    des:string[50];
    modelo:string[30];
    marca:string[20];
    stock:integer;
end;

mensual = record
    cod:integer;
    pre:real;
    fec:longint;
end;

//dispongo con que cada venta va a haber el stock suficiente como para venderla??

maestro = file of motos;
detalle = file of mensual;

rango = 1..10;
vdetalle = array [rango] of detalle;
vregistro = array [rango] of mensual;

procedure  leer (var det:detalle; var rdet:mensual);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet.cod:=valoralto;
end;

procedure minimo (var det:vdetalle; var rdet:vregistro; var min:mensual);
var
    i,j:rango;
    codMin:integer;
begin
    codMin:=valoralto;
    for i:= 1 to 10 do begin
        if(codMin>rdet[i].cod)then begin
            codMin:=rdet[i].cod;
            j:=i;
        end;
    min:= rdet[j];
    read(det[j],rdet[j]);
end;

procedure actualizar (var mae:maestro; var det:vdetalle; var codMax:integer);
var
    i:rango;
    tot,max,cod:integer;
    rmae:motos;
    rdet:vregistro;
    min:mensual;
begin
    for i:= 1 to 10 do begin
        reset(det[i]);
        leer(det[i],rdet[i]);
    end;
    reset(mae);
    max:=-1;
    minimo(det,rdet,min);
    while(rdet.cod<>valoralto)do begin
        cod:=rdet.cod;
        read(mae,rmae);
        while(rmae.cod<>cod)do 
            read(mae,rmae);
        while(rdet.cod=cod)do begin
            tot:= tot + 1;
            rmae.stock:= rmae.stock - 1;
        end;
        seek(mae,filepos(mae)-1);
        write(mae,rmae);
        if(max<tot)then begin
            max:=tot;
            codMax:=cod;
        end;
    end;
end;

var 
    mae:maestro;
    det:vdetalle;
    i:rango;
    codMax:integer;
begin
    for i:= 1 to 10 do 
        assign(det[i],'det'+str(i));
    assign(mae,'maestro');
    codMax:=valoralto;
    actualizar(mae,det,codMax);
    if(codMax<>valoralto)then
        writeln('el codigo de la moto mas vendida fue: ',codMax)
    else
        writeln('archivo detalle vacio');
end.


            