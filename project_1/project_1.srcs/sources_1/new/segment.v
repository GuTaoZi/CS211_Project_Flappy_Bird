`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/01 16:15:28
// Design Name: 
// Module Name: segment
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


module segment(clk,score,hi,cho,lseg,rseg);
input [9:0]score,hi;
input clk;
output reg[7:0]cho,lseg,rseg;

wire[7:0]seg1,seg2,seg3,seg4;
wire[7:0]seg5,seg6,seg7,seg8;
//8 7 6 5 4 3 2 1
//  hi    score

converter conv1(score,seg1,seg2,seg3,seg4);
converter conv2(hi,seg5,seg6,seg7,seg8);

reg [17:0]buffer=18'b000000000000000000;
always@(posedge clk)
begin
    buffer=buffer+1;
    case(buffer[17:16])
        2'b00:
        begin
            cho=8'b00010001;
            lseg=seg5;
            rseg=seg1;
        end
        2'b01:
        begin
            cho=8'b00100010;
            lseg=seg6;
            rseg=seg2;
        end
        2'b10:
        begin
            cho=8'b01000100;
            lseg=seg7;
            rseg=seg3;
        end
        2'b11:
        begin
            cho=8'b10001000;
            lseg=seg8;
            rseg=seg4;
        end
    endcase
end

endmodule
