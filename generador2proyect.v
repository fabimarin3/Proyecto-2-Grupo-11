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
    output wire [9:0] pixel_xm, pixel_ym,
    input wire [7:0] dia,mes,ano,horar,minr,segr,horat,mint,segt
  
    //output [8:0] nousar
    );
    //wire video_on;
    //wire [9:0] pixel_x, pixel_y;
    //wire [9:0] pixel_xm, pixel_ym;
    //reg [7:0] dia,mes,ano,horar,minr,segr,horat,mint,segt;
    //boton ring : 
    reg ring;
    
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
reg [5:0] as; //cambio :de 2 bits a 4 bits
//reg [4:0] asd;

// x , y coordinates (0.0) to (639,479)
localparam maxx = 640;
localparam maxy = 480;

// Letter boundaries

//Switches PROGRAMACION
//PH
localparam phi = 16;
localparam phf = 31;
localparam p_hi = 32;
localparam p_hf = 47;
localparam phyi = 32;
localparam phyf = 63;

localparam gphix = 48;
localparam gphfx = 63;
localparam gphiy = 32;
localparam gphfy = 63;

//numero 1
localparam uxi = 64;
localparam uxf = 79;
localparam uyi = 32;
localparam uyf = 63;


//PF
localparam pfi = 16;
localparam pff = 31;
localparam p_fi = 32;
localparam p_ff = 47;
localparam pfyi = 64;
localparam pfyf = 95;

localparam gpfix = 48;
localparam gpffx = 63;
localparam gpfiy = 64;
localparam gpffy = 95;

//numero dos
localparam dxi = 64; 
localparam dxf = 79;
localparam dyi = 64;
localparam dyf = 95;


//PT
localparam pti = 16;
localparam ptf = 31;
localparam p_ti = 32;
localparam p_tf = 47;
localparam ptyi = 96;
localparam ptyf = 127;

localparam gptix = 48;
localparam gptfx = 63;
localparam gptiy = 96;
localparam gptfy = 127;

//numero tres
localparam txi = 64;
localparam txf = 79;
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


//botones
localparam bni = 400;
localparam bnf = 415;
localparam boi = 384;
localparam bof = 399;
localparam bsi = 400;
localparam bsf = 415;
localparam bei = 416;
localparam bef = 431;
localparam bi =  400;
localparam bf = 415;

//ring
localparam ri = 400;
localparam rf = 415 ;

// letter output signals
wire hon, oon, ron, aon, f_on, e_on, c_on, h_on, a_on, ton,ion,mon, eon, r_on, 
phon,p_hon,pton, pfon,p_fon, p_ton, chon, cfon, cton , caon, cmon,cpon, cm_on, 
gph,gpf, gpt,uno, dos, tres,dh,dmin,dseg,dph1, dph2, g1fon, g2fon,dpt1, dpt2,
uh,umin,useg,dd,ud,dm,um,da,ua,dht,uht,dmint,umint,dsegt,usegt,bn,bo,bs,be,b,ring1;

// CUERPO

// pixel within letters & signs & numbers

//ring
assign ring1 = (ri<=pixel_x) && (pixel_x<=rf) &&(y_t<=pixel_y) && (pixel_y<=y_b);
//botones
assign bn = (bni<=pixel_xm)&&(pixel_xm<=bnf) && (phyi<=pixel_ym)&&(pixel_ym<=phyf) ;
assign bo = (boi<=pixel_xm)&&(pixel_xm<=bof) && (pfyi<=pixel_ym)&&(pixel_ym<=pfyf) ;
assign bs = (bsi<=pixel_xm)&&(pixel_xm<=bsf) && (ptyi<=pixel_ym)&&(pixel_ym<=ptyf) ;
assign be = (bei<=pixel_xm)&&(pixel_xm<=bef) && (pfyi<=pixel_ym)&&(pixel_ym<=pfyf) ;
assign b = (bi<=pixel_xm)&&(pixel_xm<=bf) && (pfyi<=pixel_ym)&&(pixel_ym<=pfyf) ;

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
    as <= 6'h11;
