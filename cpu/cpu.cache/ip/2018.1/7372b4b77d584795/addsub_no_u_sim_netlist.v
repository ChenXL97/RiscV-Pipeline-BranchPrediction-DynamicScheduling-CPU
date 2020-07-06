// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jul  6 20:15:52 2020
// Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ addsub_no_u_sim_netlist.v
// Design      : addsub_no_u
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku115-flvd1517-1L-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "addsub_no_u,c_addsub_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_12,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_addsub_v12_0_12 U0
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
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_addsub_v12_0_12
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_addsub_v12_0_12_viv xst_addsub
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
xPRsnubnnUbLVgYQF556qewUBIssu9c9Qw==
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
