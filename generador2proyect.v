`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Fabiola Marin, Roberto Alarcon, Jose Navarro
// 
// Create Date: 03/02/2017 11:48:03 PM
// Design Name: 
// Module Name: proyecto1
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


module proyecto1(
    input reset, clk,
    input wire [2:0] rgbswitches,
    output reg [2:0] rgbtext,
    output wire hsync, vsync,
    output video_on,
    output wire [9:0] pixel_x, pixel_y,
    output wire [9:0] pixel_xm, pixel_ym
  
    //output [8:0] nousar
    );
    
   // wire nouso = 9'b000000000;
    wire clk_25m;
    //assign nousar = nouso;
    //wire video_on;
    
    //wire [9:0] pixel_x, pixel_y;    
    reg clk_d;
    reg [1:0] count;
    wire clk_div;
        
    always @(posedge (clk), posedge (reset))
    begin
        if (reset == 1)
        begin
            count <= 'b0;
            clk_d <= 0;
        end
        else if (count == 3)
        begin
            clk_d <= 1;
            count <= 'b0;        
        end
        else 
        begin
            clk_d <= 0;
            count <= count +1;
        end
    end
    assign clk_div = clk_d;
    
    //Horizontal
    localparam areavisibleh = 640;
    localparam backporch = 48;
    localparam frontporch = 16;
    localparam retraceh = 96;
    //Vertical
    localparam areavisiblev = 480;
    localparam fronttop = 10;
    localparam backtop = 33;
    localparam retracev = 2;
    
    reg [9:0] hcount, vcount;
    reg v_sync, h_sync;
    wire v_sync_next , h_sync_next;
    
    always @ (posedge (clk), posedge (reset))
    begin
        if (reset == 1)
        begin
            hcount <= 'b0;
            vcount <= 'b0;
            v_sync <= 'b0;
            h_sync <= 'b0;
        end
        else if (clk_div == 1)
        begin
            if (hcount == (areavisibleh + backporch + frontporch + retraceh -1))
            begin
                hcount <= 'b0;
                if (vcount == (areavisiblev + backtop + fronttop + retracev -1)) 
                    vcount <= 'b0;
                else 
                    vcount <= vcount + 1;
            end
            else 
                hcount <= hcount + 1;
                
        end
        else 
        begin
            hcount <= hcount;
            vcount <= vcount;
            h_sync <= h_sync_next;
            v_sync <= v_sync_next;
        end
        
    end
    
//    //reinicio horizontal
//    always @*
//    begin
//        if (clk_div && hcount == (areavisibleh + backporch + frontporch + retraceh -1))
//        begin
//            hcount <= 'b0;
//        end
//        else
//            hcount <= hcount;
//    end
    
//    // reinicio vertical
//    always @*
//    begin
//        if (clk_div && hcount == (areavisibleh + backporch + frontporch + retraceh -1))
//        begin
//            if (vcount == (areavisiblev + backtop + fronttop + retracev -1))
//                vcount <= 'b0;
//            else 
//                vcount <= vcount + 1;
//        end
//        else 
//            vcount <= vcount;
//    end
//  pulsos
    
    assign h_sync_next = ((hcount >= 'd659) && (hcount <= 'd751));
    assign v_sync_next = ((vcount >= 'd490) && (vcount <= 'd491));
    
    // vedeo on on/of
    assign video_on = ((hcount < areavisibleh) && (vcount < areavisiblev));
    
    //salidas
    
    assign pixel_x = hcount ;
    assign pixel_xm = hcount;
    assign pixel_y = vcount;
    assign pixel_ym = vcount;
    assign hsync = ~h_sync;
    assign vsync = ~v_sync;
    assign clk_25m = clk_d;
    
    
    //Generador de caracteres
    //wire [2:0] rgbswitches;
    //wire [9:0] pixelx, pixely; 
    //reg [2:0] rgbtext;
    
    // CONSTANTES Y DECLARACIONES
        
wire [3:1] lsbx;
wire [4:1] lsby;

wire [2:0] lsbxm;
wire [3:0] lsbym;

assign lsbx = ~pixel_x[3:1] ;
assign lsby = pixel_y[4:1];

assign lsbxm = ~pixel_xm [2:0] ;
assign lsbym = pixel_ym [3:0];
        
reg [2:0] letter_rgb;

wire [7:0] Data;
reg [3:0] as; //cambio :de 2 bits a 4 bits

// x , y coordinates (0.0) to (639,479)
localparam maxx = 640;
localparam maxy = 480;

// Letter boundaries

//Switches PROGRAMACION
//PH
localparam phi = 224;
localparam phf = 239;
localparam p_hi = 240;
localparam p_hf = 255;
localparam phyi = 32;
localparam phyf = 63;

localparam gphix = 256;
localparam gphfx = 271;
localparam gphiy = 32;
localparam gphfy = 63;



//PF
localparam pfi = 224;
localparam pff = 239;
localparam p_fi = 240;
localparam p_ff = 255;
localparam pfyi = 64;
localparam pfyf = 95;

localparam gpfix = 256;
localparam gpffx = 271;
localparam gpfiy = 64;
localparam gpffy = 95;


//PT
localparam pti = 224;
localparam ptf = 239;
localparam p_ti = 240;
localparam p_tf = 255;
localparam ptyi = 96;
localparam ptyf = 127;

localparam gptix = 256;
localparam gptfx = 271;
localparam gptiy = 96;
localparam gptfy = 127;

//guiones fecha
localparam g1xi = 380;
localparam g1xf = 395;
localparam g1yi = 256;
localparam g1yf = 287;

localparam g2xi = 420;
localparam g2xf = 435;
localparam g2yi = 256;
localparam g2yf = 287;

//dos puntos hora 
localparam d1hxi = 208;
localparam d1hxf = 223;
localparam d1hyi = 256;
localparam d1hyf = 287;

localparam d2hxi = 240;
localparam d2hxf = 255;
localparam d2hyi = 256;
localparam d2hyf = 287;

//dos puntos timer
localparam d1txi = 288;
localparam d1txf = 303;
localparam d1tyi = 416;
localparam d1tyf = 447;

localparam d2txi = 336;
localparam d2txf = 351;
localparam d2tyi = 416;
localparam d2tyf = 447;


//hora
localparam hxl = 192;
localparam hxr = 207;
localparam oxl = 208;
localparam oxr = 223;
localparam rxl = 224;
localparam rxr = 239;
localparam axl = 240;
localparam axr = 255;

localparam yt = 192;
localparam yb = 223;

//fecha
localparam f_xl = 368;
localparam f_xr = 383;
localparam e_xl = 384;
localparam e_xr = 399;
localparam c_xl = 400;
localparam c_xr = 415;
localparam h_xl = 416;
localparam h_xr = 431;
localparam a_xl = 432;
localparam a_xr = 447;

//timer
localparam txl = 272;
localparam txr = 287;
localparam ixl = 288;
localparam ixr = 303;
localparam mxl = 304;
localparam mxr =  319;
localparam exl = 320;
localparam exr = 335;
localparam r_xl = 336 ;
localparam r_xr = 351;

localparam y_t = 352; 
localparam y_b = 383;

//lineas cuadro hora
localparam lvhi = 187 ;
localparam lvhf = 260;
localparam lhhi = 190;
localparam lhhf = 225;

//lineas cuadro fecha
localparam lvfi = 363; 
localparam lvff= 452;
localparam lhfi= 190;
localparam lhff= 225;

//lineas cuadro timer
localparam lvti= 267;
localparam lvtf= 356;
localparam lhti= 350;
localparam lhtf= 385;

//AM/PM 
localparam aci = 208; localparam acf = 223;
localparam mci = 224;localparam mcf = 239;
localparam pci = 288;localparam pcf = 303;
localparam mc_i = 304;localparam mc_f = 319;
localparam cayt = 288;localparam cayb = 319;

// letter output signals
wire hon, oon, ron, aon, f_on, e_on, c_on, h_on, a_on, ton,ion,mon, eon, r_on, 
chon, cfon, cton , caon, cmon,cpon, cm_on, gph,gpf, gpt, g1fon, g2fon, dph1, dph2, dpt1, dpt2;

// CUERPO

// pixel within letters and signs

//guiones fecha
assign g1fon = (g1xi<=pixel_xm)&&(pixel_xm<=g1xf) && (g1yi<=pixel_ym)&&(pixel_ym<=g1yf) ;
assign g2fon = (g2xi<=pixel_xm)&&(pixel_xm<=g2xf) && (g2yi<=pixel_ym)&&(pixel_ym<=g2yf) ;

//dos puntos hora
assign dph1 = (d1hxi<=pixel_xm)&&(pixel_xm<=d1hxf) && (d1hyi<=pixel_ym)&&(pixel_ym<=d1hyf) ;
assign dph2 = (d2hxi<=pixel_xm)&&(pixel_xm<=d2hxf) && (d2hyi<=pixel_ym)&&(pixel_ym<=d2hyf) ;

//dos puntos timer
assign dpt1 = (d1txi<=pixel_xm)&&(pixel_xm<=d1txf) && (d1tyi<=pixel_ym)&&(pixel_ym<=d1tyf) ;
assign dpt2 = (d2txi<=pixel_xm)&&(pixel_xm<=d2txf) && (d2tyi<=pixel_ym)&&(pixel_ym<=d2tyf) ;
//ph
assign phon = (phi<=pixel_xm)&&(pixel_xm<=phf) && (phyi<=pixel_ym)&&(pixel_ym<=phyf) ;
assign p_hon = (p_hi<=pixel_xm)&&(pixel_xm<=p_hf) && (phyi<=pixel_ym)&&(pixel_ym<=phyf) ;
assign gph = (gphix<=pixel_xm)&&(pixel_xm<=gphfx) && (gphiy<=pixel_ym)&&(pixel_ym<=gphfy) ;

//pf
assign pfon  = (pfi<=pixel_xm)&&(pixel_xm<=pff) && (pfyi<=pixel_ym)&&(pixel_ym<=pfyf) ;
assign p_fon = (p_fi<=pixel_xm)&&(pixel_xm<=p_ff) && (pfyi<=pixel_ym)&&(pixel_ym<=pfyf) ;
assign gpf = (gpfix<=pixel_xm)&&(pixel_xm<=gpffx) && (gpfiy<=pixel_ym)&&(pixel_ym<=gpffy) ;

//pt
assign pton  = (pti<=pixel_xm)&&(pixel_xm<=ptf) && (ptyi<=pixel_ym)&&(pixel_ym<=ptyf) ;
assign p_ton = (p_ti<=pixel_xm)&&(pixel_xm<=p_tf) && (ptyi<=pixel_ym)&&(pixel_ym<=ptyf) ;
assign gpt = (gptix<=pixel_xm)&&(pixel_xm<=gptfx) && (gptiy<=pixel_ym)&&(pixel_ym<=gptfy) ;

//am
assign caon= (aci<=pixel_xm)&&(pixel_xm<=acf) && (cayt<=pixel_ym)&&(pixel_ym<=cayb) ;
assign cmon =(mci<=pixel_xm)&&(pixel_xm<=mcf) && (cayt<=pixel_ym)&&(pixel_ym<=cayb);

//pm
assign cpon= (pci<=pixel_xm)&&(pixel_xm<=pcf) && (cayt<=pixel_ym)&&(pixel_ym<=cayb) ;
assign cm_on =(mc_i<=pixel_xm)&&(pixel_xm<=mc_f) && (cayt<=pixel_ym)&&(pixel_ym<=cayb);

//cuadro hora
assign chon= (lvhi<=pixel_x)&&(pixel_x<=lvhf) && (lhhi<=pixel_y)&&(pixel_y<=lhhf);

//cuadro fecha
assign cfon= (lvfi<=pixel_x)&&(pixel_x<=lvff) &&(lhfi<=pixel_y)&&(pixel_y<=lhff);

//cuadro timer
assign cton= (lvti<=pixel_x)&&(pixel_x<=lvtf) &&(lhti<=pixel_y)&&(pixel_y<=lhtf);

//hora
assign hon =(hxl<=pixel_x) && (pixel_x<=hxr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign oon =(oxl<=pixel_x) && (pixel_x<=oxr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign ron = (rxl<=pixel_x) && (pixel_x<=rxr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign aon =(axl<=pixel_x) && (pixel_x<=axr) && (yt<=pixel_y) && (pixel_y<=yb);

//fecha
assign f_on =(f_xl<=pixel_x) && (pixel_x<=f_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign e_on =(e_xl<=pixel_x) && (pixel_x<=e_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign c_on =(c_xl<=pixel_x) && (pixel_x<=c_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign h_on= (h_xl<=pixel_x) && (pixel_x<=h_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign a_on =(a_xl<=pixel_x) && (pixel_x<=a_xr) &&(yt<=pixel_y) && (pixel_y<=yb);

//timer

assign ton =(txl<=pixel_x) && (pixel_x<=txr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign ion =(ixl<=pixel_x) && (pixel_x<=ixr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign mon =(mxl<=pixel_x) && (pixel_x<=mxr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign eon = (exl<=pixel_x) && (pixel_x<=exr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign r_on =(r_xl<=pixel_x) && (pixel_x<=r_xr) &&(y_t<=pixel_y) && (pixel_y<=y_b);



always @* 
   begin
        //hora
    if (hon|h_on|p_hon)
        as <= 4'b0001; 
    else if (oon)
        as <= 4'b0010;
    else if (ron|r_on)
        as <= 4'b0011;
    else if (aon|a_on|caon)
        as <= 4'b0100; //se agrega 
        
        //fecha
    else if (f_on|p_fon)
         as <= 4'b0101; //se agrega 
    else if (e_on|eon)
         as <= 4'b0110; //se agrega 
    else if (c_on)
         as <= 4'b0111; //se agrega 
 
         
         //timer
    else if (ton|p_ton)
         as <= 4'b1000; //se agrega 
    else if (ion)
         as <= 4'b1001; //se agrega 
    else if (mon|cmon|cm_on)
         as <= 4'b1010; //se agrega 
    else if (cpon|phon|pfon|pton)
         as <= 4'b1011; //se agrega //letraP
              
         //signos
    else if (gph|gpf|gpt)
         as <= 4'b1100;
    else if (dph1|dph2|dpt1|dpt2)
         as <= 4'b1101;
    else if (g1fon|g2fon)
         as <= 4'b1110;
         
  
         
    else
        as <= 4'b0000;   
   end
 
ROM FONT(as,lsby,Data);//|lsbym

reg pixelbit;

always @*
    case (lsbx)//|lsbxm
    3'h0: pixelbit <= Data[0];
    3'h1: pixelbit <= Data[1];
    3'h2: pixelbit <= Data[2];
    3'h3: pixelbit <= Data[3];
    3'h4: pixelbit <= Data[4];
    3'h5: pixelbit <= Data[5];
    3'h6: pixelbit <= Data[6];
    3'h7: pixelbit <= Data[7];
endcase

always @*
    if (pixelbit)
        letter_rgb <= 3'b110;
    else
        letter_rgb <= 3'b000;

// rgb multiplexing circuit
always @*
    if (~video_on)
        rgbtext = 3'b000; // blank 
    else if (hon|oon|ron|aon|f_on|e_on|c_on|h_on|a_on|ton|ion|mon|eon|r_on|caon|cmon|cpon|cm_on|phon|pfon|pton|p_hon|p_fon|p_ton
    |gph|gpf|gpt|g1fon|g2fon|dph1|dph2|dpt1|dpt2)  
        rgbtext = letter_rgb; 
    else if (chon|cfon|cton)
        rgbtext = 3'b111;
    else
        rgbtext = 3'b000; // black background
endmodule

module ROM (
input wire [3:0]as,
input wire [4:1]lsby,
//input wire [3:0]lsbym,
output reg [7:0]data 
);

reg [7:0]adress;

always @*
    adress <= {as,lsby};

always @*
    case (adress)
    
    11'h00: data = 8'b00000000;
    11'h01: data = 8'b00000000; 
    11'h02: data = 8'b00000000; 
    11'h03: data = 8'b00000000; 
    11'h04: data = 8'b00000000; 
    11'h05: data = 8'b00000000;  
    11'h06: data = 8'b00000000;
    11'h07: data = 8'b00000000; 
    11'h08: data = 8'b00000000; 
    11'h09: data = 8'b00000000;
    11'h0a: data = 8'b00000000;
    11'h0b: data = 8'b00000000; 
    11'h0c: data = 8'b00000000; 
    11'h0d: data = 8'b00000000;
    11'h0e: data = 8'b00000000;
    11'h0f: data = 8'b00000000; 

     //code letter H
    11'h010: data = 8'b00000000; 
    11'h011: data = 8'b01100110;
    11'h012: data = 8'b01100110; 
    11'h013: data = 8'b01100110; 
    11'h014: data = 8'b01100110; 
    11'h015: data = 8'b01100110; 
    11'h016: data = 8'b01100110; 
    11'h017: data = 8'b01111110; 
    11'h018: data = 8'b01111110; 
    11'h019: data = 8'b01100110; 
    11'h01a: data = 8'b01100110; 
    11'h01b: data = 8'b01100110; 
    11'h01c: data = 8'b01100110; 
    11'h01d: data = 8'b01100110; 
    11'h01e: data = 8'b01100110; 
    11'h01f: data = 8'b00000000; 

     //code letter O
    11'h020: data = 8'b00000000; 
    11'h021: data = 8'b00111100; 
    11'h022: data = 8'b00111100; 
    11'h023: data = 8'b01100110; 
    11'h024: data = 8'b01100110;
    11'h025: data = 8'b01100110; 
    11'h026: data = 8'b01100110; 
    11'h027: data = 8'b01100110; 
    11'h028: data = 8'b01100110; 
    11'h029: data = 8'b01100110; 
    11'h02a: data = 8'b01100110; 
    11'h02b: data = 8'b01100110; 
    11'h02c: data = 8'b01100110; 
    11'h02d: data = 8'b00111100; 
    11'h02e: data = 8'b00111100; 
    11'h02f: data = 8'b00000000; 
    
    //code letter R
    11'h030: data = 8'b00000000; 
    11'h031: data = 8'b01111100; 
    11'h032: data = 8'b01100110; 
    11'h033: data = 8'b01100110; 
    11'h034: data = 8'b01100110; 
    11'h035: data = 8'b01100110; 
    11'h036: data = 8'b01100110; 
    11'h037: data = 8'b01111100; 
    11'h038: data = 8'b01111100; 
    11'h039: data = 8'b01100110; 
    11'h03a: data = 8'b01100110; 
    11'h03b: data = 8'b01100110; 
    11'h03c: data = 8'b01100110; 
    11'h03d: data = 8'b01100110; 
    11'h03e: data = 8'b01100110; 
    11'h03f: data = 8'b00000000; 
    
    //code letter A
    11'h040: data = 8'b00000000; 
    11'h041: data = 8'b00011000; 
    11'h042: data = 8'b00011000; 
    11'h043: data = 8'b00111100; 
    11'h044: data = 8'b00111100; 
    11'h045: data = 8'b01100110;
    11'h046: data = 8'b01100110; 
    11'h047: data = 8'b01111110; 
    11'h048: data = 8'b01111110; 
    11'h049: data = 8'b01100110; 
    11'h04a: data = 8'b01100110; 
    11'h04b: data = 8'b01100110; 
    11'h04c: data = 8'b01100110; 
    11'h04d: data = 8'b01100110; 
    11'h04e: data = 8'b01100110; 
    11'h04f: data = 8'b00000000; 
    
    //code letter F
    11'h050: data = 8'b00000000; //11111111
    11'h051: data = 8'b01111110; //11111111
    11'h052: data = 8'b01111110; //11100000
    11'h053: data = 8'b01100000; //11100000
    11'h054: data = 8'b01100000; //11100000
    11'h055: data = 8'b01100000; //11100000
    11'h056: data = 8'b01100000; //11100000
    11'h057: data = 8'b01111110; //11111111
    11'h058: data = 8'b01100000; //11100000
    11'h059: data = 8'b01100000; //11100000
    11'h05a: data = 8'b01100000; //11100000
    11'h05b: data = 8'b01100000; //11100000
    11'h05c: data = 8'b01100000; //11100000
    11'h05d: data = 8'b01100000; //11100000
    11'h05e: data = 8'b01100000; //11100000
    11'h05f: data = 8'b00000000; //11100000
    
    //code letter E
    11'h060: data = 8'b00000000; //11111111
    11'h061: data = 8'b01111110; //11111111
    11'h062: data = 8'b01111110; //11100000
    11'h063: data = 8'b01100000; //11100000
    11'h064: data = 8'b01100000; //11100000
    11'h065: data = 8'b01100000; //11100000
    11'h066: data = 8'b01100000; //11100000
    11'h067: data = 8'b01111110; //11111111
    11'h068: data = 8'b01100000; //11100000
    11'h069: data = 8'b01100000; //11100000
    11'h06a: data = 8'b01100000; //11100000
    11'h06b: data = 8'b01100000; //11100000
    11'h06c: data = 8'b01100000; //11100000
    11'h06d: data = 8'b01111110; //11111111
    11'h06e: data = 8'b01111110; //11111111
    11'h06f: data = 8'b00000000; //11111111
    
    //code letter C
    11'h070: data = 8'b00000000; 
    11'h071: data = 8'b01111110;
    11'h072: data = 8'b01111110; 
    11'h073: data = 8'b01100000; 
    11'h074: data = 8'b01100000; 
    11'h075: data = 8'b01100000; 
    11'h076: data = 8'b01100000; 
    11'h077: data = 8'b01100000; 
    11'h078: data = 8'b01100000; 
    11'h079: data = 8'b01100000; 
    11'h07a: data = 8'b01100000; 
    11'h07b: data = 8'b01100000; 
    11'h07c: data = 8'b01100000; 
    11'h07d: data = 8'b01111110; 
    11'h07e: data = 8'b01111110; 
    11'h07f: data = 8'b00000000; 

 

    //code letter T
    11'h080: data = 8'b00000000; 
    11'h081: data = 8'b01111110;
    11'h082: data = 8'b01111110; 
    11'h083: data = 8'b01111110; 
    11'h084: data = 8'b00011000; 
    11'h085: data = 8'b00011000; 
    11'h086: data = 8'b00011000; 
    11'h087: data = 8'b00011000; 
    11'h088: data = 8'b00011000; 
    11'h089: data = 8'b00011000; 
    11'h08a: data = 8'b00011000; 
    11'h08b: data = 8'b00011000; 
    11'h08c: data = 8'b00011000; 
    11'h08d: data = 8'b00011000; 
    11'h08e: data = 8'b00011000; 
    11'h08f: data = 8'b00000000; 

  //code letter I
    11'h090: data = 8'b00000000; 
    11'h091: data = 8'b00011000;
    11'h092: data = 8'b00011000; 
    11'h093: data = 8'b00011000; 
    11'h094: data = 8'b00011000; 
    11'h095: data = 8'b00011000; 
    11'h096: data = 8'b00011000; 
    11'h097: data = 8'b00011000; 
    11'h098: data = 8'b00011000; 
    11'h099: data = 8'b00011000; 
    11'h09a: data = 8'b00011000; 
    11'h09b: data = 8'b00011000; 
    11'h09c: data = 8'b00011000; 
    11'h09d: data = 8'b00011000; 
    11'h09e: data = 8'b00011000; 
    11'h09f: data = 8'b00000000; 
    
    //code letter M
    11'h0a0: data = 8'b00000000; 
    11'h0a1: data = 8'b01100110;
    11'h0a2: data = 8'b01100110; 
    11'h0a3: data = 8'b01100110; 
    11'h0a4: data = 8'b01011010; 
    11'h0a5: data = 8'b01011010; 
    11'h0a6: data = 8'b01011010; 
    11'h0a7: data = 8'b01011010; 
    11'h0a8: data = 8'b01000010; 
    11'h0a9: data = 8'b01000010; 
    11'h0aa: data = 8'b01000010; 
    11'h0ab: data = 8'b01000010; 
    11'h0ac: data = 8'b01000010; 
    11'h0ad: data = 8'b01000010; 
    11'h0ae: data = 8'b01000010; 
    11'h0af: data = 8'b00000000;

    //code letter P
    11'h0b0: data = 8'b00000000; //11111111
    11'h0b1: data = 8'b01111110; //11111111
    11'h0b2: data = 8'b01111110; //11100011
    11'h0b3: data = 8'b01100110; //11100011
    11'h0b4: data = 8'b01100110; //11100011
    11'h0b5: data = 8'b01100110; //11100011
    11'h0b6: data = 8'b01100110; //11100011
    11'h0b7: data = 8'b01111110; //11111111
    11'h0b8: data = 8'b01100000; //11100000
    11'h0b9: data = 8'b01100000; //11100000
    11'h0ba: data = 8'b01100000; //11100000
    11'h0bb: data = 8'b01100000; //11100000
    11'h0bc: data = 8'b01100000; //11100000
    11'h0bd: data = 8'b01100000; //11100000
    11'h0be: data = 8'b01100000; //11100000
    11'h0bf: data = 8'b00000000; //11100000

    //code sig =
    11'h0c0: data = 8'b00000000; 
    11'h0c1: data = 8'b00000000; 
    11'h0c2: data = 8'b00000000; 
    11'h0c3: data = 8'b01111110; 
    11'h0c4: data = 8'b01111110; 
    11'h0c5: data = 8'b00000000; 
    11'h0c6: data = 8'b00000000; 
    11'h0c7: data = 8'b00000000; 
    11'h0c8: data = 8'b00000000; 
    11'h0c9: data = 8'b00000000; 
    11'h0ca: data = 8'b00000000; 
    11'h0cb: data = 8'b01111110; 
    11'h0cc: data = 8'b01111110; 
    11'h0cd: data = 8'b00000000; 
    11'h0ce: data = 8'b00000000; 
    11'h0cf: data = 8'b00000000; 
    
    //code sig :
    11'h0d0: data = 8'h00000000; 
    11'h0d1: data = 8'h00000000; 
    11'h0d2: data = 8'b00011000; 
    11'h0d3: data = 8'b00011000; 
    11'h0d4: data = 8'b00011000; 
    11'h0d5: data = 8'b00000000; 
    11'h0d6: data = 8'b00000000; 
    11'h0d7: data = 8'b00000000; 
    11'h0d8: data = 8'b00000000; 
    11'h0d9: data = 8'b00000000; 
    11'h0da: data = 8'b00000000; 
    11'h0db: data = 8'b00011000; 
    11'h0dc: data = 8'b00011000; 
    11'h0dd: data = 8'b00011000; 
    11'h0de: data = 8'b00000000; 
    11'h0df: data = 8'b00000000; 
    
    //code sig -
    11'h0e0: data = 8'b0000000000;
    11'h0e1: data = 8'h04a2cb71;
    11'h0e2: data = 8'b00000000; 
    11'h0e3: data = 8'b00000000; 
    11'h0e4: data = 8'b00000000; 
    11'h0e5: data = 8'b00000000; 
    11'h0e6: data = 8'b00000000; 
    11'h0e7: data = 8'b00111100; 
    11'h0e8: data = 8'b00111100; 
    11'h0e9: data = 8'b00000000; 
    11'h0ea: data = 8'b00000000; 
    11'h0eb: data = 8'b00000000; 
    11'h0ec: data = 8'b00000000; 
    11'h0ed: data = 8'b00000000; 
    11'h0ee: data = 8'b00000000; 
    11'h0ef: data = 8'b00000000; 

     
    

    default : data = 8'b00000000;
endcase

 
endmodule
