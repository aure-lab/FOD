program Linux;
const valoralto = 'zzzz';
type
distribucion = record
    nom: string[20];
    anio: integer;
    ver: integer;
    cant:integer;
    des: string[50];
end;

archivo = file of distribucion;

procedure leer (var arch:archivo; var dis:distribucion);
begin
    if(not eof(arch))then
        read(arch,dis)
    else
        dis:= valoralto;
end;

procedure BuscarDistribucion (var arch:archivo; var donde:integer; nom:string[20]);
var
    dis:distribucion;
begin
    reset(arch);
    leer(arch,dis);
    donde:=-1;
    while((dis.nom<>valoralto)and(dis.nom<>nom))do 
        leer(archivo,dis);
    if(dis.nom=nom)then
        donde:=filepos(arch)-1;
    close(arch);
end;

procedure AltaDistribucion (var arch:archivo; dis:distribucion);
var
    aux:distribucion;
    donde:integer;
begin
    BuscarDistribucion(arch,donde,dis.nom);
    if (donde = -1) then begin
        reset(arch);
        leer(arch,aux); // la version indica el NRR
        if(aux.ver <> 0) then begin
            seek(arch,aux.ver * -1);
            leer(arch,aux);
            seek(arch,filepos(arch)-1);
            write(arch,dis);
            seek(arch,0);
            write(arch,aux)
        end
        else begin
            seek(arch,filesize(arch)-1);
            write(arch,dis)
        end
        close(arch);
    end
    else
        writeln('Ya existe la distribucion.');
end;

procedure BajaDistribucion (var arch:archivo; nom:string[20]);
    procedure modificar (var arch:archivo; dis:distribucion; donde:integer);
    begin
        arch.ver:= donde * -1;
        write(arch,dis);
    end;
var
    dis,aux:distribucion;
    donde:integer;
begin
    BuscarDistribucion(arch,donde,nom);
    if(donde<>-1)then begin
        reset(arch);
        leer(arch,dis);
        modificar(arch,dis,donde);
        seek(arch,donde);
        write(arch,dis)
    end
    else
        writeln('Distribucion no existente');
end;