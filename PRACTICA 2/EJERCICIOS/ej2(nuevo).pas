program ej2;
const valoralto=9999;
type
producto = record
    cod: integer;
    nom: String;
    pre: real;
    stock: integer;
    min: integer;
end;

venta = record 
    cod: integer;
    cant: integer;
end;

maestro = file of producto;
detalle = file of venta;

procedure leer (var det:detalle var rdet: detalle);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet.cod:=valoralto;
end;

procedure actualizarMae (var mae: maestro var det:detalle);
var
    rmae:producto;
    rdet:venta;
    cod:integer;
    total:integer;
begin
    reset(mae);
    reset(det);
    leer(det,rdet);
    while(rdet.cod<>valoralto)do begin
        cod:=rdet.cod;
        read(mae,rmae);
        total:=0;
        while(rdet.cod=cod)do begin
            total:= total + 1;
            leer(det,rdet);
        end;
        while(rmae.cod<>cod) do
            read(mae,rmae);
        seek(mae,filepos(mae)-1);
        rmae.stock:= rmae.stock - total;
        write(mae,rmae);
    end;
    close(mae);
    close(det);
end;

procedure listar (var texto:text, var mae:maestro);
var
    prod:producto;
begin
    reset(mae);
    rewrite(texto);
    while(not eof(mae))do begin
        read(mae,prod);
        if(prod.stock<prod.min)then
            with prod do writeln (texto, cod, ' ',pre, ' ', stock, ' ', min, ' ', nom);
    end;
    close(mae);
    close(texto);
end;

var
    mae:maestro;
    det:detalle;
    texto:text;
    op:byte;
begin
    assign(mae,'maestro');
    writeln('informe la operacion que desea realizar: 1.Actualizar Maestro|2.listar a TXT');
    readln(op);
    case op of:
        1: begin 
                assign(det,'detalle');
                actualizarMae(mae,det);
            end;
        2: begin
                assign(texto,'stock_minimo.txt');
                listar(texto,mae);
            end
        else
            writeln('Ingrese una opcion valida');
end.


