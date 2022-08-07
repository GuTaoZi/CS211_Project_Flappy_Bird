`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/03 23:12:12
// Design Name: 
// Module Name: conv_sim
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


module conv_sim();
reg [9:0]num;
wire[7:0]seg1,seg2,seg3,seg4;
converter cvt(num,seg1,seg2,seg3,seg4);
initial
begin
num=0;
#1000 $finish;
end
always #1 num=num+1;
endmodule
