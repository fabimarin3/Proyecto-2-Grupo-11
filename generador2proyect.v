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
    //input wire [2:0] rgbswitches,
    output reg [2:0] rgbtext,
    output wire hsync, vsync
   // input wire [7:0] hhora,minhora,seghora,dfecha,mfecha,afecha,htimer,mintimer,segtimer
   
  
    //output [8:0] nousar
    );
    wire video_on;
    wire [9:0] pixel_x, pixel_y;
    wire [9:0] pixel_xm, pixel_ym;
    
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

//Parte Dinamica

//wire [3:0] ;
        
reg [2:0] letter_rgb;

wire [7:0] Data;
reg [4:0] as; //cambio :de 2 bits a 4 bits
//reg [4:0] asd;

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

//numero 1
localparam uxi = 272;
localparam uxf = 287;
localparam uyi = 32;
localparam uyf = 63;


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

//numero dos
localparam dxi = 272; 
localparam dxf = 287;
localparam dyi = 64;
localparam dyf = 95;


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

//numero tres
localparam txi = 272;
localparam txf = 287;
localparam tyi = 96;
localparam tyf = 127;

//guiones fecha
localparam g1xi = 368;
localparam g1xf = 383;
localparam g2xi = 416;
localparam g2xf = 431;
   

//dos puntos hora 
localparam d1hxi = 192;
localparam d1hxf = 207;
localparam d2hxi = 240;
localparam d2hxf = 255;

//dos puntos timer
localparam d1txi = 288;
localparam d1txf = 303;
localparam d2txi = 336;
localparam d2txf = 351;

//hora
localparam hxl = 192;
localparam hxr = 207;
localparam oxl = 208;
localparam oxr = 223;
localparam rxl = 224;
localparam rxr = 239;
localparam axl = 240;
localparam axr = 255;

//hora dinamica
localparam hdxi = 160;
localparam hdxf = 175;
localparam huxi = 176;
localparam huxf = 191;
localparam mindxi= 208;
localparam mindxf = 223;
localparam minuxi= 224;
localparam minuxf= 239;
localparam segdxi= 256;
localparam segdxf= 271;
localparam seguxi = 272;
localparam seguxf = 287;

localparam yt = 192;
localparam yb = 223;
localparam d1yi= 226; //yi dinamica
localparam d1yf= 256; //yf dinamica


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

//fecha dinamica
localparam ddi= 336;
localparam ddf= 351;
localparam udi= 352;
localparam udf= 367;
localparam dmi= 384;
localparam dmf= 399;
localparam umi= 400;
localparam umf= 415;
localparam dai= 432;
localparam daf= 447;
localparam uai= 448;
localparam uaf= 463;

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

//timer dinamica
localparam dhi= 256;
localparam dhf= 271;
localparam uhi= 272;
localparam uhf= 287;
localparam dmini= 304;
localparam dminf= 319;
localparam umini= 320;
localparam uminf= 335;
localparam dsegi= 352;
localparam dsegf= 367;
localparam usegi= 368;
localparam usegf= 383;

localparam y_t = 352; 
localparam y_b = 383;
localparam d2yi = 386;
localparam d2yf = 415;

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
phon,p_hon,pton, pfon,p_fon, p_ton, chon, cfon, cton , caon, cmon,cpon, cm_on, 
gph,gpf, gpt,uno, dos, tres,dh,dmin,dseg,dph1, dph2, g1fon, g2fon,dpt1, dpt2,
uh,umin,useg,dd,ud,dm,um,da,ua,dht,uht,dmint,umint,dsegt,usegt;

// CUERPO

// pixel within letters & signs & numbers

//numeros
assign uno = (uxi<=pixel_x)&&(pixel_x<=uxf) && (uyi<=pixel_y)&&(pixel_y<=uyf) ;
assign dos = (dxi<=pixel_x)&&(pixel_x<=dxf) && (dyi<=pixel_y)&&(pixel_y<=dyf) ;
assign tres = (txi<=pixel_x)&&(pixel_x<=txf) && (tyi<=pixel_y)&&(pixel_y<=tyf) ;

