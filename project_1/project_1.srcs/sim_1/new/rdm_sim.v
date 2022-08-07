module rdm_sim();
reg clk=0;
reg rst_n=1;
wire [4:0]data;
random_gen rg(clk,rst_n,data);

initial
begin
#5 rst_n=0;
#5 rst_n=1;
#200 $finish;
end

always #1 clk=~clk;

endmodule