module is_tube(clk,x_tube,y_tube,x,y,tubeflag,sc_h,sc_w);
input clk;
input [10:0]x_tube;
input [10:0]y_tube;
input [10:0]x,y;
input [10:0]sc_h,sc_w;
output reg tubeflag;
parameter tubewidth=6'd60;
parameter gap=9'd250;

always@(posedge clk)
begin
    if(x<=x_tube&&(x+tubewidth)>x_tube&&x<=sc_w&&(y<y_tube||(y>(y_tube+gap)&&y<sc_h)))
    begin
        tubeflag=1;
    end
    else
    begin
        tubeflag=0;
    end
end

endmodule