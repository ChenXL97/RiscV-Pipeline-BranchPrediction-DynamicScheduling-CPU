// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jul  6 20:30:34 2020
// Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top adder_suber -prefix
//               adder_suber_ adder_suber_sim_netlist.v
// Design      : adder_suber
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku115-flvd1517-1L-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "adder_suber,c_addsub_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_12,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module adder_suber
   (A,
    B,
    CLK,
    ADD,
    CE,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 add_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME add_intf, LAYERED_METADATA undef" *) input ADD;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 s_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME s_intf, LAYERED_METADATA undef" *) output [31:0]S;

  wire [31:0]A;
  wire ADD;
  wire [31:0]B;
  wire CE;
  wire CLK;
  wire [31:0]S;
  wire NLW_U0_C_OUT_UNCONNECTED;

  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintexu" *) 
  (* c_a_type = "0" *) 
  (* c_a_width = "32" *) 
  (* c_add_mode = "2" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_value = "00000000000000000000000000000000" *) 
  (* c_b_width = "32" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "32" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  adder_suber_c_addsub_v12_0_12 U0
       (.A(A),
        .ADD(ADD),
        .B(B),
        .BYPASS(1'b0),
        .CE(CE),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_U0_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADD_MODE = "2" *) (* C_AINIT_VAL = "0" *) (* C_A_TYPE = "0" *) 
(* C_A_WIDTH = "32" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "0" *) (* C_B_VALUE = "00000000000000000000000000000000" *) 
(* C_B_WIDTH = "32" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) 
(* C_OUT_WIDTH = "32" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "kintexu" *) (* downgradeipidentifiedwarnings = "yes" *) 
module adder_suber_c_addsub_v12_0_12
   (A,
    B,
    CLK,
    ADD,
    C_IN,
    CE,
    BYPASS,
    SCLR,
    SSET,
    SINIT,
    C_OUT,
    S);
  input [31:0]A;
  input [31:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output C_OUT;
  output [31:0]S;

  wire \<const0> ;
  wire [31:0]A;
  wire ADD;
  wire [31:0]B;
  wire CE;
  wire CLK;
  wire [31:0]S;
  wire NLW_xst_addsub_C_OUT_UNCONNECTED;

  assign C_OUT = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintexu" *) 
  (* c_a_type = "0" *) 
  (* c_a_width = "32" *) 
  (* c_add_mode = "2" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_value = "00000000000000000000000000000000" *) 
  (* c_b_width = "32" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "32" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  adder_suber_c_addsub_v12_0_12_viv xst_addsub
       (.A(A),
        .ADD(ADD),
        .B(B),
        .BYPASS(1'b0),
        .CE(CE),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_xst_addsub_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
HXV4h5+M0Gyv7vvpLcg9doICq0dE9GVjJBO+hNdPTJvgX0VGA4ugqBKlkEqGuOyKztRGzLB27s8X
6i5leC2InQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
dAxa0GFtAgoazxeRmxSl0Yps/nJ8Rpb3lCs3dkGXEdmxjp4N5EFfyS7U0FLTPNVV4xnePCr4q647
L4KcUzdGFlWPqo/QF8lyz6PEdU6dW8BktZKhrZHQ5uhG7d/Bf0EOVUn0mzfj8sgbaKWZYTEDERK6
pLNcwS3fMTcRzexShzE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qFA2Sas20o42qyLKUfSMJZGJ7FMOuYDRWyURzBBH3n2Qkaa75HLaliBCTs00LUZYplObnmj1+ZAf
80sKN7qGXguQ1PwKDYYHAVh9l9yGVlyNwObLOec7nrtHIPRPZ1Am330sVZYMipFnG9PAZanD2fe4
zBKk26jw4HdRQmG3vM1SWF3vXt1VR+UBS5eMUwG6haQqtGIZWHz48uyl4zc44Tqr2H4sR+yo0gE9
bXUY7Oc0GQvnczTzBftbc9jGOvnoi8sVcybTki5B/gTVWkBqcYl+Bx+SSOCo+FyQZGBqrUAFnf1m
pKFCRJnXqs4g3cmrmEG2RflwrWfJCOs3QdUjPQ==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
EHIPCw3tqvASBeRc846RSvWMIU/QBgZYfNTkmzG9OlWqwIA3ukwCJx+dEAZCMyg/i7GW815EkwKE
ar/FOnRiTLMQpurIVTi3As1Sl6c1DkXq90HBljZSq18EFjvlH8nsGa0654mVCFQN3PiQfUfggiqD
LwP079R222U916zaDIMw6ZgRcbfM7bBAp73emqe6OC5mrt4mMGZ9AbQkGRU4iJeWX5x5zM0ev20/
2HCVT3rThYEK/hMu/29O6ZYpOwhKqVFUV8jaodAIgDRiYY0qd/CTZK9mvOgSUj0t6cJN4/Q/wVKt
mcOTr4F5A5rnCTva3pM2/SBekXOwQb01/rlfUQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L4GJr0S0dl+C4k+rj1r/KaqPKn7XGNysYQlDBTRHxj0Zgto0TejuU3cSjQJkMo/IlhkL5vx3hSMx
8DXh0KGY4W7Mmk5SffBJgti7D1pd1YP3w0zgDKIAkTLpoXaZECn77Jp9JWvdxrSHUb44QeC0VkRr
TT67tMIjtV+eqkCUfUiCSGq39iRyI7EpdVInAevmPCNIG5K4rHLTX0aJWAbgDwBRaTpw7W4wOBUe
Kag07iTsJYfG9TBJdRao3h4g2IyFjrcf4tdYFjQEIGB4Vfxhy6K9JjnkkfxGJQ4A0VrJVKlHsJFv
1+MmwN5+h/oRYCFJgcCtGfttJc2/AOQ8JKB8cw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
gW6aOcJbrDMK7JqUnzFxAaYM2DL8EnxF345IOLkdfKxGnLCsw0mROpfP26LD91CJidCf9vaqLHsN
jwsLktZ7qUykkQzv9vOvGkB2KoLh32fPvZjhbcdDei3fy9cH8haCHJCiSghwIIOfzcXDyQO7+mpH
LfBUho9v0PmfLkeqSuE=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YOgS+O+OWj8gVxfmdd2e+iTOOA4l1LloRJHtygw6wsU5a/FGoLxtLFOm39pCwOesAIo5cgP1cY7j
GMsvnPuTgP6YVNEPrLenO+0bM+rFgEpkVPDLGiQdrj+9tlcVifFJGGcDEFMtdjPm7SvdpsEh2Fzk
ZyTciJbc1vOSbmNUfL7f5SyT4X8NVQCnr4aIhzmrObrl+d/HXH5pWY0/wveklgGbBxwN3pI0aNdn
cY/a3XotdDTVTgdYnz9zaxscNhKuVHf6BpyCfI+XDdopSBDa7E47+Tot6Ck17VwjOOAKkqSNjD7+
HzzA77lmBhIrUxZnuOejS1O/VD/gmpze9ZPaeA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
pr8B+kM+iPIGlKCf8Vggu+aGKar44+oM0mB707LUlLheiMEUdhUYFvqRe1qDtklLng2mF/va4gdR
eU3DNaChQJzxBS/XWajkTpcQ6iU029ZDqXXGLm3kpq1svhP5kvSbUEe+uN1WyNY/gGngnPik5ZZt
tET4NfkC703ZxR+HJLXrvyUsNMknUYEnUyyqHhyeYS3qpClkTuP1D5xsfe4/7r0Lm6RLtdK2GtRU
ATaSetnPOGoknZeW1TvmKfpRvvvw3boqwEqywGKfpBa896kbh9RAwvOVJZ2YDdpIPGqEDOFowb7L
01+yPVrZFOwjb4Rk4Xim5UZtLl5xbTVtCkM3XQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
u/HQHOIcXUufsJoEQ7WdyDR8Hs4LFNzBsjG9oawqJb53Q2SZzX603ENnTF/qdpw9MYNwcVsKFQK0
d/w/k3i+b+i3QwFSgYgh0J2MAE7cGhk0UkZrOigdYTNNzUvj2ErAmssdQogAOGGTsUC1Z58FzpYA
ocgiG0x11XJC83w1bc8mULQVugHYBEVpfU/i6UdhVNVj77okiLfWPaVH6Am/ja253RQIUJvOVvqH
aNp1tQB3VGw5igS153fqa5yj5QckO6UI7LEV8xjvqmBtrhTi3kLsRbF9cPdSzZ7O5ZjVbMld3Ws1
UtjDEr/uOfsc67stSX9/JYEoMC6SIHl1t0FEow==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 23440)
`pragma protect data_block
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
DmMbceO9SZlkh34/mYhfGsD3BDI5sq1gJ48=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
