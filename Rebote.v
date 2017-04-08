`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2017 20:36:04
// Design Name: 
// Module Name: Rebote
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


module Rebote(clk, reset, entrada, Sal 
);

input clk;
input reset;
input entrada;
output [2:0] Sal;


   reg [2:0] Ant = 3'b000;

   always @(posedge clk)
      if (reset == 1)
         Ant <= 3'b000;
      else
         Ant <= {Ant[1:0], entrada};

   assign Sal = Ant[0] & Ant[1] & !Ant[2];
				
				
endmodule
