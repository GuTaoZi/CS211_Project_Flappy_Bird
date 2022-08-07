`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/29 20:26:22
// Design Name: 
// Module Name: velocity_ctrl
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


module velocity_ctrl(clk,x_tube,interval,sw,velocity,x_next);
input clk;
input [9:0]x_tube;
input [8:0]interval;
input [2:0]sw;
output reg[8:0]velocity;
output reg[9:0]x_next;

always@(*)
begin
    case(sw)
        2'b000:velocity=0;
        2'b001:velocity=1;
        2'b010:velocity=2;
        default:velocity=10;
    endcase
end

always@(posedge clk)
begin
    if(x_tube>velocity)
    begin
        x_next=x_tube-velocity;
    end
    else
    begin
        x_next=x_tube+interval-velocity;
    end
end

endmodule
