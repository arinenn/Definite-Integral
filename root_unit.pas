{$mode TP}
unit root_unit;
interface

    type function_t = function(x: double): double;
    const max_iter = 10000;

    {Функции}
    function F1(x: double): double;
    function F2(x: double): double;
    function F3(x: double): double;

    {Разности функций и их производные}
    function F1_F2(x: double): double;
    function F1_F2_d1(x: double): double;
    function F1_F3(x: double): double;
    function F1_F3_d1(x: double): double;
    function F2_F3(x: double): double;
    function F2_F3_d1(x: double): double;

    {Функция выпукла вниз?}
    function Convexity(f: function_t; a, b: double): boolean;
    {Приближенное решение уравнения f(x)=0. Метод касательных}
    function Root(f, df: function_t; a, b, eps: double): double;

implementation

    {Функции}
    function F1(x: double): double;
    begin
        F1 := exp(x) + 2
    end;
    function F2(x: double): double;
    begin
        F2 := -1/x
    end;
    function F3(x: double): double;
    begin
        F3 := -2*(x+1)/3
    end;

    {Разности функций и их первые производные}
    function F1_F2(x: double): double;
    begin
        F1_F2 := F1(x) - F2(x)
    end;
    function F1_F3(x: double): double;
    begin
        F1_F3 := F1(x) - F3(x)
    end;
    function F2_F3(x: double): double;
    begin
        F2_F3 := F2(x) - F3(x)
    end;
    function F1_F2_d1(x: double): double;
    begin
        F1_F2_d1 := exp(x) - 1/(x*x)
    end;
    function F1_F3_d1(x: double): double;
    begin
        F1_F3_d1 := exp(x) + 2/3
    end;
    function F2_F3_d1(x: double): double; begin
        F2_F3_d1 := 1/(x*x) + 2/3
    end;

    {Функция выпукла вниз?}
    function Convexity(f: function_t; a, b: double): boolean;
    var
        mid_x: double;
    begin
        mid_x := a/2 + b/2; {среднее значение}
        Convexity := false; {изначально выпукла вверх}
        if (f(mid_x) > f(a)/2 + f(b)/2) then
            Convexity := true {выпукла вниз}
    end;

    {Приближенное решение уравнения f(x)=0. Метод касательных}
    function Root(f, df: function_t; a, b, eps: double): double;
    var
        c: double;
        num_iter: word;
    begin
    {f(x) - функция, df(x) - производная f}
    {первая и вторая производная f не обращаются в нуль на [a,b]}
    if (a >= b) then
    begin
        writeln('Incorrect segment.');
        Halt(1)
    end
    else
    begin
        {первая и вторая производная одного знака?}
        if ( (f(a)<0) and (    Convexity(f, a, b)) )
        or ( (f(a)>0) and (not Convexity(f, a, b)) ) then
        begin
            num_iter := 0;
            {находим пересечение касательной к гр. ф. в т. (b, f(b)) с осью OX}
            repeat
                num_iter := num_iter + 1;
                c := b - f(b)/df(b);
                b := c
            until ((f(c-eps)*f(c) <= 0) or (num_iter > max_iter));
            {writeln(num_iter);}
            Root := c;
            if (num_iter > max_iter) then
            begin
                writeln('Limited iterations.');
                Halt(1)
            end
        end
        else
        {первая и вторая производная разных знаков?}
        if ( (f(a)<0) and (not Convexity(f, a, b)) )
        or ( (f(a)>0) and (    Convexity(f, a, b)) ) then
        begin
            num_iter := 0;
            {находим пересечение касательной к гр. ф. в т. (a, f(a)) с осью OX}
            repeat
                num_iter := num_iter + 1;
                c := a - f(a)/df(a);
                a := c
            until ((f(c)*f(c+eps) <= 0) or (num_iter > max_iter));
            {writeln(num_iter);}
            Root := c;
            if (num_iter > max_iter) then
            begin
                writeln('Limited iterations.');
                Halt(1)
            end
        end
    end
    end;
end.