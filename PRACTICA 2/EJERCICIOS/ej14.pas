program ej14;
const valoraltoS= 'zzz';
    valoraltoI= 999999;
type

vuelos = record
    des:string;
    fec:longint;
    hora:string[5];
    cant:integer;
end;
//son lo mismo
diario = record
    des:string;
    fec:longint;
    hora:string[5];
    cantComp:integer;
end;

lista = ^nodo;
nodo = record
    elem:vuelos;
    sig:lista;
end;

maestro = file of vuelos;
detalle = file of diario;

procedure agregar (var l:lista; elem:vuelos);
var
    nue:lista;
begin
    new(nue); nue^.elem:=elem; nue^.sig:=l; l:=nue;
end;


procedure leer(var det:detalle; var rder:diario);
begin
    if(not eof(det))then
        read(det,rdet)
    else begin
        rdet.des:=valoraltoS;
        rdet.fec:=valoraltoI;
    end;
end;

procedure minimo (var det1,det2:detalle; var rdet1,rdet2,min:diario);
var 
    clave1,clave2:string;
begin
    clave1:= rdet1.des + str(rdet1.fec);
    clave2:= rdet2.des + str(rdet2.fec);
    if((clave1<clave2) or ((clave1 = clave2)and(rdet1.hora < rdet2. hora)) )then begin
        min:=rdet1;
        leer(det1,rdet1)
    end
    else begin
        min:=rdet2;
        leer(det1,rdet2);
    end;
end;

procedure actualizar (var mae:maestro; var det1,det2:detalle; var l:lista; asientos:integer);
var
    rmae:vuelos;
    rdet1,rdet2,min:diario;
    hora:string[5];
    fec:longint;
begin
    reset(mae); reset(det1); reset(det2);
    leer(det1,rdet1); leer(det2,rdet2);
    minimo(det1,det2,rdet1,rdet2,min);
    while (not eof (mae)) do begin
        read(mae);
        while((rmae.fec = min.fec)and(rmae.hora = min.hora)and(rmae.des = min.des))do begin
            rmae.cant:= rmae.cant - min.cantComp;
            minimo(det1,det2,rdet1,rdet2,min);
        end;
        if(rmae.cant<asientos)then
            agregar(l,rmae);
        seek(mae,filepos(mae)-1);
        write(mae,rmae);
    end;
    close(mae); close(rdet1); close(rdet2);
end;
            