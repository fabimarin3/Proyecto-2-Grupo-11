`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2017 09:06:31 PM
// Design Name: 
// Module Name: lectura
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


module lectura(
    input clk,
    input reset,
    input corra, corra_timer, flag_siga, tomar_dato, puede_leer,
    input [7:0] RD_reg,
    output wire [7:0] Direc,
    output wire [7:0] Seg, Min, Hor, Date, Mes, Year, Day, SegT, MinT, HorT,
    output lea
);

reg leer, load_leer, lea_reg;
reg [7:0] Direc_reg;
reg [7:0] Direc_reg_next = 8'hf1;
//reg [7:0] RD_reg;
reg [7:0] Seg_reg = 8'h00;
reg [7:0] Min_reg = 8'h00;
reg [7:0] Hor_reg = 8'h00;
reg [7:0] Date_reg = 8'h00;
reg [7:0] Mes_reg = 8'h00;
reg [7:0] Year_reg = 8'h00;
reg [7:0] Day_reg = 8'h00;
reg [7:0] SegT_reg = 8'h00;
reg [7:0] MinT_reg = 8'h00;
reg [7:0] HorT_reg = 8'h00;
reg [7:0] Seg_reg_next = 8'h00;
reg [7:0] Min_reg_next = 8'h00;
reg [7:0] Hor_reg_next = 8'h00;
reg [7:0] Date_reg_next = 8'h00;
reg [7:0] Mes_reg_next = 8'h00;
reg [7:0] Year_reg_next = 8'h00;
reg [7:0] Day_reg_next = 8'h00;
reg [7:0] SegT_reg_next = 8'h00;
reg [7:0] MinT_reg_next = 8'h00;
reg [7:0] HorT_reg_next = 8'h00;
reg [7:0] nada = 8'h00;

//variable de carga
reg Seg_load = 1'b0;
reg Min_load = 1'b0;
reg Hor_load = 1'b0;
reg Date_load = 1'b0;
reg Mes_load = 1'b0;
reg Year_load = 1'b0;
reg Day_load = 1'b0;
reg SegT_load = 1'b0;
reg MinT_load = 1'b0;
reg HorT_load = 1'b0;


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
                 s10 = 4'ha,
                 s11 = 4'hb,
                 s12 = 4'hc,
                 s13 = 4'hd;
                    
///////////////////////////////////////////////


////////////Variables de prueba para las direcciones///////////////

localparam [7:0] ad21 = 8'h21,
                 ad22 = 8'h22, 
                 ad23 = 8'h23, 
                 ad24 = 8'h24,
                 ad25 = 8'h25, 
                 ad26 = 8'h26,  
                 ad27 = 8'h27, 
                 ad41 = 8'h41, 
                 ad42 = 8'h42, 
                 ad43 = 8'h43,
                 adF1 = 8'hf1,
                 adF2 = 8'hf2;

                    
///////////////////////////////////////////////


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
    Direc_reg_next= 8'hzz;
    
    Seg_load = 1'b0;
    Min_load = 1'b0;
    Hor_load = 1'b0;
    Date_load = 1'b0;
    Mes_load = 1'b0;
    Year_load = 1'b0;
    Day_load = 1'b0;
    SegT_load = 1'b0;
    MinT_load = 1'b0;
    HorT_load = 1'b0;
    
    nada = 0;
    leer = 1'bz;
    load_leer = 0;
    
    estado_sig = s0;
    
    if (puede_leer)
    begin
        case (estado_reg)
            s0:
            begin
                load_leer = 1;
                leer = 0;
                estado_sig = s0;
                if (corra)
                    estado_sig = s1;
                else 
                    estado_sig = s9;
            end
            
            s1:
            begin
                if (corra)
                begin
                    Direc_reg_next = adF1;
                    estado_sig = s1;
                    if(tomar_dato)
                        nada = RD_reg;
                    if(~flag_siga)
                        estado_sig = s2;
                end
                else 
                    estado_sig = s9;
            end
            
            s2:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad21;
                    estado_sig = s2;
                    if(tomar_dato)
                        Seg_load = 1;
                        Seg_reg_next = RD_reg;
                    if(~flag_siga)
                        estado_sig = s3;
                end
                else 
                    estado_sig = s9;
            end
            
            s3: 
            begin
                if (corra)
                begin
                    Direc_reg_next = ad22;
                    estado_sig = s3;
                    if(tomar_dato)
                        Min_load = 1;
                        Min_reg_next = RD_reg;
                    if(~flag_siga)
                        estado_sig = s4;
                end
                else 
                    estado_sig = s9;
            end
            
            s4: 
            begin
                if (corra)
                begin
                    Direc_reg_next = ad23;
                    estado_sig = s4;
                    if(tomar_dato)
                        Hor_load = 1;
                        Hor_reg_next = RD_reg;
                    if(~flag_siga)
                        estado_sig = s5;
                end
                else 
                    estado_sig = s9;
            end
        
        
            s5: 
            begin
                if (corra)
                begin
                    Direc_reg_next = ad24;
                    estado_sig = s5;
                    if(tomar_dato)
                        Date_load = 1;
                        Date_reg_next = RD_reg;
                    if(~flag_siga)
                        estado_sig = s6;
                end
                else 
                    estado_sig = s9;
            end
             
            s6: 
            begin
                if (corra)
                begin
                    Direc_reg_next = ad25;
                    estado_sig = s6;
                    if(tomar_dato)
                        Mes_load = 1;
                        Mes_reg_next = RD_reg;
                    if(~flag_siga)
                        estado_sig = s7;
                end
                else 
                    estado_sig = s9;
            end
             
            s7: 
            begin
                if (corra)
                begin
                    Direc_reg_next = ad26;
                    estado_sig = s7;
                    if(tomar_dato)
                        Year_load = 1;
                        Year_reg_next = RD_reg;
                    if(~flag_siga)
                        estado_sig = s8;
                end
                else 
                    estado_sig = s9;
            end     
             
            s8: 
            begin
                if (corra)
                begin
                    Direc_reg_next = ad27;
                    estado_sig = s8;
                    if(tomar_dato)
                        Day_load = 1;
                        Day_reg_next = RD_reg;
                    if(~flag_siga)
                    begin
                        if (corra_timer)
                            estado_sig = s9;
                        else
                            estado_sig = s13;
                    end
                end
                else 
                    estado_sig = s9;
            end  
            
            s9:
            begin
                if (corra_timer)
                begin
                    Direc_reg_next = adF2;
                    estado_sig = s9;
                    if(tomar_dato)
                        nada = RD_reg;
                    if(~flag_siga)
                        estado_sig = s10;
                end
                else
                    estado_sig = s13;
            end
            
            s10: 
            begin
                if (corra_timer)
                    Direc_reg_next = ad41;
                    estado_sig = s10;
                    if(tomar_dato)
                        SegT_load = 1;
                        SegT_reg_next = RD_reg;
                    if (~flag_siga)
                        estado_sig = s11;   
                else
                    estado_sig = s13;
            end
             
            s11: 
            begin
                if (corra_timer)
                    Direc_reg_next = ad42;
                    estado_sig = s11;
                    if(tomar_dato)
                        MinT_load = 1;
                        MinT_reg_next = RD_reg;
                    if(~flag_siga)
                    estado_sig = s12;
                else
                    estado_sig = s13;
            end 
             
            s12: 
            begin
                if (corra_timer)
                begin
                    Direc_reg_next = ad43;
                    estado_sig = s12;
                    if(tomar_dato)
                        HorT_load = 1;
                        HorT_reg_next = RD_reg;
                    if(~flag_siga)
                        estado_sig = s13;
                end
                else
                    estado_sig = s13;
            end  
            
            s13:
            begin
                Direc_reg_next = 8'hzz;
                estado_sig = s0;
                load_leer = 1;
            end
            
            default:
            begin
                estado_sig = s0;
            end        
        
             
        
        endcase 
    end
    else
    begin
        Direc_reg_next = 8'hzz;
        load_leer = 1;
    end
end             
         

/////////////////////  FIn de estado siguiente  //////////////////

always@ (posedge clk, posedge reset)
begin
    if (reset)
    begin
        //RD_reg =  RD;
        Seg_reg = 0;
        Min_reg = 0;
        Hor_reg = 0;
        Date_reg = 0;
        Mes_reg = 0;
        Year_reg = 0;
        Day_reg = 0;
        SegT_reg = 0;
        MinT_reg = 0;
        HorT_reg = 0;
        Direc_reg = 0; 
        lea_reg = 0;
    end
    else
    begin
        Direc_reg = Direc_reg_next; 
        //RD_reg =  RD;
        if (Seg_load)
            Seg_reg = Seg_reg_next;
        if(Min_load)
            Min_reg = Min_reg_next;
        if (Hor_load)
            Hor_reg = Hor_reg_next;
        if (Date_load)
            Date_reg = Date_reg_next;
        if (Mes_load)
            Mes_reg = Mes_reg_next;
        if (Year_load)
            Year_reg = Year_reg_next;
        if (Day_load)
            Day_reg = Day_reg_next;
        if (SegT_load)
            SegT_reg = SegT_reg_next;
        if (MinT_load)
            MinT_reg = MinT_reg_next;
        if (HorT_load)
            HorT_reg = HorT_reg_next;
        if (load_leer)
            lea_reg = leer;
        Direc_reg = Direc_reg_next; 
        
    end

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
assign  lea = lea_reg;
endmodule
