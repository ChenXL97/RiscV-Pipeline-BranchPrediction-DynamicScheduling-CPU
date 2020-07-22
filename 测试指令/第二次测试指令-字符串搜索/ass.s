@strlen: #求数组长度 (char[0])
	addi sp sp -8
	sw ra 4 sp
	sw s0 0 sp
	addi s0 sp 8
	addi t0 zero 0   #i=0
	lbu t1 0 a0    #t1 = char[0]
	jal zero .strlen2
.strlen1:    #char[i]
	addi t0 t0 1  
	add a0 a0 t0
	lbu t1 0 a0
.strlen2:    #char[i]!=0则跳转，否则返回
	bne t1 zero .strlen1
	addi a0 t0 0 	#i即为数组长度
	lw ra 4 sp
	lw s0 0 sp
	addi sp sp 8
	jalr zero ra 0 
@strncmp:
	addi sp sp -8
	sw ra 4 sp
	sw s0 0 sp
	addi t0 zero 0 #比较结果
	addi t1 zero 0 #i=0
.strncmp1:
	add a0 a0 t1
	add a1 a1 t1
	lbu t2 0 a0
	lbu t3 0 a1		#f[i],t[i]
	addi t1 t1 1
	bne t2 t3 .strncmp3
.strncmp2:
	blt t1 a2 .strncmp1
	jal zero .strncmp4
.strncmp3:
	addi t0 zero -1
	blt t2 t3 .strncmp4
	addi t0 zero 1
.strncmp4:
	addi a0 t0 0
	lw ra 4 sp
	lw s0 0 sp
	addi sp sp 8
	jalr zero ra 0 
@init_search:
	addi sp sp -12
	sw ra 8 sp
	sw s0 4 sp
	sw a0 0 sp   #a0为string的首地址
	jal ra @strlen
	addi s2 a0 0
	addi t0 zero 0
	addi t1 zero 255
	jal zero .init_search2
.init_search1:
	slli t2 t0 2
	add t2 t2 s1
	sw s2 0 t2   #table[i] = len;
	addi t0 t0 1  #i++
.init_search2:
	bgeu t1 t0 .init_search1
	addi t0 zero 0
	addi t1 s2 0
	jal zero .init_search4
.init_search3:
	lw t2 0 sp    #t2 = string
	add t2 t2 t0
	lbu t2 0 t2
	add t2 t2 s1  #table[(unsigned char)string[i]]
	sub t3 s2 t0
	addi t3 t3 -1
	sw t3 0 t2  #table[(unsigned char)string[i]] = len - i - 1
.init_search4:
	bltu t0 t1 .init_search3
	lw s3 0 sp
	lw ra 8 sp
	lw s0 4 sp
	addi sp sp 12
	jalr zero ra 0
@strsearch:
	addi sp sp -28 #4 sp, 0 sp
	sw ra 24 sp
	sw s0 20 sp
	sw a0 16 sp
	sw s4 12 sp
	sw s5 8 sp
	sw s6 4 sp
	sw s7 0 sp
	addi s5 s2 -1  #pos = len - 1
	jal ra @strlen
	addi s7 a0 0  	#limit=strlen(string)
	jal zero .strsearch4
.strsearch1:  #pos += shift
	add s5 s5 s4
.strsearch2:  #while
	bltu s5 s7 .strsearch1
	lw t0 16 sp
	add t0 t0 s5
	lw t0 0 t0
	slli t0 t0 2
	add t0 t0 s1
	lw t0 0 t0
	addi s4 t0 0  #shift = table[(unsigned char)string[pos]]
	bne s4 zero .strsearch1
.strsearch3:
	bne s4 zero .strsearch5
	sub t0 s5 s2
	addi t0 t0 -1
	lw t1 16 sp
	add t0 t0 t1
	lw t0 0 t0
	addi s6 t0 0  #here = (char *)&string[pos-len+1]
	addi a0 s3 0
	addi a1 s6 0
	addi a2 s2 0
	jal ra @strncmp
	bne a0 zero .strsearch4
	addi a0 s6 0
	jal zero .strsearch6
.strsearch4:
	addi s5 s5 1 #pos++
.strsearch5:  #while
	bltu s5 s7 .strsearch2
	addi a0 zero 0
.strsearch6:  #返回
	lw ra 24 sp
	lw s0 20 sp
	lw s4 12 sp
	lw s5 8 sp
	lw s6 4 sp
	lw s7 0 sp
	addi sp sp 28 #4 sp, 0 sp
	jalr zero ra 0
@main:
	addi s5 zero 344
	addi s6 zero 2180
	addi s7 zero 0
.main1:
	slli a0 s7 2
	add a0 a0 s5
	lw a0 0 a0  #find_string[s7]
	jal ra @init_search
	slli a0 s7 2
	add a0 a0 s6
	jal ra @strsearch
	addi s9 a0 0
	addi s7 s7 1
.main2:
	slli t0 s7 2
	add t0 t0 s5
	lw t0 0 t0  #t1 = find_string[s7]
	bne zero t0 .main1
