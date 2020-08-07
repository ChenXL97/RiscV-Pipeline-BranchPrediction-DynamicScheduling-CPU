	addi t1 zero 0
	lw t2 0 zero
	lw t3 4 zero
	lw t4 8 zero
.label:
	add t5 t3 t4
	addi t3 t4 0
	addi t4 t5 0
	addi t1 t1 1
	blt t1 t2 .label
	sw t5 12 zero