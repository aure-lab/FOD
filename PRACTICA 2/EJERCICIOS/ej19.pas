program ej19;
const valoralto = 9999;

direccion = record
    calle: string;
    nro:integer;
    piso:integer;
    ciudad:string;
end;

nacimientos = record
    nro:integer;
    nom:string[20];
    ape:string[20];
    medico:string;
    dir:direccion;
    nomYApeM:string[50];
    dniM:integer;
    nomYApeP:string[50];
    dniP:integer;
end;

fallecidos = record
    nro:integer;
    dni:integer;
    nom:string[20];
    ape:string[20];
    medico:string;
    lugar:string;
    hora:string[5];
end;

merge = record
    nac:nacimientos;
    fallecio: boolean;
    medico:string;
    lugar:string;
    hora:string[5];
end;

detalleN = file of nacimientos;
detalleF = file of fallecidos;
maestro = file of merge;

rango = 1..50;
vdetalleN = array [rango] of detalleN;
vdetalleF = array [rango] of detalleF;
vregistroN = array [rango] of nacimientos;
vregistroF = array [rango] of fallecidos;

procedure leerN (var det:detalleN; var rdet:nacimientos);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet.nro:=valoralto;
end;

procedure leerF (var det:detalleF; var rdet:fallecidos);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet.nro:=valoralto;
end;


procedure minimoN (var det:vdetalleN; rdet:vregistroN; min:nacimientos);
var
    minNro:integer;
    i,j:rango;
begin
    minNro:= valoralto
    for i:= 1 to 50 do begin
        if(rdet[i].nro<minNro)then begin
            minNro:=rdet[i].nro;
            j:=i;
        end;
    end;
    min:=rdet[j];
    leer(det[j],rdet[j]);
end;

procedure minimoF (var det:vdetalleF; rdet:vregistroF; min:fallecidos);
var
    minNro:integer;
    i,j:rango;
begin
    minNro:= valoralto
    for i:= 1 to 50 do begin
        if(rdet[i].nro<minNro)then begin
            minNro:=rdet[i].nro;
            j:=i;
        end;
    end;
    min:=rdet[j];
    leer(det[j],rdet[j]);
end;

procedure exportar (var texto:text; var rmae:merge);
begin
    with rmae do begin
        with nac do begin
            writeln(texto,nro,' ',nom);
            writeln(texto,ape);
            writeln(texto,medico);
            writeln(texto,dniM,' ',nomYApeM);
            writeln(texto,dniP,' ',nomYApeP);
            with dir do begin
                writeln(texto,nro,' ',calle);
                writeln(texto,piso,' ',ciudad);
            end;
        end;
        if(rmae.fallecio)then begin
            write(texto,medico);
            write(texto,lugar);
            write(texto,hora);
        end;
    end;
end;

procedure actualizar(var detN:vdetalleN; var detF:vdetalleF; var mae:maestro; var texto:text);
var
    rmae:merge;
    minN:nacimientos;
    minF:fallecidos;
    rdetN:vregistroN;
    rdetF:vregistroF;
    i:rango;
begin
    for i:= 1 to 50 do begin
        reset(rdetF[i]);
        leer(rdetF[i],rdetF[i]);
        reset(rdetN[i]);
        leer(rdetN[i],rdetN[i]);
    end;
    rewrite(texto);
    rewrite(mae);
    minimoF(detF,rdetF, minF);
    minimoN(detN,rdetN, minN);
    while(minN.nro<>valoralto)do begin
        rmae.nac:=minN;
        if(minF.nro=minN.nro)then begin
            rmae.fallecio:= true;
            rmae.hora:= minF.hora;
            rmae.lugar:= minF.lugar;
            rmae.medico:=minF.medico;
            minimoF(detF,rdetF,minF);
        end;
        exportar(texto,rmae);
        write(mae,rmae);
        minimoN(detN,rdetN,minN);
    end;
    for i:= 1..50 do begin
        close(detN[i]);
        close(detF[i]);
    end;
    close(mae);
    close(texto);
end;
