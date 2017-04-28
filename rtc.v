`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/17/2017 09:49:40 PM
// Design Name:
// Module Name: rtc
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


module rtc(
    input Reset, clock, ring_sw, timer_sw, hora_sw, fecha_sw,
    input [7:0] hora_seg_in, hora_min_in, hora_hor_in,
    timer_seg_in, timer_min_in, timer_hor_in,
    fecha_dia_in, fecha_mes_in, fecha_year_in, fecha_ds_in,
    output [7:0] vga_seg, vga_min, vga_hor, vga_dia, vga_mes, vga_year, vga_sd,
    vga_segt, vga_mint, vga_hort, //segundos, minutos, horas,
    output a_d, cs, rd, wr, led_ring,
    inout [7:0] entradas_rtc
    //output [5:0] estado_inicializacion,
    //output [4:0] estado_timer, estado_lectura, estado_wr_hora,
    //output [3:0] estado_wr_rd, estado_wr_fecha
    //output [2:0]  ciclos
    );

//wire [7:0] out_in_rtc;

wire flag_work_rtc, toma_m, seguir, take, can_read, rd_timer_top;

wire inicializar, escriba_inicial, rtc_ini;
wire [7:0] wr_inicial, direc_inicial;
//wire [5:0] estado1;

wire read_hour, read_m, rtc_lectura;
//wire [4:0] estado6;
wire [7:0] rd_rtc_read, direc_read;
wire [7:0] rd_seg, rd_min, rd_hor, rd_dia, rd_mes, rd_year, rd_sd, rd_segt, rd_mint, rd_hort;

wire flag_trabajo, lectura_escritura_m;
wire [7:0] direc, dato, datos_leidos;
//wire [3:0] estado2;
//wire [2:0] tiempo;

wire leer_timer, timer_rtc, rd_wr_timer, activo_timer;
wire [7:0] temporizador_dato, direc_tempo, dato_tempo_out;
//wire [4:0] estado3;

wire need_rtc_hour, wr_rd_hora, reading, activo_hora;
wire [7:0] wr_hora_dato, direc_wr_hora, dato_smh_hora, hour_seg, hour_min, hour_hor;
//wire [4:0] estado4;

wire flag_rtc_fecha, wr_rd_fecha, activa_fecha;
wire [7:0] direc_fecha, dato_dmyd_fecha, date_dia, date_mes, date_year, date_ds;
//wire [3:0] estado5;

handshaking negociacion(
    .clk(clock),//
    .reset(Reset),//
    .rtc_work(flag_work_rtc),//
    .tome(toma_m),//
    .inicializacion(inicializar),//
    .escriba_ini(escriba_inicial),//
    .flag_ini_rtc(rtc_ini),//
    .flag_escribir_hora(need_rtc_hour),//
    .lea_escriba_hora(wr_rd_hora),//
    .flag_hora_lectura(reading),//
    .swith_hora(activo_hora),//
    .flag_escribir_fecha(flag_rtc_fecha),//
    .lea_escriba_fecha(wr_rd_fecha),//
    .swith_fecha(activa_fecha),//
    .flag_timer(timer_rtc),//
    .lea_escriba_timer(rd_wr_timer),//
    .read_timer(leer_timer),//
    .swith_timer(activo_timer),//
    .lea_lectura(read_m),//
    .lectura_rtc(rtc_lectura),//
    .Direc_ini(direc_inicial),//
    .wr_ini(wr_inicial),//
    .Direc_escribir_hora(direc_wr_hora),//
    .dato_hora_wr(dato_smh_hora),//
    .seg_vga_hora(hour_seg),//
    .min_vga_hora(hour_min),//
    .hor_vga_hora(hour_hor),//
    .Direc_escribir_fecha(direc_fecha),//
    .dato_fecha_wr(dato_dmyd_fecha),//
    .dia_vga_fecha(date_dia),//
    .mes_vga_fecha(date_mes),//
    .year_vga_fecha(date_year),//
    .sd_vga_fecha(date_ds),//
    .Direc_timer(direc_tempo),//
    .dato_timer_wr(dato_tempo_out),//
    .Direc_lectura(direc_read),//
    .seg_vga_rd(rd_seg),//
    .min_vga_rd(rd_min),//
    .hor_vga_rd(rd_hor),//
    .dia_vga_rd(rd_dia),//
    .mes_vga_rd(rd_mes),//
    .year_vga_rd(rd_year),//
    .sd_vga_rd(rd_sd),//
    .rtc_read_wr(datos_leidos),//
    .siga_hand(seguir),// <=
    .lea_escriba_hand(lectura_escritura_m),//
    .trabaje_hand(flag_trabajo),//
    .puede_leer_hand(can_read),//
    .tomelo_hand(take),// <=
    .read_timer_lectura_hand(rd_timer_top),//
    .leer_hora(read_hour),//
    .direcion_rtc_hand(direc),//
    .dato_rtc_in_hand(dato),//
    .dato_hora_rd_hand(wr_hora_dato),//
    .dato_timer_rd_hand(temporizador_dato),//
    .dato_lectura_hand(rd_rtc_read),//
    .vga_seg_out(vga_seg),//
    .vga_min_out(vga_min),//
    .vga_hor_out(vga_hor),//
    .vga_dia_out(vga_dia),//
    .vga_mes_out(vga_mes),//
    .vga_year_out(vga_year),//
    .vga_sd_out(vga_sd)//
    );



inicializacion inicializando(
    .reset(Reset),//
    .clk(clock),//
    .siga(seguir),//
    .Direc(direc_inicial),//
    .WR(wr_inicial),//
    //.auxiliar(estado1),
    .inicializado(inicializar),//
    .escriba(escriba_inicial),//
    .flag_rtc_ini(rtc_ini)
);




lectura lectura_rtc(
    .clk(clock),//
    .reset(Reset),//
    .corra(read_hour),//
    .corra_timer(rd_timer_top),//
    .flag_siga(seguir),//
    .tomar_dato(take),//
    .puede_leer(can_read),//
    .RD_reg(rd_rtc_read),//
    .Direc(direc_read),//
    .Seg(rd_seg),//
    .Min(rd_min),//
    .Hor(rd_hor),//
    .Date(rd_dia),//
    .Mes(rd_mes),//
    .Year(rd_year),//
    .Day(rd_sd),//
    .SegT(rd_segt),//
    .MinT(rd_mint),//
    .HorT(rd_hort),//
    .lea(read_m),//
    //.auxiliar(estado6),//
    .flag_rtc(rtc_lectura)//
);


lectura_escritura maquina_leer_escribir(
    .reset(Reset),//
    .clk(clock), // senales de seguridad y cambio//
    .flag_in(flag_trabajo), // bandera para saber cuando se puede usar//
    .lee_escribe_m(lectura_escritura_m), // bandera para saber si escribe o lee//
    .add(direc),//
    .datos(dato), // se le envian datos para el caso de escritura y las direcciones de los registro//
    .flag_work_s(flag_work_rtc), //bandera que nos dice que esta trabajando la maquina //
    .add_data_rtc(entradas_rtc),// recibe y envia el rtc//
    .a_d_s(a_d),//
    .cs_s(cs),//
    .rd_s(rd),//
    .wr_s(wr), // senanales del rtc//
    //.auxiliar(estado2), //es solo una variable para ver los estados en la simulacion
    .data(datos_leidos), //son los datos de salida en caso de ser una lectura//
    //.ciclo(tiempo),//
    .tomar_dato(toma_m)//
    );



timer temporizador(
    .reset(Reset),//
    .clk(clock),//
    .sw_timer(timer_sw),//
    .sw_ring(ring_sw),//
    .siga(seguir),//
    .tome(take),//
    .segT(rd_segt),//
    .minT(rd_mint),//
    .horT(rd_hort),//
    .sw_seg(timer_seg_in),//
    .sw_min(timer_min_in),//
    .sw_hor(timer_hor_in),//
    .rtc(temporizador_dato),//
    .Direc(direc_tempo),//
    .dato_en_timer(dato_tempo_out),//
    .segt_s(vga_segt),//
    .mint_s(vga_mint),//
    .hort_s(vga_hort),//
    .flag_rtc(timer_rtc),//
    .lea_escriba(rd_wr_timer),//
    .rd_timer(leer_timer),//
    .flag_ring(led_ring),//
    //.auxiliar(estado3),//
    .timer_activo(activo_timer)//
    );



escribir_hora escritura_hora(
    .clk(clock),//
    .reset(Reset),//
    .siga(seguir),//
    .sw_hora(hora_sw),//
    .tome(take),//
    .sw_seg(hora_seg_in),//
    .sw_min(hora_min_in),//
    .sw_hor(hora_hor_in),//
    .rtc(wr_hora_dato),//
    .direc(direc_wr_hora),//
    .dato_smh(dato_smh_hora),//
    .vga_seg(hour_seg),//
    .vga_min(hour_min),//
    .vga_hor(hour_hor),//
    .flag_rtc(need_rtc_hour),//
    .lea_escriba(wr_rd_hora),//
    //.auxiliar(estado4),//
    .rd_hora(reading),//
    .hora_activo(activo_hora)//
    );


escribir_fecha escritura_fecha(
    .clk(clock),//
    .reset(Reset),//
    .siga(seguir),//
    .sw_fecha(fecha_sw),//
    .sw_dia(fecha_dia_in),//
    .sw_mes(fecha_mes_in),//
    .sw_year(fecha_year_in),//
    .sw_dia_semana(fecha_ds_in),//
    .direc(direc_fecha),//
    .dato_dmyd(dato_dmyd_fecha),//
    .vga_dia(date_dia),//
    .vga_mes(date_mes),//
    .vga_year(date_year),//
    .vga_dia_semana(date_ds),//
    .flag_rtc(flag_rtc_fecha),//
    .lea_escriba(wr_rd_fecha),//
    //.auxiliar(estado5),//
    .fecha_activo(activa_fecha)
    );


//assign estado_inicializacion = estado1;
//assign estado_wr_rd = estado2;
//assign estado_wr_hora = estado4;
//assign estado_wr_fecha = estado5;
//assign estado_timer = estado3;
//assign estado_lectura = estado6;
//assign segundos = rd_seg;
//assign minutos = rd_min;
//assign horas = rd_hor;
//assign ciclos = tiempo;
endmodule
