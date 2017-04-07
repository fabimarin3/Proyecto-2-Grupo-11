`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 13:46:52
// Design Name: 
// Module Name: InstaTb
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


module InstaTb(
);


reg clktb;
reg resettb;
wire [7:0] Directb;
wire [7:0] WRtb;
wire [3:0] auxiliartb;

Inicializador Inta_Inic(
.clk(clktb),
.reset(resettb),
.Direc(Directb), 
.WR(WRtb),
.auxiliar(auxiliartb)
);

    initial 
    begin
         clktb = 0;
         #10 resettb = 1;
         #10 resettb=0;
    end
    
    
     always begin 
     #5 clktb =! clktb;
     end

endmodule
