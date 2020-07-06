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
XhaFeF54xH4TFVghI20MCExHtDzzDaiZToE=
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
