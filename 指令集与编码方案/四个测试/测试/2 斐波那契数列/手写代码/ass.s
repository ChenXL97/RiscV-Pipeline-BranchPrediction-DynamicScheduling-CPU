0	addi t1 zero 0
1	lw t2 0 zero
2	lw t3 4 zero
3	lw t4 8 zero
.label:
4	add t5 t3 t4
5	addi t3 t4 0
6	addi t4 t5 0
7	addi t1 t1 1
8	blt t1 t2 .label
9	sw t5 12 zero