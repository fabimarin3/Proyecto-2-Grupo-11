`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2017 06:37:42 PM
// Design Name: 
// Module Name: inicializacion
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


module inicializacion(
    input reset, clk, siga,
    output [7:0] Direc,
    output [7:0] WR, 
    output [4:0] auxiliar,
    output inicializado, escriba
);

reg [7:0] Direc_reg;
reg [7:0] WR_reg;
reg [7:0] Direc_reg_next;
reg [7:0] WR_reg_next;
reg Load, flag_inicializado, load_flag, flag_escriba, load_escriba;
reg inicializado_reg, escriba_reg;

/////////////////Declaracion de los estados////////////////////////////////

localparam [4:0] s0 = 5'h00, 
                 s1 = 5'h01, 
                 s2 = 5'h02, 
                 s3 = 5'h03, 
                 s4 = 5'h04, 
                 s5 = 5'h05, 
                 s6 = 5'h06, 
                 s7 = 5'h07, 
                 s8 = 5'h08, 
                 s9 = 5'h09, 
                 s10 = 5'h0A, 
                 s11 = 5'h0B, 
                 s12 = 5'h0C, 
                 s13 = 5'h0D,
                 s14 = 5'h0E, 
                 s15 = 5'h0F,
                 s16 = 5'h10,
                 s17 = 5'h12;
               
/////////////////Fin declaracion de los estados///////////////////////////


///////////////////   Declaracion de la señal   ////////////////////////////////

reg [4:0] estado_reg, estado_sig; 

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

/////////////////////  Estado siguiente  //////////////////

always@*
    begin 
    Direc_reg_next = 8'h00;
    WR_reg_next =  8'h00;
    estado_sig = s0;
    Load = 1'b0;
    flag_inicializado = 1'b0;
    load_flag = 1'b0;
    flag_escriba = 1'b0;
    load_escriba = 1'b0;
    case (estado_reg)
        s0:
        begin
            if (~reset)
                estado_sig = s1;
        end
    
        s1:
        begin
            flag_escriba = 1'b1;
            load_escriba = 1'b1;
            Load = 1'b1; 
            Direc_reg_next = 8'h02;
            WR_reg_next =  8'h10;
            if (~siga)
                estado_sig = s2;
        end
        
        s2: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h10;
            WR_reg_next =  8'hD2;
             if (~siga)
                estado_sig = s3;
        end
        
        s3: 
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h00;
            WR_reg_next =  8'h00;
            if (~siga)    
                estado_sig = s4;
        end
        
        s4: 
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h01;
            if (~siga)
                estado_sig = s5;
        end
         
        s5: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h21;
            if (~siga)
                estado_sig = s6;
        end
         
        s6: 
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h22;
            if (~siga)
                estado_sig = s7;
        end     
         
        s7: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h23;
            if (~siga)
                estado_sig = s8;
        end  
         
        s8: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h24;
            if (~siga)
                estado_sig = s9;
        end
         
        s9: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h25;
            if (~siga)
                estado_sig = s10;
        end 
         
        s10: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h26;
            if (~siga)
                estado_sig = s11;
        end  
         
        s11: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h27;
            if (~siga)
                estado_sig = s12;
        end   
         
        s12: 
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h41;;
            if (~siga)
                estado_sig = s13;
        end  
         
        s13: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h42;;
            if (~siga)
                estado_sig = s14;
        end
         
        s14: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'h43;
            if (~siga)
                estado_sig = s15;
        end      
         
        s15: 
        begin
            Load = 1'b1;            
            Direc_reg_next = 8'hF0;;
            if (~siga)
                estado_sig = s16;
        end
        
        s16:
        begin
            flag_escriba = 1'b0;
            load_escriba = 1'b1;
            Load = 1'b1;
            Direc_reg_next = 8'hzz;
            WR_reg_next =  8'hzz;
            flag_inicializado = 1'b1;
            load_flag = 1'b1;
            estado_sig = s17;
        end
        
        s17:
        begin
            estado_sig = s17;
        end
        default:
        begin
            Load = 1'b0;            
            estado_sig = s0;
        end        
    
    endcase 
end             
         

always@ (posedge clk, posedge reset)
begin  
   if (reset)
   begin
        Direc_reg = 0;
        WR_reg= 0;
        escriba_reg = 0;
        inicializado_reg = 0;
   end
   else
   begin 
       if (Load)
       begin
            Direc_reg = Direc_reg_next;
            WR_reg= WR_reg_next;
       end
       if (load_escriba)
            escriba_reg = flag_escriba;
       if (load_flag)
            inicializado_reg = flag_inicializado;
   end
end

/////////////////////  FIn de estado siguiente  //////////////////

assign Direc = Direc_reg;
assign WR = WR_reg;
assign auxiliar = estado_reg;
assign inicializado = inicializado_reg;
assign escriba = escriba_reg;
endmodule
