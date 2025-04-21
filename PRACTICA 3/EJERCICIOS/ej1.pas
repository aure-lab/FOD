program ej3;
type
    empleados=record
        num:integer;
        ape: string;
        nom: string;
        edad:integer;
        dni:integer;
    end;

    arch= file of empleados;
procedure leer (var emp:empleados );
begin
    writeln('ingrese el apellido');
    readln(emp.ape);
    if(emp.ape<>'fin') then begin
        writeln('ingrese el numero de empleado');
        readln(emp.num);
        writeln('ingrese el nombre');
        readln(emp.nom);
        writeln('ingrese su edad');
        readln(emp.edad);
        writeln('ingrese su dni');
        readln(emp.dni);
    end;
end;

procedure imprimir ( emp: empleados);
begin
    writeln('------->EMPLEADO: ', emp.num);
    writeln('Nombre: ', emp.nom);
    writeln('Apellido: ', emp.ape);
    writeln('Edad: ', emp.edad);
    writeln('Dni: ', emp.dni);
end;

procedure anadirArchivo (var archivo:arch);
var 
    emp:empleados;
begin
    leer(emp);
    while(emp.ape<>'fin')do begin
        write(archivo,emp);
        leer(emp);
    end;
end;

procedure crear (var archivo:arch);
begin
    rewrite(archivo);
    anadirArchivo(archivo);
    close(archivo);
end;

procedure agregar (var archivo:arch);
begin
    reset(archivo);
    seek(archivo,filesize(archivo));
    anadirArchivo(archivo);
    close(archivo);
end;

procedure listadoNyF(var archivo:arch);
var
    emp:empleados;
begin
    reset(archivo);
    while(not eof(archivo))do begin
         read(archivo,emp);
         if((emp.nom <> '') and (emp.ape<> ''))then
            imprimir(emp);
    end;
    close(archivo);
end;

procedure listadoLinea(var archivo:arch);
var
    emp:empleados;
begin
    reset(archivo);
    while(not eof(archivo)) do begin
        read(archivo,emp);
        write('------->EMPLEADO: ', emp.num);
        write(' Nombre: ', emp.nom);
        write(' Apellido: ', emp.ape);
        write(' Edad: ', emp.edad);
        writeln(' Dni: ', emp.dni);
    end;
    close(archivo);
end;

procedure listadoJubilados(var archivo:arch);
var
    emp:empleados;
begin
    reset(archivo);
    while(not eof (archivo)) do begin
        read(archivo,emp);
        if(emp.edad>70) then    
            imprimir(emp);
    end;
    close(archivo);
end;
procedure imprimirOpciones (var archivo:arch);
var
    op:byte;
begin
    reset(archivo);
    writeln('ingrese que operacion quiere realizar, 1.listado nom y ape, 2. listado por linea, 3.listado proximos a jubilarse');
    readln(op);
    if(op=1) then
        listadoNyF(archivo)
    else
        if(op=2) then
            listadoLinea(archivo)
        else    
            listadoJubilados(archivo);
end; 

procedure modificar (var archivo:arch; edad:integer; codigo:integer);
var
    emp:empleados;
begin
    reset(archivo);
    read(archivo,emp);
    while((not eof(archivo))and (emp.num<>codigo))do
        read(archivo,emp);
    if(emp.num=codigo)then begin
        emp.edad:=edad;
        seek(archivo,filepos(archivo)-1);
        write(archivo,emp)
    end
    else
        writeln('El codigo de empleado no se encuentra en el archivo');
    end;

procedure opcionesGenerales();
begin
    writeln('////////////////////////////ingrese que operacion desea realizar: ////////////////////////////////');
    writeln('-0. cerrar');
    writeln('-1. crear archivo');
    writeln('-2. imprimir archivo');
    writeln('-3. agregar uno o mas empleados al archivo');
    writeln('-4. modificar la edad de un empleado dado');
    writeln('-5. Exportar datos a .TXT');
    writeln('-6. solo exportar de los empleados cuyo dni sea 00');
end;

procedure exportarTodos (var todos:text; var archivo:arch);
var 
    emp:empleados;
begin   
    reset(archivo);
    rewrite(todos);
    while(not(eof(archivo)))do begin
        read(archivo,emp);
        with emp do write(todos,' ', num, ' ', edad,' ', dni,' ', ape,' ', nom);
    end;
    close(archivo);
    close(todos);
end;

procedure exportarDni (var soloDni:text; var archivo:arch);
var 
    emp:empleados;
begin   
    reset(archivo);
    rewrite(soloDni);
    while(not(eof(archivo)))do begin
        read(archivo,emp);
        if(emp.dni=00)then
            with emp do write(soloDni,' ', num, ' ', edad,' ', dni,' ', ape,' ', nom);
    end;
    close(archivo);
    close(soloDni);
end;

var
    op:byte;
    archivo:arch; nombre:string;
    edad,codigo:integer;
    todos,soloDni:text;
begin
    write('ingrese el nombre del archivo: ');
    readln(nombre);
    assign(archivo,nombre);
    opcionesGenerales();
    readln(op);
    while(op<>0) do begin
        if(op=1) then   
            crear(archivo)
        else if (op=2) then   
            imprimirOpciones(archivo)
        else if (op=3)then
            agregar(archivo)
        else if (op=4)then begin
            write('ingrese el codigo del empleado:');
            readln(codigo);
            write('ingrese su edad:');
            readln(edad);
            modificar(archivo,edad,codigo)
        end
        else if(op=5)then begin
            assign(todos,'todos_empleados.txt');
            exportarTodos(todos, archivo);
        end
        else if(op=6)then begin
            assign(soloDni, 'faltaDNIEmpleado.txt');
            exportarDni(soloDni, archivo)
        end
        else
            writeln('Debe ingresar una opcion valida');
        opcionesGenerales();
        readln(op);
    end;
end.



