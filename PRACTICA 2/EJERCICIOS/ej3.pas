program ej3;
const valoralto = 'zzzz';
type 

info = record
    nom: String;
    cant:integer;
    tot:integer;
end;

encuesta = record
    nom:String;
    cod:integer;
    cant:integer;
    tot:integer;
end;

detalle = file of encuesta;
maestro = file of info;

procedure leer (var det:detalle; var rdet:encuesta);
begin
    if(not eof(det))then
        read(det,rdet)
    else
        rdet.nom:=valoralto;
end;

procedure minimo (var det1,det2:detalle; var rdet1,rdet2,min:encuesta);
begin
    if(rdet1.nom>rdet2.nom)then begin
        min:=rdet2;
        leer(det2,rdet2)
    else 
    begin
        min:=rdet1;
        leer(det1,rdet1);
end;

procedure actualizarMae (var mae:maestro; var det1,det2:detalle);
var
    rmae:info;
    cant,tot:integer;
    rdet1,rdet2,min:encuesta;
begin
    reset(mae);
    reset(rdet1);
    reset(rdet2);
    minimo(det1,det2,rdet1,rdet2,min);
    while(min<>valoralto)do begin
        read(mae,rmae);
        nom:=min.nom;
        tot:=0;
        cant:=0;
        while(nom = min.nom)do begin
            tot:= min.tot + tot;
            cant:= min.cant +cant;
            minimo(det1,det2,rdet1,rdet2,min);
        end;
        while((not eof(mae))and(rmae.nom<nom))do
            read(mae,rmae);
        if(rmae.nom=nom)then begin
            rmae.tot:= rmae.tot + tot;
            rmae.cant:= rmae.cant + cant;
            seek(mae,filepos(mae)-1);
            write(mae,rmae);
        end
        else if(eof(mae))then 
            rmin.cod:=valoralto;
            else
                 seek(mae,filepos(mae)-1);
    end;
    close(mae);
    close(rdet1);
    close(rdet2);
end;

