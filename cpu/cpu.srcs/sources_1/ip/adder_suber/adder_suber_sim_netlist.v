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
DibrKwcTyYPUhmfGNmYvMZao/QiILMeapo4=
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