else if (oon)
    as <= 6'h12;
else if (ron|r_on)
    as <= 6'h13;
else if (aon|a_on|caon)
    as <= 6'h14; //se agrega 
   
   //fecha
else if (f_on|p_fon)
    as <= 6'h15; //se agrega 
else if (e_on|eon)
    as <= 6'h16; //se agrega 
else if (c_on)
    as <= 6'h17; //se agrega 

    
    //timer
else if (ton|p_ton)
    as <= 6'h18; //se agrega 
else if (ion|bo)
    as <= 6'h19; //se agrega 
else if (mon|cmon|cm_on)
    as <= 6'h0a; //se agrega 
else if (cpon|phon|pfon|pton)
    as <= 6'h0b; //se agrega //letraP
         
    //signos
else if (gph|gpf|gpt)
    as <= 6'h0c;
else if (dph1|dph2|dpt1|dpt2)
    as <= 6'h0d;
else if (g1fon|g2fon)
    as <= 6'h0e;
    
    //numeros
else if (uno)
    as <= 6'h01;
else if (dos)
    as <= 6'h02;
else if (tres)
    as <= 6'h03;
else if (b)
    as <= 6'h20; 
else if (bn)
    as <= 6'h21;
else if (bs)
    as <= 6'h22;
else if (be)
    as <= 6'h10;
   

 
// input wire [7:0] dia,mes,ano,horar,minr,segr,horat,mint,segt   
//dh,dmin,dseg,uh,umin,useg,dd,ud,dm,um,da,ua,dht,uht,dmint,umint,dsegt,usegt
    //parte dinamica
