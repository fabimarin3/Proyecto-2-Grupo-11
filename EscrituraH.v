`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 14:24:55
// Design Name: 
// Module Name: EscrituraH
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


module EscrituraH(WR, clk, reset, Direc, Hora, Min, Seg
);

input clk;
input wire [7:0] WR;
input reset;
output wire [7:0] Direc;
output wire [7:0] Hora;
output wire [7:0] Min;
output wire [7:0] Seg;

////////////////Inicializador de estados/////////////

localparam [3:0] s0 = 4'h0, 
                 s1 = 4'h1, 
                 s2 = 4'h2, 
                 s3 = 4'h3, 
                 s4 = 4'h4;
                 
//////////Fin///////////


reg [7:0] Direc_reg;
reg [7:0] Direc_reg_next = 8'b0;
reg [7:0] WR_reg;
reg [7:0] Seg_reg = 8'b0;
reg [7:0] Min_reg = 8'b0;
reg [7:0] Hora_reg = 8'b0;
reg [7:0] Seg_reg_next = 8'b0;
reg [7:0] Min_reg_next = 8'b0 ;
reg [7:0] Hora_reg_next = 8'b0;

////////////Variables de prueba para las direcciones///////////////

    localparam [7:0] ad21 = 8'd0,
                     ad22 = 8'd10, 
                     ad23 = 8'd20,
                     adF0 = 8'd15;

                    
///////////////////////////////////////////////

reg [3:0] estado_reg, estado_sig;

 always@ (posedge clk, posedge reset)
       begin
       Seg_reg = Seg_reg_next;
       Min_reg = Min_reg_next;
       Hora_reg = Hora_reg_next;
       Direc_reg = Direc_reg_next;
            
            if (reset)
                estado_reg = s1;
            else 
                estado_reg = estado_sig; 
       end

 always@*
       begin
      
       Seg_reg_next = 0;
       Min_reg_next = 0;
       Hora_reg_next = 0;
       Direc_reg_next= 0;
       estado_sig = s1;
        
        case (estado_reg)

            s1:
            begin
            Direc_reg_next = ad21;
            Seg_reg_next = WR_reg;
            estado_sig = s2;
            end
            
            s2: 
            begin
            Direc_reg_next = ad22;
            Min_reg_next = WR_reg;
            estado_sig = s3;
            end
            
            s3: 
            begin
            Direc_reg_next = ad23;
            Hora_reg_next = WR_reg;
            end         

            default:
            begin
            estado_sig = s0;
            end        
        
             
        
        endcase 
        end           
         

/////////////////////  FIn de estado siguiente  //////////////////

       always@ (posedge clk)
       begin
        
       WR_reg =  WR;
       
       end
       
       
assign  Direc = Direc_reg;
assign  Seg = Seg_reg;
assign  Min = Min_reg;
assign  Hora = Hora_reg;


endmodule
