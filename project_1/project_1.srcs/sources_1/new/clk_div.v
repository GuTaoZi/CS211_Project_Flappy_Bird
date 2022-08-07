`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/30 09:46:08
// Design Name: 
// Module Name: clk_div
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


module clk_div(clk,trigger,clk_);
input clk,trigger;
output reg clk_=0;
reg [23:0] t=0;
parameter div=24'd2000000;
always @(posedge clk)
begin
    if(trigger)
    begin
        t=t+1;
        if(t%div==0)
        begin
            clk_=1;
            t=0;
        end
        else
            clk_=0;
    end
    else
    begin
        t=0;
        clk_=0;
    end
end
endmodule
