// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Tue Jul  7 15:49:38 2020
// Host        : 9B08 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               z:/Documents/GitHub/RiscV-Pipeline-BranchPrediction-DynamicScheduling-CPU/cpu/cpu.srcs/sources_1/ip/int32_to_float_u/int32_to_float_u_stub.v
// Design      : int32_to_float_u
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku115-flvd1517-1L-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *)
module int32_to_float_u(aclk, aclken, s_axis_a_tvalid, s_axis_a_tready, 
  s_axis_a_tdata, m_axis_result_tvalid, m_axis_result_tready, m_axis_result_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,aclken,s_axis_a_tvalid,s_axis_a_tready,s_axis_a_tdata[31:0],m_axis_result_tvalid,m_axis_result_tready,m_axis_result_tdata[31:0]" */;
  input aclk;
  input aclken;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [31:0]s_axis_a_tdata;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [31:0]m_axis_result_tdata;
endmodule
