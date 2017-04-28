`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/24/2017 08:07:24 PM
// Design Name:
// Module Name: contadores_x
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


module contadores_x(
    input clk, reset,
    input boton_r, boton_l,
    input fecha, hora, timer,
    output [1:0] posicion_x
    );

reg [1:0] count = 0;
reg state_boton_r = 0, state_boton_l = 0;

always @ (posedge clk, posedge reset)
begin
    if (reset)
    begin
        count = 0;
        state_boton_r = 0;
        state_boton_l = 0;
    end
    else
    begin
        if (~(fecha | hora | timer))
        begin
            count = 0;
        end
        else
        begin
            if (boton_r)
            begin
                state_boton_r = 1;
            end
            if (boton_l)
            begin
                state_boton_l = 1;
            end
            if (~boton_r & state_boton_r)
            begin
                if (count == 2)
                begin
                    count = 0;
                    state_boton_r = 0;
                end
                else
                begin
                    count = count + 1;
                    state_boton_r = 0;
                end
            end
            if (~boton_l & state_boton_l)
            begin
                if (count == 0)
                begin
                    count = 2;
                    state_boton_l = 0;
                end
                else
                begin
                    count = count - 1;
                    state_boton_l = 0;
                end
            end
        end
    end
end

assign posicion_x = count;

endmodule
