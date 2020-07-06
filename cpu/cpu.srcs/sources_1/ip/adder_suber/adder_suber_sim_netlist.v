// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jul  6 20:30:35 2020
// Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/Administrator/Desktop/RV-052BG/RiscV-Pipeline-BranchPrediction-DynamicScheduling-CPU/cpu/cpu.srcs/sources_1/ip/adder_suber/adder_suber_sim_netlist.v
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "kintexu" *) (* ORIG_REF_NAME = "c_addsub_v12_0_12" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
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
JdRK8YmmwK4aprTL3MmiY008dGbl82FjSzycRCSPZAnB+2h4lIA6fOPBHyfeXBoWcEoNhgExC6SI
H4PTGJQL9bOVnJaWs8fpE5+AFvrmycHHn3gpP3Wr36xkTx6KU1WAe9rdCxIH4OAEjXXhEnYalTip
x+OcIa+XKvM4wMLiGr8LdYI/gld+/eKLiWkNGmUK6r+JapnBEJjdfs1Ro8847r5GFGIXiDncTPh0
s6D8oq6WuyzS1J4Epm9irXSX4KQNMFKs5MVGL7pOZw9HqrYnx1DhUy6JSgg1uuqoCv1X9tOcqDci
E2T94RSkG6Qcd5TWVGcNbaIBohzzlQEIo5kqWA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wxuABNQGQoQZaWQJYQwICwMuvbxcwFWlPiCB3ATkjw2li26IOMaaoKilPkq4biIJB2dpMwcqOKNa
Na2YUHFFG4mVo9u6dF1TK7R1IaVWOXreJ7ie1ukVgyhvGy81O3YtVCZVq45T9fUpxxF07lyz2bcW
AB7OVh6d70J1WT+PEoa+7qN0QIzsN3wwtjL0cYu4yBeMtpTK7F2WPZiO9xlLCoKnRl+xyjyQkhug
9uN8UNzLMT/hoQL9sHAzExU/l/blR8OkO/Rq+xTWvdlBzwFOLX+cA0incISGzRTpmYLihFSNiUPk
RiITLqIdQX/ShVsKPeLEmKan0UkfZmEh+gLNOg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 23424)
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
