module cd_sim();
reg clk=0;
wire clk_;
clk_div cd(clk,1'b1,clk_);
initial
begin
#1000 $finish;
end

always #1 clk=~clk;
endmodule