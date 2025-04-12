program covid18;
const valoralto = 9999;
type
string30 = string[30]
casos = record
    codLoc:integer;
    nomLoc:string30;
    codMun:integer;
    nomMun:string30;
    codHos:integer;
    nomHos:string30;
    fec:longint;
    cant:integer;
end;

maestro = file of (inte)

procedure leer (var mae:maestro; var rmae:casos);
begin
    if(not eof(mae))then
        read(mae,rmae)
    else
        rmae.codLoc:=valoralto;
end;

procedure exportar (var texto:text; nomLoc,nomMun:string; cantMun:integer);
begin
    writeln(texto, nomLoc);
    writeln(texto, cantMun,' ', nomMun);
end;

procedure imprimir (var mae:maestro; var texto:text);
var
    rmae:casos;
    codLoc,codHos,codMun:integer
    cantLoc,cantHos,cantMun,tot:integer;

begin
    rewrite(texto);
    reset(mae);
    leer(mae,rmae);
    tot:=0;
    while (rmae.codLoc<>valoralto)do begin
        codLoc:= rmae.codLoc;
        cantLoc:= 0;
        writeln('Nombre de Localidad: ',rmae.nomLoc);
        while(rmae.codLoc=codLoc)do begin
            codMun:= rmae.codMun;
            cantMun:=0;
            writeln('Nombre de Munucipio: ', rmae.nomMun);
            while((rmae.codLoc=codLoc)and(rmae.codMun=codMun))do begin
                codHos:= rmae.codHos;
                cantHos:= 0;
                write('Nombre de hospital: ',rmae.nomHos);
                while((rmae.codLoc=codLoc)and(rmae.codMun=codMun)and(rmae.codHos=codHos))do begin
                        cantHos:= cantHos + rmae.cant;
                        leer(mae,rmae);
                end;
                writeln(' Cantidad de casos: ',cantHos);
                cantMun:=cantMun +cantHos;
            end;
            writeln(' Cantidad de casos del municipio: ', cantMun);
            if(cantMun>1500)then
                exportar(texto,nomLoc,nomMun,cantMun);
            cantLoc:= cantLoc + cantMun;
        end;
        writeln(' Cantidad de casos de la localidad: ',cantLoc);
        tot:= tot+cantLoc;
        writeln('----------------------------------------------');
    end;
    writeln(' Cantidad de casos en la provincia: ',tot);
    close(texto);
    close(mae);
end;