//guiones fecha
assign g1fon = (g1xi<=pixel_xm)&&(pixel_xm<=g1xf) && (d1yi<=pixel_ym)&&(pixel_ym<=d1yf) ;
assign g2fon = (g2xi<=pixel_xm)&&(pixel_xm<=g2xf) && (d1yi<=pixel_ym)&&(pixel_ym<=d1yf) ;

//dos puntos hora
assign dph1 = (d1hxi<=pixel_xm)&&(pixel_xm<=d1hxf) && (d1yi<=pixel_ym)&&(pixel_ym<=d1yf) ;
assign dph2 = (d2hxi<=pixel_xm)&&(pixel_xm<=d2hxf) && (d1yi<=pixel_ym)&&(pixel_ym<=d1yf) ;

//dos puntos timer
assign dpt1 = (d1txi<=pixel_xm)&&(pixel_xm<=d1txf) &&(d2yi<=pixel_y) && (pixel_y<=d2yf);
assign dpt2 = (d2txi<=pixel_xm)&&(pixel_xm<=d2txf)&&(d2yi<=pixel_y) && (pixel_y<=d2yf);

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
assign caon= (aci<=pixel_x)&&(pixel_x<=acf) && (cayt<=pixel_y)&&(pixel_y<=cayb) ;
assign cmon =(mci<=pixel_x)&&(pixel_x<=mcf) && (cayt<=pixel_y)&&(pixel_y<=cayb);

//pm
assign cpon= (pci<=pixel_x)&&(pixel_x<=pcf) && (cayt<=pixel_y)&&(pixel_y<=cayb) ;
assign cm_on =(mc_i<=pixel_x)&&(pixel_x<=mc_f) && (cayt<=pixel_y)&&(pixel_y<=cayb);

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
//hora dinamica
assign dh =(hdxi<=pixel_x) && (pixel_x<=hdxf) &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign uh = (huxi<=pixel_x) && (pixel_x<=huxf) &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign dmin =(mindxi<=pixel_x) && (pixel_x<=mindxf) &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign umin =(minuxi<=pixel_x) && (pixel_x<=minuxf)  &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign dseg =(segdxi<=pixel_x) && (pixel_x<=segdxf) &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign useg =(seguxi<=pixel_x) && (pixel_x<=seguxf) &&(d1yi<=pixel_y) && (pixel_y<=d1yf);

