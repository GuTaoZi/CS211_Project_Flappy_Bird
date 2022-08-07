module is_bird(clk,sc_h,x,y,y_bird,birdflag);
input [10:0]sc_h;//screen height
input [10:0]x,y;//pos
input [10:0]y_bird;
input clk;
output reg birdflag;

always@(posedge clk)
begin
    if(x>100&&x<=160&&y>=(y_bird)&&y<=(y_bird+50)&&y>=0&&y<=sc_h)
    begin
        birdflag=1;
    end
    else
    begin
        birdflag=0;
    end
end


endmodule