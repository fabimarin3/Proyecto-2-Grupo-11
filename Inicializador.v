`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 13:40:36
// Design Name: 
// Module Name: Inicializador
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


module Inicializador (Direc, WR, clk, reset, auxiliar
);

input clk, reset;
output [7:0] Direc;
output [7:0] WR;
output [3:0] auxiliar; 


//wire [7:0] Direc_cable;
//wire [7:0] WR_cable;

reg [7:0] Direc_reg;
reg [7:0] WR_reg;
reg [7:0] Direc_reg_next;
reg [7:0] WR_reg_next;
reg Load;







/////////////////Declaracion de los estados////////////////////////////////

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
                 s10 = 4'h0A, 
                 s11 = 4'h0B, 
                 s12 = 4'h0C, 
                 s13 = 4'h0D,
                 s14 = 4'h0E, 
                 s15 = 4'h0F;
               
/////////////////Fin declaracion de los estados///////////////////////////


///////////////////   Declaracion de la señal   ////////////////////////////////

reg [3:0] estado_reg, estado_sig; 

////////////////////// Fin de la declaracion de la señal //////////////////////


/////////////////////  Estado de Registro  //////////////////
 
       always@ (posedge clk, posedge reset)
        
       begin
        
            if (reset)
                estado_reg = s0;
            else 
                estado_reg = estado_sig; 
       end
       


////////////////////// Fin de Estado de Registro //////////////////////
 
      always@ (posedge clk, posedge reset)
       
      begin
               
           if (reset)
           begin
                Direc_reg = 0;
                WR_reg= 0;
           end
           else if (Load)
            begin
                Direc_reg = Direc_reg_next;
                WR_reg= WR_reg_next;
            end
      end

 


/////////////////////  Estado siguiente  //////////////////

       always@*
       begin 
       
       Direc_reg_next = 8'h00;
       WR_reg_next =  8'h00;
       estado_sig = s0;
       Load = 1'b0;
       
        case (estado_reg)
            
    
            s0:
            begin 
            estado_sig = s1;
            end

            s1:
            begin
            Load = 1'b1; 
            Direc_reg_next = 8'h02;
            WR_reg_next =  8'h10;
            estado_sig = s2;
            end
            
            s2: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h10;
            WR_reg_next =  8'hD2;
            estado_sig = s3;
            end
            
            s3: 
            begin
            Load = 1'b1;
            Direc_reg_next = 8'h00;
            WR_reg_next =  8'h00;
            estado_sig = s4;
            end
            
            s4: 
            begin
            Load = 1'b1;
            Direc_reg_next = 8'h01;
            estado_sig = s5;
            end
             
            s5: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h21;
            estado_sig = s6;
            end
             
            s6: 
            begin
            Load = 1'b1;
            Direc_reg_next = 8'h22;
            estado_sig = s7;
            end     
             
            s7: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h23;
            estado_sig = s8;
            end  
             
            s8: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h24;
            estado_sig = s9;
            end
             
            s9: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h25;
            estado_sig = s10;
            end 
             
            s10: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h26;
            estado_sig = s11;
            end  
             
            s11: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h27;
            estado_sig = s12;
            end   
             
            s12: 
            begin
            Load = 1'b1;
            Direc_reg_next = 8'h41;;
            estado_sig = s13;
            end  
             
            s13: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h42;;
            estado_sig = s14;
            end
             
            s14: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'h43;
            estado_sig = s15;
            end      
             
            s15: 
            begin
            Load = 1'b1;            
            Direc_reg_next = 8'hF0;;
            end
 
            default:
            begin
            Load = 1'b0;            
            estado_sig = s0;
            end        
        
        endcase 
        end             
         

/////////////////////  FIn de estado siguiente  //////////////////

assign Direc = Direc_reg;
assign WR = WR_reg;
assign auxiliar = estado_reg;

endmodule
