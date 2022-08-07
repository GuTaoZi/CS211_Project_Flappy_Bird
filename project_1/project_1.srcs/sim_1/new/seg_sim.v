module seg_sim();
reg clk=0;
reg[9:0] score,hi;
wire[7:0] cho,lseg,rseg;
segment sg(clk,score,hi,cho,lseg,rseg);

initial
begin
score=114;
hi=514;
#1000 $finish;
end

always #1
begin
clk=~clk;
score=score+5;
end


endmodule