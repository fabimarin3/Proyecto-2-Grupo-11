`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 13:43:20
// Design Name: 
// Module Name: Lectura
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


module Lectura(RD, clk, reset, Direc, Seg, Min, Hor, Date, Mes, Year, Day, SegT, MinT, HorT
);

input clk;
input reset;
input wire [7:0] RD;
output wire [7:0] Direc;
output wire [7:0] Seg, Min, Hor, Date, Mes, Year, Day, SegT, MinT, HorT;
 


reg [7:0] Direc_reg;
reg [7:0] Direc_reg_next = 8'b0;
reg [7:0] RD_reg;
reg [7:0] Seg_reg = 8'b0;
reg [7:0] Min_reg = 8'b0;
reg [7:0] Hor_reg = 8'b0;
reg [7:0] Date_reg = 8'b0;
reg [7:0] Mes_reg = 8'b0;
reg [7:0] Year_reg = 8'b0;
reg [7:0] Day_reg = 8'b0;
reg [7:0] SegT_reg = 8'b0;
reg [7:0] MinT_reg = 8'b0;
reg [7:0] HorT_reg = 8'b0;
reg [7:0] Seg_reg_next = 8'b0;
reg [7:0] Min_reg_next = 8'b0 ;
reg [7:0] Hor_reg_next = 8'b0;
reg [7:0] Date_reg_next = 8'b0;
reg [7:0] Mes_reg_next = 8'b0;
reg [7:0] Year_reg_next = 8'b0;
reg [7:0] Day_reg_next = 8'b0;
reg [7:0] SegT_reg_next = 8'b0;
reg [7:0] MinT_reg_next = 8'b0;
reg [7:0] HorT_reg_next = 8'b0;


 


////////////Estados para el ciclo///////////////

localparam [3:0] s0 = 4'h0, 
                 s1 = 4'h1, 
                 s2 = 4'h2, 
                 s3 = 4'h3, 
                 s4 = 4'h4, 
                 s5 = 4'h5, 
                 s6 = 4'h6, 
                 s7 = 4'h7, 
                 s8 = 4'h8, 
                 s9 = 4'h9, 
                 s10 = 4'h0A;
                    
///////////////////////////////////////////////


////////////Variables de prueba para las direcciones///////////////

    localparam [7:0] ad21 = 8'd0,
                     ad22 = 8'd10, 
                     ad23 = 8'd20, 
                     ad24 = 8'd30,
                     ad25 = 8'd40, 
                     ad26 = 8'd22,  
                     ad27 = 8'd24, 
                     ad41 = 8'd26, 
                     ad42 = 8'd16, 
                     ad43 = 8'd05,
                     adF0 = 8'd15,
                     adF1 = 8'd03;

                    
///////////////////////////////////////////////


reg [3:0] estado_reg, estado_sig; 

////////////////////// Fin de la declaracion de la señal //////////////////////


/////////////////////  Estado de Registro  //////////////////
 
       always@ (posedge clk, posedge reset)
       begin
       Seg_reg = Seg_reg_next;
       Min_reg = Min_reg_next;
       Hor_reg = Hor_reg_next;
       Date_reg = Date_reg_next;
       Mes_reg = Mes_reg_next;
       Year_reg = Year_reg_next;
       Day_reg = Day_reg_next;
       SegT_reg = SegT_reg_next;
       MinT_reg = MinT_reg_next;
       HorT_reg = HorT_reg_next;
       Direc_reg = Direc_reg_next;
            
            if (reset)
                estado_reg = s1;
            else 
                estado_reg = estado_sig; 
       end
       


////////////////////// Fin de Estado de Registro //////////////////////

/////////////////////  Estado siguiente  //////////////////

       

       always@*
       begin
      
       Seg_reg_next = 0;
       Min_reg_next = 0;
       Hor_reg_next = 0;
       Date_reg_next = 0;
       Mes_reg_next = 0;
       Year_reg_next = 0;
       Day_reg_next = 0;
       SegT_reg_next = 0;
       MinT_reg_next = 0;
       HorT_reg_next = 0;
       Direc_reg_next= 0;
       estado_sig = s1;
        
        case (estado_reg)

            s1:
            begin
            Direc_reg_next = ad21;
            Seg_reg_next = RD_reg;
            estado_sig = s2;
            end
            
            s2: 
            begin
            Direc_reg_next = ad22;
            Min_reg_next = RD_reg;
            estado_sig = s3;
            end
            
            s3: 
            begin
            Direc_reg_next = ad23;
            Hor_reg_next = RD_reg;
            estado_sig = s4;
            end

        
            s4: 
            begin
            Direc_reg_next = ad24;
            Date_reg_next = RD_reg;
            estado_sig = s5;
            end
             
            s5: 
            begin
            Direc_reg_next = ad25;
            Mes_reg_next = RD_reg;
            estado_sig = s6;
            end
             
            s6: 
            begin
            Direc_reg_next = ad26;
            Year_reg_next = RD_reg;
            estado_sig = s7;
            end     
             
            s7: 
            begin
            Direc_reg_next = ad27;
            Day_reg_next = RD_reg;;
            estado_sig = s8;
            end  
             
            s8: 
            begin
            Direc_reg_next = ad41;
            SegT_reg_next = RD_reg;
            estado_sig = s9;
            end
             
            s9: 
            begin
            Direc_reg_next = ad42;
            MinT_reg_next = RD_reg;
            estado_sig = s10;
            end 
             
            s10: 
            begin
            Direc_reg_next = ad43;
            HorT_reg_next = RD_reg;
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
        
       RD_reg =  RD;
       
       end
       
       
assign  Direc = Direc_reg;
assign  Seg = Seg_reg;
assign  Min = Min_reg;
assign  Hor = Hor_reg;
assign  Date = Date_reg;
assign  Mes = Mes_reg;
assign  Year = Year_reg;
assign  Day = Day_reg;
assign  SegT = SegT_reg;
assign  MinT = MinT_reg;
assign  HorT= HorT_reg;


endmodule
