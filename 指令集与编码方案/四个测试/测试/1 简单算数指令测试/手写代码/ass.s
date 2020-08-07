addi t1 zero 2   #t1=2
addi t2 t1 1 # i指令rs1相关  t2=3 
add t2 t2 zero # r指令rs1相关  t2=3
addi t0 zero 1   # t0=1
add t0 t0 t0 # r指令rs1,rs2相关 t0=2
slli t3 t0 1 # 左移指令相关   t3=4
srli t0 t3 2 #右移指令相关    
add t4 t0 zero # t0相关 