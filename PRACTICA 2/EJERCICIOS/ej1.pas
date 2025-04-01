program ej1;

const
valoralto=9999;

type
empleados = record
    cod:integer;
    nom: String;
    mont: real;
end;

archivo = file of empleados;

procedure leer (var arch: archivo; var reg: empleados);
begin
    if(not(eof(arch)))then 
        read(arch,reg)
    else
        reg.cod := valoralto;
end;

procedure asignar (var rmae:empleados; rdet:empleados);
begin
    rmae.cod:=rdet.cod;
    rmae.nom:=rdet.nom;
    rmae.mont:=0;
end;

procedure comprimirDetalle (var detalle, maestro:archivo);
var
    rdet, rmae : empleados;
begin
    reset(detalle);
    rewrite(maestro);
    leer(detalle,rdet);
    while (rdet.cod<>valoralto)do begin
        asignar(rmae,rdet);
        while(rdet.cod=rmae.cod) do begin
            rmae.mont:= rmae.mont + rdet.mont;
            leer(detalle,rdet);
        end;
        write(maestro,rmae);
    end;
    close(detalle);
    close(maestro);
end;

procedure leer1 (var emp:empleados);
begin
    readln(emp.cod);
    readln(emp.nom);
    readln(emp.mont)
end;

procedure cargar (var arch:archivo);
var
    emp:empleados;
begin
    rewrite(arch);
    leer1(emp);
    while(emp.cod<>999)do begin
        write(arch,emp);
        leer1(emp);
    end;
    close(arch);
end;

procedure imprimir (var arch:archivo);
var
    emp:empleados;
begin
    reset(arch);
    while(not eof(arch))do begin
        read(arch,emp);
        writeln('----->CODIGO: ',emp.cod);
        writeln('nombre: ', emp.nom);
        writeln('monto: ', emp.mont);
    end;
    close(arch)
end;



var
detalle, maestro : archivo;
begin
    assign(detalle,'archivoDetalle');
    assign(maestro,'archivoMaestro');
    cargar(detalle);
    comprimirDetalle(detalle,maestro);
    imprimir(maestro);
end.