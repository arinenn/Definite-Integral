{$mode TP}
unit integral_unit;
interface

    uses root_unit;

    {Сумма площадей n прямоугольников под графиком функции f на [a,b]}
    function Area(f: function_t; a, b: double; n: word): double;
    {Определённый интеграл функции f на [a,b]}
    function Integral(f: function_t; a, b, eps: double): double;

implementation

    {Сумма площадей n прямоугольников под графиком функции f на [a,b]}
    function Area(f: function_t; a, b: double; n: word): double;
    var
        count: word;
        x, h, otv: double;
    begin
        if (a>=b) then
        begin
            writeln('Error: Incorrect segment.');
            Halt(1)
        end
        else
        begin
            x := a;
            h := b/n - a/n;
            otv := 0.0;
            for count:=0 to n-1 do
            begin
                otv := otv + h*f(x);
                x := x + h
            end;
            Area := otv
        end
    end;

    {Определённый интеграл функции f на [a,b]}
    function Integral(f: function_t; a, b, eps: double): double;
    const
        n0_div = 10; {начальное число разбиений}
        c_Ronge = 1/3; {константа Ронге}
    var
        first_integral, second_integral, integral_difference: double;
        n_div, num_iter: word;
    begin
        if (a>=b) then
        begin
            writeln('Error: Incorrect segment.');
            Halt(1)
        end
        else
        begin
            n_div := n0_div;
            num_iter := 0;
            repeat
                num_iter := num_iter + 1;
                n_div := 2*n_div;
                first_integral := Area(f, a, b, n_div);
                second_integral := Area(f, a, b, 2*n_div);
                integral_difference := second_integral - first_integral
            until (abs(c_Ronge*integral_difference) < eps) or (num_iter > max_iter);
            {writeln(num_iter);}
            Integral := second_integral {более точный интеграл}
        end
    end;
end.