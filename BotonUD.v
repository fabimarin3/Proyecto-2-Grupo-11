`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2017 14:04:27
// Design Name: 
// Module Name: BotonUD
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


module BotonUD( reset, Up, Down, Cont, Us,Ds,Um,Dm,Uh,Dh,Ua,Da,Ume,Dme,Ud,Dd
); 

//input clk;
input reset; 
input Up;
input Down;
input Us,Ds,Um,Dm,Uh,Dh,Ua,Da,Ume,Dme,Ud,Dd;
output [3:0]Cont;

reg [3:0] contador_reg = 0;


always@*
   if (Us == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd9)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end   

   else if (Ds == 1) 
    begin
      if (Up == 1)
          if (reset)
              contador_reg = 0;
          else 
          
          begin    
              if (contador_reg == 6'd5)
              contador_reg = 0;
              else
              contador_reg = contador_reg + 1;
            
          end 
   end
  
   else if (Um == 1) 
    begin
      if (Up == 1)
          if (reset)
              contador_reg = 0;
          else 
          
          begin    
              if (contador_reg == 6'd5)
              contador_reg = 0;
              else
              contador_reg = contador_reg + 1;
            
          end 
   end

   else if (Dm == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd9)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end 

   else if (Uh == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd9)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end 

   else if (Dh == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd2)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end 
   
   else if (Ua == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd9)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end 
   
   else if (Da == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd9)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end 

   else if (Ume == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd9)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end 
   
   else if (Dme == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd1)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end
   
   else if (Ud == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd9)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end
   
      else if (Dd == 1 )
    begin
       if (Up == 1)
           if (reset)
               contador_reg = 0;
           else 
           
           begin    
               if (contador_reg == 6'd3)
               contador_reg = 0;
               else
               contador_reg = contador_reg + 1;
             
           end 
   end


assign Cont = contador_reg; 
		




endmodule
