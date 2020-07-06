// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jul  6 20:30:34 2020
// Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ adder_suber_stub.v
// Design      : adder_suber
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku115-flvd1517-1L-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_addsub_v12_0_12,Vivado 2018.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(A, B, CLK, ADD, CE, S)
/* synthesis syn_black_box black_box_pad_pin="A[31:0],B[31:0],CLK,ADD,CE,S[31:0]" */;
  input [31:0]A;
  input [31:0]B;
  input CLK;
  input ADD;
  input CE;
  output [31:0]S;
endmodule
