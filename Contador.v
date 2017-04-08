`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2017 14:30:19
// Design Name: 
// Module Name: Contador
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
// CONTADOR PARA MINUTOS Y SEGUNDOS 
// De hora y timer
//////////////////////////////////////////////////////////////////////////////////


module Contador(clk, reset, contador_out
);

    input clk;
    input reset;
    output  [3:0] contador_out;
    

   reg [3:0] contador_reg;

   always@ (posedge clk, posedge reset)
    
        if (reset)
            contador_reg = 0;
        else
        begin
   
            if (contador_reg == 6'd9)
            contador_reg = 0;
            else
            contador_reg = contador_reg + 1;
            
        end    
            
   assign contador_out = contador_reg;
endmodule
