// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jul  6 20:30:34 2020
// Host        : DESKTOP-P4UPRAE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ adder_suber_sim_netlist.v
// Design      : adder_suber
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku115-flvd1517-1L-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "adder_suber,c_addsub_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_12,Vivado 2018.1" *) 
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
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) 
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
IYUdwUP5K6zbRjwQ+m0qX7yl9FPuYXJVDDMmLM2QKexUn/NYz2f/m9yTjKSE4m6wbfrVQ44mhPge
nyEdM10yAj4mklhqAYqvDbquKQ2VkLPL/FXEJu+QLrFSVUJ8qlPI67ep0HCFpuMQnd7FFHoRmmG0
YSnnogcz9S8ecwPaZwWGWv2reUbqKJERZQmAqJ9isPhrYLLMp2EvNmeKOL5NwgiKuO0Z7cOIPf7r
my1ixFfFnn8UoaBJUyJa7iED5FVXwUeAOLffk0VSyl/0gMClIbSLGTWqUR+iw1i5BaYgvnrj5Tay
i0Pz/O33EhlEiODTpj9K7BvCb/ogExSxE+4ETk1K6trmValbIvTKiGEDc4dMr2efUb89IoEWe01+
vcckoKDiU0OpiXpL/aSbqs7aSXWWXC+iHoEznQe96lB4Tfe8Jcju4lOglBGkV4UDBjMgJ80O61Be
pFvj/Ry8hs5F1Utxir84+BkTIMzdpERR6nCzZC/EqheyTxVB8Wv3ZIVYO4jJ8GFaf0s1CF5YD38S
l1SUySC4AFZhvaQasHhEZDigLf1qngzZKmhP18s6mouuV5kvBc98hq5Da8Md/Eli5lIWv9qNJTCB
CFRsEAhKcdhlaxublO0/9SZpFHu9GUJduvy6wKlNGrmEZDUAD/xWfi906sgDcj04XazQqM8A1Szw
5a2rzbnvQr2oowwtwQBtiH38GV1fCAoe9kKkBEgr3z0V4D/OdZtP15J8ROJE/tZj3mOmPgaOQIx2
DfgTcA8PRnA0KnbHmy/BcBnP1cyKUyyJKCF4qjnpMEkck7IhIjS/oUlhOepzKseZ0LNarsDv7J0q
qb9Hh3jHJ/Ch5ut3OZrrupbZtW9epaO/dKpQkd5f7t84PA+Qd10pwG826K7RWqD97+tcqpDPEVwK
Yk4xk5a5cWh+3Q3HBXsfdjuIFvOPpuav3bgkH0+cAMxDgaqNgucCgq3UkaYi+QvcrhRfBK7kPeZi
i4e6BNBl/iKCmZbUZLo9+guxzwlTsAb8f0Lcu3md0RYT/RDXDMWOxIXuMunOMD0qciA+NYoV5cdO
IpzOUEMrIOaozKNyFmCUtK+0Z9QU+F62MdQy7UPHIdyotGIoexbabSbh1Q8gYur93aLT0izKwsHO
DtmttAI9uUiE3FxRBMq9Qe/EIX1R6iY1xoZINkiMx8tVXLKAZwDWgCfu7mnBjKUvhKfgzVlChWR4
Y1w+sGRNTkJV5meS1kS0mF8n/RYsarMpZrTWDmaMy39f2/vce4+9IcANUyf+EBgcU6bVCl6gnyzP
RVbMcfTGssfVVMc/2QPzz8GOLqpHPxS7+vtoaUcuuFbzLDcL2/HB9oUItiuMezR94JtAOhxQgb+8
ELVdhCK/qfLv7PEoY4t9PSYkFUMUjqueLmoWok/AzzprgUOFaFLfxqKKDo2o/8D/EUsTvOEzSvbN
7TDFSJl1hcxyiGEAIzJftHseMtju/vY2zo9gvV5Hh+vQLVRRIBIRCdExPfJYR11eLhWpgMQhbCsR
ncp41js7AEw17N+kEHM+r91QwSyMR9FrIhwxZ2JyVWWbhE2tJdMISjYhvLiz6EHfWo+cuFruYmWk
dtq5oXbQLUTKTiZr9fQ4jDgfuZiE/iEN4pNcUeQCMc3XNW50swS1C8ZfMBJl2vlxCcOVfofvbn+m
vYWok7bnxIr97WghCSegfoJ/UTiRKTRRgKTfiyk38NvhBrtuEWKIhxSIsINusdcN+EhX5AQvCSyn
/V4vEDfWsmWiNUFivBJI1oYk+tf6skc6LwXRynoEDCy9kJiMZw7KIVQg0oRDHEoJwhJSeGHuK1xu
r4NoPvg/lP7CSedBe4KM360rRYA8XqyNwpqiazw9Jm9Cywii2+lVYPLJQMlsgcZ2VgY9K1fE9PcE
LdxmmAyJxrNOCrtC69fqSov5J0pXMn2Y2s1TmN/YiGTtUucknUQP3qtY0oYQxAMyGruK4QQ8AzyK
kCVSh7AvFWxsCnWgCBhMPa4A7YgSDod4CnJ54LMkOywMhibqnBwvPSDC/jTAnCqv1dljVAB716Ml
ioqSTexS6FD4E8YBp2ZZ8v2S+KQJ/bctTgZhABz6Z4abzgwUhNsSlsabMA6spZ1PYAPMO1pNfciX
0M4Mzweq6PSj/3e4pam0xOnvwTDfQlCHDyraI7miwJTzGiX+HjA6uJZaO5oaJUkk62Ul3tKI4yRs
lNslJDj0mFFPVOpNVXRMJbzGgqeJ6xmm9NNSoLOecqQxpFVxtmJIcKnjKh+maO7wurjhTDh2StyW
OS75O6t0Dropo0RqYLKzKXLy4LmN89zlM4FLs7zywE4vx0GuEcuKjaBfbFz0mp45XJpjIWMh1kta
j5SCGETkdjiFovgamNFjB5w5B75hJvWwKPF9UWvOGk8TqSfiTenBXOtiztCsuxz6DuEsr/7szI3Z
LNE4Mm0PCBNHrmwJHhUaj07W46JVs7np1NiwB5hkkuplLuH2uVUobi8xq4sg7n/KX1TO9DPhMKNw
4BT1+O2PQshkYygWuqnyO1h/v4LHzfIgtbAaEGe8KMw5Mjt4PFkzNssT2noPWYffDWB3/RIQO42q
Ly6kEQbE56Clk5uP0pl3uuenohNQLa3n8BeBLHguYdbV5JwwRls8z7W5z1vm5/JYtn2GaIrwfeWI
csT6ES0TC+oyj3JB/YGrMUYZruH8DDT667jTVz2iOISGWsn+0P3JMvf6q59d9wPADMvaKKu/cAxi
QFjYlJMEpn5fnehyuO7X0wVs7BrMinERjQAGsiiLnKK0xOPEF2JXOJxoJkG5RRArLA7dQBEtvK6y
nKe3qNrs9G/7UTjB7vDd/dzYpGuETLOAsHloYRZdnz4GFBzD8xjpYibw95lq9sF0eQZl525bfQvZ
nMCgRxba+hSdlQHxgCtokaiCewYhvKcQR6jYoYGKPWc/No2KS6GYReiPvRKdtylOCQF1VzwfxJ/D
nvFF6PwmlbFbT6WSEfE0PrvPFqU9onMFSblb35r27a6pJbRHk+uupo86JxiN91gGZMbUOSc6X+7Y
75NNdnEwKbV1YOMIM3pPLfZxfcytXANBugSuozGQILOVMcBm+UOQKO9Nan1U0YFbhstypeMMAjAX
+8dPRqIR0ZuDEElMCxwOgePBOfTuQqIwSePbty/8R8aUVSLdp4NPVxiQAT+ei60Z1wgOEsBDvrsI
7KuRvkc8kNrM2wRNmUhN46webveE0aJpdguAHy0eGUo3G8x0QZYuOOc/H99aGRYXxSFxKAkaf6+8
wT8tfX6WmzzzHqa4ZK/et0eClwTfR5ZF+X4BtWq8MuMz1fP2JVsIp51jRi/x/INapM8XuxR8PQR6
/ExBJZN3MsUjCiYLmxdocznntEGHvjyoIFB1Qv8U1K37GLuahNfNu6e7tB4+0BAZDqI757YkQf1y
TGf/he8iShv/0V+h43Thjgtj4rX+zXzJwLIjCEO3fEavAurumtDJGzCOhxxPpjw/U5fhXqXqwGht
iF/NfaV2RYyIneLaPMsQJpuGKlf6fgWlKTwupYvJMYVCTjxXywSD1ll7nCMK3OJP5De4L22Wb5DR
9DsDLQ32LhnPwMA2oHN96RkpZEan2CyZsUJaOsG6WfF5NUOQ1pCinOYb2Ukui9me9BnzLeWhAXuc
9VbJD0QiZy9H0hHlDK4z+1+HuT3F2P16QZIQpGdoROjn0hEhp/H7w0MSWCdJevq+kWZ8FcNH6VoC
o9u3qVQ8xmbxvFCCKWIIHxli4Ayce9QTtieB/imWSErk6BRug4YpjgzCQT9YzB4qa5VUNQkzL9Up
7vvhBgY3lGx+yzKW7+Wdqv86e92k9Oz45Ti5m4OxPukzrYcMJzDUhEvAy8Llo0pl8WWv7VOcy0wo
ceW3KqajXSSEq8HRueSlr1eVDTQOvoqAgIsjFZ+isvgYA9T3ejxtpmF4jjAuiKrCEoMcN7I08+Vu
Jno6c23EoR2QpBtDCyXvE8VnWTEPVcCz3fd2N7TUWX4Vce0VC959A9hqJLq4ngRc2CJpKudCPxQk
Mt50WXlvuzz/AGaOfGRV4r3T6bpcyLQXiaryR5tbGYC13qMpCi6wObd5JOkFntoIOR4D+usS/yTO
ZqqggmIeOa+JvIf3PAKPcKUTnU1G6rEXwSStLYngRWgzlSgpB9OdOsZ3nSxyhTIFw9ptGB/V2fTd
p+nHCW6CNLjclEyP6NLoyWVNjp2o/S2ECi/qSS+073VqBhV97RaQqNwTHwT64onnpkFKZKAdldhE
ub6CqvLspWfrPx6S5Q0C6ool53nXaxk7TQalTGcJsYIcyu+7NLwJRw50moZ//dgYAf2hR347sNcW
/YT2vaAzZvDd7e4jdifsGmjla4ljZSQHfhzSprAmr6dNYaVIyayCKXpo4ylDgcDLYTF/PzSZ7KLm
5PI0pL0R2y3mhu4rmk/QjFvCKxNFJTHzpspxP1A336NGiDQ3m05fi4yAbGcTre62LO7wmXVMyOBE
RyAYDabgeZEjsIAom0ZgbIZTohVhkmOCbQUJNJd3nJxy1yHWGPPFDUkJu5LZJVa/piOdanCPKpJz
CvTiVoHaAG7OcyoSBy5PgAuDBcDb53pSuJd9QcliWrZFLpP1rRI/jVp0GuanNPIWZ79/jGaRbqUb
V2YwR1WhYr+NxXVRjjD5zzJXnb7rdnrwD4iHPG7utMsYgKA7LZL6v4yz4CFRlqFx08XSpmJG2Hu1
3rQOEPZEDfM4HCss3LbxzJsySbErEypzTQWyTmWwqs/Q+bkudbG0Luiw6PeySLJqQEkIEb0avekI
NpsF3aVjhfe509jVaJQ6VBfVOsAdXUl4FmnGAThYxjtwVeMIpM6aM0mFd7OavlZaWk/YwytugNAF
tHAUmTY+FYlz9SIwqY/JKZWh0oRaVIEZCxRX67uKzMJZOi+DLWKHh/npt6PgTLjyxfQ+OnE6dolw
EHL1wL3mwVkyXZ8w+qc5O42xo1z4wnIX+ISCQ1l6sh97/nTKhwBD6ckSiA6B0guXAwmcklj1b0Ib
JoddY0AGjClIFMfJw5lvbvUYku3qQRwi/BXilPaoAZPph0+jWh5ycmmdHe2MRH+o52zcQsVggQZt
YzqNdHTqzMVUfAr2wL1ktZqEz8kI6j/0CjEKWSoKn+M0dS8WP3bYDC1YTDSJ/o7ASVTBpIXEUO1O
XlgpmIZDcVS6cL4qjy2j/ByECHIj0oHNbEy8ee7bcgkuaTe0ont4JQzrmCU6p++xbsmJkI5zAHWR
gAMzBpEV5GW6XOE7vYAiI0Hv1N9pmiDCXn0cKvSuABU/ZUwbUwut+bCH3y/rTbEMnphlZtI347gH
J7KWXi7o3JfyBqWWeC6YdRTvuZXIZNfiUkNg/SL1vTf67+BT5S3MP0Xkv2jWkwNxbLEpiFgghjTD
Alw7VxB9mRp7X4Vq/WHHAmgbYu1wqtRCjsZ9wBiU5FBd21Ms4efjrvl2T9RYl+3A3b0hYaTog6uI
ta4CGmYkT6U2RnTo/qdZ4Pnf1Be/v3ff6GI8S9lz8pKwJOfbR15bD/iZ4KMMJUgugj3f9vvA4vt4
D9/YKggV26S8SQKdFUfpbYeSTHsWf/gqe47EVcDu61f3hozFvSmXldhScWiJ2z9uI6pYNIUPy8rU
Q3dImICqWRVQnegBuspBVG4oA6vK2ZfOr+lmU+q6TVpLj0M/BkIFfpTpDXxpUOUthJiI4ryEArcW
ns57djVtVdwnwA52cVH29rE3fiVt4JYLJAKQOWWIpSqMPkai6AhomDT3WmUNH0aaX/UV+zZeV4Wv
SdUcxI6+a+2ktvVXA161m5i27Vvf1iCTM8IR89nkmRMv14ZguMHZzbI1TQPCbass/EQBRVGC3H2T
yObUmgUj6mxYGNXuc2/aMScdsupl9MiVw+JWsxYTU5CbcFTnVziKpnakW6+qTvUvP0PM+56+Nxr/
ht2nWxl9JtMah8CjCelwdopd/LqXoFDbv1Aat4UQkW/fWwHYX72tGCWv3pkGZmdj6LpRhLosh4jz
zHVy0BcFGWWJcKugP/8tP89VuFhqCNiqcLLh0fJRUTUPv8Ej+2hNkPbw53XENcYkdzakhgobCARx
jjL8yEe2bF9t5pruS4CLChvg0bnMsbQhuHZfFyR7/H66S2BYZd7xU0JQ2BeGWZOKQdRAlLL4l67O
cEfszFdduUnmA8Uxqj7Jn5NVbSTTkD3PKpFXSzKLQOb4jUZfuC4rmN059Pg1tw3/FO6l2DHz8Jm7
9Fq/J3cwGkCEGpXjkUtnrof7mBceY32si0c0llg4d+QNk878ETXoV0D6PMEGDWbyg/q//80JR2bO
WJVWGd1NuKia5fLpUHJj0d1XgTeccpJEM8n1Ay5Pmb/L+xqkCMavdRKYE22rfVff8TCVJ2vLUMIT
bfxE8vxCvPhfdyOye8fijtnBsQoj95cwrjeydSyS5ZEMdAL591YYMmcPFmx4dPXrkruFexC1Lw8v
t5OEoEU84bcFQrKmJ+iRbpAeoaK9aI0T/OUlgOyBU5YhoFaka/KdGhVcMy1GLjgnLevg1IN8ryqY
AdpoJMur+GESCY3vebQHE98U4wme2+dO8BQg0/eGBD4nBmzWjGfZvqEXzweM2SUCYLdRLiCCs76S
GHegCQU6Z+rtkqMiIPXNBNzoE3hHijEpxqogTHXipacnXviLIZq0l/aptqHE78GcMmxMQtn7dxqc
ZoJk0OLbXIU5JyNfUNeDeGXKtbs5v/tQmSQdQQj0fNYcairugMvbT9ygyqTvQ8G0sJrNT3iz5G3A
6tywncd6jeoi73ec+idVx6cUvzyHnEqBhyTTSB/phZwWPPirF5eMX7Ml9jsvbx7Z590pXhNiqEhe
Xvh13rdP93oGsscmWoaRcDJ74bAZ8GmfyhoY14KkNJ9DWbFBuBw3Bc4eW7z6d7oipnUMOI6/z9KB
Y1Ij+ZMzjz6Or8PGRKXDqHeO1MnKaP5D48QQyabXTnrXYVt/4PjrEi9QVd/xFodur54z5CY2eEOH
xLlXACUzu4cQAW9Nb/SEQDEMqFjaqSCIWanqp5DdQhGZYxoB4ryIONFeyy05Z6bBhNn3c2H+oSzO
CUjzKsbKg5ZaOdaIuMGfvgqqQocXGR8fGxltb6Ma4y7T2TTdQKTn9tLETXvu3wqB0r2iYKLYcS47
lSqqb0XKrmV532SzcjGXzkIOwyNrZchTSICkXcmOJ3sHJYFh/mKMWeRtiYVV4dcdAB+mdSDIx4mC
fEPxaJS1yavar7dEnQBHUm2YSD20W64WwbsFVxnuOI3V77wEM4NlsJE2DwcTjFif650n2orv+JgA
vlizITlHJZ6vURl8CdnSPS/qCF0Q2v4m5I4w/6kvYesVtBNnTRqjgkdh+MhSxxNdkLkvBVZbz68h
Bdj03EYQVlnJDy7dukSLn43k/0EiYxq7etn7hM+POyZ0NZKoGJvu8CHJhzN1zBdkHkqNphs7AAZO
Q+LzIJ35RB0Y2TyIjZsUwEb8QxO5YnjDODeD6cLPQysliQSkKwwMbbcdSGacwYMKItEknr2m1S3a
Lbz0nH563Mubb8EYmTPBzsQbt4Kl/oIq0/qWkEyiKfgSUQ8S5GsThhHeXuHO/UKB5PvYZ6K5AFUm
wpVteAtzGh2qzFGgBFBbMSroq0/4T0NOpLFrr1RpUsX6aC653MH9xWQ1mNyKfhlaNrt7ZoGxdjtB
30YTpuMFtFYqHZQpj/LxGG9op1Vsg+G0ibdlum1tUQacqwy46DnK6W2It9Yr1upr9rawQWzrC5a5
mbKm+HqysTbKxQQJ+tDANB2YSoGwV/89TLSW16hwkFSNJvjKMS3nPRpXuEgN6msQiSNNpL/kKQ6F
Yd5OowXoQgP0+N0WiG72MNl7yOBI8f5+vFmmKXzYgVZPjTdZycRiziwygRufSG+AVDHVbFojysbO
7hRFKP6sZyF9C+gn+h9JGU0Oqe4hge23q2A6Yp6w2eijcQBPg3TDNo/P+Nfbgg56mPxnsJdiQzSA
f/VsZI2bVbTQtYJsnjDeKHcV0rA8ZZigPInNWFRU5RG3iNqQu1b9EtsctqM354DnU3CGnVVhZNO7
BraVx3upbJkgcA189onUuZuI9HkOUd4HO7FQpyAUvvVcbjbbeQZx1uG/KWbkHNH0JyQSzsXmp9Kp
hzmxSFcndeZZoz9I6Tj7ILrKEPGLqKUblctJpe5SSbJAdge6O8mD/B1tHy6JZnOtSXsbHDIzqBXo
P3Ls4prU3g7bfYx3TD6v2ozvskoeSIjtN+Iz+6ScA/3qJIOmQtI/BDGnY2aCVbk+dB0PDcx6/GXj
aEeVuFPKkt2HZjiMzKGv0+miz2bhzRVxAYiivrQbnVL6H6P/ycnudIlkxAvj7RxLyoE09cSQjlO+
p+etFyhrnSraVweL4McTLkrNk5QZsD/C97e+h5Zz5GoG0lwV2B09US2E+v/b6Opxj6aBXa27AvJh
k+AyaDttVW7OeSt241uVezWblU3vCscRP5J1P2g63Aa/thHobjAgQw/wc2CUk8MI1VAdUtO6b1tO
txgbsFJs46Cwqsp9/hQWswvrnkMHCcLPZ0IlULbtyQ5d+PXHM7HDvQb4MRRl7zq9Knn9Cuo8D48Y
5y4yXuwufX1bTtSCcQrgaF1CeW1JAf7dBuxM1KZI7vCKYxj9nu8kxkSvU/Tx6ID5j9S1M97w4kGq
8sDfd1iKiwnMZ5e3w0x4kJGy68ixxBYP55YuaO8eluoZ99FCl8so/Y1Cm0Csv3TDRZurdwI74RW7
BJQPL3hN62FaCf5C0n1fjPEjQp5ZH0vvC97on/bpIf/vk06trEQqeniTFlHzw3knFNcYq6DcT+dE
9kljvF/xmfK8cuntLVs5Z8ph/iCDagaDirfD7RlFRntT23VYAUo76on/rvqrkRSOaK+nIhRA0Muj
zWccOWKRe8ZYlAI/XYF57+gImGd0uWkh79QHLJ1855GCKo/pR9L5prF6eTpKtsPDfi5Aq+kO08xj
IzzQwENcHjozDyVA/yUaI853Wb3vrgYRjJVRvjecjQCR4MU6rAsKHOZlt8l10yuxmULQg1nLQHqM
VlgnltvNZsc2Smue865CxvVAKWQPtcvjN/GcSqxhlLpmWq9SYoIl4K+zHgJxrKvII3Z5KVAvmpjv
Vzo3bnhjFFJBGnvFwF5ueHzOjT3MUuvFmhXgqOI/Wx1Naxkb6O/SWgNNL+ZtQfIdiPGZ2QgH2Zx6
FEGNcTe9KPxOxc4SmFq91mcai+rjEvvVxMgTzANCmTBj4qNvEJ7VAaFotKrmfH8aPLJQeMVSoXR2
TE3/8wHBpzonVeDIKklaZFciCN3hV7K3LRgO8Ut/A9npS/ZpE5KJ9n9lqvV07Q+UwwSOfwyKtKdF
YX3liL1wV+Pk9YoIV0KSf/jzFX/ZvtUv2DZmupDN1+bTS9FsnApGHH0/Z3162/YDgb5qmD12XhJe
TGVVbjWzwJEkTy0tVoe6/tYQfawvF/r7p/HrYZBbGFfQx7VB580amv+ziIik1Mp6HXHxyZU+HZMW
IApAo2iMIU1jmz3K7+PbLHDKTlH2whP5NaTDXjCbiDkOvF93j4AeMbU4vSwKYnzyeV7pWk8rFow9
mCUTCO3Ny4qEaLjkJo6FbkSNPjoT/e8PbbsFMKTrQgs49AHRkTHzaEAyLAreg2GisEqI8JSt1wQU
E2EjYCwzI3NgVEg25eUdkp8coWbboQLnE8Rzwkq9Gz0zJwpYqYYgsVI3Uc1xwVSXE2QA3FXzXQAG
AgsN+y7H1syrt7Y+z7MEHZFNalQu9lp1Mcn3AWWqW9UVfYG9z8v/bZg2NG4MMGy1EvoQ/LYGirz0
1EHE98sc5fNY8n/eC6nYcGlxjCgK0ThSucK91ZFNmoQLcPO3VmOwampzcH1hAmrlj4BfN9ss3IhT
9tfhX5NbNG1ZAaJF2yMln7Ws7lpDH1l34u8ewxpTPNmbelEJtikMnNTfG+on/HJpFsDhvB8Dm9RC
ZWAQ26fQPn2kZljC1W4rBBSoTiqWA2aqTJya2KE51gpsJyVTRVGkoUr7ldLB8fdBSQDxMDs7fS/q
89UdeEyY7tOKhn3jiAD+3/tGkqKtfap0VN/YILubk6GuoxusWcF0SfqiyKDhwdyPZuSFHJtpusGQ
6o5v8eMLg2517MmIjS+JfLWwhNmkuoinGIHURIDcM4rqwLLGf3vW2bgduXwIt7k2otVU8ben0USI
Djn/V9c+9mlAZYeQEvamgDqfL2fQDbGDnwT9WyfBJZVE8K6pws/aLEZCKhKRH/HgNBKWGyuLLzLE
LBwtBoDt3Le+FsgN02dKX9+LJVrhILdsOKXpJYpja6wBYBSx/m9aEfQ8w9j/vZnsKHFPB1h8eexY
WOJcqj3jA7XaWT14AuU9mOUDdtPLW0zxf4l/lzirMzHOGLn6GOAn8l4p4v9LJJkOjKt+40kze0k4
y6Ka8+qx2TkSspRR+t0DTGLKHDhW++K3+G1eNxzgg7pQ3ZLEojJPtQUufviQdalhBNnBfDv8xSXq
6WkHFv/J8js7R9u3Hj6W0Ayt4d4EAmB+BgSs3rVlY00ky0+IHqXtWL8KYt3kyyx+wGoYXyPgc+/p
NlO3uSgoSlH0ekWRRGN3+KstBqLH5STG8y6M0UsEpDxoOvezSxvBYMef1YnI7LGxsM0E7aOSeRyE
KbI8f+gP9WMo8KpGMV7X9zbaDdORUjkRTx3f4BbE9POT0GzxcZaZ5C6QfLvpmF3ewvsOInlzuF7h
4q6gbw18ZgLFaYCobAVaeZmyJdmaLvH74EAkgo4iJHsiquM2VeKNy1UtLCMsMvczcn0gyS5fIXm3
kZdAHfNtbBLgGy7uC5SaCKBVbqeVA6X0CuUi5B70lwx5CMp390iiNwdb8pZq7BuLPcsFUzTQMKI6
uyadznzZ8Eepkiqr8dQPiDPdzDiMHPG1/iNLmh0nmeUcbv5aRPR0l6EK121yyJe2kjsszQwA4L3B
PE3X4+KtQ3LN06aJJyG27DwIzJUvpCJrCaTfEiYjYvOM06FzBAmg9KRFkqLc1AGOVnsXX0dLGMZc
YgZwIv6zvwYEV3ZrkQfK6Cjk286FqEIff01DMh/SGIqRek9zv8i5IOaj/rbKf7CX+Rf49PiczEVP
cbYvYy/XxW7qtOdn40S2yB3UgKd1gvqjQLk0BIsx5BuhLW6fedrZRLLsenUSNVfO0Q/rHjvUjmWl
qr+lQaiP8vlU3NqlbAW3RHvf9EeaT5BTkszC4ZvsLvxJBjwz5UbZi68eY+rs9DpNehPCWsrG/jH5
o6EAkILwAIycrbBpQBy9QYYnfYspzHtXyGO5tsFUovxaSzvCgdKJs2FgSrjOSIJz3PYRAp2dNTZ7
KQ4+qWIjNULgvgFZKpeaVG6eJlGtaSyhSP2y46i0SJPivyztjbpM0XV/708S+LDWie/eKOr0BNgL
Ax3NZ+UdG62AVkPGVQCYEdNOaW9Pa1fT28rnelBgAgXEmY0fEAe87u65FsigVxXl7jbeLk38+Njw
o4F1TNxXqJzUraj+0tsNDWWYQJPAraCakIOkANp+6wLGLPW7D0+bA1Lo4MSshDnA9vdnK/dCvL8b
ogfx4YFbE0JPr0wsyVeGUQzoTjGmPHqKBMO4OjBsWfE/jlHIqRaqRqZSgxsNFH5u6TtOcVm1CcUj
EPlKdNe9JDIi53MLdmZe1in0vD+SLHgd/3xz5KdFgNAEcgyuAhlrVLySY0dWF/Pt+XIe2wwxvBJi
Ww3rM2uHECw0EgkiQx3YMkoQHjuwUB8T9IYa3PeWAd7JhhQ9RbTfIk1VmYTxnG72v7DSDtMcEiwO
JdTomwI/YCh3sOKeN/MlyLA9mF2zPHJXIUKeZ2DH2uFxoStCdn/fos68h5005WAZremUUwEdVYsQ
Un9oeaoOc0BCP3SIvlrE6mgdiGBGc9QDoikHBBcF1DVPqErs0SPcGv7PBuGd/WqEiYenKZ8OFJMD
eIjPAiw8y844VHCycmusb1CIK4QcX2nlWWvdK6cdlIJl/NDsIMaFGwMd9lTvoOTd9qfSQSquZHEQ
HV7Rg/lP4fN5GTixdkBj2Zo+og4ZmQUQZU+/7K2sQ0G8zzX5K4fEB1j2BLxdVGfEx2aIoyKoCoox
ta20gx498YkjJ/0FGl3kh4/d6BP4cmzH/dzqZ0qiPjH79iYzSO1KXE8DWeBsyV6q02UVurZ2yyqK
J2VRgeNx7EkcSddVFk94acKx3e4Yg3ZeAw112kB3VKrTzAbAy+6RJYHHpOenxAphtoWDluqm7xlW
UgaezCVWDcQx96jZ1mZZvTZZYQpZhgbt/LdlG4+FfDx7j+6xBe/KIkVcMrK/pO/D7MaiLgfq9Wnu
kV2N7J2GOFsijjn7rTJdJGYLeitUaNXSITC3USNhx/owduXDCKrzDziGsm3/mYnBG+oulGZECY8T
BteIFKaSB6tHBYpZZruWM0Tj/QDrK74OE3JzBCNV0UNtgG292TTXhJ3Wz2Y1BIwrW4HKIjAVnHwK
fG3V70PK+XjXkepmzcKyZ4jT4ySydczKTRJu1YXW1x4skLtIGSuFp7ke5ivOcE4diVdNnGnTfyIw
DZIONuUYTdrDSR/zcr73/pshmJczM+BSrXJ6grl7rYZaWmDCUE573bTGvsTZr4DIDO47vSxtU9L1
7/rU7R/1sCmYvmdnI6j3X1frEt1N4G5QlPJuNJsBuSHyvInBoNiMvixbdvh4WqT+wolFPmfCk97F
5C1OR5gRxlup3dxOsESqYPGC2VO8Ov2STVQh1D4KomATw1xmA+BM5jLtBaHPmY7jJrwN6tSYVfQm
REPZyw3DsGsdEStwdfXvBI+90CGU6F9y5yDyFkl0tGne+kThVKmugyFA4eFw9j7v8sGnsXLQZpbB
0vI7cKXgRQv5tUcxPy7IUqzeGlJCi4yB1NpCLkApTuSDIIt06GBv2pkrojLb/NO4l8MqGZvKarsN
X0wu+iLuuiCBMJKliocgjwX6oF9hc8U8r4xIs/cEJqm1Sfb0rkg6EE3wrnqLNGf1iBj42EXXakJH
UUaaEi6lL90mY5CI92p8tnhuBJzsV8dqeerhwQZ2r8IQY97Z0NOPlI0DOANsrJ3shKZ/Lfrkzq+8
FSQm7ImrreQwwEGOHI3KyfR60bDXfv+O4fk26luvrXJWNWGk8+dratk5a3C/AY67UYR7d+9NSpyc
ImbpsP3q+x2TQiS1ZyRV2VgJSccEG6eKn3ykAdLU7rugxvKrF8QBWqlhtkeVR8F2Mx/MxsKujSxc
1ZWwdezaUMwHTMlmJNe80mKeWuTEuobTasuxmUwBZGUJLratvxhsfqSnD/N8ZSjynPk3FEqOJID3
Q/9BzBBPORJaOOHLKlbwAOZTZmEbKShlEwisoFzMYR2eFE613MiJb4IzegoFV4gI8H1F3pKnY1qy
2hWTqKy1AoybFJ0Sevp7T3aHKaoQFgXesWhLLdT8FjNXB1sdiqUT9+YXjLQQ3fXysmshsARlMNS9
0cPBgyBM8t8SXGjmv8E7wQzNMT19aYIhZtCNzUrjie4HkEUgBrgqibiBDwPujwaCfsrRhRgFbm+G
BFJ8SX6IxkxcDoEQXNmFsidsgozHg7J6NHl6J90v5IHdIbzpHoKcTJU85tmu4Y2yagDTbdfSHm9z
jafUiFN2rkQ6AG1Omtc3D2XBC+JHiOvxV5NhnXwnTwSZCFrYH2qER6TNQnWYRmJBuIBJul5zWShb
wqvA83SjaAQvzMn4hkqUhyaJThZV8aS0dRSKIJlU9eW7xh0ShauR1ZzN/1u5Dfj7Zp/l67ILWUXE
vfhO0P16ZlJzEoEdYM+VToOKfPjl8J7meom/Vwjk/SbAxBaGDodqKIOMoyip1Nbl7StoyCFh8Yr4
HVIHo3/pbiwVsbrwiee7NwIBsQswKFpXvuaf9Upfzw1m7TSkK+E7sZ3u6gQQtK4Pb8LsVxeqzod3
XzEuA6xeb0AnWs0/3610Eh7VqNiUQNyr586ZIV3fA835R1CFCn8drfqNpGG0JWAvckaNjYrzuz/u
TvUbeazHFqV+Fkh2idujlA+JMTthh02yApf7BMNUi8wv+VIm+N/DdG2d9AjBgXxrBOiIasfUgtm6
RFd4cBPUpb2GseTI7cE9bSd156w1OgU7SLFEDRVb5+Ii6Ni5K/WA86Wg4HzgemblliFytT3qQ9Rf
KVfnJPKL6zlQCgCuoOcNH9OHw7nUQLJZmtoav03zdxdaSyppZSW99alkKEbTQDSpfD7h4pDBhKGZ
hfuiUC8+h0/+NRy6OKfIPSutYnzxPckgYUPV0yeh1PpaKk556Q8R/Iz0GinY2EPNWtBxKH8P/bum
3iIoG7Vvq31B/lloYAwHbZH1wWA0IbMM72G6FTbyGtynxjfhQhnfhqIl+Wa/dsqk8hycFQjC2dXf
Hwi9jf/6/HQ6rdoCXBzAjlfkuvu378fQMTc2vDc4+gi+oOnNsT8gntLBzSqkyeKX8pZrvTPZObkM
Ur7h1p23e3+QuYoiRYwhLvt4u2qY9TbmtRbWSq9gGrm67KIpUpr2vrgs2N4EoCG2zgyweRhkJ8Hp
qNCtAjaT1xkA1IIMTrgYzn/r3tVkCy1Q439Dzslr3yIBgmHWqBjcSrfpvOjJhXxlV60t9HFMYixk
udDkrBG56adYaIOLk+9QqBejJCIxLy3P5aXNvKNihzUEBXadGkGQPLO34V0bMmSSTD5ApI1ndAsC
xWptpJLwTDqS8+0QZOQBfCus5mmN5QxVSjtyAuNeEapY+99GOR1pB6VmpFe4rR8G59ou4wN7HObg
d57de/SJoyGz/EYZgG0jfpgbF4fgqdDfZJBLV16AVqkhiGJTvMXa/qJP0sH+4TNBl03Bvfcp7Pog
wGtdN4aE30GHtxwi0QRB+nohv42LAwSGLfNYZBGoCVAc4GmkW27lptO6hUKJnmE8d6zeD+jplb2J
nF+n+HJLX4z2ezNd0GIWw3SCl1r1MLfc2ormYuzOWAf0z5v/punTzkJBs63/OkK/jaYbn0N/zo5o
Xu8UaZleT9BiTiVnDgR03YSnussAWB/cvaOkh+Zpmz73RJkbam0LSiwcln7ZVwzOhCNMIgMsZVtK
3ANoD2k2SMV5PN1PSONe58K8jJ1pVOFbCnvrQkkrTibDDop5TcFdSSyrWgtdcLsleK/ZE9iEpgG7
ePVdYb0Ka5LBRbVd7eJHSfuyyKZH3F9e6Yz+pmLqtoTBZnSMmUCsYk51VxMHWLf/AIJefdRWWB1t
45IcVTYYSoHToJFX3Zm5qf9aBgwjUL/JOILonWCaCbsjb/hDha8qDEzDb6DOyVyBXqhGKujWDOGM
+8fl9WJoxmykI6rGJ9UiTYY2CLmdcMLg7QF592+RZBdMaf5qSoWQ02RmYnrHTZaNXUd5S/Nw71eM
jsnya9JzWe0tnf1WbDQrI6NArfjJIRbcZLp3z+iK7mQmLm2Ekp9qY7rF3OyxB6hOiLYBWiGus0Da
D32z6Bx6zLX6eAr3p8DiVAkMnPrYl3NN1Epe8o5z6q+LkYxrs1GorJHen0uVabAEeGtihDpSKkGt
5Sy9TzpHgX+mzcJ/KPawr2b+sRW+Z1TrLPl3KpQdDf4a56/slMhM++QVXbtEM/iSPSOaAc1+BIPn
a3NHM5tV5xK9wt8usmNUKBVQ47TgdqbBXY1ZP6Y0xFUIaBge1AD3x82GGTv/qA8S5C7s9KnjkbJC
ZxOUSS0hne8zxYtneEuDsGI+KFx+UqtQSyf1eKr8juY199LCywd8kJEEuKgauZ0N/TVzI7hRc+Uv
ij1uLj1N+93Sz93s2f3AHeNQReNwu3hTXXJHikkvFnh0XKIAKX8SZ0GvPxRPpOT/EqGHi7gQgiJR
W5ps1nXJyCHj/uLb/HrVOUXzAF41NJugvTEH3PAxJyYWcnpjvGzoqF70fJbOyl2dj7UjlPZr8ESl
wBvDonznd5mnr++mpI5eJmXtFxoxpkYDgchZrFkFbwu0ks0TSqpf8N1RFod+gr0FctPORgC1ZBdu
hO6EVAStVlUckuozEiuPgEtm0uqQXm9f5W7ikGeVyMgabWtlDpj4DVDDZpQmwqE39UF3QLBote6g
7bc/VCijSTdRABpuAxeq6HrC4e1yfrc/+h/A3iGvmkalLVg/L9B6oj+ccCw4Ocrl+vYOObv/icD2
t2XgCgQOmVJlCHla8APeUcTl57ps0XjkQ5qJxbjUbkThHCJKqJAazmsvnpSkAqEQG+/eSsJKkNQG
GKfTriOtEbSeZG8GuwLwgB/ByNuuq0MXd8c8nZKgWteFusPFA+F0wndIILFbn+LCqp5Lg0+BJUyC
YZeKe2mjuoYcus/2kXgGvVpuqFsgaqM/zRlR/NSBdT1upXOGU+UCOlEJTpjgs+wBAp1gSo5Dw200
n3OrBoeog2l/3yBQ+CEiy2n4py5lqWkW68lvFwsun2K1PT1+xhS4ohum6+PZDuZaNle1j+9FQUDd
7fBNTdBn69SnmJ2fnqZOgEmxWgiHbEEMoB7gUo4Py93O3tx6RlLInganqft6FgLX4FQAQbuxjMeE
u3oeselSTxBn8ZnZk96d1PfpfdzcbhoBe/d2a6ImvrXHwJheSwghlDtVDVXyU/LB+AFGksHNkxPs
1FAVf0w9OV7fflMjHUqcSlZlcAmyFeI1ZMuP8SPz8fY5Y7QrSbl1ttKwvCyY80ujMGl2YzIU8EKX
vgaUZ1EdobhwAV8eGQH+ObjmCS+UHIRC19VfDBVXwnzf9EYQOaHSgTlvyv8+9wOXujDbxG8Av03J
Hn/eW7/J+4jPdH4Z6koiAJow9RRL2m+Tj5zk2CsAiEMd0ejXiC9ka0qEc3vrCmWXTbYYNIxtnOhy
9se/5dsWTvb9gBzTz9PAz3h36LRGOl5iXsBqox3ZLwk9a0HShEIKJInF33Ek4++tb2Gnldi0r8Nx
7KFs8lfBdN4+5gluGtrg1EetXghk2bndIK32kiTAlB6uMOq9qWQNT3Hobh+QZ32XyJOGls56TGu2
VgdE4D9QfyGxreK1vpbz0qjcGOx8I/5U3xmhSA/FnDgLW2/VbU5PtytsShuZkfiZ1JdEZV8G4s7C
+gh5v8xG3I30F/69Wgsk3TqOAQ1vNWDI+n81Q1Xt28gTfGYs2Aj0BMKHQ4i2XT64gjptIG12jlGr
Z2eaXh8yEd+CdBYLit99caEqvbTqiDy4W++M/xIZ0mQCRpsP1a9AVc4r5AFBh4kWziu6XyJ1497d
lsKaDNVD/uvkwVkLKtQuD2416IvI6GHKOybz5AtHp0lgw8Zhhlrei58UrQ5AtrWsYiSIr6su8B3D
7e26QkEUTfSM6cJv2ATbJ8iyzMxkT5mmzxAKaczhq748VhPz/FRBsaFPD1lmFuyo1Zw1prShIgTC
MSKxDCu6vCi1vngaOBO8XcMzm+F9q7ZHaDeDWhx8nQP3SpvZE+y8R+j34dCTqrwKQLgSD61FaWN1
08kkFLn+N28UK1G7fcOdNlt1Vfo7LYleTBF3SYb6+OWPtJs4rtHdVkzYpNMYNdoGEBD0r2wXb/qe
7HMRITHL77Utojmx1Xfqm2NCT9yVriwVZ/woTK+5343/LevlG5xohgxpnybo3MpglzTj6agmNcMc
0I/+KjnVuM1f2eGHr8jDzcLTKXkWl/sD3fS1LyBCVKRdLbFzzoYiA27SjuyJ05TPOgpjpcMURpE8
fGbbnFBlC5b/zGql5mIoMrFkAtyqKjv6RU9vsifsRL86hi1/5touNseca5S3RzW02GguUuBEItF4
opJ5z5ZzsfWB2DzR+Vrdscp7bnkucU+CJDsvFXElmFliG+W4gveqeX8Hy1jzNFNNgPQaKa1woOy7
B5IC29UkQB9IQeoa2kptQnWS/jPXoT7vvDEUuONUv6xxJXMtgio/7DdOw4ds3v3T/wOABF3sey2d
s7GnTBj9BSoOFc0huOjqnyriFdNhYbt7HqzgBN5QrkNz33cplsvaw1PPODUrvIBkY+qVTyuckV5m
Wzc0TaZ4BCTuA0W0jzbrUy2FQbzMlDBkYCUKbdyCDJa26gwjH9jAnJQu3tcYnFSkKCYzMmvsdpnC
EARf0qa0V73+5IZyg3AxtEu0FJC+Xt12rsr3tLjF03G5biHIM1W2WI8j44XM2DkXVA1Z8m41cRNj
bnNLoCy5imWtqLPm78SnkFZcCnTQ1g3Vy+9C6SYs9scBxuQqAZWydoc5yqYjoK4YMlCuEfLr9ckK
tnRoCCNXpL09JLaxJKKAAKiS0ncHIjDXUeAdwj8WyUi+tDDZoTr+o1f0VQ47LWuOQbhFSWaBXgYf
26QwcB2qt4ncxIJvd0wpWub5MBYVefBI4M/5t1GTLK6nI1F8vGbxgBknMtA3CLL3VCCyE48Edu6U
LNp1XKYg+gbxwvcyAjLEwVsXKAb11VwVxFiCfJCE8n2dWG87oKx42Oy9NAlU9aKMLG9MOP9LPAYP
FaVelbm4dv7PrgX0lCeuts0bPrbMGboyCyWn+Z11A1ngVgXb5W2zOQCJxAKrlffUYaMFNsldcxTY
HCWJfcMzF0pIPtEpG5M00PcxA+hxC5wHvGxoFZDwSTDyNl+dQQhK+t1D9Cuod5UvO5WxtHWODAn6
iGek9bZmnEhlF30L80I+vxIm3au6+nPBwzvC5nMZwRBpAer7C47QKQFy7Bxhv0sYsS33PfgD/Yf1
6rCD2rF1rvTmRsEixNSCGaLWCp7Rr8j58qwnliFn7nkAHBBr3VabvK+qe3jT3OLQIOzVmr6eUVA/
CyyOGCXFhI+hQesSxO0GtkH+Ngv+9v5it7OsBD9eJcumNaiaAIWL0a1A6wZpOFhHxgmimepXkwx7
yVkgzAZJwtVtVqpqgGBOb85unzZSkTtDfKv48oKbuoSxoebfA7Q6tCdzupHpu7+IhQ+cNMacWa9y
u9iHpExRWOK7lUuIk+S+aNOwKR8+p1ZAFHVdgo7tkF9SvaedekVlJXFgcjbpukcYw15KnItWKOpO
GkY645psHwEbZqi8Fm8+03fNiq4mLy+g3wtCZN3XhpXVKCKidDRHDeDKMHDPf7oBKBZQuFG77/GB
Icdp0N6Qg7GHqrBm3VYko243si4j5xF54Wiq26Xeq70nMVjZ10K8egwUEA8s//zXRecLu1JSkNbw
tfMr9cHXWJXw3136c0P3K9dTW2H3BT10VO4TCjMjWMH/6bbbmA3h3j3ZVyYBJL7NzSnQx9X+Gnop
P07SiMTSwwy+gRjcCPc27O7k9X3VlZyY8c23S4y1+gihROlzwRl2YiSty9uo+cluv83AQVuQEmwR
+r7AbusqJLrZ5xm53nyfnM+jEgVhTwa2p9gjsics360Hd5I/GCQdwo7DbmEAjj9UXzWwuq98DloH
CpRBwTWQ3tjVDptWcNEMUxwhv88EV1jjktxCnP9JUVruntcvlxlv7txvvSb4mWnnA8aXwke3doo1
VzjzYeZONZKa4Y8bn0BY3KdEn4G2YTegbQ1HY3wzhZyC4vYtwnZ1CyZKdzffQpuNL9BZQ7lq92zN
oAGBAb5biEuHPcapdpek9lCTArA+K1329r3ZIoStSa4yKq9kLQzZHMjInf7QWiAtb3Ac6RfCIcEb
jre4szdlJnh23lMoTLVyNIwP/jnMXQsJj0vYtTsQICWl3OGmuV6n0bQzjnUtONxXwf4xt2E6Ew2V
v7j642Fo7AuJ+w1HvDBdDjS8SDK6JhN0mg/RPvektA0/6yfGpPiAa0qzUZ1+rKoI8EzKGhsz+IV5
S4i/Cj9tcAGxkz/waNc5CAXh34n+nWAlUkE5FVqFSl7ordqSwuGZvRNNoKbhzZV9z0IsPa7iG2Gl
33wFzUO96vywTISjnswS39L8+KwVviUjsyGq0e8iDoj99YPli7ukEK1TZ8Qkvn/TeGtB9Dn68tG5
KdJjVpVcvpOtlvUz/IL8Q0otJDIhPNSWz0D4euAFOF/eDJciaEPZJWLi9WaJU2mC62C2R4VeFvyE
E84qx//YFHC9WPFgx7sR4He/kS3YcJcjbzQMniD867WPyJsu9xn1G0zqFfSZs7aUglZ56j5VYpvm
VmuuanoA96jwFXGIYa1rz0OX389/Op5SCqJwwwyFNp6M2/aBDzhrGhamkk44P5sPi3nZit6ofe6/
jzDrlMdhbfzV8ck+BCVixAVKXOm1pxo8yrJVluGpc1zm7Ja3pCPwiIIWWDC1mEMBERIEL+86nqc7
YiybG7CgzEgVW3SAu0yGfuS3VWgOqM459nGksYpJRFSh0wIuArsbSx0VL8UFHcLjLCikitnK64yO
fvbiinNqy3a4LI32g/iWqMcczCOhZN1wk3FlFfa95cLUKxxtwsL+IArRlyVPaZE5Dz+EKcNOHBno
EmURSFeS0rw+swte0SuMAWAgl9piFKpnLQwEbv3h6oO9lUFxkBtZuz8/eCJCYGd+dzaks73Hv6Nn
5l4fmtiaqR/iSbLlU2QlE4GY7T/LUnHJ2aL6UxDYkv3K0XCxvMmwLwkwAnw0QmY9m9gY8/K5gJQB
O9yF/wiiI0gapm424kfEat72YvgD/UjbFRA4wol5Temxdhtk3nXOfvWDuRewSkfy99WzXRlripgv
rrgEzp3oqne189Gn9VqKpxqAQ6jEOcVYPp9264LcMl6a6MEIewgRDwUOP9MirHhtOKcXWDxk0m66
9DhXKuLsQU3UFgUU4zqwlvVRjDiv2/zumnUnMX02Qzv/UTSIdoCYsBF9OuAmK57D0zi97QuBxCM9
cFtzH76zvZuKAo3pHTjxBpI3ugQ6kho7DbdxMds/k/dqzc4sKoVW4w1pe/z3JuM6RqK8ksgabRcr
g635r+IaSAn2TYpbkroT0fOFqGfo3EXgZUxsV93g50Uu8WAoSoFcXP+vLzou93Rk2LlFfNw0qyV4
irh5Tw1JW6IucHwsWh9N3AA0P5pgHghrbDUNdbfdRaxi6wYpvaa1j6XfqSRSN3VzmPuMWmKLxP+L
9sIGCyIh6mvKRiDqldpx0sl9xYxh146L1jNg8aWkNOCfk/VEUkam87F0cnwCQV+ZNPXWkAp85/ly
vXrIaoSPPV1yy2bi4FJKSXo6u+HLbknzbUniBekyvTGxJayjGlXHNEeEUhcP5ux/bxJJX5IvTp9l
wABNcd+PN4PPHfK6YMTSXajB8S5cqZYFnheii7xFgm8AxP1aECKm+GtxXw/BfK721Tw1nBF4OnhA
uclmzFK6PoVMvqL1luY7riQgLi6bSWhjRzzL6vzK9paCvqRJNmpTDKfIst9mADRcXHI4NrN8K978
Njoklq2iYx9wWUmMARl9SVor8OaROdtkpUehiYdmFSNe6uDgWiKyMtTt49WDZK34LplmWuc4PiUF
JoQKyw0b9LmPy0LqiNOESKmGHstDeQlnil0ArzeUNs4IS9g2tfbqIq9xzBc/wXdtpWotUf441gVs
Buk7zajYk0XF7gi6H23VCiaxNR23jCJFPZU3itfqU/kGqcdaFT/wA+4Tyxf/k9skgTS2i1Q1ImM6
9TbAKnbdTIMgEMdWy+G6s1prR/rICJmEDER/MUN1O2huMZOlT9lIgRLu+xHfrTvcmvxY4HY/OtW4
xz/oyL/mICb4NC7L/OEQyJFlNDT8GQPwBG1W9wPEgb1jOgPfM2wH0r2sCVQKfbtRqrTODojg495x
nIB0DNaqfdRB7TkAgUDLbjnFUnWp8/nt7teTh6g/Pow1auFONzzCke0L/ojR9yGQ1i1haKPoVsUH
c8+v3YRXeuLhqLWZyz3vCBW/vLQEuHBrgt1iHoqKfcdHB2Ql9qzbbglN81WMc+6FCh00vY5zY+3C
sLn5qm/yRD1vQow9WdIF8oidQhWXQrVMjaEWAoLucWOue/aFnobyXT7gh2jKK3MbUhIzFiKOWnWo
nbkzGIWzbnbS/dpn46hsi7PpweW7GD47gwJA0LREY5M3x+KAe1E+L5niorYjdOBjylsSj5YvfLCu
TZCvvOmfisJbJkbYw79v4Apd9+Gn5hRuzTyZKaPrzp6tDsi3cSaMBipCkXmwjOelzZoP7KnRTnG+
5tJGUunE/HOnJ2gOGqfCTibyYdP4YqdW/3Zu4bQjcDeoGv1+Ae5ZIJ8WN73u1BpxOYzRbV6s+VCL
7DknzruXif5sAGw8g8Y8DRUAmn7yarM+kR94rWUeX17hh6vjln84/gT1iVoFI5+qV3z+CxTaDuMO
8ECXd3TqzfmWMCleOGXCqqA2mBcN0umcsker3kDvF+F5rHD2sSfPkccDkNGTOY2zD4k2sgIJFxn7
vlAkAXiSA4iw+H/Bl0TJ9RwN36VJ2CQcQ9NRherjNNUL9lsIQZ3z0X0IKzCeSwAVe2Dy9IX7h3vX
cNih+Tb5F8BG2GhfLSIiZ2KICA0mOeJXMySdLRGIqHQgUQbzvGL1ay2WHE3RX7RvY3aaXQ0UZn3b
1iDwaJ4Zx7xSr4TqzlqGXwiRNIohK7ovqCrs7wu0k7j5RsZYOVWA8ubZnhBAPoTOp/cnoWlyIc1s
nFBvgibZkCsh0TvxEb2CSw+K1WHD4SzGcV/mkDDIY453IaBVtfok4JKVuOXiQ5cP0EpZWdh3aNIW
/epO7TTmMVNd7aV0ecl1xIHF8pR0s1A9d3Inn5ERaMz2YJ0hzzDWGNjSWFBgd67Xd/3dTyhuysDB
kGjTWU4g8u5Xfip8xs6K/nptvkS2oHO6d7EP8b0iRyfajnJoCExiK7S84Rm5Bw75WYgvflcNVyoB
ujX9amc+a/Po/2mIrLtXL99NWOV4ARzBV9G7BM1yOawYC0RoC4VgAYQB4fMWdBfwWwmolDKq0yip
cEhVjXn3Cr/TsOTJdKnSowNTaiY3p0o7jkEnYUFX5moz5zmkKryYQqbR2cyz///rUSdjS+3TSbqc
5t3F0mOxH1hkWzSfYuc9yDSpWNlMciRHxjXe+nORexOY7J+RpVuLDfmB+c8TO8XEj7gElV8K9CIu
qrkVcRnI5pZzmbZ3EE20MDsULtrfbrfL3q1KqNZmph/f8lSWfWb6y0V7JQ5ypr/SQVfHBrIszPms
s39GOdUaqFo/QwSck4N8aUNHusDbq7YVsl2seW4/oRaS1loxR7K5CEMEvrW0/PZJmC/Xm/2iyPcA
VvnoMOiD2dBM/6J8mxLVwti5yN3ju6gNcn7hZw0ZSwDFtaHamDEg7uG06/oiv6I4Dmq47ZOdzyB7
gVDSEe6almkgy3FE0KyYvmKS3lqKiPokL4v1tYNHd5IDy5ftmXXKMtMt48V+3caQE40OHRDR2cji
LGJ+Kcw8RAdjE5jCOuaI5Ki8ViAdl0GGJVRdOoT6+C81IqmaJn+3AXbg8PYB+gq1rM2E27sm7ldp
OzFUT8oJV0l+gbHFtuhMhSfDDPsC9987UTmG7iz2DzjtFdXJk9Xm15VSFlQVZIIpSZGRdFP+1f/Y
GE4Qi3adoHcqdvsjjgjZYUjURLR2MFA3lqOfONJR/BtFU9Qzc6Iv0WzT7RS3w4o2J6X9QDaUmq6b
Bj/x8PKV1o2HUlzBNwaGutYowSpK1JIWgczBJqHbuZOClgHUPd5tNr/+jfpi9X09zhad+l02xXFD
n4jYlGonPRaFoMOr0Jq1bVHC/Tb4GJytC2NA8p+RUmZImzzfKr8BA0Z3zXQU1eVWANFRlBmkm4+R
l09VO7rAR1shJZJzDONnaAqAvPZhtoCoOSs7h37pznd0JGIWOJbAbTyXH2nraFWNCq9l3OZiFZLq
Fddu/uzdbQcQCEVbTSPSp2wmggoioz9cooQAYmitMv+W5vwUNtlYUtL1AsdtPU7F7oSvB8tRwFrX
x3P/AWrQft2nXvRE5krT1IE+xBVUgn8gYti2cbTtRKClc0S7wcBeKoBe6zBycS1QVO0GqPevTEbY
hcaC2EIQdVuKdEGKr2CiO16+SyuUY68YB788+O4rLSxib6H8YinvW84YqcSs5UrBlKcvq55KvePU
NmqrpiEapUKz0URd/qhhn4GmErT59y5DeGluGlZhNwUx5CzpJ1XPCXdJv/QcQbQMqiyGTRQ3mHqt
La7Mt0zCMPaaCX6KCW30P7TiRQCR6swfnNuIG/T4xOiGgYMnWIGy1EhnAmr28joIMub17r/JdcVk
z/7jToauzwmCmgXleGEF3wdDkUQUHUudn2RjnBC9GywzNOEdnj0U0nO/twvIDF7CQDwfNeUwnLdm
eXSszWhfv8j3S54qE8WSsHfeYkFS2oT85ez2HcP4uTN/HGSUhUCeB7f8MtA9cRz1BsnRqzIN0DC4
UCZz4pf3iAbDGx/YraynKZTAfHq0ZVyMJ5DflaMsKDOTshEz5FXaNwJTaogKzh+/wT/ObOg3n57A
/Zx+VgTyO5kfBGpkyfa6JeTRc9R7yqiAi5C0iu+Vep6j8Mjk42c7RQVYrytV/kreUkq/B/EFW5an
tmWUKrq7DXQqI1e8EIbUSfCrtSB/8F2Hc1LaWXrgOi1C1mfeOiI/5MVX3KUoQ5aRylYq0I8R7crF
4rLubHs0+wEKDS278f7V6N9jB4m/kNGsBQHumlaqU/wZfKYw59YwNY1cZ7iUHqLTJv+rswe41JhX
SJuEnYr1XXGH7KhoKd6k9SoylXWZctmPTLnTZo6vUXOXXW5q0b9JHpftQvORRTcyFTjiERLzJuRm
hXE7GlluW5h19AzfCAQTZaMAzrN4vuYRQgY3ZmthT7EqHaaIxiE5TK6fJV89aTtZbbgkfQd8bFYN
VRWEenAO+35GsBjooXc+K+4AXMkV6NS0FVO1p/Afq8TOBPbUbeuYNdhQw+FBm3rjUULP5R3FnqVX
mO8sXx1ZRtWJyTSMw03vWJZjSQvIjwklu8cnpKYQ1E86id9fmWHFkW0a7sYwsyCt+YQeVdOqxf/W
qpYPqB+FM5OcJIOLHjxIgOoOTIaWW9mPEZoGPlUsVxT7PfYtjGR5eEZ8ucKisHE9JvDCrjQJp7RX
xHr5ILsVSns4wKcM446yNDATfa3SM35P1eXDmMEHRD3NC27DoFbJh2MyaKmxqKEIa8ElwyKw/sfn
j0PKluMi9zb1NnXqu/1jPJGpKt7jeU43jUHvapJmXqwGFl3MXxC6lsk4TIaDVPqhspUstE3BhJN2
4vzRm/d/uMMCYkILMwOTBCUk5zLKqO1jAwfLiFiF+0LwSmQoacrpO9qBbKd/DZn5djRR/UzO9CfW
4uHR3v6JKGpU18NxmLfui4rqGUwN+KGTjrkbVi1NkApqLq3P+P9NGaFvLVRsdPOq33QQQNBTKhEN
+bZPBJnP4AmwV2qRbyysQsHYiMA3F62EFcaPr4iWsP4jkuMLHFNWftk7Bbk+uphIGQE2OllbwVDx
2tkPbjbffDVyUU6uGGU5B18ZMG0AvqQFxkSKidCjQ33P58cOC0NHSk0eP/qIA+J27GjAP2LeXjqU
HCEVPAlYNAhYnYe1peyixSASuYdTcLMGiMnG9ksxpuBtYusRlfkeZlD8yHPiV/azwUHSCGB9PcC4
1u/Bt90VnRSMj7hVOYsjAkUTQgYA8HliYx2GrAJ6UQ9f2cGj+lPE4OuoaXpWyiBCtkpaHCxj2c27
5es2poBOwq2qwPYxFwnnN66bes8yEtQQNJplQXcX0THLObWF81X/pkWCF4Wtl67eqILdQFaS41aN
oKsC/j2FS26+FGCFa6hguS3HvJyNR2lFx6PKvBzrUsWRSVlIghTNBK4yjNqD0CjfKFRK97vMRPA1
PEc8UiFbV8vMDPNVi7AnTT7DpQTDSYJpXfovBPuLAPjYpY1GY8NHX6waVGAu9ZVauLJ8aTnCYMrr
zX28wsIscmcYRN7ecXu1U+O9Iq7zjB1m+84QnwX8ZaTcsTjs3xN4r9H11fvVY8M+FiKJafGD4lGI
4UW0jABUd20U7kxDZU9miuFvSi5Du+GytExY7EaeoW5EavEQ5TMtTKfyvk9zXVsQC8DtmRYOT3ZG
QVp3w+nIJ1Pl/M7+RkUqTfjlFyj90xWAe6UT90dEl1RxpPfMmV8AVFR41OeAG+/rYE1PqzXCp+6l
7OMcBPA4B2N6/UFO4ZQ15n4IhEe0hLoYy2kXwq2W/u+zplumd/XyI1UBJCAdfZIIh79l4pfdojnw
taVLzzef/V/R1XjMNOnCajgrbp6s3/pCjHzNYfVT9SM8JNSYQz1nX9suBvvMjGHxODbX6sUWSzCe
1yQa4J1bDyBxqtvwHEEY5Rz0riOKJRkDAAnPCjjakwg2PVV7Pf1sY0qN8qWpctiAm8N1aFpr+m+K
kesXrpYkkwrjL10iXmHkq06XEmNOhhsoS9A7hrm5/Cjn47mQS1e49kMrv+ETf1Jnbx32ClDjNKXq
8KyIHzIutuprtGwKUZmQPe0RNEO7ngROL5G9TPzpqbz0/Au0MCeADdLDCeUMLkOvYomIgtGnfV46
VoN0LIFsn9EZ6V5vHMZB7vr3H6plaIZBB1NJEHY8h+zOtvimRiM/k+UowrBiJ51CuipVqTSybAmM
DAq3MWs2qrVqkEIAJ6LjFd/9+QgfKJCCf5HXIkcT9jmRmzVHo0Wjon7gteizH/j+Z6n/zrIYXkBh
T12aZZ3FpeYl/dFm4aGzS2XCi3YTx+wspBQUNMBU1U7LM5VXW8c9pVvtmRrAiAmESOo7QJyLAYRY
A5bJVLcMWsGXj3JpL8A4QuBQK6iD9FA9104S9/QXCC5Ejs5VnfGTkSx1v8r4jXzWMEUAfs8tUJdP
02fWelCa3pURHyur5JxV+RfiKZsDwBCeoHdaI159UikTzv4wGaW5Ei5g/+6GmNUS08Zjsi+Wd1Ap
Zpmdze3831XW4gqUQsLFhltF3iavUQDU0nunn8LEWUphPO37F4Yz0rSh1e2MFZ3w/kCfjGsuT/WH
oWxEf4UUb7UuVgOcswZ20SMBYxwRd2HXnvevJU+RHPryOVtd5MDlVbDA9gTgdCaGmPVgMdSnCvyE
vxuJnXM/lyMs1LOpMftUt4ycz/+wX6Kxd5CkitfC3SyDaeegS3BsBg2vTr0yR4D6N5xcto0Fbc06
p1MC6r4NwHbRiTOyAfvElshDGZqjtn6nh82Os/AamwFAFBkIQnG7KCiMDmHKumAonpRrYdXMZdt1
9TKJv39JVD+Z/YH+y8HVgkZ42r0f39yMhmZBxLnV8eNiQcSWZz/dGCDxI+GBW7eFtxWC/lC33FI4
rFx0oEJXjGgNYlcSZwWRLEo6rtln5ZHq+PZEG7nhCxr4GFBidFrO62dm000MNS0n4335+aHgiI+S
SsBf21w2c3L1bcBfu4qIJgpOr4Gc38Iekk08bEGZYSf2Rt0PY1xQXWkckaFWaVlRiLogkqasSSU9
xhvvn2FJa9M6aUBNUsJEKw4SiUtxEn5TR0+QaBdO8uD0KJop62PY9BngW94VkQIj+E4yi6dpC31Z
0Yf2x8VBdDKx5LRS0W2yCTWQFTB2p6wZdnT25wZ/19BxpOHNqlOLIqJpUSdghI7RuSBhGEvQHR55
zjGe1Kcgpgg1ivzDMsQnJicgF+IuCBj6nMz18RitaEKf553IqcKnKe5fqmUr2MRQ62aD/W+VbP87
5ghbMFa4YAAgbuViezYGyVqxu9U7lSjY9Z/ya629eGYiV/ZivlTLu99GkXqC15bM1UPv6ATGzKcD
Ns37bGE7E3db6Z1LSQ/p66VqO4dBJ7B+0PTKeqS4qMSNPN5yhsvf1KCNkEsCmlV5QxhscYA5RhPU
rf1LXU2Rfp6DvCTFii4tCMhYTvopk81Xe16ARLOCGvYFvDtd1qK3HKvfoe9Gy5+Z9F1tGdKaZvcH
Vrcuwod+zNWclCqS6RiFBiwwEJkIfePpzk9+iLjO3E2A4NnwPrvVGduqaEas7AhlTshuHMdnqkbv
RG9GlnguRNgLp9NYfNOWcur41qCOdDAjsQQb16EQxcyC/nCBKwhczwlI3mWKdGcUCC6pPvPSSnCO
z1lcZ8gIzcoqsb64Ml140ADZfkwOUdtt5lEcJWfzAqXwvrVu/M88RJQskwoVCH0PblecDbSftOBo
HMr+MJ+TK2yLl61Rj9vSKuTndUPrtjKa0zKcKQ0NH2rEroUoeHbx67mgVGxkrUWmXHpFQH8hqlAk
oRnFh0gbOZvdFbqo6MMzAUZtiqdfTL8nXTgIlWrBAXCC6HMyTAtH6sxsM2AeQ7c++M5WRHn6TSU7
fH68eNS3q1MaUh4YTOFq687bP2Kztz2zNVpP3ngQOGAi94TRNa/3Z9fF+osv+PJ8O2EHSrn4thEo
e7F06aoi2wWcx1rjDeXaoFhe8HTJHquybGNGleBBJdZmB7a4eCwaMeRWxT5pXEmW3Bxta0xH6rUt
F5psvMJxRbsiKjbSGK9AqP6E+WDIXZLVQIF+tA7+/CI4uxFUy0YLx7KaKM9mBu5hEtLO+S5FZZBL
agctwDcHCs7d6GBB6IJOQhIWqkL3xLV16DLvlVCNY6FHpjiRQA06FuJBHf171FHaKCU9p9UY4W4R
+OjIhqSka9w585ERTfkUcpUTKsSkRTzBW4K8bDFU9mMjK3/BU7oizaetk5W2VmIYGblL3rBN0QRJ
+vkdV2S9MHDaId6vdpsQlcN91W2KHOXGtZBHh8f0mhCSW9+pMxnQRY1SnM4ABkJhW/PoEH7cGtfn
oHizyNL2bS6Q4WbRKq34MzRnKfPusmtbO81gRDdftRrLk1zpFVjAlfhTm9hAHqbGV3bWoB/TIAec
GTuj4Pq8ieuxb2uEDu6DDxJOxhaPH4vkyi3Wi3orWOG81CXLLvXW18YesgNm0T42SLxrxBEhFX5Q
XW8xw3gKdoXCglApEOMmnlpHOIzZ0HWXgfpCAzld0S9ffnnjP/KhsGzVdskmVH4Ah2Gl/wtd7XEW
+tR8Eh7trQkhoXY2IeCmo71cXBp9YtLgd+9esQDu35KBPiPFuTJ3YstzPV9P5DiBm3GBoEqE1wPG
zaVHs5NSwLIVlYQ/MpeFV53Sx5CMoRUgyH18gLa1lhN4YHR2C6NePda6+dPbRAWbBO3zMomeccP2
Wo/5KZczoTuhUpNtHeo5evPQxcK0wjXr2mi6iimsWPhAUyD6LKrj+bW0OEkewn9xttBGyuRPKouR
V8MaqzJKjPmLC47CNZmL0rFOJhBevx5Q1XB/p5qRPaXGxLUgqilwd/ywIJWhCX2GykD/LZt3JQph
w0v8o3R8MTkIicRFATIgMkizSclVcPU+R8htbfmacbiciGNnq5bJyx6xm1Wd5qyF2BnANAxBdPab
5vXXYCvdrAc4qoZ+B1w8ZfZxP0+XgixMY0Dh0vKrwd3zAJk/1HdSy8Xyo1rkXGTqAcNozd/Eh/be
kvkUouEjK4PVqNA18JECisvGM3uHbP9HZh+CfN+i8SMEI1f4RmWumIavxTfC7A567oeeTLvCBML3
LfgJ0nxtQAcIIigTs+0oFGU6TcxvJYTPAxmVYBZ7+P2BELGI+5hIjAMySVwfaptHBQF4Zn95Fkfg
7zHnIaCIjFU/ka0QPWhi68Mm++lH3jYsudCWi5epJ1c60g2l52/LoCoKTky2+frS9w4vrTFU4VnH
Yimpj40nWGYtfXPYhBxGuVKjlqKFscX7iBDTFtNdxcarOnoNgKtVVFr6HLb4633RVWVNG1SYhYze
zbigMwRwfpZmzoIt1xBnDzTNpz1KO8loaQlQYaLkY2T3vc6utj2FaYjKVdYlYEPGgQ+OOGFOrCtN
A/1SmLPIr2oKuHww9IPdDD+eO7zAj0sItOTSZs8TBZy7/JhD2BGwrmsUpmdy8cxxYMHyr3+GWOK8
cMTAgJ3q4CnbQ/mlrApKNmsf/ZuBHco8FK8zIizzs/Ya2OETJLbL+e9UvCoKm+HjVUJb+UqkJm4t
4B8fu5ubYBA5MozG87UeD97+tJRauZZm3U1JVtyk1W+5nIGKAWntxI6sx1DDW5BtpA4TiOBq+z4D
gtxj0evmHd00x+S3zhhBXHH77m+GKxiOITO4LHJXgbLifqnHRtxjWRcl+/hp/2YfOnTPg/gAiyJ7
hhMsQ2mGDAFgeGEkS1CuW2fsJy/my4BK0ZoNLcFx2QO5z/1wbGFV7APmBroiUvB1RN9gS1U45qxp
wTxCfTOfAsuZPUX66ChbVfl9g9nnQUSBjgpKIa1U58nQHq2oRD7Lx2aHJHRpiKmaJ118m2FyRDnA
h3nPxRZCNCY/s/4jV3wKPwZnAJno5hvbNqq2KJkvGIZq5I9hd2NRwYlURdhPABeuXU/DxA9dH9uu
DTM4MRGg2okm/CnM26shQZmX7tdjztaD4AGD4Zmlgp+eOwQDmartyrfKMGtfrQgNbxUFoh3VI1Ht
GU6DiltGVp4RQ68hGeNRRmvBEtItkMEadCh3Spb9C3qBlY63c2FOOWps6VngI51YMIoumxUQOBCu
4lkx6ZXxpVDWOSAaWvj/+xqy5tvgEs3hZFch4CFMri6TT1KSSqsQ3+QATAfQwE5A0pmC+g8v6zpH
f3VprNtpj8+hIXub/MCt2erEvwZmqz/1zQtt813vIsC+MQ9ajGZTSG1nBnUp4FVs3y417VNE+uFV
HLzTNsztn8zLF/plG/pklkGYBGO/QuaJWpHjvgNikCLRQ4ezlB9IVqiZQ3ZPHL7AaSNY7ml1Tp+i
PjXMJ4diEgRuxQ1UzKmVZDzwCtRzjblD39xNfc9PfOpE2En0S7kK/dFY3PizXqLPGDj/ak+lfM61
dM8cPKFU+idQRZpDrgXwhaNUbLPv1MuyOxWMC7nsc0YS7Pk7MC0Ng1Tyf8t6hwmdzLIPHiO+p7DY
8Nk5bwt/aZZBAVTgxhbM4IuR02O3d6LrhmMoW/5QJPpDKTCRplKcIrGVsdcpJU+gqFasa3kH4K+c
mjBLMuT5VCazmqnMJHcBarnJTakU5Gtjl+8pBVPr3cJZNK+Dh39Rhf0A83QRPyJRsl5Xhe91/CJP
9vbjx7gbs3foxcEDKw4cyRLJnssEOvazhFYtJUg2EWGXwBwz8IhnRCzbnZItyQZoNaZ8fdVQ/cb5
j/R7KH3v/0lDD+eflY7J1GwUORNOolyHvKCcg7CUJAG14WDyoj6BNduYq2vrxNT5SHEDfWBaKB8z
Fcxm/h92qfsY66yLVK2q/kLQ84M2H6cz+VWWEMqWkcpVHV5hLafLGxl7UgcMQHB9k8gqelP4BEtp
4D7qwq9N2Pjj1cC6biFuj488K7H1XEvsQsnaLw4bTxJnOfmJVm6kX7Sr4gRlQI2953KYCki3r6MC
tG6efM/38Y9kmE+BrOvG7B0J+Qv4RfqIOs6W8X9+hc+DLPEHhvN1EO6RrMP7s0+YflCp31RGDl00
+WZDgGZluSPDNo9C/U/BUd4sZl8ssS7N9WxAokkH2Iw0TGcTwMxpLaSobM3cenc+9s0GHvl03nRd
qINhunnK8A00gy7l5Q==
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
