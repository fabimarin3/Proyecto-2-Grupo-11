`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/24/2017 08:06:15 PM
// Design Name:
// Module Name: contador_hora
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


module contador_hora(
    input clk, reset,
    input boton_u, boton_d, cambiar_hora,
    input [7:0] segundos, minutos, horas,
    input [1:0] pos_x,
    output [7:0] segundos_out, minutos_out, horas_out
    );

reg [7:0] count_seg, count_min, count_hor;
reg state_boton_u, state_boton_d;

always @ (posedge clk, posedge reset)
begin
    if (reset)
    begin
        count_seg = 8'h00;
        count_min = 8'h00;
        count_hor = 8'h00;
        state_boton_u = 0;
        state_boton_d = 0;
    end
    else
    begin
        if (~cambiar_hora)
        begin
            count_seg = segundos;
            count_min = minutos;
            count_hor = horas;
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
                if (count_seg == 8'h9 | count_seg == 8'h19 | count_seg == 8'h29 | count_seg == 8'h39 | count_seg == 8'h49)
                begin
                    count_seg = count_seg + 8'h07;
                    state_boton_u = 0;
                end
                else if (count_seg == 8'h59)
                begin
                    count_seg = 8'h00;
                    state_boton_u = 0;
                end
                else
                begin
                    count_seg = count_seg + 1;
                    state_boton_u = 0;
                end
            end
            if (~boton_d & state_boton_d & (pos_x == 0))
            begin
                if (count_seg == 8'h10 | count_seg == 8'h20 | count_seg == 8'h30 | count_seg == 8'h40 | count_seg == 8'h50)
                begin
                    count_seg = count_seg - 8'h07;
                    state_boton_d = 0;
                end
                else if (count_seg == 8'h00)
                begin
                    count_seg = 8'h59;
                    state_boton_u = 0;
                end
                else
                begin
                    count_seg = count_seg - 1;
                    state_boton_u = 0;
                end
            end
            if (~boton_u & state_boton_u & (pos_x == 1))//minutos
            begin
                if (count_min == 8'h9 | count_min == 8'h19 | count_min == 8'h29 | count_min == 8'h39 | count_min == 8'h49)
                begin
                    count_min = count_min + 8'h07;
                    state_boton_u = 0;
                end
                else if (count_min == 8'h59)
                begin
                    count_min = 8'h00;
                    state_boton_u = 0;
                end
                else
                begin
                    count_min = count_min + 1;
                    state_boton_u = 0;
                end
            end
            if (~boton_d & state_boton_d & (pos_x == 1))
            begin
                if (count_min == 8'h10 | count_min == 8'h20 | count_min == 8'h30 | count_min == 8'h40 | count_min == 8'h50)
                begin
                    count_min = count_min - 8'h07;
                    state_boton_d = 0;
                end
                else if (count_min == 8'h00)
                begin
                    count_min = 8'h59;
                    state_boton_u = 0;
                end
                else
                begin
                    count_min = count_min - 1;
                    state_boton_u = 0;
                end
            end
            if (~boton_u & state_boton_u & (pos_x == 2))//hora
            begin
                if (count_hor == 8'h09 | count_hor == 8'h19 )
                begin
                    count_hor = count_hor + 8'h07;
                    state_boton_u = 0;
                end
                else if (count_hor == 8'h23)
                begin
                    count_hor = 8'h00;
                    state_boton_u = 0;
                end
                else
                begin
                    count_hor = count_hor + 1;
                    state_boton_u = 0;
                end
            end
            if (~boton_d & state_boton_d & (pos_x == 2))
            begin
                if (count_hor == 8'h10 | count_hor == 8'h20 )
                begin
                    count_hor = count_hor - 8'h07;
                    state_boton_d = 0;
                end
                else if (count_hor == 8'h00)
                begin
                    count_hor = 8'h23;
                    state_boton_u = 0;
                end
                else
                begin
                    count_hor = count_hor - 1;
                    state_boton_u = 0;
                end
            end
        end
    end
end

assign segundos_out = count_seg;
assign minutos_out = count_min;
assign horas_out = count_hor;

endmodule
