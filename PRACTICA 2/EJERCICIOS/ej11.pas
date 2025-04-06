program ej11;
const valoralto = 9999;
type
categorias=1..15;

empleado = record
    depto:integer;
    division:integer;
    nro:integer;
    cat:categorias;
    cantHs:integer;
end;

hsExtras = array [categorias] of real;

procedure cargarVec (var vec:hsExtras; var texto:text);
var 
    i:categorias;
begin
    for i:= 1 to 15 do 
        readln(texto, vec[i]);
end;

procedure leer (var arch:text; var emp:empleado);
begin
    if (not eof(arch))then
        with emp do readln(arch,depto,division,nro,cat,cantHs)
    else
        emp.depto:=valoralto;
end;

procedure listar (var arch:text);
var
    horas,hsDiv:integer;
    total,totDiv:real;
    depto,division:integer;
    v:hsExtras;
    emp:empleado;
begin
    reset(arch);
    cargarVec(v,arch);
    leer(arch,emp);
    while(emp.depto<>valoralto)do begin
        depto:=emp.depto;
        writeln('------>DEPARTAMENTO: ', depto);
        total:=0;
        horas:=0;
        while(emp.depto=depto)do begin
            division:=emp.division;
            writeln('-Division: ', division);
            hsDiv:=0;
            totDiv:=0;
            writeln('---------------------------------------------------');
            writeln('Nro de empleado    Horas   Importe');
            writeln('---------------------------------------------------');
            while((emp.depto=depto)and(division=emp.division))do begin
                writeln(emp.nro,'                   ', emp.cantHs,'     ', (emp.cantHs * v[emp.cat]):0:2);
                hsDiv:= hsDiv+emp.cantHs;
                totDiv:= totDiv + (emp.cantHs*v[emp.cat]);
                leer(arch,emp);
            end;
            writeln('--------------------------------------------------');
            writeln('-Total de horas por Division: ', hsDiv);
            writeln('-Monto total por Division: ', totDiv:0:2);
            total:= total +  totDiv;
            horas:= horas + hsDiv;
        end;
        writeln('------------------------------------------------------');
        writeln('-Total de horas por Departamento: ', horas);
        writeln('-Monto total por Departamento: ', total:0:2);
    end;
    writeln('Fin del archivo...');
close(arch);
end;

var
    arch:text;
begin
    assign(arch,'empresa.txt');
    listar(arch);
end.

                




