`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/17/2017 02:42:21 PM
// Design Name:
// Module Name: handshaking
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


module handshaking(
    input clk, reset, rtc_work, tome,
    inicializacion, escriba_ini, flag_ini_rtc,
    flag_escribir_hora, lea_escriba_hora, flag_hora_lectura, swith_hora,
    flag_escribir_fecha, lea_escriba_fecha, swith_fecha,
    flag_timer, lea_escriba_timer, read_timer, swith_timer,
    lea_lectura, lectura_rtc,
    input [7:0] Direc_ini, wr_ini,
    Direc_escribir_hora, dato_hora_wr, seg_vga_hora, min_vga_hora, hor_vga_hora,
    Direc_escribir_fecha, dato_fecha_wr, dia_vga_fecha, mes_vga_fecha, year_vga_fecha, sd_vga_fecha,
    Direc_timer, dato_timer_wr,
    Direc_lectura, seg_vga_rd, min_vga_rd, hor_vga_rd, dia_vga_rd, mes_vga_rd, year_vga_rd, sd_vga_rd,
    rtc_read_wr,
    output siga_hand, lea_escriba_hand, trabaje_hand, puede_leer_hand, tomelo_hand, read_timer_lectura_hand, leer_hora,
    output [7:0] direcion_rtc_hand, dato_rtc_in_hand, dato_hora_rd_hand, dato_timer_rd_hand, dato_lectura_hand,
    vga_seg_out, vga_min_out, vga_hor_out, vga_dia_out, vga_mes_out, vga_year_out, vga_sd_out
    );

reg siga, lea_escriba, trabaje, puede_leer, tomelo, read_timer_lectura, read_hora;
reg [7:0] direcion_rtc, dato_rtc_in, dato_hora_rd, dato_timer_rd, dato_lectura,
vga_seg, vga_min, vga_hor, vga_dia, vga_mes, vga_year, vga_sd;

always @ ( posedge clk, posedge reset)
begin
    if (reset) begin
        trabaje = 1'b0;
        siga = 1'b0;
        direcion_rtc = 8'h00;
        dato_rtc_in = 8'h00;
        dato_hora_rd = 8'h00;
        dato_timer_rd = 8'h00;
        dato_lectura = 8'h00;
        lea_escriba = 1'bz;
        puede_leer = 1'b0;
        tomelo = 1'b0;
        read_hora = 1'b1;
        read_timer_lectura = 1'b0;
        vga_seg = 8'h00;
        vga_min = 8'h00;
        vga_hor = 8'h00;
        vga_dia = 8'h00;
        vga_mes = 8'h00;
        vga_year = 8'h00;
        vga_sd = 8'h00;
    end
    else if (~inicializacion)
    begin
        if (~rtc_work)
        begin
            siga = 1'b0;
            trabaje = flag_ini_rtc;
            direcion_rtc = Direc_ini;
            dato_rtc_in = wr_ini;
            lea_escriba = escriba_ini;
        end
        else
        begin
            siga = 1'b1;
        end
        read_timer_lectura = 1'b0;
        puede_leer = 1'b0;
        read_hora = 1'b1;
    end
    else if (swith_hora)
    begin
        if (~rtc_work)
        begin
            siga = 1'b0;
            trabaje = flag_escribir_hora;
            lea_escriba = lea_escriba_hora;
            direcion_rtc = Direc_escribir_hora;
            dato_rtc_in = dato_hora_wr;
        end
        else
        begin
            siga = 1'b1;
        end
        tomelo = tome;
        puede_leer = 1'b0;
        trabaje = flag_escribir_hora;
        direcion_rtc = Direc_escribir_hora;
        lea_escriba = lea_escriba_hora;
        read_hora = flag_hora_lectura;
        vga_seg = seg_vga_hora;
        vga_min = min_vga_hora;
        vga_hor = hor_vga_hora;
        dato_rtc_in = dato_hora_wr;
        if (tome)
        begin
            dato_hora_rd = rtc_read_wr;
        end
    end
    else if (swith_fecha)
    begin
        tomelo = tome;
        vga_dia = dia_vga_fecha;
        vga_mes = mes_vga_fecha;
        vga_year = year_vga_fecha;
        vga_sd = sd_vga_fecha;
        dato_rtc_in = dato_fecha_wr;
        puede_leer = 1'b0;
        direcion_rtc = Direc_escribir_fecha;
        if (~rtc_work)
        begin
            siga = 1'b0;
            trabaje = flag_escribir_fecha;
            direcion_rtc = Direc_escribir_fecha;
            dato_rtc_in = dato_fecha_wr;
            lea_escriba = lea_escriba_fecha;
        end
        else
        begin
            siga = 1'b1;
        end
    end

    else if (swith_timer)
    begin
        //spuede_leer = 1'b0;
        puede_leer = 1'b0;
        tomelo = tome;
        read_timer_lectura = read_timer;
        direcion_rtc = Direc_timer;
        dato_rtc_in = dato_timer_wr;
        lea_escriba = lea_escriba_timer;
        dato_rtc_in = dato_timer_wr;
        if (~rtc_work)
        begin
            siga = 1'b0;
            //puede_leer = 1'b0;
            //trabaje = lectura_rtc;
            trabaje = flag_timer;
            lea_escriba = lea_escriba_timer;
            direcion_rtc = Direc_timer;
            dato_rtc_in = dato_timer_wr;
        end
        else
        begin
            siga = 1'b1;
        end
        if (tome)
            dato_timer_rd = rtc_read_wr;
    end
    else
    begin
        puede_leer = 1'b1;
        tomelo = tome;
        read_timer_lectura = 1;
        read_hora = flag_hora_lectura;
        vga_seg = seg_vga_rd;
        vga_min = min_vga_rd;
        vga_hor = hor_vga_rd;
        vga_dia = dia_vga_rd;
        vga_mes = mes_vga_rd;
        vga_year = year_vga_rd;
        vga_sd = sd_vga_rd;
        if (~rtc_work)
        begin
            siga = 1'b0;
            trabaje = lectura_rtc;
            lea_escriba = lea_lectura;
            direcion_rtc = Direc_lectura;
        end
        else
        begin
            siga = 1'b1;
        end
        if (tome)
            dato_lectura = rtc_read_wr;
    end
end

assign siga_hand = siga;
assign lea_escriba_hand = lea_escriba;
assign trabaje_hand = trabaje;
assign puede_leer_hand = puede_leer;
assign tomelo_hand = tomelo;
assign read_timer_lectura_hand = read_timer_lectura;
assign direcion_rtc_hand = direcion_rtc;
assign dato_rtc_in_hand = dato_rtc_in;
assign dato_hora_rd_hand = dato_hora_rd;
assign dato_timer_rd_hand = dato_timer_rd;
assign dato_lectura_hand = dato_lectura;
assign vga_seg_out = vga_seg;
assign vga_min_out = vga_min;
assign vga_hor_out = vga_hor;
assign vga_dia_out = vga_dia;
assign vga_mes_out = vga_mes;
assign vga_year_out = vga_year;
assign vga_sd_out = vga_sd;
assign leer_hora = read_hora;
endmodule
