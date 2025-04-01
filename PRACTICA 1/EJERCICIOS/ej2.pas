program ej2;
type
    numeros= file of integer;

var
    num:numeros;
    nombre: String;
    x,cont:integer;
    prom: real;
begin
    writeln('ingrese el nombre del archivo');
    readln(nombre);
    assign(num,nombre);
    Reset(num);
    cont:=0;
    prom:=0;
    while(not eof(num)) do begin
        read(num,x);
        if(x<1500) then
            cont:=cont+1;
        writeln(x);
        prom:= prom + x;
    end;
    prom:= prom/filesize(num);
    close(num);
    writeln('la cantidad de numeros menores a 1500 son: ', cont);
    writeln('el promedio es: ', prom);
end.