//fecha
assign f_on =(f_xl<=pixel_x) && (pixel_x<=f_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign e_on =(e_xl<=pixel_x) && (pixel_x<=e_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign c_on =(c_xl<=pixel_x) && (pixel_x<=c_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign h_on= (h_xl<=pixel_x) && (pixel_x<=h_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
assign a_on =(a_xl<=pixel_x) && (pixel_x<=a_xr) &&(yt<=pixel_y) && (pixel_y<=yb);
//fecha dinamica
assign dd = (ddi<=pixel_x) && (pixel_x<=ddf)  &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign ud = (udi<=pixel_x) && (pixel_x<=udf)  &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign dm = (dmi<=pixel_x) && (pixel_x<=dmf)  &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign um = (umi<=pixel_x) && (pixel_x<=umf)  &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign da = (dai<=pixel_x) && (pixel_x<=daf)  &&(d1yi<=pixel_y) && (pixel_y<=d1yf);
assign ua = (uai<=pixel_x) && (pixel_x<=uaf)  &&(d1yi<=pixel_y) && (pixel_y<=d1yf);

//timer
assign ton =(txl<=pixel_x) && (pixel_x<=txr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign ion =(ixl<=pixel_x) && (pixel_x<=ixr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign mon =(mxl<=pixel_x) && (pixel_x<=mxr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign eon = (exl<=pixel_x) && (pixel_x<=exr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
assign r_on =(r_xl<=pixel_x) && (pixel_x<=r_xr) &&(y_t<=pixel_y) && (pixel_y<=y_b);
//timer dinamica
assign dht= (dhi<=pixel_x) && (pixel_x<=dhf) &&(d2yi<=pixel_y) && (pixel_y<=d2yf);
assign uht= (uhi<=pixel_x) && (pixel_x<=uhf) &&(d2yi<=pixel_y) && (pixel_y<=d2yf);
assign dmint= (dmini<=pixel_x) && (pixel_x<=dminf) &&(d2yi<=pixel_y) && (pixel_y<=d2yf);
assign umint= (umini<=pixel_x) && (pixel_x<=uminf) &&(d2yi<=pixel_y) && (pixel_y<=d2yf);
assign dsegt= (dsegi<=pixel_x) && (pixel_x<=dsegf) &&(d2yi<=pixel_y) && (pixel_y<=d2yf);
assign usegt= (usegi<=pixel_x) && (pixel_x<=usegf)&&(d2yi<=pixel_y) && (pixel_y<=d2yf);


always @* 
   begin
        //hora
    if (hon|h_on|p_hon)
         as  = 5'b00001; 
    else if (oon|dh|uh|dmin|umin|dseg|useg|dd|ud|dm|um|da|ua)
         as = 5'b00010;
    else if (ron|r_on)
         as = 5'b00011;
    else if (aon|a_on|caon)
         as = 5'b00100; //se agrega 
        
        //fecha
    else if (f_on|p_fon)
         as = 5'b00101; //se agrega 
    else if (e_on|eon)
         as = 5'b00110; //se agrega 
    else if (c_on)
         as = 5'b00111; //se agrega 
 
         
         //timer
    else if (ton|p_ton)
         as = 5'b01000; //se agrega 
    else if (ion|dht|uht|dmint|umint|dsegt|usegt)
         as = 5'b01001; //se agrega 
    else if (mon|cmon|cm_on)
         as = 5'b01010; //se agrega 
    else if (cpon|phon|pfon|pton)
         as = 5'b01011; //se agrega //letraP
              
         //signos
    else if (gph|gpf|gpt)
         as = 5'b01100;
    else if (dph1|dph2|dpt1|dpt2)
         as = 5'b01101;
    else if (g1fon|g2fon)
         as = 5'b01110;
         
         //numeros
    else if (uno)
         as <= 5'h0f;
    else if (dos)
         as <= 5'h10;
    else if (tres)
         as <= 5'h11;
         
       
    else
        as <= 5'b00000;   
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
        letter_rgb <= 3'b100;
    else
        letter_rgb <= 3'b000;

// rgb multiplexing circuit
always @*
    if (~video_on)
        rgbtext = 3'b000; // blank 
    else if (hon|oon|ron|aon|f_on|e_on|c_on|h_on|a_on|ton|ion|mon|eon|r_on|caon|cmon|cpon|
            cm_on|phon|pfon|pton|p_hon|p_fon|p_ton|gph|gpf|gpt|g1fon|g2fon|dph1|dph2|dpt1|
            dpt2|uno|dos|tres|dh|uh|dmin|umin|dseg|useg|dd|ud|dm|um|da|ua|dht|uht|dmint|
            umint|dsegt|usegt)  
        rgbtext = letter_rgb; 
    else if (chon|cfon|cton)
        rgbtext = 3'b111;
    else
        rgbtext = 3'b000; // black background
endmodule



module ROM (
input wire [4:0]as,
input wire [4:1]lsby,
//input wire [3:0]lsbym,
output reg [7:0]data 
);

reg [8:0]adress;

always @*
    adress <= {as,lsby};

always @*
    case (adress)
    
    9'h000: data = 8'b00000000;
    9'h001: data = 8'b00000000; 
    9'h002: data = 8'b00000000; 
    9'h003: data = 8'b00000000; 
    9'h004: data = 8'b00000000; 
    9'h005: data = 8'b00000000;  
    9'h006: data = 8'b00000000;
    9'h007: data = 8'b00000000; 
    9'h008: data = 8'b00000000; 
    9'h009: data = 8'b00000000;
    9'h00a: data = 8'b00000000;
    9'h00b: data = 8'b00000000; 
    9'h00c: data = 8'b00000000; 
    9'h00d: data = 8'b00000000;
    9'h00e: data = 8'b00000000;
    9'h00f: data = 8'b00000000; 

     //code letter H
    9'h010: data = 8'b00000000; 
    9'h011: data = 8'b01100110;
    9'h012: data = 8'b01100110; 
    9'h013: data = 8'b01100110; 
    9'h014: data = 8'b01100110; 
    9'h015: data = 8'b01100110; 
    9'h016: data = 8'b01100110; 
    9'h017: data = 8'b01111110; 
    9'h018: data = 8'b01111110; 
    9'h019: data = 8'b01100110; 
    9'h01a: data = 8'b01100110; 
    9'h01b: data = 8'b01100110; 
    9'h01c: data = 8'b01100110; 
    9'h01d: data = 8'b01100110; 
    9'h01e: data = 8'b01100110; 
    9'h01f: data = 8'b00000000; 

     //code letter O
    9'h020: data = 8'b00000000; 
    9'h021: data = 8'b00111100; 
    9'h022: data = 8'b00111100; 
    9'h023: data = 8'b01100110; 
    9'h024: data = 8'b01100110;
    9'h025: data = 8'b01100110; 
    9'h026: data = 8'b01100110; 
    9'h027: data = 8'b01100110; 
    9'h028: data = 8'b01100110; 
    9'h029: data = 8'b01100110; 
    9'h02a: data = 8'b01100110; 
    9'h02b: data = 8'b01100110; 
    9'h02c: data = 8'b01100110; 
    9'h02d: data = 8'b00111100; 
    9'h02e: data = 8'b00111100; 
    9'h02f: data = 8'b00000000; 
    
    //code letter R
    9'h030: data = 8'b00000000; 
    9'h031: data = 8'b01111100; 
    9'h032: data = 8'b01100110; 
    9'h033: data = 8'b01100110; 
    9'h034: data = 8'b01100110; 
    9'h035: data = 8'b01100110; 
    9'h036: data = 8'b01100110; 
    9'h037: data = 8'b01111100; 
    9'h038: data = 8'b01111100; 
    9'h039: data = 8'b01100110; 
    9'h03a: data = 8'b01100110; 
    9'h03b: data = 8'b01100110; 
    9'h03c: data = 8'b01100110; 
    9'h03d: data = 8'b01100110; 
    9'h03e: data = 8'b01100110; 
    9'h03f: data = 8'b00000000; 
    
    //code letter A
    9'h040: data = 8'b00000000; 
    9'h041: data = 8'b00011000; 
    9'h042: data = 8'b00011000; 
    9'h043: data = 8'b00111100; 
    9'h044: data = 8'b00111100; 
    9'h045: data = 8'b01100110;
    9'h046: data = 8'b01100110; 
    9'h047: data = 8'b01111110; 
    9'h048: data = 8'b01111110; 
    9'h049: data = 8'b01100110; 
    9'h04a: data = 8'b01100110; 
    9'h04b: data = 8'b01100110; 
    9'h04c: data = 8'b01100110; 
    9'h04d: data = 8'b01100110; 
    9'h04e: data = 8'b01100110; 
    9'h04f: data = 8'b00000000; 
    
    //code letter F
    9'h050: data = 8'b00000000; //11111111
    9'h051: data = 8'b01111110; //11111111
    9'h052: data = 8'b01111110; //11100000
    9'h053: data = 8'b01100000; //11100000
    9'h054: data = 8'b01100000; //11100000
    9'h055: data = 8'b01100000; //11100000
    9'h056: data = 8'b01100000; //11100000
    9'h057: data = 8'b01111110; //11111111
    9'h058: data = 8'b01100000; //11100000
    9'h059: data = 8'b01100000; //11100000
    9'h05a: data = 8'b01100000; //11100000
    9'h05b: data = 8'b01100000; //11100000
    9'h05c: data = 8'b01100000; //11100000
    9'h05d: data = 8'b01100000; //11100000
    9'h05e: data = 8'b01100000; //11100000
    9'h05f: data = 8'b00000000; //11100000
    
    //code letter E
    9'h060: data = 8'b00000000; //11111111
    9'h061: data = 8'b01111110; //11111111
    9'h062: data = 8'b01111110; //11100000
    9'h063: data = 8'b01100000; //11100000
    9'h064: data = 8'b01100000; //11100000
    9'h065: data = 8'b01100000; //11100000
    9'h066: data = 8'b01100000; //11100000
    9'h067: data = 8'b01111110; //11111111
    9'h068: data = 8'b01100000; //11100000
    9'h069: data = 8'b01100000; //11100000
    9'h06a: data = 8'b01100000; //11100000
    9'h06b: data = 8'b01100000; //11100000
    9'h06c: data = 8'b01100000; //11100000
    9'h06d: data = 8'b01111110; //11111111
    9'h06e: data = 8'b01111110; //11111111
    9'h06f: data = 8'b00000000; //11111111
    
    //code letter C
    9'h070: data = 8'b00000000; 
    9'h071: data = 8'b01111110;
    9'h072: data = 8'b01111110; 
    9'h073: data = 8'b01100000; 
    9'h074: data = 8'b01100000; 
    9'h075: data = 8'b01100000; 
    9'h076: data = 8'b01100000; 
    9'h077: data = 8'b01100000; 
    9'h078: data = 8'b01100000; 
    9'h079: data = 8'b01100000; 
    9'h07a: data = 8'b01100000; 
    9'h07b: data = 8'b01100000; 
    9'h07c: data = 8'b01100000; 
    9'h07d: data = 8'b01111110; 
    9'h07e: data = 8'b01111110; 
    9'h07f: data = 8'b00000000; 

 

    //code letter T
    9'h080: data = 8'b00000000; 
    9'h081: data = 8'b01111110;
    9'h082: data = 8'b01111110; 
    9'h083: data = 8'b01111110; 
    9'h084: data = 8'b00011000; 
    9'h085: data = 8'b00011000; 
    9'h086: data = 8'b00011000; 
    9'h087: data = 8'b00011000; 
    9'h088: data = 8'b00011000; 
    9'h089: data = 8'b00011000; 
    9'h08a: data = 8'b00011000; 
    9'h08b: data = 8'b00011000; 
    9'h08c: data = 8'b00011000; 
    9'h08d: data = 8'b00011000; 
    9'h08e: data = 8'b00011000; 
    9'h08f: data = 8'b00000000; 

  //code letter I
    9'h090: data = 8'b00000000; 
    9'h091: data = 8'b00011000;
    9'h092: data = 8'b00011000; 
    9'h093: data = 8'b00011000; 
    9'h094: data = 8'b00011000; 
    9'h095: data = 8'b00011000; 
    9'h096: data = 8'b00011000; 
    9'h097: data = 8'b00011000; 
    9'h098: data = 8'b00011000; 
    9'h099: data = 8'b00011000; 
    9'h09a: data = 8'b00011000; 
    9'h09b: data = 8'b00011000; 
    9'h09c: data = 8'b00011000; 
    9'h09d: data = 8'b00011000; 
    9'h09e: data = 8'b00011000; 
    9'h09f: data = 8'b00000000; 
    
    //code letter M
    9'h0a0: data = 8'b00000000; 
    9'h0a1: data = 8'b01100110;
    9'h0a2: data = 8'b01100110; 
    9'h0a3: data = 8'b01100110; 
    9'h0a4: data = 8'b01011010; 
    9'h0a5: data = 8'b01011010; 
    9'h0a6: data = 8'b01011010; 
    9'h0a7: data = 8'b01011010; 
    9'h0a8: data = 8'b01000010; 
    9'h0a9: data = 8'b01000010; 
    9'h0aa: data = 8'b01000010; 
    9'h0ab: data = 8'b01000010; 
    9'h0ac: data = 8'b01000010; 
    9'h0ad: data = 8'b01000010; 
    9'h0ae: data = 8'b01000010; 
    9'h0af: data = 8'b00000000;

    //code letter P
    9'h0b0: data = 8'b00000000; //11111111
    9'h0b1: data = 8'b01111110; //11111111
    9'h0b2: data = 8'b01111110; //11100011
    9'h0b3: data = 8'b01100110; //11100011
    9'h0b4: data = 8'b01100110; //11100011
    9'h0b5: data = 8'b01100110; //11100011
    9'h0b6: data = 8'b01100110; //11100011
    9'h0b7: data = 8'b01111110; //11111111
    9'h0b8: data = 8'b01100000; //11100000
    9'h0b9: data = 8'b01100000; //11100000
    9'h0ba: data = 8'b01100000; //11100000
    9'h0bb: data = 8'b01100000; //11100000
    9'h0bc: data = 8'b01100000; //11100000
    9'h0bd: data = 8'b01100000; //11100000
    9'h0be: data = 8'b01100000; //11100000
    9'h0bf: data = 8'b00000000; //11100000

    //code sig =
    9'h0c0: data = 8'b00000000; 
    9'h0c1: data = 8'b00000000; 
    9'h0c2: data = 8'b00000000; 
    9'h0c3: data = 8'b01111110; 
    9'h0c4: data = 8'b01111110; 
    9'h0c5: data = 8'b00000000; 
    9'h0c6: data = 8'b00000000; 
    9'h0c7: data = 8'b00000000; 
    9'h0c8: data = 8'b00000000; 
    9'h0c9: data = 8'b00000000; 
    9'h0ca: data = 8'b00000000; 
    9'h0cb: data = 8'b01111110; 
    9'h0cc: data = 8'b01111110; 
    9'h0cd: data = 8'b00000000; 
    9'h0ce: data = 8'b00000000; 
    9'h0cf: data = 8'b00000000; 
    
    //code sig :
    9'h0d0: data = 8'b00000000; 
    9'h0d1: data = 8'b00000000; 
    9'h0d2: data = 8'b00011000; 
    9'h0d3: data = 8'b00011000; 
    9'h0d4: data = 8'b00011000; 
    9'h0d5: data = 8'b00000000; 
    9'h0d6: data = 8'b00000000; 
    9'h0d7: data = 8'b00000000; 
    9'h0d8: data = 8'b00000000; 
    9'h0d9: data = 8'b00000000; 
    9'h0da: data = 8'b00000000; 
    9'h0db: data = 8'b00011000; 
    9'h0dc: data = 8'b00011000; 
    9'h0dd: data = 8'b00011000; 
    9'h0de: data = 8'b00000000; 
    9'h0df: data = 8'b00000000; 
    
    //code sig -
    9'h0e0: data = 8'b00000000;
    9'h0e1: data = 8'b00000000;
    9'h0e2: data = 8'b00000000; 
    9'h0e3: data = 8'b00000000; 
    9'h0e4: data = 8'b00000000; 
    9'h0e5: data = 8'b00000000; 
    9'h0e6: data = 8'b00000000; 
    9'h0e7: data = 8'b00111100; 
    9'h0e8: data = 8'b00111100; 
    9'h0e9: data = 8'b00000000; 
    9'h0ea: data = 8'b00000000; 
    9'h0eb: data = 8'b00000000; 
    9'h0ec: data = 8'b00000000; 
    9'h0ed: data = 8'b00000000; 
    9'h0ee: data = 8'b00000000; 
    9'h0ef: data = 8'b00000000; 

    //code sig 1
    9'h0f0: data = 8'b00000000;
    9'h0f1: data = 8'b00011000;
    9'h0f2: data = 8'b00111000; 
    9'h0f3: data = 8'b00111000; 
    9'h0f4: data = 8'b00011000; 
    9'h0f5: data = 8'b00011000; 
    9'h0f6: data = 8'b00011000; 
    9'h0f7: data = 8'b00011000; 
    9'h0f8: data = 8'b00011000; 
    9'h0f9: data = 8'b00011000; 
    9'h0fa: data = 8'b00011000; 
    9'h0fb: data = 8'b00011000; 
    9'h0fc: data = 8'b00011000; 
    9'h0fd: data = 8'b01111110; 
    9'h0fe: data = 8'b01111110; 
    9'h0ff: data = 8'b00000000; 
    
    //code sig 2
    9'h100: data = 8'b00000000;
    9'h101: data = 8'b01111110;
    9'h102: data = 8'b01111110; 
    9'h103: data = 8'b01111110; 
    9'h104: data = 8'b00001110; 
    9'h105: data = 8'b00001110; 
    9'h106: data = 8'b00001110; 
    9'h107: data = 8'b01111110; 
    9'h108: data = 8'b01111110; 
    9'h109: data = 8'b01110000; 
    9'h10a: data = 8'b01110000; 
    9'h10b: data = 8'b01110000; 
    9'h10c: data = 8'b01111110; 
    9'h10d: data = 8'b01111110; 
    9'h10e: data = 8'b01111110; 
    9'h10f: data = 8'b00000000; 

    //code sig 3
    9'h110: data = 8'b00000000;
    9'h111: data = 8'b01111110;
    9'h112: data = 8'b01111110; 
    9'h113: data = 8'b01111110; 
    9'h114: data = 8'b00001110; 
    9'h115: data = 8'b00001110; 
    9'h116: data = 8'b00001110; 
    9'h117: data = 8'b01111110; 
    9'h118: data = 8'b01111110; 
    9'h119: data = 8'b00001110; 
    9'h11a: data = 8'b00001110; 
    9'h11b: data = 8'b00001110; 
    9'h11c: data = 8'b01111110; 
    9'h11d: data = 8'b01111110; 
    9'h11e: data = 8'b01111110; 
    9'h11f: data = 8'b00000000; 
    
    //code sig 4
    9'h120: data = 8'b00000000;
    9'h121: data = 8'b01100110;
    9'h122: data = 8'b01100110; 
    9'h123: data = 8'b01100110; 
    9'h124: data = 8'b01111110; 
    9'h125: data = 8'b01111110; 
    9'h126: data = 8'b00000110; 
    9'h127: data = 8'b00000110; 
    9'h128: data = 8'b00000110; 
    9'h129: data = 8'b00000110; 
    9'h12a: data = 8'b00000110; 
    9'h12b: data = 8'b00000110; 
    9'h12c: data = 8'b00000110; 
    9'h12d: data = 8'b00000110; 
    9'h12e: data = 8'b00000110; 
    9'h12f: data = 8'b00000000; 
    
    //code sig 5
    9'h130: data = 8'b00000000;
    9'h131: data = 8'b01111110;
    9'h132: data = 8'b01111110; 
    9'h133: data = 8'b01111110; 
    9'h134: data = 8'b01100000; 
    9'h135: data = 8'b01100000; 
    9'h136: data = 8'b01111110; 
    9'h137: data = 8'b01111110; 
    9'h138: data = 8'b01111110; 
    9'h139: data = 8'b00000110; 
    9'h13a: data = 8'b00000110; 
    9'h13b: data = 8'b00000110; 
    9'h13c: data = 8'b01111110; 
    9'h13d: data = 8'b01111110; 
    9'h13e: data = 8'b01111110; 
    9'h13f: data = 8'b00000000; 
    
    //code sig 6
    9'h140: data = 8'b00000000;
    9'h141: data = 8'b01111110;
    9'h142: data = 8'b01111110; 
    9'h143: data = 8'b01111110; 
    9'h144: data = 8'b01100000; 
    9'h145: data = 8'b01100000; 
    9'h146: data = 8'b01111110; 
    9'h147: data = 8'b01111110; 
    9'h148: data = 8'b01111110; 
    9'h149: data = 8'b01100110; 
    9'h14a: data = 8'b01100110; 
    9'h14b: data = 8'b01100110; 
    9'h14c: data = 8'b01111110; 
    9'h14d: data = 8'b01111110; 
    9'h14e: data = 8'b01111110; 
    9'h14f: data = 8'b00000000; 
    
    //code sig 7
    9'h150: data = 8'b00000000;
    9'h151: data = 8'b01111110;
    9'h152: data = 8'b01111110; 
    9'h153: data = 8'b01111110; 
    9'h154: data = 8'b00001110; 
    9'h155: data = 8'b00001110; 
    9'h156: data = 8'b00001110; 
    9'h157: data = 8'b00001110; 
    9'h158: data = 8'b01111110; 
    9'h159: data = 8'b01111110; 
    9'h15a: data = 8'b00001110; 
    9'h15b: data = 8'b00001110; 
    9'h15c: data = 8'b00001110; 
    9'h15d: data = 8'b00001110; 
    9'h15e: data = 8'b00001110; 
    9'h15f: data = 8'b00000000; 
    
    //code sig 8
    9'h160: data = 8'b00000000;
    9'h161: data = 8'b01111110;
    9'h162: data = 8'b01111110; 
    9'h163: data = 8'b01111110; 
    9'h164: data = 8'b01100110; 
    9'h165: data = 8'b01100110; 
    9'h166: data = 8'b01111110; 
    9'h167: data = 8'b01111110; 
    9'h168: data = 8'b01111110; 
    9'h169: data = 8'b01100110; 
    9'h16a: data = 8'b01100110; 
    9'h16b: data = 8'b01100110; 
    9'h16c: data = 8'b01111110; 
    9'h16d: data = 8'b01111110; 
    9'h16e: data = 8'b01111110; 
    9'h16f: data = 8'b00000000; 
    
    //code sig 9
    9'h170: data = 8'b00000000;
    9'h171: data = 8'b01111110;
    9'h172: data = 8'b01111110; 
    9'h173: data = 8'b01111110; 
    9'h174: data = 8'b01100110; 
    9'h175: data = 8'b01100110; 
    9'h176: data = 8'b01111110; 
    9'h177: data = 8'b01111110; 
    9'h178: data = 8'b01111110; 
    9'h179: data = 8'b00000110; 
    9'h17a: data = 8'b00000110; 
    9'h17b: data = 8'b00000110; 
    9'h17c: data = 8'b01111110; 
    9'h17d: data = 8'b01111110; 
    9'h17e: data = 8'b01111110; 
    9'h17f: data = 8'b00000000; 
    
    //code sig 0
    9'h180: data = 8'b00000000;
    9'h181: data = 8'b01111110;
    9'h182: data = 8'b01111110; 
    9'h183: data = 8'b01111110; 
    9'h184: data = 8'b01100110; 
    9'h185: data = 8'b01100110; 
    9'h186: data = 8'b01100110; 
    9'h187: data = 8'b01100110; 
    9'h188: data = 8'b01100110; 
    9'h189: data = 8'b01100110; 
    9'h18a: data = 8'b01100110; 
    9'h18b: data = 8'b01100110; 
    9'h18c: data = 8'b01111110; 
    9'h18d: data = 8'b01111110; 
    9'h18e: data = 8'b01111110; 
    9'h18f: data = 8'b00000000; 


    
    default : data = 8'b00000000;
endcase 

endmodule

