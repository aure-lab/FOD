program ej9;
const valoralto = 9999;
type
cliente = record
    cod:integer;
    nom:string[50];
    ape:string[50];
end;

meses = 1..12;
formato = record
    cli:cliente;
    mes:meses;
    anio:integer;
    monto:real;
end;

maestro = file of formato;

procedure leer (var mae:maestro; var rmae:formato);
begin
    if(not eof(mae))then
        read(mae,rmae)
    else
        rmae.cli.cod:=valoralto;

procedure procesar(var mae:maestro);
var 
    totmes,tot:real;
    ventas:integer;
    mes:meses;
    anio:integer;
    cod:integer;
    rmae:formato;
begin
    reset(mae);
    ventas:=0;
    leer(mae,rmae);
    while(mae.cli.cod<>valoralto)do begin
        writeln('---------> CODIGO: ',rmae.cli.cod);
        writeln('Nombre completo: ',rmae.cli.nom, ' ', rmae.cli.ape);
        tot:=0;
        cod:= rmae.cli.cod;
        while(cod = rmae.cli.cod)do begin
            anio:= rmae.anio;
            while((cod = rmae.cli.cod)and(anio = rmae.anio))do begin
                totmes:=0;
                mes:= rmae.mes;
                while((cod = rmae.cli.cod)and(anio = rmae.anio)and(mes = rmae.mes))do begin
                    totmes:= totmes + rmae.monto;
                    leer(mae,rmae);
                end;
                tot:= tot+totmes;
                writeln('-Mes ', rmae.mes,': ',totmes);
            end;
            ventas:= ventas+ tot;
            writeln('\\\\\\\\\\\\\\\\\\total gastado anualmente: ',tot,'\\\\\\\\\\\\\\\\\\');
        end;
    end;
    writeln('El monto total de las ventas fue de $', ventas,'!');
    close(mae);
end;

