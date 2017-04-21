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
    //output [5:0] auxiliar,
    output inicializado, escriba, flag_rtc_ini
);

reg [7:0] Direc_reg;
reg [7:0] WR_reg;
reg [7:0] Direc_reg_next;
reg [7:0] WR_reg_next;
reg Load, flag_inicializado, load_flag, flag_escriba, load_escriba, load_rtc, rtc, load_ciclos;
reg inicializado_reg, escriba_reg, rtc_reg;

/////////////////Declaracion de los estados////////////////////////////////

localparam [5:0] s0 = 6'h00,
                 s1 = 6'h01,
                 s2 = 6'h02,
                 s3 = 6'h03,
                 s4 = 6'h04,
                 s5 = 6'h05,
                 s6 = 6'h06,
                 s7 = 6'h07,
                 s8 = 6'h08,
                 s9 = 6'h09,
                 s10 = 6'h0A,
                 s11 = 6'h0B,
                 s12 = 6'h0C,
                 s13 = 6'h0D,
                 s14 = 6'h0E,
                 s15 = 6'h0F,
                 s16 = 6'h10,
                 s17 = 6'h12,
                 s18 = 6'h13,
                 s19 = 6'h14,
                 s20 = 6'h15,
                 s21 = 6'h16,
                 s22 = 6'h17,
                 s23 = 6'h18,
                 s24 = 6'h19,
                 s25 = 6'h1a,
                 s26 = 6'h1b,
                 s27 = 6'h1c,
                 s28 = 6'h1d,
                 s29 = 6'h1e,
                 s30 = 6'h1f,
                 s31 = 6'h20,
                 s32 = 6'h21;

/////////////////Fin declaracion de los estados///////////////////////////


///////////////////   Declaracion de la señal   ////////////////////////////////

reg [5:0] estado_reg, estado_sig;
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
    flag_escriba = 1'bz;
    load_escriba = 1'b0;
    load_rtc = 1'b0;
    rtc = 1'b0;
    load_ciclos = 1'b0;
    ciclos = 0;
    case (estado_reg)
        s0:
        begin
            estado_sig = s0;
            if (~reset)
            begin
                estado_sig = s1;
                load_rtc = 1'b1;
                rtc = 1'b1;
            end
        end

        s1:
        begin
            load_rtc = 1'b1;
            flag_escriba = 1'b1;
            load_escriba = 1'b1;
            Load = 1'b1;
            flag_escriba = 1;
            Direc_reg_next = 8'h02;
            WR_reg_next =  8'h10;
            load_ciclos = 1'b1;
            ciclos = 2;
            estado_sig = s1;
            if (contador == ciclos)
            begin
                estado_sig = s18;
                ciclos = 0;
            end
        end

        s18:
        begin
            estado_sig = s18;
            if (~siga)
            begin
                load_rtc = 1'b1;
                rtc = 1'b1;
                estado_sig = s2;
            end
        end

        s2:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h10;
            WR_reg_next =  8'hD2;
            estado_sig = s2;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s19;
                ciclos = 0;
            end
        end

        s19:
        begin
            estado_sig = s19;
            if (~siga)
            begin
               estado_sig = s3;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s3:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h00;
            WR_reg_next =  8'h08;
            estado_sig = s3;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s20;
                ciclos = 0;
            end
        end

        s20:
        begin
            estado_sig = s20;
            if (~siga)
            begin
               estado_sig = s4;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s4:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h02;
            estado_sig = s4;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s21;
                ciclos = 0;
            end
        end

        s21:
        begin
            estado_sig = s21;
            if (~siga)
            begin
               estado_sig = s5;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s5:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h21;
            estado_sig = s5;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s22;
                ciclos = 0;
            end
        end

        s22:
        begin
            estado_sig = s22;
            if (~siga)
            begin
               estado_sig = s6;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s6:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h22;
            estado_sig = s6;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s23;
                ciclos = 0;
            end
        end

        s23:
        begin
            estado_sig = s23;
            if (~siga)
            begin
               estado_sig = s7;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s7:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h23;
            estado_sig = s7;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s24;
                ciclos = 0;
            end
        end

        s24:
        begin
            estado_sig = s24;
            if (~siga)
            begin
               estado_sig = s8;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s8:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h24;
            estado_sig = s8;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s25;
                ciclos = 0;
            end
        end

        s25:
        begin
            estado_sig = s25;
            if (~siga)
            begin
               estado_sig = s9;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s9:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h25;
            estado_sig = s9;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s26;
                ciclos = 0;
            end
        end

        s26:
        begin
            estado_sig = s26;
            if (~siga)
            begin
               estado_sig = s10;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s10:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h26;
            estado_sig = s10;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s27;
                ciclos = 0;
            end
        end

        s27:
        begin
            estado_sig = s27;
            if (~siga)
            begin
               estado_sig = s11;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s11:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h27;
            estado_sig = s11;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s28;
                ciclos = 0;
            end
        end

        s28:
        begin
            estado_sig = s28;
            if (~siga)
            begin
               estado_sig = s12;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s12:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h41;
            estado_sig = s12;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s29;
                ciclos = 0;
            end
        end

        s29:
        begin
            estado_sig = s29;
            if (~siga)
            begin
               estado_sig = s13;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s13:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h42;
            estado_sig = s13;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s30;
                ciclos = 0;
            end
        end

        s30:
        begin
            estado_sig = s30;
            if (~siga)
            begin
               estado_sig = s14;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s14:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'h43;
            estado_sig = s14;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s31;
                ciclos = 0;
            end
        end

        s31:
        begin
            estado_sig = s31;
            if (~siga)
            begin
               estado_sig = s15;
               load_rtc = 1'b1;
               rtc = 1'b1;
            end
        end

        s15:
        begin
            Load = 1'b1;
            Direc_reg_next = 8'hF0;
            estado_sig = s15;
            load_rtc = 1'b1;
            load_ciclos = 1'b1;
            ciclos = 2;
            if (contador == ciclos)
            begin
                estado_sig = s32;
                ciclos = 0;
            end
        end

        s32:
        begin
            estado_sig = s32;
            if (~siga)
            begin
               estado_sig = s16;
            end
        end

        s16:
        begin
            load_escriba = 1'b1;
            Load = 1'b1;
            load_rtc = 1'b1;
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
        rtc_reg = 0;
        ciclos_s = 0;
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
       if (load_rtc)
            rtc_reg = rtc;
      if (load_ciclos)
            ciclos_s = ciclos;
   end
end

/////////////////////  FIn de estado siguiente  //////////////////

assign Direc = Direc_reg;
assign WR = WR_reg;
//assign auxiliar = estado_reg;
assign inicializado = inicializado_reg;
assign escriba = escriba_reg;
assign flag_rtc_ini = rtc_reg;

endmodule
