program ej5y6;

type
celulares = record
    cod:integer;
    nom:String;
    des:String;
    marca:String;
    pre:real;
    stockmin:integer;
    stock:integer;
end;

archivo = file of celulares;

procedure imprimir(cel:celulares);
begin   
    writeln('------> CODIGO: ', cel.cod);
    writeln('Nombre: ', cel.nom);
    writeln('Descripcion: ', cel.des);
    writeln('Marca: ', cel.marca);
    writeln('Precio: $', cel.pre);
    writeln('Stock Minimo: ', cel.stockmin);
    writeln('Stock Real: ', cel.stock);
end;

procedure leer (var cel:celulares);
begin
    write('ingrese el codigo del celular: ');
    readln(cel.cod);
    write('ingrese el nombre del celular: ');
    readln(cel.nom);
    write('ingrese la descripcion del celular: ');
    readln(cel.des);
    write('ingrese su marca: ');
    readln(cel.marca);
    write('ingrese el precio: ');
    readln(cel.pre);
    write('ingrese el stock minimo: ');
    readln(cel.stockmin);
    write('ingrese el stock real: ');
    readln(cel.stock);
end;

procedure cargar(var texto:text; var arch:archivo);
var
    cel:celulares;
begin
    rewrite(arch);
    reset(texto);
    while (not(eof(texto)))do begin
        with cel do 
        begin
            readln(texto,cod,pre,marca);
            readln(texto,stock,stockmin,des);
            readln(texto,nom);
        end;
        write(arch,cel);
    end;
    close(arch);
    close(texto);
    writeln('archivo cargado correctamente...');
end;

procedure menorAlPromedio (var arch:archivo);
var
    cel:celulares;
begin
    reset(arch);
    while(not(eof(arch)))do begin 
        read(arch,cel);  
        if(cel.stockmin>cel.stock)then
            imprimir(cel);
    end;
    close(arch);
end;

procedure conDescripcion (var arch:archivo);
var
    cel:celulares;
begin   
    reset(arch);
    while(not(eof(arch)))do begin
        read(arch,cel);
        if(cel.des<>' vacio')then
            imprimir(cel);
    end;
    close(arch);
end;

procedure copiarATexto (var texto: text; cel:celulares);
begin
    with cel do 
    begin
        writeln(texto, ' ',cod, ' ',pre, ' ',marca);
        writeln(texto, ' ',stock, ' ',stockmin, ' ',des);
        writeln(texto, ' ',nom);
    end;
end;
procedure exportar (var texto: text; var arch:archivo);
var 
    cel:celulares;
begin
    reset(arch);
    rewrite(texto);
    while(not(eof(arch)))do begin
        read(arch,cel);  
        copiarATexto(texto,cel);
    end;
    close(arch);
    close(texto);
end;

procedure menu ();
begin
    writeln('//////////////MENU DE OPCIONES/////////////////');
    writeln('-1. Crear un archivo en base al texto.');
    writeln('-2. Listar aquellos celulares cuyo stock sea menor al minimo.');
    writeln('-3. Listar celulares que contengan una descripcion.');
    writeln('-4. Exportar archivo a .TXT');
    writeln('-5. Agregar uno o mas celulares al archivo.');
    writeln('-6. Modificar el stock de un celular');
    writeln('-7. Exportar a .TXT aquellos celulares que se hayan quedado sin stock');
    writeln('-0. Cerrar programa.');
end;

procedure agregarCelular (var arch:archivo);
var
    cel:celulares;
    seguir:integer;
begin
    reset(arch);
    seek(arch,filesize(arch));
    seguir:=1;
    while(seguir=1)do begin
        leer(cel);
        write(arch,cel);
        write('Desea seguir? -1.si  -cualquier numero. no');
        readln(seguir);
    end;
    close(arch);
end;

procedure modificarCelular (var arch:archivo; nombre:String; stock:integer);
var
    cel:celulares;
begin
    reset(arch);
    if(not(eof(arch)))then begin
        read(arch,cel);
        while ((not(eof(arch)))and(nombre<>cel.nom))do
            read(arch,cel);
        if(cel.nom=nombre)then begin
            cel.stock := stock;
            seek(arch,filepos(arch)-1);
            write(arch,cel);
        end;
    end;
    close(arch);
end;

procedure exportarSinStock (var arch:archivo; var sinStock:text);
var
    cel:celulares;
begin
    reset(arch);
    rewrite(sinStock);
    while(not(eof(arch)))do begin
        read(arch,cel);
        if (cel.stock=0)then
            copiarATexto(sinStock,cel);
    end;
    close(sinStock);
    close(arch);
end;
var
    texto,sinStock:text;
    arch:archivo;
    nombre:String;
    op:byte;
    stock:integer;
begin
    write('Ingrese el nombre del archivo: ');
    readln(nombre);
    assign(arch, nombre);
    menu();
    readln(op);
    while(op<>0) do begin
        if(op = 1)then
            cargar(texto,arch)
        else if (op = 2) then
            menorAlPromedio(arch)
        else if (op = 3) then
            conDescripcion(arch)
        else if (op = 4) then begin
            assign(texto, 'celulares.txt');
            exportar(texto,arch)
        end
        else if (op = 5) then
            agregarCelular(arch)
        else if (op = 6) then begin
            write('ingrese el nombre del celular: ');
            readln(nombre);
            write('ingrese su nuevo stock: ');
            readln(stock);
            modificarCelular(arch,nombre,stock)
        end
        else if (op = 7) then begin
            assign(sinStock,'SinStock.txt');
            exportarSinStock(arch,sinStock)
        end
        else
            writeln('Debe ingresar una opcion valida');
        menu();
        readln(op);
    end;
end.
        



    

