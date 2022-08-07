`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/01 16:17:27
// Design Name: 
// Module Name: converter
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


module converter(num,seg1,seg2,seg3,seg4);
parameter _0 = 8'h3f;
parameter _1 = 8'h06;
parameter _2 = 8'h5b;
parameter _3 = 8'h4f;
parameter _4 = 8'h66;
parameter _5 = 8'h6d;
parameter _6 = 8'h7d;
parameter _7 = 8'h07;
parameter _8 = 8'h7f;
parameter _9 = 8'h6f;
parameter _E = 8'h79;
input [9:0]num;
output reg[7:0]seg1,seg2,seg3,seg4;

always @(*)
begin
    case(num%10)
        0:seg1=_0;
        1:seg1=_1;
        2:seg1=_2;
        3:seg1=_3;
        4:seg1=_4;
        5:seg1=_5;
        6:seg1=_6;
        7:seg1=_7;
        8:seg1=_8;
        9:seg1=_9;
    endcase
    case((num/10)%10)
        0:seg2=_0;
        1:seg2=_1;
        2:seg2=_2;
        3:seg2=_3;
        4:seg2=_4;
        5:seg2=_5;
        6:seg2=_6;
        7:seg2=_7;
        8:seg2=_8;
        9:seg2=_9;
    endcase
    case((num/100)%10)
        0:seg3=_0;
        1:seg3=_1;
        2:seg3=_2;
        3:seg3=_3;
        4:seg3=_4;
        5:seg3=_5;
        6:seg3=_6;
        7:seg3=_7;
        8:seg3=_8;
        9:seg3=_9;
    endcase
    case((num/1000)%10)
        0:seg4=_0;
        1:seg4=_1;
        2:seg4=_2;
        3:seg4=_3;
        4:seg4=_4;
        5:seg4=_5;
        6:seg4=_6;
        7:seg4=_7;
        8:seg4=_8;
        9:seg4=_9;
    endcase
end

endmodule
