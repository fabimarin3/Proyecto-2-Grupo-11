`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 15:02:00
// Design Name: 
// Module Name: EscrituraT
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


module EscrituraT(WR, clk, reset, Direc, HoraT, MinT, SegT
);

input clk;
input wire [7:0] WR;
input reset;
output wire [7:0] Direc;
output wire [7:0] HoraT;
output wire [7:0] MinT;
output wire [7:0] SegT;

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
reg [7:0] SegT_reg = 8'b0;
reg [7:0] MinT_reg = 8'b0;
reg [7:0] HoraT_reg = 8'b0;
reg [7:0] SegT_reg_next = 8'b0;
reg [7:0] MinT_reg_next = 8'b0 ;
reg [7:0] HoraT_reg_next = 8'b0;

////////////Variables de prueba para las direcciones///////////////

    localparam [7:0] ad41 = 8'd0,
                     ad42 = 8'd10, 
                     ad43 = 8'd20,
                     adF0 = 8'd15;

                    
///////////////////////////////////////////////

reg [3:0] estado_reg, estado_sig;

 always@ (posedge clk, posedge reset)
       begin
       SegT_reg = SegT_reg_next;
       MinT_reg = MinT_reg_next;
       HoraT_reg = HoraT_reg_next;
       Direc_reg = Direc_reg_next;
            
            if (reset)
                estado_reg = s1;
            else 
                estado_reg = estado_sig; 
       end

 always@*
       begin
      
       SegT_reg_next = 0;
       MinT_reg_next = 0;
       HoraT_reg_next = 0;
       Direc_reg_next= 0;
       estado_sig = s1;
        
        case (estado_reg)

            s1:
            begin
            Direc_reg_next = ad41;
            SegT_reg_next = WR_reg;
            estado_sig = s2;
            end
            
            s2: 
            begin
            Direc_reg_next = ad42;
            MinT_reg_next = WR_reg;
            estado_sig = s3;
            end
            
            s3: 
            begin
            Direc_reg_next = ad43;
            HoraT_reg_next = WR_reg;
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
assign  SegT = SegT_reg;
assign  MinT = MinT_reg;
assign  HoraT = HoraT_reg;


endmodule