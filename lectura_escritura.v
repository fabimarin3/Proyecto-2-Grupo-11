`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2017 06:36:01 PM
// Design Name: 
// Module Name: lectura_escritura
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


module lectura_escritura(
    input reset, clk, // senales de seguridad y cambio
    input flag_in, // bandera para saber cuando se puede usar
    input lee_escribe_m, // bandera para saber si escribe o lee
    input [7:0] add, datos, // se le envian datos para el caso de escritura y las direcciones de los registro
    output reg flag_work_s, //bandera que nos dice que esta trabajando la maquina
    inout [7:0] add_data_rtc,// recibe y envia el rtc
    output reg a_d_s, cs_s, rd_s, wr_s, // senanales del rtc
    output [3:0] auxiliar, //es solo una variable para ver los estados en la simulacion
    output [7:0] data, //son los datos de salida en caso de ser una lectura
    output [2:0] ciclo,
    output reg tomar_dato 
    );

localparam [3:0]                  // estados de la maquina 
                espera = 4'h0,
                state_1 = 4'h1,
                state_2 = 4'h2,
                state_3 = 4'h3,
                state_4 = 4'h4,
                state_5 = 4'h5,
                state_6 = 4'h6,
                state_7 = 4'h7,
                state_8 = 4'h8,
                state_9 = 4'h9,
                state_10 = 4'ha,
                state_11 = 4'hb,
                state_12 = 4'hc;

reg [3:0] estado, state_next;  //registros de estado
reg [7:0] add_rtc_m,   // variables de entrada salida rtc
        add_data_rtc_m, 
        data_rtc_m, 
        data_m_in;
reg a_d = 1,    //senales del rtc
    cs = 1, 
    rd = 1, 
    wr = 1, 
    flag_work,
    flag_tome_dato;
    
reg [2:0] ciclos = 0, contador = 0, ciclos_s = 0;

reg load_a_d, 
    load_cs, 
    load_rd, 
    load_wr, 
    load_flag,
    load_ciclos,
    load_tome;
    
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
    a_d =  1'b1;
    cs =  1'b1;
    rd =  1'b1;
    wr =  1'b1;
    flag_work =  1'b0;
    flag_tome_dato = 1'b0;
    ciclos = 0;
    load_a_d =  1'b0;  
    load_cs =  1'b0; 
    load_rd =  1'b0; 
    load_wr =  1'b0; 
    load_flag =  1'b0;
    load_ciclos = 1'b0;
    load_tome = 1'b0;
    state_next = espera;
    add_rtc_m = add;  //esto me esta reiniciando siempre todas las variables por lo que el flag out solo dura un periodo
    data_m_in = datos;  //una opcion es ponerlo en datos los case para que se mantengan ya que no lo hacen 
    add_data_rtc_m = 8'hzz;
    data_rtc_m = 8'hzz;
    case (estado)
        espera: 
        begin
            if (flag_in)
            begin
                state_next = state_1;
                
            end
        end
        state_1:
        begin
            a_d = 0;
            load_a_d = 1;
            load_flag = 1;
            flag_work = 1;
            state_next = state_2;
        end
        state_2:
        begin
            load_ciclos = 1;
            load_cs = 1;
            load_wr = 1;
            cs = 0;
            wr = 0;
            ciclos = 4;
            state_next = state_2;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_3;
            end
        end
        state_3:
        begin
            add_data_rtc_m = add_rtc_m;
            load_ciclos = 1;
            ciclos = 2;
            state_next = state_3;
            if (contador == ciclos)
            begin
                ciclos = 0;
                state_next = state_4;
            end
        end
        state_4:
        begin
            load_cs = 1;
            load_wr = 1;
            add_data_rtc_m = add_rtc_m;
            state_next = state_5;
        end
        state_5:
        begin
            load_a_d = 1;
            load_ciclos = 1;
            add_data_rtc_m = add_rtc_m;
            state_next = state_5;
            ciclos = 3;
            if (contador == ciclos)
            begin
                state_next = state_6;
                ciclos = 0;
            end
        end
        state_6:
        begin
            load_ciclos = 1;
            state_next = state_6;
            ciclos = 7;
            if (contador == ciclos)
            begin
                state_next = state_7;
                ciclos = 0;
            end
        end
        state_7:
        begin
            load_cs = 1;
            load_rd = 1;
            load_wr = 1;
            load_ciclos = 1;
            if (~lee_escribe_m)
            begin
                cs = 1'b0;
                rd = 1'b0;
            end
            else
            begin
                cs = 1'b0;
                wr = 1'b0;
            end
            state_next = state_7;
            ciclos = 4;
            if (contador == ciclos)
            begin
                state_next = state_8;
                ciclos = 0;
            end
        end
        state_8:
        begin
            load_ciclos = 1;
            if (~lee_escribe_m)
            begin
                data_rtc_m = add_data_rtc_m;
            end
            else
            begin
                add_data_rtc_m = data_m_in;
            end
            state_next = state_8;
            ciclos = 4;
            if (contador == ciclos)
            begin
                state_next = state_9;
                ciclos = 0;
            end
        end
        state_9:
        begin
            load_cs = 1;
            load_rd = 1;
            load_wr = 1;
            if (~lee_escribe_m)
            begin
                data_rtc_m = add_data_rtc_m;
            end
            else
            begin
                add_data_rtc_m = data_m_in;
            end
            state_next = state_10;
        end
        state_10:
        begin
            load_tome = 1;
            flag_tome_dato = 1;
            state_next = state_11;
        end
        state_11:
        begin
            load_tome = 1;
            if (~lee_escribe_m)
            begin
                data_rtc_m = add_data_rtc_m;
            end
            else
            begin
                add_data_rtc_m = data_m_in;
            end
            state_next = state_12;
        end
        state_12:
        begin
            load_flag = 1;
            flag_work = 0;
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
    if(reset)
    begin
        a_d_s =  1'b1;
        cs_s =  1'b1;
        rd_s =  1'b1;
        wr_s =  1'b1;
        flag_work_s =  1'b0;
        ciclos_s = 0;
        tomar_dato = 0;
    end
    else
    begin
    if (load_a_d)
        a_d_s = a_d;
    if (load_cs)
        cs_s = cs;
    if (load_rd)
        rd_s = rd;
    if (load_wr)
        wr_s = wr;
    if (load_flag)
        flag_work_s = flag_work;
    if (load_ciclos)
        ciclos_s = ciclos;
    if (load_tome)
        tomar_dato = flag_tome_dato;
    end
end

assign data = data_rtc_m;
assign add_data_rtc = add_data_rtc_m;
assign auxiliar = estado;
assign ciclo = ciclos_s;
endmodule
