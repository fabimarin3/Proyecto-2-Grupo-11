`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/12/2017 11:54:41 PM
// Design Name:
// Module Name: escribir_fecha
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


module escribir_fecha(
    input clk,reset, siga, sw_fecha,
    input [7:0] sw_dia, sw_mes, sw_year, sw_dia_semana,
    output [7:0] direc, dato_dmyd, vga_dia, vga_mes, vga_year, vga_dia_semana,
    output flag_rtc, lea_escriba, fecha_activo
    //output [3:0] auxiliar
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

reg load_fecha, fecha_reg, fecha_next, load_ciclos;

reg load_lea_escriba, flag_lea_escriba, lea_escriba_next;

reg [7:0] direc_reg, direc_next, dato_dmyd_reg, dato_dmyd_next;
reg load_direc, load_dato;

reg [7:0] sw_dia_reg, sw_mes_reg, sw_year_reg, sw_dia_semana_reg,
sw_dia_semana_next, sw_dia_next, sw_mes_next, sw_year_next;
reg load_sw;

reg [7:0] vga_dia_reg, vga_mes_reg, vga_year_reg, vga_dia_semana_reg,
vga_dia_next, vga_mes_next, vga_year_next, vga_dia_semana_next;
reg load_vga;

reg [2:0] ciclos = 0, contador = 0, ciclos_s = 0;

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
    load_rtc = 0;
    load_lea_escriba = 0;
    load_direc = 0;
    load_dato = 0;
    load_sw = 0;
    load_vga = 0;
    load_fecha = 0;
    load_ciclos = 0;

    state_next = espera;
    lea_escriba_next = 1'bz;
    flag_rtc_next = 0;
    direc_next = 8'hzz;
    dato_dmyd_next = 8'hzz;
    sw_dia_next = 8'h00;
    sw_mes_next = 8'h00;
    sw_year_next = 8'h00;
    sw_dia_semana_next = 8'h00;
    vga_dia_next = 8'hzz;
    vga_mes_next = 8'hzz;
    vga_year_next = 8'hzz;
    vga_dia_semana_next = 8'hzz;
    fecha_next = 0;
    ciclos = 0;

    case (estado)
      espera:
          begin
              if (sw_fecha)
              begin
                  state_next = state_1;
              end
          end

      state_1:
      begin
          load_sw = 1;
          sw_dia_next = sw_dia;
          sw_mes_next = sw_mes;
          sw_year_next = sw_year;
          sw_dia_semana_next = sw_dia_semana;
          state_next = state_2;
      end

      state_2:
      begin
          load_vga = 1;
          vga_dia_next = sw_dia_reg;
          vga_mes_next = sw_mes_reg;
          vga_year_next = sw_year_reg;
          vga_dia_semana_next = sw_dia_semana_reg;
          if (~sw_fecha)
          begin
              load_fecha = 1;
              fecha_next = 1;
              state_next = state_2;
              if (~siga)
              begin
                  load_ciclos = 1;
                  ciclos = 5;
                  if (contador == ciclos)
                  begin
                      ciclos = 0;
                      load_rtc = 1;
                      flag_rtc_next = 1;
                      state_next = state_3;
                  end
              end
          end
          else
              state_next = state_1;
      end

      state_3:
      begin
          load_direc = 1;
          load_dato = 1;
          load_lea_escriba = 1;
          lea_escriba_next = 1;
          direc_next = 8'h24;
          dato_dmyd_next = vga_dia_reg;
          load_rtc = 1;
          load_ciclos = 1;
          ciclos = 2;
          state_next = state_3;
          if (contador == ciclos)
          begin
              ciclos = 0;
              state_next = state_8;
          end
      end

      state_8:
      begin
          state_next = state_8;
          if (~siga)
          begin
              state_next = state_4;
              load_rtc = 1;
              flag_rtc_next = 1;
          end
      end

      state_4:
      begin
          load_direc = 1;
          load_dato = 1;
          direc_next = 8'h25;
          dato_dmyd_next = vga_mes_reg;
          state_next = state_4;
          load_rtc = 1;
          load_ciclos = 1;
          ciclos = 2;
          if (contador == ciclos)
          begin
              ciclos = 0;
              state_next = state_9;
          end
      end

      state_9:
      begin
          state_next = state_9;
          if (~siga)
          begin
              state_next = state_5;
              load_rtc = 1;
              flag_rtc_next = 1;
          end
      end

      state_5:
      begin
          load_direc = 1;
          load_dato = 1;
          direc_next = 8'h26;
          dato_dmyd_next = vga_year_reg;
          state_next = state_5;
          load_rtc = 1;
          load_ciclos = 1;
          ciclos = 2;
          if (contador == ciclos)
          begin
              ciclos = 0;
              state_next = state_10;
          end

      end

      state_10:
      begin
          state_next = state_10;
          if (~siga)
          begin
              state_next = state_6;
              load_rtc = 1;
              flag_rtc_next = 1;
          end
      end

      state_6:
      begin
          load_direc = 1;
          load_dato = 1;
          direc_next = 8'h27;
          dato_dmyd_next = vga_dia_semana_reg;
          state_next = state_6;
          load_rtc = 1;
          load_ciclos = 1;
          ciclos = 2;
          if (contador == ciclos)
          begin
              ciclos = 0;
              state_next = state_11;
          end
      end

      state_11:
      begin
          state_next = state_11;
          if (~siga)
          begin
              state_next = state_7;
          end
      end

      state_7:
      begin
          load_lea_escriba = 1;
          load_fecha = 1;
          load_direc = 1;
          load_dato = 1;
          load_rtc = 1;
          load_fecha = 1;
          state_next = espera;
      end

      default: state_next = espera ;
    endcase
end

always @ ( posedge clk, posedge reset )
begin
    if (reset)
    begin
        flag_lea_escriba = 1'bz;
        flag_rtc_reg = 0;
        direc_reg = 8'hzz;
        dato_dmyd_reg = 8'hzz;
        sw_dia_reg = 8'h00;
        sw_mes_reg = 8'h00;
        sw_year_reg = 8'h00;
        sw_dia_semana_reg = 8'h00;
        vga_dia_reg = 8'hzz;
        vga_mes_reg = 8'hzz;
        vga_year_reg = 8'hzz;
        vga_dia_semana_reg = 8'hzz;
        fecha_reg = 0;
        ciclos_s = 0;
    end
    else
    begin
        if (load_lea_escriba)
            flag_lea_escriba = lea_escriba_next;

        if (load_rtc)
            flag_rtc_reg = flag_rtc_next;

        if (load_direc)
            direc_reg = direc_next;

        if (load_dato)
            dato_dmyd_reg = dato_dmyd_next;

        if (load_sw)
        begin
            sw_dia_reg = sw_dia_next;
            sw_mes_reg = sw_mes_next;
            sw_year_reg = sw_year_next;
            sw_dia_semana_reg = sw_dia_semana_next;
        end

        if (load_vga)
        begin
            vga_dia_reg = vga_dia_next;
            vga_mes_reg = vga_mes_next;
            vga_year_reg = vga_year_next;
            vga_dia_semana_reg = vga_dia_semana_next;
        end

        if (load_fecha)
            fecha_reg = fecha_next;

        if (load_ciclos)
            ciclos_s = ciclos;
    end

end

assign lea_escriba = flag_lea_escriba;
assign flag_rtc = flag_rtc_reg;
assign direc = direc_reg;
assign dato_dmyd = dato_dmyd_reg;
assign vga_dia = vga_dia_reg;
assign vga_mes = vga_mes_reg;
assign vga_year = vga_year_reg;
assign vga_dia_semana = vga_dia_semana_reg;
//assign auxiliar = estado;
assign fecha_activo = fecha_reg;

endmodule
