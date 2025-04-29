program ej7;
const valoralto = 9999;
const eliminado = 'zzz';
type
string30 = string[30];
aves = record 
    cod:integer;
    nom:string30;
    fam:string30;
    des:string30;
    zon:string30;
end;

archivo = file of aves;

procedure leer (var arch:archivo; var av:aves);
begin
    if(not eof (arch))then
        read(arch,av)
    else
        av.cod:=valoralto;
end;

procedure eliminar (var arch:archivo; cod:integer);
var 
    av:aves;
begin
    reset(arch);
    leer(arch,av);
    while((av.cod<>valoralto) and (av.cod<>cod))do 
        leer(arch,av);
    if(av.cod = cod)then begin
        av.nom:= eliminado;
        seek(arch, filepos(arch)-1);
        write(arch,av);
    end
    else
        writeln('La especie de ave ',cod, ' no ha sido encontrada.');
    close(arch);
end;

procedure bajaFisica (var arch:archivo);
var
    av,aux:aves;
    inicio,fin:integer;
begin
    reset(arch);
    inicio:=0;
    fin:=filesize(arch)-1;
    while(inicio<>fin)do begin
        leer(arch, av);
        if(av.nom = eliminado)then begin
            seek(arch, fin);
            leer(arch, aux);
            while(aux.nom=eliminado)do begin
                fin:= fin -1;
                seek(arch,fin);
                leer(arch,aux);
            end;
            seek(arch,filepos(arch)-1);
            write(arch,av);
            seek(arch,inicio);
            write(arch,aux);
            fin:=fin-1;
        end;
        inicio := inicio+1;  
    end;
    Truncate(arch); 
    close(arch); 
end;
