program ej12;
const valoralto = 9999;
type

dias = 1..31;
meses = 1..12;
fecha = record
    dia: dias;
    mes: meses;
    anio:integer;
end;

acceso = record
    fec:fecha;
    id:integer;
    tie: real;
end;

maestro = file of acceso;

procedure leer (var mae:maestro; var rmae:acceso);
begin
    if(not eof(mae))then
        read(mae,rmae)
    else
        rmae.anio:=valoralto;
end;

procedure imprimir (var mae:maestro; anio:integer);
var
    totDia,tieDia,tieMes,tieAnio: real;
    rmae: acceso;
    dia:dias;
    mes:meses;
    id: integer;
begin
    reset(mae);
    leer(mae,rmae);
    while((rmae.fec.anio<>valoralto)and(rmae.anio<>anio))do
        leer(mae,rmae);
    if(rmae.fec.anio<>valoralto)then begin
        writeln('-------->ANIO: ',anio);
        tieAnio:=0;
        while(rmae.fec.anio=anio)do begin
            mes:= rmae.fec.mes;
            writeln('MES: ',mes);
            tieMes:= 0;
            while((rmae.fec.anio=anio)and(rmae.fec.mes=mes))do begin
                totDia:=0;
                dia:= rmae.fec.dia;
                writeln('DIA: ',dia);
                while((rmae.fec.anio=anio)and(rmae.fec.mes=mes)and(rmae.fec.dia=dia))do begin
                    tieDia:=0;
                    id:= rmae.id;
                    write('IdUsuario: ',id);
                    while((rmae.fec.anio=anio)and(rmae.fec.mes=mes)and(rmae.fec.dia=dia)and(rmae.id=id))do begin
                        tieDia:=tieDia+rmae.tie;
                        leer(mae,rmae);
                    end;
                    writeln(' Tiempo total: ', tieDia);
                    totDia:= totDia+tieDia;
                end;
                tieMes:= tieMes + totDia;
                writeln('Tiempo total de acceso en el dia ',dia, ' mes ',mes,': ',totDia)
            end
            tieAnio:= tieAnio+tieMes;
            writeln('Tiempo total mensual: ', tieMes)
        end
        writeln('Tiempo total anual: ', tieAnio)
    end
    else
        writeln('año no encontrado');
    close(mae);
end;

var
    anio:integer;
    mae:maestro;
begin
    assign(mae,'maestro');
    write('Escriba el anio a buscar: ');
    readln(anio);
    imprimir(mae,anio);
end.