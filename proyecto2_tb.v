`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2017 15:42:43
// Design Name: 
// Module Name: proyecto1_tb
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


module proyecto1_tb;

    reg resettb; 
    reg clktb;
    reg [2:0] rgbswitchestb;
    wire video_ontb;
    wire [2:0] rgbtexttb;
    wire hsynctb, vsynctb;
    wire [9:0] pixel_xtb, pixel_ytb;
    wire [9:0] pixel_xtbb, pixel_ytbb;
   
        
    proyecto1 uut(
     
    .reset(resettb),
    .clk(clktb),
    .rgbswitches(rgbswitchestb),
    .rgbtext(rgbtexttb),
    .hsync(hsynctb),
    .vsync(vsynctb),
    .video_on(video_ontb),
    .pixel_x(pixel_xtb),
    .pixel_y(pixel_ytb),
    .pixel_xm(pixel_xtbb),
    .pixel_ym(pixel_ytbb)
    
    );
    
    always #5 clktb = ~clktb;
      integer i ;
      integer j ;
    
    initial
    begin
        clktb = 0;
        rgbswitchestb = 3'b110;
        #10 resettb = 1;
        #10 resettb = 0; 
    

  //archivo txt para observar los bits, simulando una pantalla
		    i = $fopen("joseVGA.txt","w");
		    for(j=0;j<383520;j=j+1) begin
		      #40
		      if(video_ontb) begin
		        $fwrite(i,"%h",rgbtexttb);
		      end
		      else if(pixel_xtb==641 )
		        $fwrite(i,"\n");
		    end
		    #16800000
		    $fclose(i);
		   // $stop;
		#100;
		
    end
    
endmodule
