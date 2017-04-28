`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/10/2017 06:32:13 PM
// Design Name:
// Module Name: top
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


module top(
    input reset, clk, sw_hora, sw_fecha, sw_timer, sw_ring,
    push_up, push_down, push_left, push_right, sw_ds,
    output [2:0] rgb,
    output nada, AD, CS, WR, RD, hsin, vsin,
    inout [7:0] add_datos
    //output [7:0] vgaseg, vgamin, vgahor, vgadia, vgames, vgayear
    );

wire swith_hora, swith_fecha, swith_timer, swith_ring, flag_ring;
wire [7:0] trans_dia, trans_mes, trans_year, trans_ds, trans_seg, trans_min, trans_hor, trans_segT, trans_minT, trans_horT;
wire [7:0] vga_seg_s, vga_min_s, vga_hor_s, vga_dia_s, vga_mes_s, vga_year_s, vga_ds_s, vga_segT, vga_minT, vga_horT;
reg [7:0] trans_ds_nada;

rtc rtc_maquina(
    .Reset(reset),
    .clock(clk),
    .ring_sw(swith_ring),
    .timer_sw(swith_timer),
    .hora_sw(swith_hora),
    .fecha_sw(swith_fecha),
    .hora_seg_in(trans_seg),
    .hora_min_in(trans_min),
    .hora_hor_in(trans_hor),
    .timer_seg_in(trans_segT),
    .timer_min_in(trans_minT),
    .timer_hor_in(trans_horT),
    .fecha_dia_in(trans_dia),
    .fecha_mes_in(trans_mes),
    .fecha_year_in(trans_year),
    .fecha_ds_in(trans_ds),
    .vga_seg(vga_seg_s),
    .vga_min(vga_min_s),
    .vga_hor(vga_hor_s),
    .vga_dia(vga_dia_s),
    .vga_mes(vga_mes_s),
    .vga_year(vga_year_s),
    .vga_sd(vga_ds_s),
    .vga_segt(vga_segT),
    .vga_mint(vga_minT),
    .vga_hort(vga_horT),
    .a_d(AD),
    .cs(CS),
    .rd(RD),
    .wr(WR),
    .led_ring(flag_ring),
    .entradas_rtc(add_datos)
    //.segundos(vga_seg_s),
    //.minutos(vga_min_s),
    //.horas(vga_hor_s)
    );

proyecto1 driver_vga(
    .reset(reset),
    .clk(clk),
    .rgbtext(rgb),
    .hsync(hsin),
    .vsync(vsin),
    .dia(vga_dia_s),
    .mes(vga_mes_s),
    .ano(vga_year_s),
    .horar(vga_hor_s),//vga_hor_s
    .minr(vga_min_s),//vga_min_s
    .segr(vga_seg_s),//vga_seg_s
    .horat(vga_horT),
    .mint(vga_minT),
    .segt(vga_segT),
    .ring(flag_ring)
    );


BotonesRebote eliminador(
    .clk(clk),
    .ES4(sw_ring),
    .ES1(sw_fecha),
    .ES2(sw_hora),
    .ES3(sw_timer),
    .ELeft(push_left),
    .ERight(push_right),
    .EUp(push_up),
    .EDown(push_down),
    .reset(reset),
    .S1(swith_fecha),
    .S2(swith_hora),
    .S3(swith_timer),
    .S4(swith_ring),
    .DiaO(trans_dia),
    .MesO(trans_mes),
    .AO(trans_year),
    .HoraO(trans_hor),
    .MinO(trans_min),
    .SegO(trans_seg),
    .HoraTO(trans_horT),
    .MinTO(trans_minT),
    .SegTO(trans_segT),
    .seg(vga_seg_s),
    .min(vga_min_s),
    .hor(vga_hor_s),
    .day(vga_dia_s),
    .meses(vga_mes_s),
    .years(vga_year_s),
    .segT(vga_segT),
    .minT(vga_minT),
    .horT(vga_horT)
);

always @ ( posedge clk, posedge reset )
begin
    if (reset)
        trans_ds_nada = 8'h00;
    else if (sw_ds)
        trans_ds_nada = 8'hff;
    else
        trans_ds_nada = 8'hzz;
end

assign trans_ds = trans_ds_nada;
assign nada =  vga_ds_s [0] & vga_ds_s [1]  & vga_ds_s [2] & vga_ds_s [3] & vga_ds_s [4] & vga_ds_s [5] & vga_ds_s [6] & vga_ds_s [7];
//assign vgaseg = vga_seg_s;
//assign vgamin = vga_min_s;
//assign vgahor = vga_hor_s;
//assign vgadia = vga_dia_s;
//assign vgames = vga_mes_s;
//assign vgayear = vga_year_s;
endmodule
