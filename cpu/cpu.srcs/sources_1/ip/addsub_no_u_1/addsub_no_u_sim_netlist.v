// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jul  6 20:15:52 2020
// Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top addsub_no_u -prefix
//               addsub_no_u_ addsub_no_u_sim_netlist.v
// Design      : addsub_no_u
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku115-flvd1517-1L-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "addsub_no_u,c_addsub_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_12,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module addsub_no_u
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

  (* C_ADD_MODE = "2" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_CONSTANT = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "00000000000000000000000000000000" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_BYPASS = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_C_IN = "0" *) 
  (* C_HAS_C_OUT = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "1" *) 
  (* C_OUT_WIDTH = "32" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintexu" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  addsub_no_u_c_addsub_v12_0_12 U0
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
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "1" *) (* C_LATENCY = "1" *) 
(* C_OUT_WIDTH = "32" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "kintexu" *) (* downgradeipidentifiedwarnings = "yes" *) 
module addsub_no_u_c_addsub_v12_0_12
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
  (* C_ADD_MODE = "2" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_CONSTANT = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "00000000000000000000000000000000" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_BYPASS = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_C_IN = "0" *) 
  (* C_HAS_C_OUT = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "1" *) 
  (* C_OUT_WIDTH = "32" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintexu" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  addsub_no_u_c_addsub_v12_0_12_viv xst_addsub
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
ggO+TS4vP6djx2/oetF9lKxb167mf1H4GjHqMeeW1GzYSj3DYKpMCod/v5tKftHUEDe4CWoeEqeV
uGna5WZsneT9k71QJMfnlbIqWrCfbGQcLTqoBHEBzpigHZYt4LjkIukUg22/AzBicb4AjcGpLU/H
owpT/3icuSXyG8qMs5jPFZOfEWYlKcTeCSur1etXhtuL2EGufv2352aUaWPoa4L7fJCFVEiFml5B
sYai8AxocwgSz0msoemk2qhYlCJTq8hzvr2KYIhAsqcw3UO71AneWnMlwg0CCpXZ0fkg/oMdpBw4
WepipZ5T759Ak2q0Jgdo3jlRgV/qe21o5vINKg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F6BHAK2N1yovNVvpnDH1LA8SvR+aUhUK1yvYxhAwkvfA0WR//TCSgKMM/31Ob1rB5Ch9qQDe6Fvm
ZJ0/Tm0lqB0vj4T0aKU+GQRtqDcL6ZWroMoYHlQKvNrU2420Zl8/oyzFo2j7irAKBsngC2oeiHAj
rEUDe4SvAp4VT0L0fy06FEKnfwuQG/4acQ/zJhRdsi3GrZZ61KqtvhZVoXpGw/NWGMVh/FQGkDLj
jeL1UdusM8az9MuPJvaf2Dn2610cvfxGiBTgVEB5qXK060Iv67lZfXEDIXpcKGot5PFCsQFaGaC/
G1CZIFn3xw7i8ys5l1gwYod79Q+v0Oxhurnqbg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12736)
`pragma protect data_block
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
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
