{$mode TP}
program main;
uses root_unit, integral_unit, graph_unit;
const
    a1 = -2; b1 = 1/9;
    a2 = -5; b2 = -3;
    a3 = -2; b3 = -1;
    eps1 = 0.0001;
    eps2 = 0.0001;
var
    x_otl, S_otl,
    x12, x13, x23,
    s1, s2: double;
{Отладочные функции и их производные}
function F_root_otl(x: double): double;
begin
    F_root_otl := x*x - 1
end;
function F_root_otl_df(x: double): double;
begin
    F_root_otl_df := 2*x
end;
function F_integral_otl(x: double): double;
begin
    F_integral_otl := x*x*x + 8
end;

begin
{даны F1, F2, F3; на бумаге знаем абсциссы точек пересечения}
{проверка на отладочных функциях}
    x_otl := Root(F_root_otl, F_root_otl_df, 0.5, 1.5, eps1);
    writeln('f(x) = x*x - 1;   x_otl = ', x_otl);
    S_otl := Integral(F_integral_otl, -2, 0, eps2);
    writeln('f(x) = x*x*x + 8; S_otl = ', S_otl);
{вычисление абсцисс пересечения графиков функции по методу касательных}
    x12 := Root(F1_F2, F1_F2_d1, a1, b1, eps1);
    writeln('F1^F2: x12 = ', x12);
    x13 := Root(F1_F3, F1_F3_d1, a2, b2, eps1);
    writeln('F1^F3: x13 = ', x13);
    x23 := Root(F2_F3, F2_F3_d1, a3, b3, eps1);
    writeln('F2^F3: x23 = ', x23);
{вычисление площади фигуры по методу прямоугольников}
    s1 := Integral(F1_F3, x13, x23, eps2);
    writeln('s1 =', s1);
    s2 := Integral(F1_F2, x23, x12, eps2);
    writeln('s2 =', s2);
    writeln('S = s1 + s2 =', s1+s2);
{рисуем график}
    Graph(F1, F2, F3, x12, x13, x23, s1, s2, s1+s2)
end.