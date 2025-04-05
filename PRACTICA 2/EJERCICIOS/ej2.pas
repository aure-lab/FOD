program ej2;

const 
valoralto = 9999;

type
alumno = record
    cod:integer;
    ape:String;
    nom:String;
    cursada:integer;
    final:integer;
end;

materia = record
    cod:integer;
    aprobo:boolean;
end;

detalle = file of materia;
maestro = file of alumno;

procedure leer (var det:detalle; var rdet:materia);
begin
    if (not eof(det))then
        read(det,rdet)
    else
        rdet.cod:=valoralto;
end;

procedure actualizarMaestro(var det:detalle; var mae:maestro);
var
    rdet:materia;
    rmae:alumno;
begin
    reset(det);
    reset(mae);
    leer(det,rdet);
    read(mae,rmae);
    while(rdet.cod<>valoralto)do begin
        read(mae,rmae);
        while(rmae.cod<>rdet.cod)do 
            read(mae,rmae);
        while(rdet.cod=rmae.cod)do begin
            if(rdet.aprobo)then
                rmae.final:= rmae.final+1
            else
                rmae.cursada:= rmae.cursada+1;
            leer(det,rdet);
        end;
        seek(mae,filepos(mae)-1);
        write(mae,rmae);
        end
    end;
    close(mae);
    close(det);
end;

procedure listar (var texto: text; var mae:maestro);
var
    alum:alumno;
begin
    reset(mae);
    rewrite(texto);
    while(not eof(mae))do begin
        read(mae,alum);
        if(alum.cursada>4) then begin
            with alum do begin 
                writeln(texto,cod,' ', cursada,' ',final,' ', nom);
                writeln(texto,ape);
            end;
        end;
    end;
    close(mae);
    close(texto);
end;

var
    mae:maestro;
    det:detalle;
    texto:text;
begin
    assign(mae,'maestro');
    assign(det,'detalle');
    assign(texto,'alumnos.txt');
    actualizarMaestro(det,mae);
    listar(texto,mae);
end.

