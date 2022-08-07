// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Fri Jul 29 20:15:17 2022
// Host        : FIRST-MICROSOFT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/Lab_DL/Flappy_Bird_demo/project_1/project_1.srcs/sources_1/ip/BG_png/BG_png_stub.v
// Design      : BG_png
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module BG_png(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[14:0],douta[15:0]" */;
  input clka;
  input [14:0]addra;
  output [15:0]douta;
endmodule
