`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2017 09:26:28 PM
// Design Name:
// Module Name: timer
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


module timer(
    input reset, clk, sw_timer, sw_ring, siga, tome,
    input [7:0] segT, minT, horT, sw_seg, sw_min, sw_hor, rtc,
    output [7:0] Direc, dato_en_timer, segt_s, mint_s, hort_s,
    output flag_rtc, lea_escriba, rd_timer, flag_ring, timer_activo
    //output [4:0] auxiliar
    );

localparam [4:0]                  // estados de la maquina
                espera = 5'h00,
                state_1 = 5'h01,
                state_2 = 5'h02,
                state_3 = 5'h03,
                state_4 = 5'h04,
                state_5 = 5'h05,
                state_6 = 5'h06,
                state_7 = 5'h07,
                state_8 = 5'h08,
                state_9 = 5'h09,
                state_10 = 5'h0a,
                state_11 = 5'h0b,
                state_12 = 5'h0c,
                state_13 = 5'h0d,
                state_14 = 5'h0e,
                state_15 = 5'h0f,
                state_16 = 5'h10,
                state_17 = 5'h11,
                state_18 = 5'h12,
                state_19 = 5'h13,
                state_20 = 5'h14,
                state_21 = 5'h15,
                state_22 = 5'h16,
                state_23 = 5'h17,
                state_24 = 5'h18,
                state_25 = 5'h19,
                state_26 = 5'h1a,
                state_27 = 5'h1b;

reg [4:0] estado, state_next;  //registros de estado
reg [3:0] ciclos = 0, contador = 0, ciclos_s = 0;

reg load_timer, timer_reg, timer_next, load_ciclos;

reg [7:0] segt_s_reg, mint_s_reg, hort_s_reg, segt_s_next, mint_s_next, hort_s_next;

reg [7:0] sw_c_seg, sw_c_min, sw_c_hor;

reg [7:0] segT_reg, minT_reg, horT_reg,segT_next, minT_next, horT_next,segT_c, minT_c, horT_c;

reg [7:0] resta_seg, resta_min, resta_hor,
resta_seg_next, resta_min_next, resta_hor_next,
resta_seg_reg, resta_min_reg, resta_hor_reg;
reg load_resta;

reg [7:0] sw_seg_reg, sw_min_reg, sw_hor_reg, sw_seg_next, sw_min_next, sw_hor_next;

reg [7:0] direc_reg, direc_next, dato_in, dato_next, dato_out_next, dato_out_reg;

reg flag_rtc_next /*para decir que va usar el rtc*/, lea_escriba_next, /*rd_timer_next*/ flag_rtc_reg, flag_lea_escriba_reg;

reg flag_rd_timer_next, flag_rd_timer;

reg load_rtc, load_lea_escriba, load_rd_timer,
load_datos_sw, load_dato,
load_seg, load_min, load_hor,
load_tempo, load_direc, load_out;

//reg flag_cambio;
//reg [7:0] dato_cambiado;

reg flag_ring_next, load_ring, flag_ring_reg;

//logica de estado siguiente
always @ (posedge clk, posedge reset)
begin
    if (reset)
        estado <= espera;
    else
        estado <= state_next;
end

//contador de ciclos
always @ (posedge clk, posedge reset)//contador temporizador para cambios de estado
begin
    if(reset || ciclos_s == 0)
        contador <= 0;
    else if(contador <= ciclos_s)
        contador <= contador + 1;
    else
        contador <= 0;
end

always @*
begin
    flag_rtc_next = 1'b0;
    lea_escriba_next = 1'b0;
    //rd_timer_next = 1'b0;
    flag_ring_next = 0;
    flag_rd_timer_next = 0;

    sw_seg_next = 8'd00;
    sw_min_next = 8'd00;
    sw_hor_next = 8'd00;

    direc_next = 8'h00;
    dato_next = 8'hzz;
    dato_out_next = 8'h00;

    state_next = espera;
    timer_next = 0;
    ciclos = 0;

    segT_next = 0;
    minT_next = 0;
    horT_next = 0;
    segt_s_next = 0;
    mint_s_next = 0;
    hort_s_next = 0;
    resta_seg_next = 0;
    resta_min_next = 0;
    resta_hor_next = 0;

    load_seg = 0;
    load_min = 0;
    load_hor = 0;
    load_tempo = 0;
    load_rtc = 1'b0;
    load_lea_escriba = 1'b0;
    load_rd_timer = 1'b0;
    load_datos_sw = 1'b0;
    load_ring = 0;
    load_direc = 0;
    load_out = 0;
    load_dato = 0;
    load_resta = 0;
    load_timer = 0;
    load_ciclos = 0;

    case (estado)

        espera:
        begin
            if (sw_timer)
                state_next = state_25;
        end

        state_25:
        begin
            state_next = state_1;
            load_datos_sw = 1;
            sw_seg_next = sw_seg;
            sw_min_next = sw_min;
            sw_hor_next = sw_hor;
            load_tempo = 1;
            segt_s_next = sw_seg_reg;
            mint_s_next = sw_min_reg;
            hort_s_next = sw_hor_reg;
            state_next = state_1;
        end

        state_1:
        begin
            if (~sw_timer)
            begin
                if (sw_seg_reg == 0 & sw_min_reg == 0 & sw_hor_reg == 0 & ~siga)
                    state_next = espera;
                else
                begin
                    load_timer = 1;
                    timer_next = 1;
                    state_next = state_2;
                    if (~siga)
                    begin
                        load_ciclos = 1;
                        ciclos = 8;
                        if (contador == ciclos)
                        begin
                            ciclos = 0;
                            load_rtc = 1;
                            flag_rtc_next = 1;
                            state_next = state_2;
                        end
                    end
                end
            end
            else
                state_next = state_25;
        end

        state_2:
        begin
            load_datos_sw = 1;
            sw_seg_next = sw_c_seg;
            sw_min_next = sw_c_min;
            sw_hor_next = sw_c_hor;
            load_direc = 1;
            flag_rtc_next = 1;
            direc_next = 8'h00;
            state_next = state_2;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_18;
            end
        end

        state_18:
        begin
            state_next = state_18;
            if (tome)
            begin
                load_dato = 1;
                dato_next = rtc;
            end
            if (~siga)
            begin
                state_next = state_3;
                load_rtc = 1;
                flag_rtc_next = 1;
            end
        end
        //state_3:
      //  begin
        //    state_next = state_3;
        //    if (flag_cambio)
        //        load_dato = 1;
        //        state_next = state_4;
        //end

        state_3:
        begin
            load_lea_escriba = 1;
            lea_escriba_next = 1;
            load_out = 1;
            dato_out_next = {dato_in[7:4],1'b1,dato_in [2:0]};
            state_next = state_3;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_19;
            end
        end

        state_19:
        begin
            state_next = state_19;
            if (~siga)
            begin
                state_next = state_4;
                load_timer = 1;
            end
        end

        state_4:
        begin
            load_out = 1;
            load_direc = 1;
            load_lea_escriba = 1;
            load_rd_timer = 1;
            flag_rd_timer_next = 1;
            state_next = state_5;
        end

        state_5:
        begin
            load_seg = 1;
            load_min = 1;
            load_hor = 1;
            segT_next = segT_c;
            minT_next = minT_c;
            horT_next = horT_c;
            state_next = state_6;
        end

        state_6:
        begin
            load_resta = 1;
            if (sw_seg_reg >= segT_reg)
                resta_seg_next = sw_seg_reg - segT_reg;
            else
                resta_seg_next = segT_reg - sw_seg_reg;

            if (sw_min_reg >= minT_reg)
                resta_min_next = sw_min_reg - minT_reg;
            else
                resta_min_next = minT_reg - sw_min_reg;

            resta_hor_next = sw_hor_reg - horT_reg;
            state_next = state_7;
        end

        state_7:
        begin
            load_tempo = 1;
            segt_s_next = resta_seg_reg;
            mint_s_next = resta_min_reg;
            hort_s_next = resta_hor_reg;
            if ((segt_s_reg == 8'h00) & (mint_s_reg == 8'h00) & (hort_s_reg == 8'h00))
            begin
                state_next = state_7;
                //load_timer = 1;
                //timer_next = 1;
                load_rd_timer = 1;
                if (~siga)
                begin
                    load_ciclos = 1;
                    ciclos = 8;
                    state_next = state_7;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        state_next = state_8;
                    end
                end
            end
            else
                state_next = state_5;
        end

        state_8:
        begin
            load_ring = 1;
            load_resta = 1;
            flag_ring_next = 1;
            state_next = state_9;
        end

        state_9:
        begin
            state_next = state_9;
            if (sw_ring)
            begin
                load_ring = 1;
                load_timer = 1;
                timer_next = 1;
                if (~siga)
                begin
                    load_ciclos = 1;
                    ciclos = 8;
                    if (contador == ciclos)
                    begin
                        ciclos = 0;
                        load_rtc = 1;
                        flag_rtc_next = 1;
                        state_next = state_10;
                    end
                end
            end
        end

        state_10:
        begin
            load_lea_escriba = 1;
            lea_escriba_next = 0;
            load_direc = 1;
            load_rtc = 1;
            //flag_rtc_next = 1;
            direc_next = 8'h00;
            state_next = state_10;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_20;
            end

        end

        state_20:
        begin
            state_next = state_20;
            if (tome)
            begin
                load_dato = 1;
                dato_next = rtc;
            end
            if (~siga)
            begin
                state_next = state_11;
                load_rtc = 1;
                flag_rtc_next = 1;
            end
        end

        //state_11:
        //begin
        //    state_next = state_11;
        //    if (flag_cambio)
        //        load_dato = 1;
        //        state_next = state_13;
        //end

        state_11:
        begin
            load_lea_escriba = 1;
            lea_escriba_next = 1;
            load_out = 1;
            dato_out_next = {dato_in[7:4], 1'b0, dato_in [2:0]};
            state_next = state_11;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_21;
            end
        end

        state_21:
        begin
            state_next = state_21;
            if (~siga)
            begin
                state_next = state_12;
                load_rtc = 1;
                flag_rtc_next = 1;
            end
        end

        state_12:
        begin
            load_direc = 1;
            load_out = 1;
            direc_next = 8'h41;
            dato_out_next = 8'h00;
            state_next = state_12;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_22;
            end
        end

        state_22:
        begin
            state_next = state_22;
            if (~siga)
            begin
                state_next = state_13;
                load_rtc = 1;
                flag_rtc_next = 1;
            end
        end

        state_13:
        begin
            load_direc = 1;
            direc_next = 8'h42;
            dato_out_next = 8'h00;
            state_next = state_13;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_23;
            end
        end

        state_23:
        begin
            state_next = state_23;
            if (~siga)
            begin
                state_next = state_14;
                load_rtc = 1;
                flag_rtc_next = 1;
            end
        end

        state_14:
        begin
            load_direc = 1;
            direc_next = 8'h43;
            dato_out_next = 8'h00;
            state_next = state_14;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_24;
            end
        end

        state_24:
        begin
            state_next = state_24;
            if (~siga)
            begin
                state_next = state_26;
                load_rtc = 1;
                flag_rtc_next = 1;
            end
        end

        state_26:
            begin
            load_direc = 1;
            direc_next = 8'hf2;
            dato_out_next = 8'h00;
            state_next = state_26;
            load_rtc = 1;
            load_ciclos = 1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_24;
            end
        end

        state_27:
        begin
            state_next = state_27;
            if (~siga)
            begin
                state_next = state_15;
            end
        end

        state_15:
        begin
            load_direc = 1;
            load_out = 1;
            load_rtc = 1;
            load_datos_sw = 1;
            load_lea_escriba = 1;
            load_timer = 1;
            load_rtc = 1;
            state_next = state_16;
        end

        state_16:
        begin
            load_tempo = 1;
            segt_s_next = 8'h00;
            mint_s_next = 8'h00;
            hort_s_next = 8'h00;
            state_next = state_17;
        end

        state_17:
        begin
            if (~sw_ring)
                state_next = espera;
        end

        default:
        begin
            state_next = espera;
        end

    endcase

end

always @(posedge clk, posedge reset)
begin
    if (reset)
    begin
        segt_s_reg = 0;
        mint_s_reg = 0;
        hort_s_reg = 0;
        segT_reg = 0;
        minT_reg = 0;
        horT_reg = 0;
        sw_seg_reg = 0;
        sw_min_reg = 0;
        sw_hor_reg = 0;
        direc_reg = 0;
        dato_in = 0;
        dato_out_reg = 0;
        //dato_cambiado = 8'hzz;
        //flag_cambio = 0;
        flag_rd_timer = 0;
        flag_rtc_reg = 0;
        flag_lea_escriba_reg = 0;
        flag_ring_reg = 0;
        resta_seg = 8'h00;
        resta_min = 8'h00;
        resta_hor = 8'h00;
        timer_reg = 0;
        ciclos_s = 0;
    end
    else
    begin
        if (load_datos_sw)
        begin
            sw_seg_reg = sw_seg_next;
            sw_min_reg = sw_min_next;
            sw_hor_reg = sw_hor_next;
        end
        if (load_rtc)
            flag_rtc_reg = flag_rtc_next;

        if (load_direc)
            direc_reg = direc_next;

        if (load_dato)
            dato_in = dato_next;
        //if (estado == state_3)
        //begin
        //    dato_cambiado = {dato_in[7:4],1'b0,dato_in [2:0]};
        //    flag_cambio = 1;
        //end
        //else
        //begin
        //    flag_cambio = 0;
        //end
        //if (estado == state_5)
        //    dato_cambiado = 8'hzz;

        if (load_lea_escriba)
            flag_lea_escriba_reg = lea_escriba_next;

        if (load_rd_timer)
            flag_rd_timer = flag_rd_timer_next;

        if (load_seg)
            segT_reg = segT_next;
        if (load_min)
            minT_reg = minT_next;
        if (load_hor)
            horT_reg = horT_next;

        if (load_tempo)
        begin
            segt_s_reg = segt_s_next;
            mint_s_reg = mint_s_next;
            hort_s_reg = hort_s_next;
        end

        if (load_ring)
            flag_ring_reg = flag_ring_next;

        //if (estado == state_11)
        //begin
        //    dato_cambiado = {dato_in[7:4],1'b1,dato_in [2:0]};
        //    flag_cambio = 1;
        //end
        //else
        //begin
        //    flag_cambio = 0;
        //end
        //if (estado == state_13)
        //    dato_cambiado = 8'hzz;

        if (load_out )
            dato_out_reg = dato_out_next;

        if (load_resta)
        begin
            resta_seg = resta_seg_next;
            resta_min = resta_min_next;
            resta_hor = resta_hor_next;
        end

        if (load_timer)
            timer_reg = timer_next;

        if (load_ciclos)
            ciclos_s = ciclos;

    end
end


//convierte los numeros que vienen del rtc a decimal
always @*
begin
    //if (reset)
    //begin
    //    segT_c = 0;
    //    minT_c = 0;
    //    horT_c = 0;
    //    resta_seg_reg = 0;
    //    resta_min_reg = 0;
    //    resta_hor_reg = 0;
    //    sw_c_seg = 0;
    //    sw_c_min = 0;
    //    sw_c_hor = 0;

    //end
    //else
    //begin
        case(segT) //pasa la conversion de segundos
        8'h00: segT_c = 8'd00;
        8'h01: segT_c = 8'd01;
        8'h02: segT_c = 8'd02;
        8'h03: segT_c = 8'd03;
        8'h04: segT_c = 8'd04;
        8'h05: segT_c = 8'd05;
        8'h06: segT_c = 8'd06;
        8'h07: segT_c = 8'd07;
        8'h08: segT_c = 8'd08;
        8'h09: segT_c = 8'd09;
        8'h10: segT_c = 8'd10;
        8'h11: segT_c = 8'd11;
        8'h12: segT_c = 8'd12;
        8'h13: segT_c = 8'd13;
        8'h14: segT_c = 8'd14;
        8'h15: segT_c = 8'd15;
        8'h16: segT_c = 8'd16;
        8'h17: segT_c = 8'd17;
        8'h18: segT_c = 8'd18;
        8'h19: segT_c = 8'd19;
        8'h20: segT_c = 8'd20;
        8'h21: segT_c = 8'd21;
        8'h22: segT_c = 8'd22;
        8'h23: segT_c = 8'd23;
        8'h24: segT_c = 8'd24;
        8'h25: segT_c = 8'd25;
        8'h26: segT_c = 8'd26;
        8'h27: segT_c = 8'd27;
        8'h28: segT_c = 8'd28;
        8'h29: segT_c = 8'd29;
        8'h30: segT_c = 8'd30;
        8'h31: segT_c = 8'd31;
        8'h32: segT_c = 8'd32;
        8'h33: segT_c = 8'd33;
        8'h34: segT_c = 8'd34;
        8'h35: segT_c = 8'd35;
        8'h36: segT_c = 8'd36;
        8'h37: segT_c = 8'd37;
        8'h38: segT_c = 8'd38;
        8'h39: segT_c = 8'd39;
        8'h40: segT_c = 8'd40;
        8'h41: segT_c = 8'd41;
        8'h42: segT_c = 8'd42;
        8'h43: segT_c = 8'd43;
        8'h44: segT_c = 8'd44;
        8'h45: segT_c = 8'd45;
        8'h46: segT_c = 8'd46;
        8'h47: segT_c = 8'd47;
        8'h48: segT_c = 8'd48;
        8'h49: segT_c = 8'd49;
        8'h50: segT_c = 8'd50;
        8'h51: segT_c = 8'd51;
        8'h52: segT_c = 8'd52;
        8'h53: segT_c = 8'd53;
        8'h54: segT_c = 8'd54;
        8'h55: segT_c = 8'd55;
        8'h56: segT_c = 8'd56;
        8'h57: segT_c = 8'd57;
        8'h58: segT_c = 8'd58;
        8'h59: segT_c = 8'd59;
        default: segT_c = 8'd255;
        endcase

        case(minT) //pasa la conversion de minutos
        8'h00: minT_c = 8'd00;
        8'h01: minT_c = 8'd01;
        8'h02: minT_c = 8'd02;
        8'h03: minT_c = 8'd03;
        8'h04: minT_c = 8'd04;
        8'h05: minT_c = 8'd05;
        8'h06: minT_c = 8'd06;
        8'h07: minT_c = 8'd07;
        8'h08: minT_c = 8'd08;
        8'h09: minT_c = 8'd09;
        8'h10: minT_c = 8'd10;
        8'h11: minT_c = 8'd11;
        8'h12: minT_c = 8'd12;
        8'h13: minT_c = 8'd13;
        8'h14: minT_c = 8'd14;
        8'h15: minT_c = 8'd15;
        8'h16: minT_c = 8'd16;
        8'h17: minT_c = 8'd17;
        8'h18: minT_c = 8'd18;
        8'h19: minT_c = 8'd19;
        8'h20: minT_c = 8'd20;
        8'h21: minT_c = 8'd21;
        8'h22: minT_c = 8'd22;
        8'h23: minT_c = 8'd23;
        8'h24: minT_c = 8'd24;
        8'h25: minT_c = 8'd25;
        8'h26: minT_c = 8'd26;
        8'h27: minT_c = 8'd27;
        8'h28: minT_c = 8'd28;
        8'h29: minT_c = 8'd29;
        8'h30: minT_c = 8'd30;
        8'h31: minT_c = 8'd31;
        8'h32: minT_c = 8'd32;
        8'h33: minT_c = 8'd33;
        8'h34: minT_c = 8'd34;
        8'h35: minT_c = 8'd35;
        8'h36: minT_c = 8'd36;
        8'h37: minT_c = 8'd37;
        8'h38: minT_c = 8'd38;
        8'h39: minT_c = 8'd39;
        8'h40: minT_c = 8'd40;
        8'h41: minT_c = 8'd41;
        8'h42: minT_c = 8'd42;
        8'h43: minT_c = 8'd43;
        8'h44: minT_c = 8'd44;
        8'h45: minT_c = 8'd45;
        8'h46: minT_c = 8'd46;
        8'h47: minT_c = 8'd47;
        8'h48: minT_c = 8'd48;
        8'h49: minT_c = 8'd49;
        8'h50: minT_c = 8'd50;
        8'h51: minT_c = 8'd51;
        8'h52: minT_c = 8'd52;
        8'h53: minT_c = 8'd53;
        8'h54: minT_c = 8'd54;
        8'h55: minT_c = 8'd55;
        8'h56: minT_c = 8'd56;
        8'h57: minT_c = 8'd57;
        8'h58: minT_c = 8'd58;
        8'h59: minT_c = 8'd59;
        default: minT_c = 8'd255;
        endcase

        case(horT) //pasa la conversion de horas
        8'h00: horT_c = 8'd00;
        8'h01: horT_c = 8'd01;
        8'h02: horT_c = 8'd02;
        8'h03: horT_c = 8'd03;
        8'h04: horT_c = 8'd04;
        8'h05: horT_c = 8'd05;
        8'h06: horT_c = 8'd06;
        8'h07: horT_c = 8'd07;
        8'h08: horT_c = 8'd08;
        8'h09: horT_c = 8'd09;
        8'h10: horT_c = 8'd10;
        8'h11: horT_c = 8'd11;
        8'h12: horT_c = 8'd12;
        8'h13: horT_c = 8'd13;
        8'h14: horT_c = 8'd14;
        8'h15: horT_c = 8'd15;
        8'h16: horT_c = 8'd16;
        8'h17: horT_c = 8'd17;
        8'h18: horT_c = 8'd18;
        8'h19: horT_c = 8'd19;
        8'h20: horT_c = 8'd20;
        8'h21: horT_c = 8'd21;
        8'h22: horT_c = 8'd22;
        8'h23: horT_c = 8'd23;
        default: horT_c = 8'd255;
        endcase

        case(resta_seg) //pasa la conversion de segundos
        8'd00: resta_seg_reg = 8'h00;
        8'd01: resta_seg_reg = 8'h01;
        8'd02: resta_seg_reg = 8'h02;
        8'd03: resta_seg_reg = 8'h03;
        8'd04: resta_seg_reg = 8'h04;
        8'd05: resta_seg_reg = 8'h05;
        8'd06: resta_seg_reg = 8'h06;
        8'd07: resta_seg_reg = 8'h07;
        8'd08: resta_seg_reg = 8'h08;
        8'd09: resta_seg_reg = 8'h09;
        8'd10: resta_seg_reg = 8'h10;
        8'd11: resta_seg_reg = 8'h11;
        8'd12: resta_seg_reg = 8'h12;
        8'd13: resta_seg_reg = 8'h13;
        8'd14: resta_seg_reg = 8'h14;
        8'd15: resta_seg_reg = 8'h15;
        8'd16: resta_seg_reg = 8'h16;
        8'd17: resta_seg_reg = 8'h17;
        8'd18: resta_seg_reg = 8'h18;
        8'd19: resta_seg_reg = 8'h19;
        8'd20: resta_seg_reg = 8'h20;
        8'd21: resta_seg_reg = 8'h21;
        8'd22: resta_seg_reg = 8'h22;
        8'd23: resta_seg_reg = 8'h23;
        8'd24: resta_seg_reg = 8'h24;
        8'd25: resta_seg_reg = 8'h25;
        8'd26: resta_seg_reg = 8'h26;
        8'd27: resta_seg_reg = 8'h27;
        8'd28: resta_seg_reg = 8'h28;
        8'd29: resta_seg_reg = 8'h29;
        8'd30: resta_seg_reg = 8'h30;
        8'd31: resta_seg_reg = 8'h31;
        8'd32: resta_seg_reg = 8'h32;
        8'd33: resta_seg_reg = 8'h33;
        8'd34: resta_seg_reg = 8'h34;
        8'd35: resta_seg_reg = 8'h35;
        8'd36: resta_seg_reg = 8'h36;
        8'd37: resta_seg_reg = 8'h37;
        8'd38: resta_seg_reg = 8'h38;
        8'd39: resta_seg_reg = 8'h39;
        8'd40: resta_seg_reg = 8'h40;
        8'd41: resta_seg_reg = 8'h41;
        8'd42: resta_seg_reg = 8'h42;
        8'd43: resta_seg_reg = 8'h43;
        8'd44: resta_seg_reg = 8'h44;
        8'd45: resta_seg_reg = 8'h45;
        8'd46: resta_seg_reg = 8'h46;
        8'd47: resta_seg_reg = 8'h47;
        8'd48: resta_seg_reg = 8'h48;
        8'd49: resta_seg_reg = 8'h49;
        8'd50: resta_seg_reg = 8'h50;
        8'd51: resta_seg_reg = 8'h51;
        8'd52: resta_seg_reg = 8'h52;
        8'd53: resta_seg_reg = 8'h53;
        8'd54: resta_seg_reg = 8'h54;
        8'd55: resta_seg_reg = 8'h55;
        8'd56: resta_seg_reg = 8'h56;
        8'd57: resta_seg_reg = 8'h57;
        8'd58: resta_seg_reg = 8'h58;
        8'd59: resta_seg_reg = 8'h59;
        default: resta_seg_reg = 8'hff;
        endcase

        case(resta_min) //pasa la conversion de minutos
        8'd00: resta_min_reg = 8'h00;
        8'd01: resta_min_reg = 8'h01;
        8'd02: resta_min_reg = 8'h02;
        8'd03: resta_min_reg = 8'h03;
        8'd04: resta_min_reg = 8'h04;
        8'd05: resta_min_reg = 8'h05;
        8'd06: resta_min_reg = 8'h06;
        8'd07: resta_min_reg = 8'h07;
        8'd08: resta_min_reg = 8'h08;
        8'd09: resta_min_reg = 8'h09;
        8'd10: resta_min_reg = 8'h10;
        8'd11: resta_min_reg = 8'h11;
        8'd12: resta_min_reg = 8'h12;
        8'd13: resta_min_reg = 8'h13;
        8'd14: resta_min_reg = 8'h14;
        8'd15: resta_min_reg = 8'h15;
        8'd16: resta_min_reg = 8'h16;
        8'd17: resta_min_reg = 8'h17;
        8'd18: resta_min_reg = 8'h18;
        8'd19: resta_min_reg = 8'h19;
        8'd20: resta_min_reg = 8'h20;
        8'd21: resta_min_reg = 8'h21;
        8'd22: resta_min_reg = 8'h22;
        8'd23: resta_min_reg = 8'h23;
        8'd24: resta_min_reg = 8'h24;
        8'd25: resta_min_reg = 8'h25;
        8'd26: resta_min_reg = 8'h26;
        8'd27: resta_min_reg = 8'h27;
        8'd28: resta_min_reg = 8'h28;
        8'd29: resta_min_reg = 8'h29;
        8'd30: resta_min_reg = 8'h30;
        8'd31: resta_min_reg = 8'h31;
        8'd32: resta_min_reg = 8'h32;
        8'd33: resta_min_reg = 8'h33;
        8'd34: resta_min_reg = 8'h34;
        8'd35: resta_min_reg = 8'h35;
        8'd36: resta_min_reg = 8'h36;
        8'd37: resta_min_reg = 8'h37;
        8'd38: resta_min_reg = 8'h38;
        8'd39: resta_min_reg = 8'h39;
        8'd40: resta_min_reg = 8'h40;
        8'd41: resta_min_reg = 8'h41;
        8'd42: resta_min_reg = 8'h42;
        8'd43: resta_min_reg = 8'h43;
        8'd44: resta_min_reg = 8'h44;
        8'd45: resta_min_reg = 8'h45;
        8'd46: resta_min_reg = 8'h46;
        8'd47: resta_min_reg = 8'h47;
        8'd48: resta_min_reg = 8'h48;
        8'd49: resta_min_reg = 8'h49;
        8'd50: resta_min_reg = 8'h50;
        8'd51: resta_min_reg = 8'h51;
        8'd52: resta_min_reg = 8'h52;
        8'd53: resta_min_reg = 8'h53;
        8'd54: resta_min_reg = 8'h54;
        8'd55: resta_min_reg = 8'h55;
        8'd56: resta_min_reg = 8'h56;
        8'd57: resta_min_reg = 8'h57;
        8'd58: resta_min_reg = 8'h58;
        8'd59: resta_min_reg = 8'h59;
        default: resta_min_reg = 8'hff;
        endcase

        case(resta_hor) //pasa la conversion de horas
        8'd00: resta_hor_reg = 8'h00;
        8'd01: resta_hor_reg = 8'h01;
        8'd02: resta_hor_reg = 8'h02;
        8'd03: resta_hor_reg = 8'h03;
        8'd04: resta_hor_reg = 8'h04;
        8'd05: resta_hor_reg = 8'h05;
        8'd06: resta_hor_reg = 8'h06;
        8'd07: resta_hor_reg = 8'h07;
        8'd08: resta_hor_reg = 8'h08;
        8'd09: resta_hor_reg = 8'h09;
        8'd10: resta_hor_reg = 8'h10;
        8'd11: resta_hor_reg = 8'h11;
        8'd12: resta_hor_reg = 8'h12;
        8'd13: resta_hor_reg = 8'h13;
        8'd14: resta_hor_reg = 8'h14;
        8'd15: resta_hor_reg = 8'h15;
        8'd16: resta_hor_reg = 8'h16;
        8'd17: resta_hor_reg = 8'h17;
        8'd18: resta_hor_reg = 8'h18;
        8'd19: resta_hor_reg = 8'h19;
        8'd20: resta_hor_reg = 8'h20;
        8'd21: resta_hor_reg = 8'h21;
        8'd22: resta_hor_reg = 8'h22;
        8'd23: resta_hor_reg = 8'h23;
        default: resta_hor_reg = 8'hff;
        endcase

      //  if (sw_timer)
      //  begin
            case(sw_seg) //pasa la conversion de segundos
            8'h00: sw_c_seg = 8'd00;
            8'h01: sw_c_seg = 8'd01;
            8'h02: sw_c_seg = 8'd02;
            8'h03: sw_c_seg = 8'd03;
            8'h04: sw_c_seg = 8'd04;
            8'h05: sw_c_seg = 8'd05;
            8'h06: sw_c_seg = 8'd06;
            8'h07: sw_c_seg = 8'd07;
            8'h08: sw_c_seg = 8'd08;
            8'h09: sw_c_seg = 8'd09;
            8'h10: sw_c_seg = 8'd10;
            8'h11: sw_c_seg = 8'd11;
            8'h12: sw_c_seg = 8'd12;
            8'h13: sw_c_seg = 8'd13;
            8'h14: sw_c_seg = 8'd14;
            8'h15: sw_c_seg = 8'd15;
            8'h16: sw_c_seg = 8'd16;
            8'h17: sw_c_seg = 8'd17;
            8'h18: sw_c_seg = 8'd18;
            8'h19: sw_c_seg = 8'd19;
            8'h20: sw_c_seg = 8'd20;
            8'h21: sw_c_seg = 8'd21;
            8'h22: sw_c_seg = 8'd22;
            8'h23: sw_c_seg = 8'd23;
            8'h24: sw_c_seg = 8'd24;
            8'h25: sw_c_seg = 8'd25;
            8'h26: sw_c_seg = 8'd26;
            8'h27: sw_c_seg = 8'd27;
            8'h28: sw_c_seg = 8'd28;
            8'h29: sw_c_seg = 8'd29;
            8'h30: sw_c_seg = 8'd30;
            8'h31: sw_c_seg = 8'd31;
            8'h32: sw_c_seg = 8'd32;
            8'h33: sw_c_seg = 8'd33;
            8'h34: sw_c_seg = 8'd34;
            8'h35: sw_c_seg = 8'd35;
            8'h36: sw_c_seg = 8'd36;
            8'h37: sw_c_seg = 8'd37;
            8'h38: sw_c_seg = 8'd38;
            8'h39: sw_c_seg = 8'd39;
            8'h40: sw_c_seg = 8'd40;
            8'h41: sw_c_seg = 8'd41;
            8'h42: sw_c_seg = 8'd42;
            8'h43: sw_c_seg = 8'd43;
            8'h44: sw_c_seg = 8'd44;
            8'h45: sw_c_seg = 8'd45;
            8'h46: sw_c_seg = 8'd46;
            8'h47: sw_c_seg = 8'd47;
            8'h48: sw_c_seg = 8'd48;
            8'h49: sw_c_seg = 8'd49;
            8'h50: sw_c_seg = 8'd50;
            8'h51: sw_c_seg = 8'd51;
            8'h52: sw_c_seg = 8'd52;
            8'h53: sw_c_seg = 8'd53;
            8'h54: sw_c_seg = 8'd54;
            8'h55: sw_c_seg = 8'd55;
            8'h56: sw_c_seg = 8'd56;
            8'h57: sw_c_seg = 8'd57;
            8'h58: sw_c_seg = 8'd58;
            8'h59: sw_c_seg = 8'd59;
            default: sw_c_seg = 8'd255;
            endcase

            case(sw_min) //pasa la conversion de segundos
            8'h00: sw_c_min = 8'd00;
            8'h01: sw_c_min = 8'd01;
            8'h02: sw_c_min = 8'd02;
            8'h03: sw_c_min = 8'd03;
            8'h04: sw_c_min = 8'd04;
            8'h05: sw_c_min = 8'd05;
            8'h06: sw_c_min = 8'd06;
            8'h07: sw_c_min = 8'd07;
            8'h08: sw_c_min = 8'd08;
            8'h09: sw_c_min = 8'd09;
            8'h10: sw_c_min = 8'd10;
            8'h11: sw_c_min = 8'd11;
            8'h12: sw_c_min = 8'd12;
            8'h13: sw_c_min = 8'd13;
            8'h14: sw_c_min = 8'd14;
            8'h15: sw_c_min = 8'd15;
            8'h16: sw_c_min = 8'd16;
            8'h17: sw_c_min = 8'd17;
            8'h18: sw_c_min = 8'd18;
            8'h19: sw_c_min = 8'd19;
            8'h20: sw_c_min = 8'd20;
            8'h21: sw_c_min = 8'd21;
            8'h22: sw_c_min = 8'd22;
            8'h23: sw_c_min = 8'd23;
            8'h24: sw_c_min = 8'd24;
            8'h25: sw_c_min = 8'd25;
            8'h26: sw_c_min = 8'd26;
            8'h27: sw_c_min = 8'd27;
            8'h28: sw_c_min = 8'd28;
            8'h29: sw_c_min = 8'd29;
            8'h30: sw_c_min = 8'd30;
            8'h31: sw_c_min = 8'd31;
            8'h32: sw_c_min = 8'd32;
            8'h33: sw_c_min = 8'd33;
            8'h34: sw_c_min = 8'd34;
            8'h35: sw_c_min = 8'd35;
            8'h36: sw_c_min = 8'd36;
            8'h37: sw_c_min = 8'd37;
            8'h38: sw_c_min = 8'd38;
            8'h39: sw_c_min = 8'd39;
            8'h40: sw_c_min = 8'd40;
            8'h41: sw_c_min = 8'd41;
            8'h42: sw_c_min = 8'd42;
            8'h43: sw_c_min = 8'd43;
            8'h44: sw_c_min = 8'd44;
            8'h45: sw_c_min = 8'd45;
            8'h46: sw_c_min = 8'd46;
            8'h47: sw_c_min = 8'd47;
            8'h48: sw_c_min = 8'd48;
            8'h49: sw_c_min = 8'd49;
            8'h50: sw_c_min = 8'd50;
            8'h51: sw_c_min = 8'd51;
            8'h52: sw_c_min = 8'd52;
            8'h53: sw_c_min = 8'd53;
            8'h54: sw_c_min = 8'd54;
            8'h55: sw_c_min = 8'd55;
            8'h56: sw_c_min = 8'd56;
            8'h57: sw_c_min = 8'd57;
            8'h58: sw_c_min = 8'd58;
            8'h59: sw_c_min = 8'd59;
            default: sw_c_min = 8'd255;
            endcase

            case(sw_hor) //pasa la conversion de horas
            8'h00: sw_c_hor = 8'd00;
            8'h01: sw_c_hor = 8'd01;
            8'h02: sw_c_hor = 8'd02;
            8'h03: sw_c_hor = 8'd03;
            8'h04: sw_c_hor = 8'd04;
            8'h05: sw_c_hor = 8'd05;
            8'h06: sw_c_hor = 8'd06;
            8'h07: sw_c_hor = 8'd07;
            8'h08: sw_c_hor = 8'd08;
            8'h09: sw_c_hor = 8'd09;
            8'h10: sw_c_hor = 8'd10;
            8'h11: sw_c_hor = 8'd11;
            8'h12: sw_c_hor = 8'd12;
            8'h13: sw_c_hor = 8'd13;
            8'h14: sw_c_hor = 8'd14;
            8'h15: sw_c_hor = 8'd15;
            8'h16: sw_c_hor = 8'd16;
            8'h17: sw_c_hor = 8'd17;
            8'h18: sw_c_hor = 8'd18;
            8'h19: sw_c_hor = 8'd19;
            8'h20: sw_c_hor = 8'd20;
            8'h21: sw_c_hor = 8'd21;
            8'h22: sw_c_hor = 8'd22;
            8'h23: sw_c_hor = 8'd23;
            default: sw_c_hor = 8'd255;
            endcase
    //    end
    //end
end



assign Direc = direc_reg;
assign dato_en_timer = dato_out_reg;
assign segt_s = segt_s_reg;
assign mint_s = mint_s_reg;
assign hort_s = hort_s_reg;
assign flag_rtc = flag_rtc_reg;
assign lea_escriba = flag_lea_escriba_reg;
assign rd_timer = flag_rd_timer;
assign flag_ring = flag_ring_reg;
//assign auxiliar = estado;
assign timer_activo = timer_reg;



endmodule
