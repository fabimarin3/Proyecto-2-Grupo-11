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
    output lea, flag_rtc
    //output [4:0] auxiliar
);

reg leer, load_leer, lea_reg, load_rtc, rtc_flag, rtc_reg, load_ciclos;
reg [7:0] Direc_reg;
reg [7:0] Direc_reg_next = 8'hf1;
//reg [7:0] RD_reg;
reg [7:0] Seg_reg;
reg [7:0] Min_reg;
reg [7:0] Hor_reg;
reg [7:0] Date_reg;
reg [7:0] Mes_reg;
reg [7:0] Year_reg;
reg [7:0] Day_reg;
reg [7:0] SegT_reg;
reg [7:0] MinT_reg;
reg [7:0] HorT_reg;
reg [7:0] Seg_reg_next;
reg [7:0] Min_reg_next;
reg [7:0] Hor_reg_next;
reg [7:0] Date_reg_next;
reg [7:0] Mes_reg_next;
reg [7:0] Year_reg_next;
reg [7:0] Day_reg_next;
reg [7:0] SegT_reg_next;
reg [7:0] MinT_reg_next;
reg [7:0] HorT_reg_next;
reg [7:0] nada;

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
                 s10 = 5'h0a,
                 s11 = 5'h0b,
                 s12 = 5'h0c,
                 s13 = 5'h0d,
                 s14 = 5'h0e,
                 s15 = 5'h0f,
                 s16 = 5'h10,
                 s17 = 5'h11,
                 s18 = 5'h12,
                 s19 = 5'h13,
                 s20 = 5'h14,
                 s21 = 5'h15,
                 s22 = 5'h16,
                 s23 = 5'h17,
                 s24 = 5'h18,
                 s25 = 5'h19,
                 s26 = 5'h1a;

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


reg [4:0] estado_reg, estado_sig;
reg [1:0] ciclos = 0, contador = 0, ciclos_s = 0;

////////////////////// Fin de la declaracion de la señal //////////////////////


/////////////////////  Estado de Registro  //////////////////

always@ (posedge clk, posedge reset)
begin
    if (reset)
        estado_reg = s0;
    else
        estado_reg = estado_sig;
end

always @ (posedge clk, posedge reset)//contador temporizador para cambios de estado
begin
    if(reset || ciclos_s == 0)
        contador <= 0;
    else if(contador <= ciclos_s)
        contador <= contador + 1;
    else
        contador <= 0;
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

    load_ciclos = 0;
    ciclos = 0;

    load_rtc = 1'b0;
    rtc_flag = 1'b0;

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
                begin
                    estado_sig = s1;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
                else
                begin
                    estado_sig = s9;
                end
            end

            s1:
            begin
                if (corra)
                begin
                    Direc_reg_next = adF1;
                    estado_sig = s1;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s14;
                    end
                end
                else
                    estado_sig = s9;
            end

            s14:
            begin
                estado_sig = s14;
                if(tomar_dato)
                    nada = RD_reg;
                if(~flag_siga)
                begin
                    estado_sig = s2;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s2:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad21;
                    estado_sig = s2;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s15;
                    end
                end
                else
                    estado_sig = s9;
            end

            s15:
            begin
                estado_sig = s15;
                if(tomar_dato)
                begin
                    Seg_load = 1;
                    Seg_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    estado_sig = s3;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s3:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad22;
                    estado_sig = s3;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s16;
                    end
                end
                else
                    estado_sig = s9;
            end

            s16:
            begin
                estado_sig = s16;
                if(tomar_dato)
                begin
                    Min_load = 1;
                    Min_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    estado_sig = s4;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s4:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad23;
                    estado_sig = s4;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s17;
                    end
                end
                else
                    estado_sig = s9;
            end

            s17:
            begin
                estado_sig = s17;
                if(tomar_dato)
                begin
                    Hor_load = 1;
                    Hor_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    estado_sig = s5;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s5:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad24;
                    estado_sig = s5;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s18;
                    end
                end
                else
                    estado_sig = s9;
            end

            s18:
            begin
                estado_sig = s18;
                if(tomar_dato)
                begin
                    Date_load = 1;
                    Date_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    estado_sig = s6;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s6:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad25;
                    estado_sig = s6;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s19;
                    end
                end
                else
                    estado_sig = s9;
            end

            s19:
            begin
                estado_sig = s19;
                if(tomar_dato)
                begin
                    Mes_load = 1;
                    Mes_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    estado_sig = s7;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s7:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad26;
                    estado_sig = s7;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s20;
                    end
                end
                else
                begin
                    estado_sig = s9;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s20:
            begin
                estado_sig = s20;
                if(tomar_dato)
                    Year_load = 1;
                    Year_reg_next = RD_reg;
                if(~flag_siga)
                    estado_sig = s8;
            end

            s8:
            begin
                if (corra)
                begin
                    Direc_reg_next = ad27;
                    estado_sig = s8;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s21;
                    end
                end
                else
                    estado_sig = s9;
            end

            s21:
            begin
                estado_sig = s21;
                if(tomar_dato)
                begin
                    Day_load = 1;
                    Day_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    if (corra_timer)
                    begin
                        estado_sig = s22;
                        load_rtc = 1'b1;
                        rtc_flag = 1'b1;
                    end
                    else
                        estado_sig = s13;
                end
            end

            s9:
            begin
                if (corra_timer)
                begin
                    estado_sig = s22;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
                else
                begin
                    estado_sig = s13;
                end
            end

            s22:
            begin
                if (corra_timer)
                begin
                    Direc_reg_next = adF2;
                    estado_sig = s22;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s23;
                    end
                end
                else
                    estado_sig = s13;
            end

            s23:
            begin
                estado_sig = s23;
                if(tomar_dato)
                    nada = RD_reg;
                if(~flag_siga)
                begin
                    estado_sig = s10;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s10:
            begin
                if (corra_timer)
                    Direc_reg_next = ad41;
                    estado_sig = s10;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s24;
                    end
                else
                    estado_sig = s13;
            end

            s24:
            begin
                estado_sig = s24;
                if(tomar_dato)
                begin
                    SegT_load = 1;
                    SegT_reg_next = RD_reg;
                end
                if (~flag_siga)
                begin
                    estado_sig = s11;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s11:
            begin
                if (corra_timer)
                    Direc_reg_next = 8'h42;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    estado_sig = s11;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s25;
                    end
                else
                    estado_sig = s13;
            end

            s25:
            begin
                estado_sig = s25;
                if(tomar_dato)
                begin
                    MinT_load = 1;
                    MinT_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    estado_sig = s12;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
            end

            s12:
            begin
                if (corra_timer)
                begin
                    Direc_reg_next = ad43;
                    estado_sig = s12;
                    load_rtc = 1;
                    load_ciclos = 1;
                    ciclos = 2;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        estado_sig = s26;
                    end
                end
                else
                    estado_sig = s13;
            end

            s26:
            begin
                estado_sig = s26;
                if(tomar_dato)
                begin
                    HorT_load = 1;
                    HorT_reg_next = RD_reg;
                end
                if(~flag_siga)
                begin
                    estado_sig = s13;
                    load_rtc = 1'b1;
                    rtc_flag = 1'b1;
                end
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
        rtc_reg = 0;
        ciclos_s = 0;
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
        if (load_rtc)
            rtc_reg = rtc_flag;
        if (load_ciclos)
            ciclos_s = ciclos;

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
//assign  auxiliar = estado_reg;
assign  flag_rtc = rtc_reg;
endmodule
