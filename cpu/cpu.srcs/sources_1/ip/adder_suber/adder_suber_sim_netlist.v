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
itxg+MZLF/3ziE6Yhk91IFjlwxlU9mXh+7Q=
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
