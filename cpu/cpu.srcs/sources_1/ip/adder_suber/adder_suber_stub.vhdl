-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
-- Date        : Mon Jul  6 20:30:35 2020
-- Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/Administrator/Desktop/RV-052BG/RiscV-Pipeline-BranchPrediction-DynamicScheduling-CPU/cpu/cpu.srcs/sources_1/ip/adder_suber/adder_suber_stub.vhdl
-- Design      : adder_suber
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku115-flvd1517-1L-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_suber is
  Port ( 
    A : in STD_LOGIC_VECTOR ( 31 downto 0 );
    B : in STD_LOGIC_VECTOR ( 31 downto 0 );
    CLK : in STD_LOGIC;
    ADD : in STD_LOGIC;
    CE : in STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end adder_suber;

architecture stub of adder_suber is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "A[31:0],B[31:0],CLK,ADD,CE,S[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "c_addsub_v12_0_12,Vivado 2018.1";
begin
end;
