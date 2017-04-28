`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/24/2017 09:05:43 PM
// Design Name:
// Module Name: contador_fecha
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module contador_fecha(
    input clk, reset,
    input boton_u, boton_d, cambiar_fecha,
    input [7:0] dias, mes, year,
    input [1:0] pos_x,
    output [7:0] dias_out, mes_out, year_out
    );

reg [7:0] count_dias, count_mes, count_year;
reg state_boton_u, state_boton_d;

always @ (posedge clk, posedge reset)
begin
if (reset)
begin
    count_dias = 8'h01;
    count_mes = 8'h01;
    count_year = 8'h00;
    state_boton_u = 0;
    state_boton_d = 0;
end
else
begin
    if (~cambiar_fecha)
    begin
        count_dias = dias;
        count_mes = mes;
        count_year = year;
    end
    else
    begin
        if (boton_u)
        begin
            state_boton_u = 1;
        end
        if (boton_d)
        begin
            state_boton_d = 1;
        end
        if (~boton_u & state_boton_u & (pos_x == 0))
        begin
            if (count_dias == 8'h9 | count_dias == 8'h19 | count_dias == 8'h29 )
            begin
                count_dias = count_dias + 8'h07;
                state_boton_u = 0;
            end
            else if (count_dias == 8'h31)
            begin
                count_dias = 8'h01;
                state_boton_u = 0;
            end
            else
            begin
                count_dias = count_dias + 1;
                state_boton_u = 0;
            end
        end
        if (~boton_d & state_boton_d & (pos_x == 0))
        begin
            if (count_dias == 8'h10 | count_dias == 8'h20 | count_dias == 8'h30 )
            begin
                count_dias = count_dias - 8'h07;
                state_boton_d = 0;
            end
            else if (count_dias == 8'h01)
            begin
                count_dias = 8'h31;
                state_boton_u = 0;
            end
            else
            begin
                count_dias = count_dias - 1;
                state_boton_u = 0;
            end
        end
        if (~boton_u & state_boton_u & (pos_x == 1))//mes
        begin
            if (count_mes == 8'h9 )
            begin
                count_mes = count_mes + 8'h07;
                state_boton_u = 0;
            end
            else if (count_mes == 8'h12)
            begin
                count_mes = 8'h01;
                state_boton_u = 0;
            end
            else
            begin
                count_mes = count_mes + 1;
                state_boton_u = 0;
            end
        end
        if (~boton_d & state_boton_d & (pos_x == 1))
        begin
            if (count_mes == 8'h10)
            begin
                count_mes = count_mes - 8'h07;
                state_boton_d = 0;
            end
            else if (count_mes == 8'h01)
            begin
                count_mes = 8'h12;
                state_boton_u = 0;
            end
            else
            begin
                count_mes = count_mes - 1;
                state_boton_u = 0;
            end
        end
        if (~boton_u & state_boton_u & (pos_x == 2))//hora
        begin
            if (count_year == 8'h09 | count_year == 8'h19 | count_year == 8'h29 | count_year == 8'h39 |
                count_year == 8'h49 | count_year == 8'h59 | count_year == 8'h69 | count_year == 8'h79 | count_year == 8'h89)
            begin
                count_year = count_year + 8'h07;
                state_boton_u = 0;
            end
            else if (count_year == 8'h99)
            begin
                count_year = 8'h00;
                state_boton_u = 0;
            end
            else
            begin
                count_year = count_year + 1;
                state_boton_u = 0;
            end
        end
        if (~boton_d & state_boton_d & (pos_x == 2))
        begin
            if (count_year == 8'h10 | count_year == 8'h20 | count_year == 8'h30 | count_year == 8'h40 |
                count_year == 8'h50 | count_year == 8'h60 | count_year == 8'h70 | count_year == 8'h80 | count_year == 8'h90)
            begin
                count_year = count_year - 8'h07;
                state_boton_d = 0;
            end
            else if (count_year == 8'h00)
            begin
                count_year = 8'h99;
                state_boton_u = 0;
            end
            else
            begin
                count_year = count_year - 1;
                state_boton_u = 0;
            end
        end
    end
end
end

assign dias_out = count_dias;
assign mes_out = count_mes;
assign year_out = count_year;

endmodule
