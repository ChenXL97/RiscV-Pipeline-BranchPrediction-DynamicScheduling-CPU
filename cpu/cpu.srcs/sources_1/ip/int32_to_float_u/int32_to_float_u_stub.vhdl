-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
-- Date        : Tue Jul  7 15:49:38 2020
-- Host        : 9B08 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               z:/Documents/GitHub/RiscV-Pipeline-BranchPrediction-DynamicScheduling-CPU/cpu/cpu.srcs/sources_1/ip/int32_to_float_u/int32_to_float_u_stub.vhdl
-- Design      : int32_to_float_u
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku115-flvd1517-1L-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity int32_to_float_u is
  Port ( 
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_axis_a_tvalid : in STD_LOGIC;
    s_axis_a_tready : out STD_LOGIC;
    s_axis_a_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_result_tvalid : out STD_LOGIC;
    m_axis_result_tready : in STD_LOGIC;
    m_axis_result_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end int32_to_float_u;

architecture stub of int32_to_float_u is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,aclken,s_axis_a_tvalid,s_axis_a_tready,s_axis_a_tdata[31:0],m_axis_result_tvalid,m_axis_result_tready,m_axis_result_tdata[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "floating_point_v7_1_6,Vivado 2018.1";
begin
end;
