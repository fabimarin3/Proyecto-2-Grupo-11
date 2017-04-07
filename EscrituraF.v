`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 14:52:32
// Design Name: 
// Module Name: EscrituraF
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


module EscrituraF(WR, clk, reset, Direc, Date, Mes, Year, Day
);

input clk;
input wire [7:0] WR;
input reset;
output wire [7:0] Direc;
output wire [7:0] Date;
output wire [7:0] Mes;
output wire [7:0] Year;
output wire [7:0] Day;

////////////////Inicializador de estados/////////////

localparam [3:0] s0 = 4'h0, 
                 s1 = 4'h1, 
                 s2 = 4'h2, 
                 s3 = 4'h3, 
                 s4 = 4'h4, 
                 s5 = 4'h5;
                 
//////////Fin///////////


reg [7:0] Direc_reg;
reg [7:0] Direc_reg_next = 8'b0;
reg [7:0] WR_reg;
reg [7:0] Date_reg = 8'b0;
reg [7:0] Mes_reg = 8'b0;
reg [7:0] Year_reg = 8'b0;
reg [7:0] Day_reg = 8'b0;
reg [7:0] Date_reg_next = 8'b0;
reg [7:0] Mes_reg_next = 8'b0;
reg [7:0] Year_reg_next = 8'b0;
reg [7:0] Day_reg_next = 8'b0;
////////////Variables de prueba para las direcciones///////////////

    localparam [7:0] ad24 = 8'd0,
                     ad25 = 8'd10, 
                     ad26 = 8'd20,
                     ad27 = 8'd02,
                     adF0 = 8'd15;

                    
///////////////////////////////////////////////

reg [3:0] estado_reg, estado_sig;

 always@ (posedge clk, posedge reset)
       begin
       Date_reg = Date_reg_next;
       Mes_reg = Mes_reg_next;
       Year_reg = Year_reg_next;
       Day_reg = Day_reg_next;
       Direc_reg = Direc_reg_next;
            
            if (reset)
                estado_reg = s1;
            else 
                estado_reg = estado_sig; 
       end

 always@*
       begin
       
       Date_reg_next = 0;
       Mes_reg_next = 0;
       Year_reg_next = 0;
       Day_reg_next = 0;
       Direc_reg_next= 0;
       estado_sig = s1;
        
        case (estado_reg)

            s1:
            begin
            Direc_reg_next = ad24;
            Date_reg_next = WR_reg;
            estado_sig = s2;
            end
            
            s2: 
            begin
            Direc_reg_next = ad25;
            Mes_reg_next = WR_reg;
            estado_sig = s3;
            end
            
            s3: 
            begin
            Direc_reg_next = ad26;
            Year_reg_next = WR_reg;
            estado_sig = s4;
            end         
            
            s4: 
            begin
            Direc_reg_next = 8'h01;
            Day_reg_next = WR_reg;
            estado_sig = s5;
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
assign  Date = Date_reg;
assign  Mes = Mes_reg;
assign  Year = Year_reg;
assign  Day = Day_reg;

endmodule