else if (dh)
    as <= {2'b0,horar[7:4]};
else if (uh)
    as <= {2'b0,horar[3:0]};
else if (dmin)
    as <= {2'b0,minr[7:4]};
else if (umin) 
    as <= {2'b0,minr[3:0]};
else if (dseg)
    as <= {2'b0,segr[7:4]};
else if (useg) 
    as <= {2'b0,segr[3:0]};
    
else if (dd)
    as <= {2'b0,dia[7:4]};
else if (ud) 
    as <= {2'b0,dia[3:0]};
else if (dm)
    as <= {2'b0,mes[7:4]};
else if (um) 
    as <= {2'b0,mes[3:0]};
else if (da)
    as <= {2'b0,ano[7:4]};
else if (ua) 
    as <= {2'b0,ano[3:0]};   

else if (dht)
    as <= {2'b0,horat[7:4]};
else if (uht) 
    as <= {2'b0,horat[3:0]};
else if (dmint)
    as <= {2'b0,mint[7:4]};
else if (umint) 
    as <= {2'b0,mint[3:0]};
else if (dsegt)
    as <= {2'b0,segt[7:4]};
else if (usegt) 
    as <= {2'b0,segt[3:0]};   
else if (ring1)
    as <= 6'h23;
 // if  (ring == 1)
   // as <= 6'h23;
 // else
   // as <= 6'h0f;
  
    

 

    
else
   as <= 6'h0f;   
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
            cm_on|gph|gpf|gpt|g1fon|g2fon|dph1|dph2|dpt1|
            dpt2|uno|dos|tres|dh|uh|dmin|umin|dseg|useg|dd|ud|dm|um|da|ua|dht|uht|dmint|
            umint|dsegt|usegt)  
        rgbtext = letter_rgb; 
    else if (chon|cfon|cton)
        rgbtext = 3'b111;
    else if (bn|bo|bs|be|b|phon|pfon|pton|p_hon|p_fon|p_ton)    
        rgbtext  = letter_rgb <= 3'b010;
    else if (ring1)
        rgbtext  = letter_rgb <= 3'b001;
        
    else
        rgbtext = 3'b000; // black background
endmodule



module ROM (
input wire [5:0]as,
input wire [4:1]lsby,
//input wire [3:0]lsbym,
output reg [7:0]data 
);

reg [9:0]adress;

always @*
    adress <= {as,lsby};

always @*
    case (adress)
    
       10'h0f0: data = 8'b00000000;
       10'h0f1: data = 8'b00000000; 
       10'h0f2: data = 8'b00000000; 
       10'h0f3: data = 8'b00000000; 
       10'h0f4: data = 8'b00000000; 
       10'h0f5: data = 8'b00000000;  
       10'h0f6: data = 8'b00000000;
       10'h0f7: data = 8'b00000000; 
       10'h0f8: data = 8'b00000000; 
       10'h0f9: data = 8'b00000000;
       10'h0fa: data = 8'b00000000;
       10'h0fb: data = 8'b00000000; 
       10'h0fc: data = 8'b00000000; 
       10'h0fd: data = 8'b00000000;
       10'h0fe: data = 8'b00000000;
       10'h0ff: data = 8'b00000000; 
   
        //code letter H
       10'h110: data = 8'b00000000; 
       10'h111: data = 8'b01100110;
       10'h112: data = 8'b01100110; 
       10'h113: data = 8'b01100110; 
       10'h114: data = 8'b01100110; 
       10'h115: data = 8'b01100110; 
       10'h116: data = 8'b01100110; 
       10'h117: data = 8'b01111110; 
       10'h118: data = 8'b01111110; 
       10'h119: data = 8'b01100110; 
       10'h11a: data = 8'b01100110; 
       10'h11b: data = 8'b01100110; 
       10'h11c: data = 8'b01100110; 
       10'h11d: data = 8'b01100110; 
       10'h11e: data = 8'b01100110; 
       10'h11f: data = 8'b00000000; 
   
        //code letter O
       10'h120: data = 8'b00000000; 
       10'h121: data = 8'b00111100; 
       10'h122: data = 8'b00111100; 
       10'h123: data = 8'b01100110; 
       10'h124: data = 8'b01100110;
       10'h125: data = 8'b01100110; 
       10'h126: data = 8'b01100110; 
       10'h127: data = 8'b01100110; 
       10'h128: data = 8'b01100110; 
       10'h129: data = 8'b01100110; 
       10'h12a: data = 8'b01100110; 
       10'h12b: data = 8'b01100110; 
       10'h12c: data = 8'b01100110; 
       10'h12d: data = 8'b00111100; 
       10'h12e: data = 8'b00111100; 
       10'h12f: data = 8'b00000000; 
       
       //code letter R
       10'h130: data = 8'b00000000; 
       10'h131: data = 8'b01111100; 
       10'h132: data = 8'b01100110; 
       10'h133: data = 8'b01100110; 
       10'h134: data = 8'b01100110; 
       10'h135: data = 8'b01100110; 
       10'h136: data = 8'b01100110; 
       10'h137: data = 8'b01111100; 
       10'h138: data = 8'b01111100; 
       10'h139: data = 8'b01100110; 
       10'h13a: data = 8'b01100110; 
       10'h13b: data = 8'b01100110; 
       10'h13c: data = 8'b01100110; 
       10'h13d: data = 8'b01100110; 
       10'h13e: data = 8'b01100110; 
       10'h13f: data = 8'b00000000; 
       
       //code letter A
       10'h140: data = 8'b00000000; 
       10'h141: data = 8'b00011000; 
       10'h142: data = 8'b00011000; 
       10'h143: data = 8'b00111100; 
       10'h144: data = 8'b00111100; 
       10'h145: data = 8'b01100110;
       10'h146: data = 8'b01100110; 
       10'h147: data = 8'b01111110; 
       10'h148: data = 8'b01111110; 
       10'h149: data = 8'b01100110; 
       10'h14a: data = 8'b01100110; 
       10'h14b: data = 8'b01100110; 
       10'h14c: data = 8'b01100110; 
       10'h14d: data = 8'b01100110; 
       10'h14e: data = 8'b01100110; 
       10'h14f: data = 8'b00000000; 
       
       //code letter F
       10'h150: data = 8'b00000000; //11111111
       10'h151: data = 8'b01111110; //11111111
       10'h152: data = 8'b01111110; //11100000
       10'h153: data = 8'b01100000; //11100000
       10'h154: data = 8'b01100000; //11100000
       10'h155: data = 8'b01100000; //11100000
       10'h156: data = 8'b01100000; //11100000
       10'h157: data = 8'b01111110; //11111111
       10'h158: data = 8'b01100000; //11100000
       10'h159: data = 8'b01100000; //11100000
       10'h15a: data = 8'b01100000; //11100000
       10'h15b: data = 8'b01100000; //11100000
       10'h15c: data = 8'b01100000; //11100000
       10'h15d: data = 8'b01100000; //11100000
       10'h15e: data = 8'b01100000; //11100000
       10'h15f: data = 8'b00000000; //11100000
      
       //code letter E
       10'h160: data = 8'b00000000; //11111111
       10'h161: data = 8'b01111110; //11111111
       10'h162: data = 8'b01111110; //11100000
       10'h163: data = 8'b01100000; //11100000
       10'h164: data = 8'b01100000; //11100000
       10'h165: data = 8'b01100000; //11100000
       10'h166: data = 8'b01100000; //11100000
       10'h67: data = 8'b01111110; //11111111
       10'h168: data = 8'b01100000; //11100000
       10'h169: data = 8'b01100000; //11100000
       10'h16a: data = 8'b01100000; //11100000
       10'h16b: data = 8'b01100000; //11100000
       10'h16c: data = 8'b01100000; //11100000
       10'h16d: data = 8'b01111110; //11111111
       10'h16e: data = 8'b01111110; //11111111
       10'h16f: data = 8'b00000000; //11111111
       
       //code letter C
       10'h170: data = 8'b00000000; 
       10'h171: data = 8'b01111110;
       10'h172: data = 8'b01111110; 
       10'h173: data = 8'b01100000; 
       10'h174: data = 8'b01100000; 
       10'h175: data = 8'b01100000; 
       10'h176: data = 8'b01100000; 
       10'h177: data = 8'b01100000; 
       10'h178: data = 8'b01100000; 
       10'h179: data = 8'b01100000; 
       10'h17a: data = 8'b01100000; 
       10'h17b: data = 8'b01100000; 
       10'h17c: data = 8'b01100000; 
       10'h17d: data = 8'b01111110; 
       10'h17e: data = 8'b01111110; 
       10'h17f: data = 8'b00000000; 
   
       //code letter T
       10'h180: data = 8'b00000000; 
       10'h181: data = 8'b01111110;
       10'h182: data = 8'b01111110; 
       10'h183: data = 8'b01111110; 
       10'h184: data = 8'b00011000; 
       10'h185: data = 8'b00011000; 
       10'h186: data = 8'b00011000; 
       10'h187: data = 8'b00011000; 
       10'h188: data = 8'b00011000; 
       10'h189: data = 8'b00011000; 
       10'h18a: data = 8'b00011000; 
       10'h18b: data = 8'b00011000; 
       10'h18c: data = 8'b00011000; 
       10'h18d: data = 8'b00011000; 
       10'h18e: data = 8'b00011000; 
       10'h18f: data = 8'b00000000; 
   
     //code letter I
       10'h190: data = 8'b00000000; 
       10'h191: data = 8'b00011000;
       10'h192: data = 8'b00011000; 
       10'h193: data = 8'b00011000; 
       10'h194: data = 8'b00011000; 
       10'h195: data = 8'b00011000; 
       10'h196: data = 8'b00011000; 
       10'h197: data = 8'b00011000; 
       10'h198: data = 8'b00011000; 
       10'h199: data = 8'b00011000; 
       10'h19a: data = 8'b00011000; 
       10'h19b: data = 8'b00011000; 
       10'h19c: data = 8'b00011000; 
       10'h19d: data = 8'b00011000; 
       10'h19e: data = 8'b00011000; 
       10'h19f: data = 8'b00000000; 
       
       //code letter M
       10'h0a0: data = 8'b00000000; 
       10'h0a1: data = 8'b01100110;
       10'h0a2: data = 8'b01100110; 
       10'h0a3: data = 8'b01100110; 
       10'h0a4: data = 8'b01011010; 
       10'h0a5: data = 8'b01011010; 
       10'h0a6: data = 8'b01011010; 
       10'h0a7: data = 8'b01011010; 
       10'h0a8: data = 8'b01000010; 
       10'h0a9: data = 8'b01000010; 
       10'h0aa: data = 8'b01000010; 
       10'h0ab: data = 8'b01000010; 
       10'h0ac: data = 8'b01000010; 
       10'h0ad: data = 8'b01000010; 
       10'h0ae: data = 8'b01000010; 
       10'h0af: data = 8'b00000000;
   
       //code letter P
       10'h0b0: data = 8'b00000000; //11111111
       10'h0b1: data = 8'b01111110; //11111111
       10'h0b2: data = 8'b01111110; //11100011
       10'h0b3: data = 8'b01100110; //11100011
       10'h0b4: data = 8'b01100110; //11100011
       10'h0b5: data = 8'b01100110; //11100011
       10'h0b6: data = 8'b01100110; //11100011
       10'h0b7: data = 8'b01111110; //11111111
       10'h0b8: data = 8'b01100000; //11100000
       10'h0b9: data = 8'b01100000; //11100000
       10'h0ba: data = 8'b01100000; //11100000
       10'h0bb: data = 8'b01100000; //11100000
       10'h0bc: data = 8'b01100000; //11100000
       10'h0bd: data = 8'b01100000; //11100000
       10'h0be: data = 8'b01100000; //11100000
       10'h0bf: data = 8'b00000000; //11100000
   
       //code sig =
       10'h0c0: data = 8'b00000000; 
       10'h0c1: data = 8'b00000000; 
       10'h0c2: data = 8'b00000000; 
       10'h0c3: data = 8'b01111110; 
       10'h0c4: data = 8'b01111110; 
       10'h0c5: data = 8'b00000000; 
       10'h0c6: data = 8'b00000000; 
       10'h0c7: data = 8'b00000000; 
       10'h0c8: data = 8'b00000000; 
       10'h0c9: data = 8'b00000000; 
       10'h0ca: data = 8'b00000000; 
       10'h0cb: data = 8'b01111110; 
       10'h0cc: data = 8'b01111110; 
       10'h0cd: data = 8'b00000000; 
       10'h0ce: data = 8'b00000000; 
       10'h0cf: data = 8'b00000000; 
       
       //code sig :
       10'h0d0: data = 8'b00000000; 
       10'h0d1: data = 8'b00000000; 
       10'h0d2: data = 8'b00011000; 
       10'h0d3: data = 8'b00011000; 
       10'h0d4: data = 8'b00011000; 
       10'h0d5: data = 8'b00000000; 
       10'h0d6: data = 8'b00000000; 
       10'h0d7: data = 8'b00000000; 
       10'h0d8: data = 8'b00000000; 
       10'h0d9: data = 8'b00000000; 
       10'h0da: data = 8'b00000000; 
       10'h0db: data = 8'b00011000; 
       10'h0dc: data = 8'b00011000; 
       10'h0dd: data = 8'b00011000; 
       10'h0de: data = 8'b00000000; 
       10'h0df: data = 8'b00000000; 
       
       //code sig -
       10'h0e0: data = 8'b00000000;
       10'h0e1: data = 8'b00000000;
       10'h0e2: data = 8'b00000000; 
       10'h0e3: data = 8'b00000000; 
       10'h0e4: data = 8'b00000000; 
       10'h0e5: data = 8'b00000000; 
       10'h0e6: data = 8'b00000000; 
       10'h0e7: data = 8'b00111100; 
       10'h0e8: data = 8'b00111100; 
       10'h0e9: data = 8'b00000000; 
       10'h0ea: data = 8'b00000000; 
       10'h0eb: data = 8'b00000000; 
       10'h0ec: data = 8'b00000000; 
       10'h0ed: data = 8'b00000000; 
       10'h0ee: data = 8'b00000000; 
       10'h0ef: data = 8'b00000000; 
   
       //code sig 1
       10'h010: data = 8'b00000000;
       10'h011: data = 8'b00011000;
       10'h012: data = 8'b01111000; 
       10'h013: data = 8'b01111000; 
       10'h014: data = 8'b00011000; 
       10'h015: data = 8'b00011000; 
       10'h016: data = 8'b00011000; 
       10'h017: data = 8'b00011000; 
       10'h018: data = 8'b00011000; 
       10'h019: data = 8'b00011000; 
       10'h01a: data = 8'b00011000; 
       10'h01b: data = 8'b00011000; 
       10'h01c: data = 8'b00011000; 
       10'h01d: data = 8'b01111110; 
       10'h01e: data = 8'b01111110; 
       10'h01f: data = 8'b00000000; 
       
       //code sig 2
       10'h020: data = 8'b00000000;
       10'h021: data = 8'b01111110;
       10'h022: data = 8'b01111110; 
       10'h023: data = 8'b01111110; 
       10'h024: data = 8'b00001110; 
       10'h025: data = 8'b00001110; 
       10'h026: data = 8'b00001110; 
       10'h027: data = 8'b01111110; 
       10'h028: data = 8'b01111110; 
       10'h029: data = 8'b01110000; 
       10'h02a: data = 8'b01110000; 
       10'h02b: data = 8'b01110000; 
       10'h02c: data = 8'b01111110; 
       10'h02d: data = 8'b01111110; 
       10'h02e: data = 8'b01111110; 
       10'h02f: data = 8'b00000000; 
   
       //code sig 3
       10'h030: data = 8'b00000000;
       10'h031: data = 8'b01111110;
       10'h032: data = 8'b01111110; 
       10'h033: data = 8'b01111110; 
       10'h034: data = 8'b00001110; 
       10'h035: data = 8'b00001110; 
       10'h036: data = 8'b00001110; 
       10'h037: data = 8'b01111110; 
       10'h038: data = 8'b01111110; 
       10'h039: data = 8'b00001110; 
       10'h03a: data = 8'b00001110; 
       10'h03b: data = 8'b00001110; 
       10'h03c: data = 8'b01111110; 
       10'h03d: data = 8'b01111110; 
       10'h03e: data = 8'b01111110; 
       10'h03f: data = 8'b00000000; 
       
       //code sig 4
       10'h040: data = 8'b00000000;
       10'h041: data = 8'b01100110;
       10'h042: data = 8'b01100110; 
       10'h043: data = 8'b01100110; 
       10'h044: data = 8'b01100110; 
       10'h045: data = 8'b01100110; 
       10'h046: data = 8'b01100110; 
       10'h047: data = 8'b01111110; 
       10'h048: data = 8'b01111110; 
       10'h049: data = 8'b00000110; 
       10'h04a: data = 8'b00000110; 
       10'h04b: data = 8'b00000110; 
       10'h04c: data = 8'b00000110; 
       10'h04d: data = 8'b00000110; 
       10'h04e: data = 8'b00000110; 
       10'h04f: data = 8'b00000000; 
       
       //code sig 5
       10'h050: data = 8'b00000000;
       10'h051: data = 8'b01111110;
       10'h052: data = 8'b01111110; 
       10'h053: data = 8'b01111110; 
       10'h054: data = 8'b01100000; 
       10'h055: data = 8'b01100000; 
       10'h056: data = 8'b01111110; 
       10'h057: data = 8'b01111110; 
       10'h058: data = 8'b01111110; 
       10'h059: data = 8'b00000110; 
       10'h05a: data = 8'b00000110; 
       10'h05b: data = 8'b00000110; 
       10'h05c: data = 8'b01111110; 
       10'h05d: data = 8'b01111110; 
       10'h05e: data = 8'b01111110; 
       10'h05f: data = 8'b00000000; 
       
       //code sig 6
       10'h060: data = 8'b00000000;
       10'h061: data = 8'b01111110;
       10'h062: data = 8'b01111110; 
       10'h063: data = 8'b01111110; 
       10'h064: data = 8'b01100000; 
       10'h065: data = 8'b01100000; 
       10'h066: data = 8'b01111110; 
       10'h067: data = 8'b01111110; 
       10'h068: data = 8'b01111110; 
       10'h069: data = 8'b01100110; 
       10'h06a: data = 8'b01100110; 
       10'h06b: data = 8'b01100110; 
       10'h06c: data = 8'b01111110; 
       10'h06d: data = 8'b01111110; 
       10'h06e: data = 8'b01111110; 
       10'h06f: data = 8'b00000000; 
       
       //code sig 7
       10'h070: data = 8'b00000000;
       10'h071: data = 8'b01111110;
       10'h072: data = 8'b01111110; 
       10'h073: data = 8'b00000110; 
       10'h074: data = 8'b00000110; 
       10'h075: data = 8'b00001100; 
       10'h076: data = 8'b00001100; 
       10'h077: data = 8'b00011000; 
       10'h078: data = 8'b00011000; 
       10'h079: data = 8'b01111110; 
       10'h07a: data = 8'b00110000; 
       10'h07b: data = 8'b00110000; 
       10'h07c: data = 8'b01100000; 
       10'h07d: data = 8'b01100000; 
       10'h07e: data = 8'b01000000; 
       10'h07f: data = 8'b00000000; 
       
       //code sig 8
       10'h080: data = 8'b00000000;
       10'h081: data = 8'b01111110;
       10'h082: data = 8'b01111110; 
       10'h083: data = 8'b01111110; 
       10'h084: data = 8'b01100110; 
       10'h085: data = 8'b01100110; 
       10'h086: data = 8'b01111110; 
       10'h087: data = 8'b01111110; 
       10'h088: data = 8'b01111110; 
       10'h089: data = 8'b01100110; 
       10'h08a: data = 8'b01100110; 
       10'h08b: data = 8'b01100110; 
       10'h08c: data = 8'b01111110; 
       10'h08d: data = 8'b01111110; 
       10'h08e: data = 8'b01111110; 
       10'h08f: data = 8'b00000000; 
       
       //code sig 9
       10'h090: data = 8'b00000000;
       10'h091: data = 8'b01111110;
       10'h092: data = 8'b01111110; 
       10'h093: data = 8'b01111110; 
       10'h094: data = 8'b01100110; 
       10'h095: data = 8'b01100110; 
       10'h096: data = 8'b01111110; 
       10'h097: data = 8'b01111110; 
       10'h098: data = 8'b01111110; 
       10'h099: data = 8'b00000110; 
       10'h09a: data = 8'b00000110; 
       10'h09b: data = 8'b00000110; 
       10'h09c: data = 8'b01111110; 
       10'h09d: data = 8'b01111110; 
       10'h09e: data = 8'b01111110; 
       10'h09f: data = 8'b00000000; 
       
       //code sig 0
       10'h000: data = 8'b00000000;
       10'h001: data = 8'b00111100;
       10'h002: data = 8'b01100110; 
       10'h003: data = 8'b01100110; 
       10'h004: data = 8'b01100110; 
       10'h005: data = 8'b01100110; 
       10'h006: data = 8'b01100110; 
       10'h007: data = 8'b01100110; 
       10'h008: data = 8'b01100110; 
       10'h009: data = 8'b01100110; 
       10'h00a: data = 8'b01100110; 
       10'h00b: data = 8'b01100110; 
       10'h00c: data = 8'b01100110; 
       10'h00d: data = 8'b01100110; 
       10'h00e: data = 8'b00111100; 
       10'h00f: data = 8'b00000000; 
       
       //code D
        
       10'h100: data = 8'b00000000; 
       10'h101: data = 8'b01111000; 
       10'h102: data = 8'b01111110; 
       10'h103: data = 8'b01111110; 
       10'h104: data = 8'b01100110; 
       10'h105: data = 8'b01100110; 
       10'h106: data = 8'b01100110; 
       10'h107: data = 8'b01100110; 
       10'h108: data = 8'b01100110; 
       10'h109: data = 8'b01100110; 
       10'h10a: data = 8'b01100110; 
       10'h10b: data = 8'b01100110; 
       10'h10c: data = 8'b01111100; 
       10'h10d: data = 8'b01111100; 
       10'h10e: data = 8'b01111000; 
       10'h10f: data = 8'b00000000; 
       
       //code boton       
        10'h200: data = 8'b00000000;
        10'h201: data = 8'b00111100;
        10'h202: data = 8'b00111100; 
        10'h203: data = 8'b00111100; 
        10'h204: data = 8'b00111100; 
        10'h205: data = 8'b01111110; 
        10'h206: data = 8'b01111110; 
        10'h207: data = 8'b01111110; 
        10'h208: data = 8'b01111110; 
        10'h209: data = 8'b00111100; 
        10'h20a: data = 8'b00111100; 
        10'h20b: data = 8'b00111100; 
        10'h20c: data = 8'b00111100; 
        10'h20d: data = 8'b00111100; 
        10'h20e: data = 8'b00000000; 
        10'h20f: data = 8'b00000000;

      //code flecha arriba
       10'h210: data = 8'b00000000;
       10'h211: data = 8'b00011000;
       10'h212: data = 8'b00011000; 
       10'h213: data = 8'b00111100; 
       10'h214: data = 8'b00111100; 
       10'h215: data = 8'b01111110; 
       10'h216: data = 8'b01111110; 
       10'h217: data = 8'b00011000; 
       10'h218: data = 8'b00011000; 
       10'h219: data = 8'b00011000; 
       10'h21a: data = 8'b00011000; 
       10'h21b: data = 8'b00011000; 
       10'h21c: data = 8'b00011000; 
       10'h21d: data = 8'b00011000; 
       10'h21e: data = 8'b00011000; 
       10'h21f: data = 8'b00000000; 

        //code flecha abajo
       10'h220: data = 8'b00000000;
       10'h221: data = 8'b00011000;
       10'h222: data = 8'b00011000; 
       10'h223: data = 8'b00011000; 
       10'h224: data = 8'b00011000; 
       10'h225: data = 8'b00011000; 
       10'h226: data = 8'b00011000; 
       10'h227: data = 8'b00011000; 
       10'h228: data = 8'b00011000; 
       10'h229: data = 8'b01111110; 
       10'h22a: data = 8'b01111110; 
       10'h22b: data = 8'b00111100; 
       10'h22c: data = 8'b00111100; 
       10'h22d: data = 8'b00011000; 
       10'h22e: data = 8'b00011000; 
       10'h22f: data = 8'b00000000; 

        //code luz ring
       10'h230: data = 8'b00000000;
       10'h231: data = 8'b00000000;
       10'h232: data = 8'b00000000; 
       10'h233: data = 8'b00000000; 
       10'h234: data = 8'b00000000; 
       10'h235: data = 8'b00011000; 
       10'h236: data = 8'b00111100; 
       10'h237: data = 8'b01111110; 
       10'h238: data = 8'b01111110; 
       10'h239: data = 8'b01111110; 
       10'h23a: data = 8'b01111110; 
       10'h23b: data = 8'b00111100; 
       10'h23c: data = 8'b00011000; 
       10'h23d: data = 8'b00000000; 
       10'h23e: data = 8'b00000000; 
       10'h23f: data = 8'b00000000;        



    
    default : data = 8'b00000000;
endcase 

endmodule