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
ZMLXXruzdW4KtYVEmE89FNPNV36KD3mhlgs=
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
