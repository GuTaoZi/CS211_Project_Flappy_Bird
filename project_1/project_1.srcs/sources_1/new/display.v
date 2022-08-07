module display(cheatmode,restart,clk,Color,interval,x_tube,y_tube0,y_tube1,y_tube2,y_tube3,x,y,y_bird,sc_w,sc_h,gameover);
input clk,restart,cheatmode;
input [9:0]y_bird;
input [9:0]x,y;
input [10:0]sc_w,sc_h;
input [9:0]x_tube;
input [8:0]interval;
input [9:0]y_tube0;
input [9:0]y_tube1;
input [9:0]y_tube2;
input [9:0]y_tube3;
output reg [11:0]Color;
output reg gameover=0;
wire birdflag;
wire [3:0]tubeflag;
is_bird ib(clk,sc_h,x,y,y_bird,birdflag);
is_tube it0(clk,x_tube,y_tube0,x,y,tubeflag[0],sc_h,sc_w);
is_tube it1(clk,x_tube+interval,y_tube1,x,y,tubeflag[1],sc_h,sc_w);
is_tube it2(clk,x_tube+2*interval,y_tube2,x,y,tubeflag[2],sc_h,sc_w);
is_tube it3(clk,x_tube+3*interval,y_tube3,x,y,tubeflag[3],sc_h,sc_w);
reg [11:0]pos_bird;
reg [7:0]pos_tube_body;
reg [7:0]pos_tube_head;
reg [15:0]pos_bg;
wire [15:0]readColor0,readColor1,readColor2,readColor3;
Bird_png birdimg(.addra(pos_bird),.clka(clk),.douta(readColor0));
TubeBody_png tbimg(.addra(pos_tube_body),.clka(clk),.douta(readColor1));
TubeHead_png thimg(.addra(pos_tube_head),.clka(clk),.douta(readColor2));
BG_png bgimg(.addra(pos_bg),.clka(clk),.douta(readColor3));

parameter tubewidth=6'd60;
parameter gap=8'd150;
parameter groundlevel=9'd280;

always @(posedge clk)
begin
    if(restart)
    begin
        gameover=0;
    end
    if(birdflag)
    begin
        pos_bird=(y-y_bird)*60+x-101;
        if(readColor0[15:12]!=4'hf)
        begin
            if(tubeflag[0])
            begin
                pos_tube_head=x-(1+x_tube-tubewidth);
                Color=readColor2[11:0];
            end
            else if(tubeflag[1])
            begin
                pos_tube_head=x-(1+x_tube+interval-tubewidth);
                Color=readColor2[11:0];
            end
            else if(tubeflag[2])
            begin
                pos_tube_head=x-(1+x_tube+2*interval-tubewidth);
                Color=readColor2[11:0];
            end
            else if(tubeflag[3])
            begin
                pos_tube_head=x-(1+x_tube+3*interval-tubewidth);
                Color=readColor2[11:0];
            end
            else
            begin
                if(y<groundlevel) Color=12'h7cc;
                else if(y>=(groundlevel+180)) Color=12'hdd9;
                else
                begin
                    pos_bg=x%160+(y-groundlevel)*160;
                    Color=readColor3[11:0];
                end
            end
        end
        else
        begin
            Color=readColor0[11:0];
        end
        if((y_bird+50>=sc_h)||(tubeflag[0]&&x_tube<=300)||(tubeflag[1]&&x_tube+interval<=300))
        begin
        if(~cheatmode)
            gameover=1;
        end
    end
    else if(tubeflag[0])
    begin
        pos_tube_head=x-(1+x_tube-tubewidth);
        Color=readColor2[11:0];
    end
    else if(tubeflag[1])
    begin
        pos_tube_head=x-(1+x_tube+interval-tubewidth);
        Color=readColor2[11:0];
    end
    else if(tubeflag[2])
    begin
        pos_tube_head=x-(1+x_tube+2*interval-tubewidth);
        Color=readColor2[11:0];
    end
    else if(tubeflag[3])
    begin
        pos_tube_head=x-(1+x_tube+3*interval-tubewidth);
        Color=readColor2[11:0];
    end
    else
    begin
        if(y<groundlevel) Color=12'h7cc;
        else if(y>=(groundlevel+180)) Color=12'hdd9;
        else
        begin
            pos_bg=x%160+(y-groundlevel)*160;
            Color=readColor3[11:0];
        end
    end
end

endmodule