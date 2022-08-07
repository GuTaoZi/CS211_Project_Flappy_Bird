module bird_pos(clk,clk_div,sw,restart,flap,y0,y,sc_h);
input clk,restart,flap,clk_div;
input [2:0]sw;
input [10:0]y0;
input [10:0]sc_h;//height of the screen
output reg [10:0]y;
reg up=0;
reg [15:0] v=0;
reg [15:0] float_y;
parameter v0=16'd300;
parameter g=10'd20;

always @(posedge clk_div)
begin
    if(restart)
    begin
        y=sc_h/2-25;
        float_y=y<<6;
        up=0;
        v=0;
    end
    else if(sw==3'b000)
    begin
        y=y0;
    end
    else
    begin
        if(up)
        begin
            if(float_y>v)
            begin
                float_y=float_y-v;
            end
            else
            begin
                float_y=0;
            end
            if(~flap)
            begin
                if(v>g)
                begin
                    v=v-g;
                end
                else
                begin
                    v=g-v;
                    up=0;
                end
            end
        end
        else
        begin
            float_y=float_y+v;
            if(float_y[15:6]<=sc_h-50)
            begin
                //do nothing
            end
            else
            begin
                //gameover
            end
            v=v+g;
            if(flap)
            begin
                up=1;
                v=v0;
            end
        end
    y=float_y[15:6];
    end
end

endmodule