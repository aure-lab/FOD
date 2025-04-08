program ej10;
const valoralto=9999;

type
mesas = record
    codProv:integer;
    codLoc:integer;
    num:integer;
    cant:integer;
end;

archivo = file of mesas;

procedure leer(var arch:archivo; var mesa:mesas);
begin
    if(not eof(arch))then
        read(arch,mesa)
    else
        mesa.codProv:=valoralto;
end;

procedure contabilizar (var arch:archivo);
var
    prov,loc,tot:integer;
    codLoc,codLoc:integer;
    mesa:mesas;
begin
    tot:=0;
    reset(arch);
    leer(arch,mesa);
    while (mesa.codProv<>valoralto)do begin
        prov:=0;
        codProv:=mesa.codProv;
        writeln(codProv);
        while(mesa.codProv=codProv)do begin
            codLoc:=mesa.codLoc;
            writeln(codLoc);
            loc:=0;
            while((mesa.codProv=codProv)  and mesa.codLoc=codLoc)do begin
                loc:=loc+mesa.cant;
                leer(arch,mesa);
            end;
            writeln('total de votos de localidad: ',loc);
            prov:= prov + loc;
        end;
        writeln('total de votos provincia: ',prov);
        tot:= tot + prov;
    end;
    writeln('total General de votos: ', tot);
    close(arch);
end;
