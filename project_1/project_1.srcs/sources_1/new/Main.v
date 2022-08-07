`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/29 20:26:49
// Design Name: 
// Module Name: Main
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


module Main(clk,rst,R,G,B,hsync,vsync,sw,reso,restart,flap,cheatmode,cheatled,overled,cho,lseg,rseg,stateled);

reg[10:0] C_H_SYNC_PULSE=11'd96;
reg[10:0] C_H_BACK_PORCH=11'd48;
reg[10:0] C_H_ACTIVE_TIME=11'd640;
reg[10:0] C_H_FRONT_PORCH=11'd16;
reg[10:0] C_H_LINE_PERIOD=11'd800;
reg[10:0] C_V_SYNC_PULSE=11'd2;
reg[10:0] C_V_BACK_PORCH=11'd33;
reg[10:0] C_V_ACTIVE_TIME=11'd480;
reg[10:0] C_V_FRONT_PORCH=11'd10;
reg[10:0] C_V_FRAME_PERIOD=11'd525;

input clk,rst;
input [2:0]sw;
input restart;
input flap;
input cheatmode;
output cheatled;
output overled;
output [7:0]lseg,rseg,cho;
reg [8:0]velocity;
wire [11:0] Color;
reg [10:0]sc_w=11'd640;
reg [10:0]sc_h=11'd480;
reg [10:0]x_tube=10'd860;
reg [8:0]interval=9'd180;
reg [10:0]y_tube0=10'd100;
reg [10:0]y_tube1=10'd60;
reg [10:0]y_tube2=10'd80;
reg [10:0]y_tube3=10'd150;

reg [10:0]ybird_now=215;
wire [10:0]y_bird;
wire gameover;


wire clk_v;
clk_div cd(clk,1'b1,clk_v);


output reg [3:0] R;
output reg [3:0] G;
output reg [3:0] B;
output hsync,vsync;

wire vga_clk1,vga_clk2;
wire vga_clk;
clk_wiz_0 clk_inst(.clk_in1(clk),.clk_out1(vga_clk1),.clk_out2(vga_clk2));

//horizontal counter

output stateled;
assign stateled=reso;
input reso;

always @(*)
begin
    if(reso)
    begin
        C_H_SYNC_PULSE   <= (11'd128);
        C_H_BACK_PORCH   <= (11'd88);
        C_H_ACTIVE_TIME  <= (11'd800);        
        C_H_FRONT_PORCH  <= (11'd40);
        C_H_LINE_PERIOD  <= (11'd1056);
        C_V_SYNC_PULSE   <= (11'd4);  
        C_V_BACK_PORCH   <= (11'd23);
        C_V_ACTIVE_TIME  <= (11'd600);
        C_V_FRONT_PORCH  <= (11'd1);
        C_V_FRAME_PERIOD <= (11'd623);
    end
    else
    begin
        C_H_SYNC_PULSE<=11'd96;
        C_H_BACK_PORCH<=11'd48;
        C_H_ACTIVE_TIME<=11'd640;
        C_H_FRONT_PORCH<=11'd16;
        C_H_LINE_PERIOD<=11'd800;
        C_V_SYNC_PULSE<=11'd2;
        C_V_BACK_PORCH<=11'd33;
        C_V_ACTIVE_TIME<=11'd480;
        C_V_FRONT_PORCH<=11'd10;
        C_V_FRAME_PERIOD<=11'd525;
    end
    sc_w<=C_H_ACTIVE_TIME;
    sc_h<=C_V_ACTIVE_TIME;
end

assign vga_clk=reso?vga_clk2:vga_clk1;

always @(*)
begin
    if(~gameover)
    begin
        case(sw)
        3'b001:velocity=2;
        3'b010:velocity=5;
        3'b100:velocity=10;
        default:velocity=0;
        endcase
    end
    else
    begin
        velocity=0;
    end
end

wire [4:0]rnd;
parameter gap=250;
parameter tubewidth=6'd60;
random_gen rg(clk,rst,rnd);
reg [9:0] score=0;
reg [9:0] hi=0;

segment seg_uut(clk,score,hi,cho,lseg,rseg);

always @(posedge clk_v)
begin
    if(~gameover)
    begin
        ybird_now=y_bird;
        if(x_tube>velocity)
        begin
            x_tube=x_tube-velocity;
        end
        else
        begin
            score=score+1;
            hi=hi>score?hi:score;
            x_tube=x_tube+interval-velocity;
            y_tube0=y_tube1;
            y_tube1=y_tube2;
            y_tube2=y_tube3;
            y_tube3=rnd*(sc_h-gap)/32;
        end
    end
    else if(ybird_now+50<sc_h)
    begin
        ybird_now=ybird_now+8;
    end
    if(restart)
    begin
        score=0;
        x_tube=sc_w+tubewidth;
        ybird_now=sc_h/2-25;
    end
end

bird_pos bp(clk,clk_v,sw,restart,flap,ybird_now,y_bird,sc_h);

reg[10:0]hc;
always @(posedge vga_clk)
begin
    if(~rst)
        hc<=0;
    else if(hc==C_H_LINE_PERIOD-1)
        hc<=0;
    else
        hc<=hc+1;
end

//vertical counter
reg [10:0] vc;
always @(posedge vga_clk)
begin
    if(~rst)
        vc<=0;
    else if(vc==C_V_FRAME_PERIOD-1)
        vc<=0;
    else if(hc==C_H_LINE_PERIOD-1)
        vc<=vc+1;
    else
        vc<=vc;
end

wire active = (hc>= (C_H_SYNC_PULSE+C_H_BACK_PORCH))&&
(hc<(C_H_SYNC_PULSE+C_H_BACK_PORCH+C_H_ACTIVE_TIME))&&
(vc>=(C_V_SYNC_PULSE+C_V_BACK_PORCH))&&
(vc<(C_V_SYNC_PULSE+C_V_BACK_PORCH+C_V_ACTIVE_TIME)) ? 1 : 0;
                
wire[10:0] px=hc-C_H_SYNC_PULSE-C_H_BACK_PORCH;
wire[10:0] py=vc-C_V_SYNC_PULSE-C_V_BACK_PORCH;

display Display(cheatmode,restart,vga_clk,Color,interval,x_tube,y_tube0,y_tube1,y_tube2,y_tube3,px,py,ybird_now,sc_w,sc_h,gameover);

always @(*)
begin
    if(restart)
    begin
        {R,G,B}=0;
    end
    if(~rst)
    begin
        {R,G,B}=0;
    end
    else if(active)
    begin
        interval=sc_w/4;
        if(px>=0&&px<sc_w&&py>=0&&py<sc_h)
        begin
            {R,G,B}=Color;
        end
    end
    else {R,G,B}=12'h000;
end

assign hsync=(hc<C_H_SYNC_PULSE)?0:1;
assign vsync=(vc<C_V_SYNC_PULSE)?0:1;
assign cheatled=cheatmode;
assign overled=gameover;

endmodule