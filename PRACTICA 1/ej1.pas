program ej1;
type
    numeros= file of integer;

var
    num:numeros;
    nombre: String;
    x:integer;
begin
    writeln('ingrese el nombre del archivo');
    readln(nombre);
    assign(num,nombre);
    rewrite(num);
    writeln('ingrese numeros, en caso de querer terminar con el programa ingrese el numero "30000"');
    readln(x);
    while (x<>30000)do begin
        write(num,x);
        readln(x);
    end;
    Close(num);
end.
