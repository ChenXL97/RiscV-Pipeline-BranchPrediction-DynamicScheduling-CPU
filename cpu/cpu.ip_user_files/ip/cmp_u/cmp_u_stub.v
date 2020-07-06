// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jun 29 23:15:04 2020
// Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Administrator/Desktop/RV-052B/RISCV-Code/RV052B/RV052B.srcs/sources_1/ip/cmp_u/cmp_u_stub.v
// Design      : cmp_u
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku115-flva2104-3-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_addsub_v12_0_12,Vivado 2018.1" *)
module cmp_u(A, B, CLK, CE, S)
/* synthesis syn_black_box black_box_pad_pin="A[32:0],B[32:0],CLK,CE,S[32:0]" */;
  input [32:0]A;
  input [32:0]B;
  input CLK;
  input CE;
  output [32:0]S;
endmodule
