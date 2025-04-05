program ej3;
const
    valoralto=9999;
type

producto = record
    cod:integer;
    nom:String;
    des:String;
    stock:integer;
    min:integer;
    pre:real;
end;

info = record
    cod:integer;
    cant:integer;
end;

maestro = file of producto;
detalle = file of info;

vdet = array [1..30] of detalle;
vreg = array [1..30] of info;

procedure leer (var det:detalle; var rdet:info);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet.cod:=valoralto;
end;

procedure minimo (var det:vdet; var rdet: vreg; var min:info);
var
    i,j:integer;
    minimo:integer;
begin
    codmin:=999;
    for i:= 1 to 30 do begin
        if (rdet[i].cod<minimo) then begin
            codmin:=rdet[i].cod;
            j:=i;
        end;
    end;
    min:=rdet[j];
    leer(det[j],rdet[j]);
end;

procedure actualizarMaestro (var mae:maestro; var rdet:vreg; var det: vdet);
var
    min:info;
    i:integer;
    rmae:producto;
begin
    reset(mae);
    for i:= 1 to 30 do begin
        reset(det[i]);
        leer(det[i],rdet[i]);
    end;
    minimo(det,rdet,min);
    while(min.cod<>valoralto)do begin
        read(mae,rmae);
        while(not eof(mae) and (min.cod<>rmae.cod))do
            read(mae,rmae);
        while(rmae.cod=rdet.cod)do begin
            rmae.stock:=rmae.stock-min.cant;
            minimo(det,rdet,min);
        end;
        seek(mae,filepos(mae)-1);
        write(mae,rmae);
        end;
    end;
    close(mae);
    for i:= 1 to 30 do 
        close(rdet[i]);
end;

procedure exportarTXT (var mae:maestro; var texto:text);
var
    prod:producto;
begin
    reset(mae);
    rewrite(texto);
    while(not(eof(mae)))do begin
        read(mae,prod);
        if(prod.stock<prod.min)then begin
            with prod do begin
                writeln(texto, nom);
                writeln(texto, des);
                writeln(texto, stock,' ',pre);
            end;
        end;
    end;
    close(mae);
    close(texto);
end;
