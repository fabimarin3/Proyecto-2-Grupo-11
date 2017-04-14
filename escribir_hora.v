`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/12/2017 11:54:16 PM
// Design Name:
// Module Name: escribir_hora
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


module escribir_hora(
    input clk, reset, siga, sw_hora, tome,
    input [7:0] sw_seg, sw_min, sw_hor, rtc,
    output [7:0] direc, dato_smh, vga_seg, vga_min, vga_hor,
    output flag_rtc, lea_escriba,
    output [3:0] auxiliar
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
                state_11 = 5'h0b;


reg [3:0] estado, state_next;  //registros de estado

reg load_rtc, flag_rtc_reg, flag_rtc_next;

reg load_lea_escriba, flag_lea_escriba, lea_escriba_next;

reg [7:0] direc_reg, direc_next, dato_smh_reg, dato_smh_next, dato_in, dato_in_next;
reg load_direc, load_dato, load_dato_in;

reg [7:0] sw_seg_reg, sw_min_reg, sw_hor_reg, sw_seg_next, sw_min_next, sw_hor_next;
reg load_sw;

reg [7:0] vga_seg_reg, vga_min_reg, vga_hor_reg, vga_seg_next, vga_min_next, vga_hor_next;
reg load_vga;




//logica de estado siguiente
always @ (posedge clk, posedge reset)
begin
    if (reset)
        estado <= espera;
    else
        estado <= state_next;
end

always @*
begin
    load_rtc = 0;
    load_direc = 0;
    load_dato = 0;
    load_dato_in = 0;
    dato_in_next = 0;
    direc_next = 8'hzz;
    dato_smh_next = 8'hzz;
    flag_rtc_next = 0;
    load_lea_escriba = 0;
    lea_escriba_next = 1'bz;
    load_sw = 0;
    sw_seg_next = 0;
    sw_min_next = 0;
    sw_hor_next = 0;
    load_vga = 0;
    vga_seg_next = 8'hzz;
    vga_min_next = 8'hzz;
    vga_hor_next = 8'hzz;
    state_next = espera;

    case (estado)
      espera:
      begin
          if (sw_hora)
              load_rtc = 1;
              flag_rtc_next = 1;
              state_next = state_1;
      end

      state_1:
      begin
          load_rtc = 1;
          load_direc = 1;
          load_lea_escriba = 1;
          lea_escriba_next = 0;
          flag_rtc_next = 1;
          direc_next = 8'h00;
          state_next = state_2;
          if (tome)
              load_dato_in = 1;
              dato_in_next = rtc;
          if (~siga)
              state_next = state_2;
      end

      state_2:
      begin
          load_dato = 1;
          load_lea_escriba = 1;
          lea_escriba_next = 1;
          dato_smh_next = {dato_in[7:6], 1'b1, dato_in[4:0]};
          state_next = state_2;
          if (~siga)
              load_rtc = 1;
              state_next = state_3;
      end

      state_3:
      begin
          load_sw = 1;
          sw_seg_next = sw_seg;
          sw_min_next = sw_min;
          sw_hor_next = sw_hor;
          state_next = state_4;
      end

      state_4:
      begin
          load_vga = 1;
          vga_seg_next = sw_seg_reg;
          vga_min_next = sw_min_reg;
          vga_hor_next = sw_hor_reg;
          if (~sw_hora)
              state_next = state_5;
          else
              state_next = state_3;
      end

      state_5:
      begin
          load_rtc = 1;
          load_direc = 1;
          flag_rtc_next = 1;
          direc_next = 8'h21;
          dato_smh_next = vga_seg_reg;
          state_next = state_5;
          if (~siga)
              state_next = state_6;
      end

      state_6:
      begin
          load_direc = 1;
          direc_next = 8'h22;
          dato_smh_next = vga_min_reg;
          state_next = state_6;
          if (~siga)
              state_next = state_7;
      end

      state_7:
      begin
          load_direc = 1;
          direc_next = 8'h23;
          dato_smh_next = vga_hor_reg;
          state_next = state_7;
          if (~siga)
              state_next = state_8;
      end

      state_8:
      begin
          load_direc = 1;
          load_lea_escriba = 1;
          lea_escriba_next = 0;
          direc_next = 8'h00;
          state_next = state_8;
          if (tome)
              load_dato_in = 1;
              dato_in_next = rtc;
          if (~siga)
              state_next = state_9;
      end

      state_9:
      begin
          load_dato = 1;
          load_lea_escriba = 1;
          lea_escriba_next = 1;
          dato_smh_next = {dato_in[7:6], 1'b0, dato_in[4:0]};
          state_next = state_9;
          if (~siga)
              state_next = state_10;
      end

      state_10:
      begin
          load_dato = 1;
          load_lea_escriba = 1;
          load_dato_in = 1;
          load_direc = 1;
          state_next = state_11;
      end

      state_11:
      begin
          state_next = espera;
      end

      default: state_next = espera ;

    endcase
end

always @ ( posedge clk, posedge reset )
begin
    if (reset)
    begin
        flag_rtc_reg = 0;
        flag_lea_escriba = 0;
        direc_reg = 8'hzz;
        dato_smh_reg = 8'hzz;
        dato_in = 8'hzz;
        sw_seg_reg = 8'h00;
        sw_min_reg = 8'h00;
        sw_hor_reg = 8'h00;
        vga_seg_reg = 8'hzz;
        vga_min_reg = 8'hzz;
        vga_hor_reg = 8'hzz;
    end
    else
    begin
        if (load_rtc)
            flag_rtc_reg = flag_rtc_next;

        if (load_lea_escriba)
            flag_lea_escriba = lea_escriba_next;

        if (load_direc)
            direc_reg = direc_next;

        if (load_dato)
            dato_smh_reg = dato_smh_next;

        if (load_dato_in)
            dato_in = dato_in_next;

        if (load_sw)
        begin
            sw_seg_reg = sw_seg_next;
            sw_min_reg = sw_min_next;
            sw_hor_reg = sw_hor_next;
        end

        if (load_vga)
        begin
            vga_seg_reg = vga_seg_next;
            vga_min_reg = vga_min_next;
            vga_hor_reg = vga_hor_next;
        end
    end

end

assign flag_rtc = flag_rtc_reg;
assign lea_escriba = flag_lea_escriba;
assign direc = direc_reg;
assign dato_smh = dato_smh_reg;
assign vga_seg = vga_seg_reg;
assign vga_min = vga_min_reg;
assign vga_hor = vga_hor_reg;
assign auxiliar = estado;


endmodule
