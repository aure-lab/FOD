program editorialX;

const
valoralto = 20261331;
valoraltoInt = 9999;

type
emision = record
    fec:longint;
    cod:integer;
    des:string;
    pre:real;
    totEj:integer;
    totVent:integer;
end;

ventas = record
    fec:longint;
    cod:integer;
    cantVent:integer;
end;

maestro = file of emision;
detalle = file of ventas;

rango= 1..100;
vdetalle = array [rango] of detalle;
vregistro = array[rango] of ventas;

procedure leer(var det:detalle; var rdet:ventas);
begin
    if(not eof(det))then
        read(det,rdet)
    else begin
        rdet.fec:=valoralto;
        rdet.cod:= valoraltoInt;
    end;
end;

procedure minimo (var det:vdetalle; var rdet:vregistro; var min:ventas);
var
    minFec:longint;
    minSem:integer;
    i,j:rango;
begin
    minFec:=valoralto;
    minSem:=valoraltoInt;
    for i := 1 to 100 do begin
        clave:= str(rdet[i].fec)+str(rdet[i].cod);
        if((minFec>rdet[i].fec)or((minFec=rdet.fec)and(minSem>rdet[i].cod)))then begin
            minFec:=rdet[i].fec;
            minSem:=rdet[i].cod;
            j:=i;
        end;
    end;
    min:= rdet[j];
    leer(det[j],rdet[j]);
end;

procedure actualizar (var mae:maestro; var det:vdetalle);
var
    rdet: vregistro;
    min:ventas;
    rmae:emision;
    i:rango
    minFec,maxFec:longint;
    minSem,maxSem:integer;
    minCant,maxCant:integer;
begin
    for i := 1 to 100 do begin
        reset(det[i]);
        leer(det[i],rdet[i]);
    end;
    minSem:=0; maxSem:=0;
    minFec:=valoralto; maxFec:=0;
    minCant:=9999; maxCant:=-1;
    reset(mae);
    minimo(det,rdet,min);
    while(not eof (mae))do begin
        read(mae,rmae);
        while((rmae.fec=min.fec)and(rmae.cod=min.cod))do begin
            if((rmae.totEj-min.cantVent)>=0)then begin
                rmae.totEj:= rmae.totEj-minc.cantVent;
                rmae.totVent:= totVent + min.cantVent;
            end;
            minimo(det,rdet,min);
        end;
        seek(mae,filepos(mae)-1);
        write(mae,rmae);
        if(minCant>rmae.cantVent)then begin
            minCant:=rmae.cantVent;
            minFec:=rmae.fec;
            minSem:= rmae.cod;
        end;
        if(maxCant<rmae.cantVent)then begin
            maxCant:=rmae.cantVent;
            maxFec:=rmae.fec;
            maxSem:=rmae.cod;
        end;
    end;
    close(mae);
    for i:= 1 to 100 do
        close(det[i]);
    writeln('la fecha y seminario con menos ventas es: ',minFec,' | ',minSem);
    writeln('la fecha y seminario con mas ventas es: ',maxFec,' | ',maxSem);
end;
        

