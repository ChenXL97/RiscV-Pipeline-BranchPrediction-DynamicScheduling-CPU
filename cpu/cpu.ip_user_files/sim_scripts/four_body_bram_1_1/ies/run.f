-makelib ies_lib/xil_defaultlib -sv \
  "D:/Software/Vivado/Vivado/2018.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Software/Vivado/Vivado/2018.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../cpu.srcs/sources_1/ip/four_body_bram_1_1/sim/four_body_bram_1.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

