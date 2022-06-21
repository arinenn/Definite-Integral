{$mode TP}
unit graph_unit;
interface
uses ptcgraph, root_unit;
procedure Graph(F1, F2, F3: function_t; x12, x13, x23, s1, s2, S: double);
implementation

procedure Graph(F1, F2, F3: function_t; x12, x13, x23, s1, s2, S: double);
const
    color_OXY = 12109509;
    color_OXY_text = 6139362;
    color_num = 16044095;
    color_F1 = 16711680;
    color_F2 = 20991;
    color_F3 = 896269;
    color_points = 13611962;
    color_area = 5156790;
var
    GD, {graph driver}
    GM, {graph mode}
    n, {количество засечек}
    x0, y0, {начальные координаты}
    x_coord, y_coord, {координаты на графике}
    xMin, xMax, yMin, yMax, {значения на осях}
    p_xMin, p_xMax, p_yMin, p_yMax, {граница}
    i, {счётчик}
    runner: integer;
    MX, MY, {масштаб}
    x, dx, x_num,
    y, dy, y_num: real;
    slovo, point12, point13, point23: string;
begin
    GD := Detect;
{инициализация графического режима}
    InitGraph(GD, GM, '');
    SetColor(color_OXY);
{начало координат находится в левом верхнем углу}
{отступы от границ окна, значения рассматриваемого отрезка}
    p_xMin := 50; p_xMax := GetMaxX - 50;
    p_yMin := 50; p_yMax := GetMaxY - 50;
    xMin := -7; xMax := 3; dx := 0.5;
    yMin := -2; yMax := 4; dy := 0.5;
{сопоставляем координаты с желаемыми}
    MX := (p_xMax - p_xMin) / (xMax - xMin);
    MY := (p_yMax - p_yMin) / (yMax - yMin);
    x0 := p_xMax - trunc(xMax*MX);
    y0 := p_yMin + trunc(yMax*MY);
{рисуем оси}
    Line(p_xMin, y0, p_xMax, y0); {OX}
    Line(x0, p_yMin, x0, p_yMax); {OY}
{подписываем оси}
    SetColor(color_OXY_text);
    SetTextStyle(1, 0, 1);
    OutTextXY(GetMaxX - 30, y0, 'OX');
    OutTextXY(x0, 30, 'OY');
{рисуем засечки на OX}
    SetColor(color_num);
    OutTextXY(x0 - 10, y0 + 10, '0');
    n := round((xMax - xMin)/dx) + 1;
    for i := 1 to n do
    begin
    {координата на бумаге}
        x_num := xMin + (i-1)*dx;
    {координата в окне}
        x_coord := p_xMin + trunc((x_num - xMin)*MX);
    {оставляем штрих}
        Line(x_coord, y0-3, x_coord, y0+3);
    {оставляем число, если не нуль}
        str(x_num:0:1, slovo);
        if (abs(x_num) > 1E-10) then
            OutTextXY(x_coord - TextWidth(slovo) div 2, y0+10, slovo)
    end;
{рисуем засечки на OY}
    n := round((yMax - yMin)/dy) + 1;
    for i := 1 to n do
    begin
    {координата на бумаге}
        y_num := yMin + (i-1)*dy;
    {координата в окне}
        y_coord := p_yMax - trunc((y_num - yMin)*MY);
    {оставляем штрих}
        Line(x0-3, y_coord, x0+3, y_coord);
    {оставляем число, если не нуль}
        str(y_num:0:1, slovo);
        if (abs(y_num) > 1E-10) then
            OutTextXY(x0+10, y_coord - TextHeight(slovo) div 2, slovo)
    end;
{рисуем график F1}
    SetColor(color_F1);
    OutTextXY(x0+50, y0-trunc(F1(0)*MY)-40, 'F1 = exp(x) + 2');
    x := xMin;
    while (x <= xMax) do
    begin
    {вычисляем значение функции}
        y := F1(x);
    {координаты в окне}
        x_coord := x0 + round(x*MX);
        y_coord := y0 - round(y*MY);
        if (y_coord >= p_yMin) and (y_coord <= p_yMax) then
        begin
            PutPixel(x_coord, y_coord, color_F1);
            PutPixel(x_coord-1, y_coord-1, color_F1)
        end;
        x := x + 0.00001
    end;
{рисуем график F2}
    SetColor(color_F2);
    OutTextXY(x0-trunc(MX), y0-trunc(F2(-1)*MY)+10, 'F2 = -1/x');
    x := xMin;
    while (x <= xMax) do
    begin
    {вычисляем значение функции}
        y := F2(x);
    {координаты в окне}
        x_coord := x0 + round(x*MX);
        y_coord := y0 - round(y*MY);
        if (y_coord >= p_yMin) and (y_coord <= p_yMax) then
        begin
            PutPixel(x_coord, y_coord, color_F2);
            PutPixel(x_coord-1, y_coord-1, color_F2)
        end;
        x := x + 0.00001
    end;
{рисуем график F3}
    SetColor(color_F3);
    OutTextXY(x0+trunc((-5)*MX), y0-trunc(F3(-5)*MY)-20, 'F3 = -2(x+1)/3');
    x := xMin;
    while (x <= xMax) do
    begin
    {вычисляем значение функции}
        y := F3(x);
    {координаты в окне}
        x_coord := x0 + round(x*MX);
        y_coord := y0 - round(y*MY);
        if (y_coord >= p_yMin) and (y_coord <= p_yMax) then
        begin
            PutPixel(x_coord, y_coord, color_F3);
            PutPixel(x_coord-1, y_coord-1, color_F3)
        end;
        x := x + 0.00001
    end;
{отмечаем точки пересечения}
    SetColor(color_points);
    Str(x12:0:10, point12);
    Str(x13:0:10, point13);
    Str(x23:0:10, point23);
    point12 := 'x12 =' + point12;
    point13 := 'x13 =' + point13;
    point23 := 'x23 =' + point23;
    OutTextXY(x0+trunc(x12*MX), y0+30, point12);
    OutTextXY(x0+trunc(x13*MX), y0+30, point13);
    OutTextXY(x0+trunc(x23*MX), y0+30, point23);
{опускаем перпендикуляры}
    line(x0+round(x12*MX), y0-round(F1(x12)*MY), x0+round(x12*MX), y0);
    line(x0+round(x13*MX), y0-round(F3(x13)*MY), x0+round(x13*MX), y0);
    line(x0+round(x23*MX), y0-round(F1(x23)*MY), x0+round(x23*MX), y0);
{обозначение площадей}
    SetColor(color_OXY);
    SetTextStyle(1,0,2);
    OutTextXY(x0+round(-2.7*MX), y0-round(1.5*MY), 'S1');
    OutTextXY(x0+round(-1.2*MX), y0-round(1.5*MY), 'S2');
    str(S:0:12, slovo);
    OutTextXY(x0+round(-3.2*MX), y0-round(2.4*MY), 'S = '+slovo);
{заливка первой половины на [x13, x23]}
    SetColor(color_area);
    x := x13 + 0.25;
    while (x <= x23) do
    begin
    {соединяем точки на двух графиках}
        Line(x0+round((x)*MX), y0-round(F1(x)*MY), x0+round(x*MX), y0-round(F3(x)*MY));
        x := x + 0.25
    end;
{заливка второй половины на [x23, x12]}
    while (x <= x12) do
    begin
    {соединяем точки на двух графиках}
        Line(x0+round(x*MX), y0-round(F1(x)*MY), x0+round(x*MX), y0-round(F2(x)*MY));
        x := x + 0.25
    end;
{режим ожидания}
    Readln(runner)
end;

end.