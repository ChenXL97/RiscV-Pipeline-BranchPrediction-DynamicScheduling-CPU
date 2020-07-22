	.file	"pbmsrch_small.c"
	.option nopic
	.text
	.local	table
	.comm	table,1024,4
	.local	len
	.comm	len,4,4
	.local	findme
	.comm	findme,4,4
	.align	1
	.globl	init_search
	.type	init_search, @function
init_search:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a0,-36(s0)
	call	strlen
	mv	a4,a0
	lui	a5,%hi(len)
	sw	a4,%lo(len)(a5)
	sw	zero,-20(s0)
	j	.L2
.L3:
	lui	a5,%hi(len)
	lw	a4,%lo(len)(a5)
	lui	a5,%hi(table)
	lw	a3,-20(s0)
	slli	a3,a3,2
	addi	a5,a5,%lo(table)
	add	a5,a3,a5
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,255
	bleu	a4,a5,.L3
	sw	zero,-20(s0)
	j	.L4
.L5:
	lui	a5,%hi(len)
	lw	a4,%lo(len)(a5)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	lw	a3,-36(s0)
	lw	a4,-20(s0)
	add	a4,a3,a4
	lbu	a4,0(a4)
	mv	a3,a4
	addi	a4,a5,-1
	lui	a5,%hi(table)
	slli	a3,a3,2
	addi	a5,a5,%lo(table)
	add	a5,a3,a5
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L4:
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)
	lw	a4,-20(s0)
	bltu	a4,a5,.L5
	lui	a5,%hi(findme)
	lw	a4,-36(s0)
	sw	a4,%lo(findme)(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	init_search, .-init_search
	.align	1
	.globl	strsearch
	.type	strsearch, @function
strsearch:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	sw	s2,32(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)
	addi	s1,a5,-1
	lw	a0,-36(s0)
	call	strlen
	sw	a0,-20(s0)
	j	.L7
.L10:
	add	s1,s1,s2
.L8:
	lw	a5,-20(s0)
	bgeu	s1,a5,.L9
	lw	a5,-36(s0)
	add	a5,a5,s1
	lbu	a5,0(a5)
	mv	a4,a5
	lui	a5,%hi(table)
	slli	a4,a4,2
	addi	a5,a5,%lo(table)
	add	a5,a4,a5
	lw	s2,0(a5)
	bnez	s2,.L10
.L9:
	bnez	s2,.L7
	lui	a5,%hi(findme)
	lw	a3,%lo(findme)(a5)
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)
	sub	a5,s1,a5
	addi	a5,a5,1
	lw	a4,-36(s0)
	add	a5,a4,a5
	sw	a5,-24(s0)
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)
	mv	a2,a5
	lw	a1,-24(s0)
	mv	a0,a3
	call	strncmp
	mv	a5,a0
	bnez	a5,.L11
	lw	a5,-24(s0)
	j	.L12
.L11:
	addi	s1,s1,1
.L7:
	lw	a5,-20(s0)
	bltu	s1,a5,.L8
	li	a5,0
.L12:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	strsearch, .-strsearch
	.section	.rodata
	.align	2
.LC0:
	.string	"abb"
	.align	2
.LC1:
	.string	"you"
	.align	2
.LC2:
	.string	"not"
	.align	2
.LC3:
	.string	"it"
	.align	2
.LC4:
	.string	"dad"
	.align	2
.LC5:
	.string	"yoo"
	.align	2
.LC6:
	.string	"hoo"
	.align	2
.LC7:
	.string	"oo"
	.align	2
.LC8:
	.string	"oh"
	.align	2
.LC9:
	.string	"xx"
	.align	2
.LC10:
	.string	"x"
	.align	2
.LC11:
	.string	"field"
	.align	2
.LC12:
	.string	"new"
	.align	2
.LC13:
	.string	"row"
	.align	2
.LC14:
	.string	"regime"
	.align	2
.LC15:
	.string	"boom"
	.align	2
.LC16:
	.string	"that"
	.align	2
.LC17:
	.string	"impact"
	.align	2
.LC18:
	.string	"and"
	.align	2
.LC19:
	.string	"zoom"
	.align	2
.LC20:
	.string	"texture"
	.align	2
.LC21:
	.string	"magnet"
	.align	2
.LC22:
	.string	"doom"
	.align	2
.LC23:
	.string	"loom"
	.align	2
.LC24:
	.string	"freq"
	.align	2
.LC25:
	.string	"current"
	.align	2
.LC26:
	.string	"phase"
	.align	2
.LC27:
	.string	"images"
	.align	2
.LC28:
	.string	"appears"
	.align	2
.LC29:
	.string	"conductor"
	.align	2
.LC30:
	.string	"wavez"
	.align	2
.LC31:
	.string	"normal"
	.align	2
.LC32:
	.string	"free"
	.align	2
.LC33:
	.string	"termed"
	.align	2
.LC34:
	.string	"provide"
	.align	2
.LC35:
	.string	"for"
	.align	2
.LC36:
	.string	"struct"
	.align	2
.LC37:
	.string	"about"
	.align	2
.LC38:
	.string	"have"
	.align	2
.LC39:
	.string	"proper"
	.align	2
.LC40:
	.string	"involve"
	.align	2
.LC41:
	.string	"describedly"
	.align	2
.LC42:
	.string	"thats"
	.align	2
.LC43:
	.string	"spaces"
	.align	2
.LC44:
	.string	"circumstance"
	.align	2
.LC45:
	.string	"the"
	.align	2
.LC46:
	.string	"member"
	.align	2
.LC47:
	.string	"such"
	.align	2
.LC48:
	.string	"guide"
	.align	2
.LC49:
	.string	"regard"
	.align	2
.LC50:
	.string	"officers"
	.align	2
.LC51:
	.string	"implement"
	.align	2
.LC52:
	.string	"principalities"
	.align	2
.LC106:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LC9
	.word	.LC9
	.word	.LC10
	.word	.LC10
	.word	.LC11
	.word	.LC12
	.word	.LC13
	.word	.LC14
	.word	.LC15
	.word	.LC16
	.word	.LC17
	.word	.LC18
	.word	.LC19
	.word	.LC20
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LC24
	.word	.LC25
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	.LC26
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC33
	.word	.LC34
	.word	.LC35
	.word	.LC18
	.word	.LC36
	.word	.LC37
	.word	.LC38
	.word	.LC39
	.word	.LC40
	.word	.LC41
	.word	.LC42
	.word	.LC43
	.word	.LC44
	.word	.LC45
	.word	.LC46
	.word	.LC47
	.word	.LC48
	.word	.LC49
	.word	.LC50
	.word	.LC51
	.word	.LC52
	.word	0
	.align	2
.LC54:
	.string	"cabbie"
	.align	2
.LC55:
	.string	"your"
	.align	2
.LC56:
	.string	"It isn't here"
	.align	2
.LC57:
	.string	"But it is here"
	.align	2
.LC58:
	.string	"hodad"
	.align	2
.LC59:
	.string	"yoohoo"
	.align	2
.LC60:
	.string	"."
	.align	2
.LC61:
	.string	"In recent years, the field of photonic "
	.align	2
.LC62:
	.string	"crystals has found new"
	.align	2
.LC63:
	.string	"applications in the RF and microwave"
	.align	2
.LC64:
	.string	"regime. A new type of metallic"
	.align	2
.LC65:
	.string	"electromagnetic crystal has been"
	.align	2
.LC66:
	.string	"developed that is having a"
	.align	2
.LC67:
	.string	"significant impact on the field of"
	.align	2
.LC68:
	.string	"antennas. It consists of a"
	.align	2
.LC69:
	.string	"conductive surface, covered with a"
	.align	2
.LC70:
	.string	"special texture which alters its"
	.align	2
.LC71:
	.string	"electromagnetic properties. Made of solid"
	.align	2
.LC72:
	.string	"metal, the structure"
	.align	2
.LC73:
	.string	"conducts DC currents, but over a"
	.align	2
.LC74:
	.string	"particular frequency range it does"
	.align	2
.LC75:
	.string	"not conduct AC currents. It does not"
	.align	2
.LC76:
	.string	"reverse the phase of reflected"
	.align	2
.LC77:
	.string	"waves, and the effective image currents"
	.align	2
.LC78:
	.string	"appear in-phase, rather than"
	.align	2
.LC79:
	.string	"out-of-phase as they are on normal"
	.align	2
.LC80:
	.string	"conductors. Furthermore, surface"
	.align	2
.LC81:
	.string	"waves do not propagate, and instead"
	.align	2
.LC82:
	.string	"radiate efficiently into free"
	.align	2
.LC83:
	.string	"space. This new material, termed a"
	.align	2
.LC84:
	.string	"high-impedance surface, provides"
	.align	2
.LC85:
	.string	"a useful new ground plane for novel"
	.align	2
.LC86:
	.string	"low-profile antennas and other"
	.align	2
.LC87:
	.string	"electromagnetic structures."
	.align	2
.LC88:
	.string	"The recent protests about the Michigamua"
	.align	2
.LC89:
	.string	"student organization have raised an"
	.align	2
.LC90:
	.string	"important question as to the proper nature"
	.align	2
.LC91:
	.string	"and scope of University involvement"
	.align	2
.LC92:
	.string	"with student organizations. Accordingly"
	.align	2
.LC93:
	.string	"the panel described in my Statement of"
	.align	2
.LC94:
	.string	"February 25, 2000 that is considering the"
	.align	2
.LC95:
	.string	"question of privileged space also will"
	.align	2
.LC96:
	.string	"consider under what circumstances and in"
	.align	2
.LC97:
	.string	"what ways the University, its"
	.align	2
.LC98:
	.string	"administrators and faculty members should"
	.align	2
.LC99:
	.string	"be associated with such organizations"
	.align	2
.LC100:
	.string	"and it will recommend guiding principles"
	.align	2
.LC101:
	.string	"in this regard. The University's"
	.align	2
.LC102:
	.string	"Executive Officers and I will then decide"
	.align	2
.LC103:
	.string	"whether and how to implement such"
	.align	2
.LC104:
	.string	"principles."
	.align	2
.LC107:
	.word	.LC54
	.word	.LC55
	.word	.LC56
	.word	.LC57
	.word	.LC58
	.word	.LC59
	.word	.LC59
	.word	.LC59
	.word	.LC59
	.word	.LC59
	.word	.LC9
	.word	.LC10
	.word	.LC60
	.word	.LC61
	.word	.LC62
	.word	.LC63
	.word	.LC64
	.word	.LC65
	.word	.LC66
	.word	.LC67
	.word	.LC68
	.word	.LC69
	.word	.LC70
	.word	.LC71
	.word	.LC72
	.word	.LC73
	.word	.LC74
	.word	.LC75
	.word	.LC76
	.word	.LC77
	.word	.LC78
	.word	.LC79
	.word	.LC80
	.word	.LC81
	.word	.LC82
	.word	.LC83
	.word	.LC84
	.word	.LC85
	.word	.LC86
	.word	.LC87
	.word	.LC88
	.word	.LC89
	.word	.LC90
	.word	.LC91
	.word	.LC92
	.word	.LC93
	.word	.LC94
	.word	.LC95
	.word	.LC96
	.word	.LC97
	.word	.LC98
	.word	.LC99
	.word	.LC100
	.word	.LC101
	.word	.LC102
	.word	.LC103
	.word	.LC104
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-496
	sw	ra,492(sp)
	sw	s0,488(sp)
	addi	s0,sp,496
	lui	a5,%hi(.LC106)
	addi	a4,s0,-256
	addi	a5,a5,%lo(.LC106)
	li	a3,232
	mv	a2,a3
	mv	a1,a5
	mv	a0,a4
	call	memcpy
	lui	a5,%hi(.LC107)
	addi	a4,s0,-484
	addi	a5,a5,%lo(.LC107)
	li	a3,228
	mv	a2,a3
	mv	a1,a5
	mv	a0,a4
	call	memcpy
	sw	zero,-20(s0)
	j	.L15
.L16:
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-240(a5)
	mv	a0,a5
	call	init_search
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-468(a5)
	mv	a0,a5
	call	strsearch
	sw	a0,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L15:
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-240(a5)
	bnez	a5,.L16
	li	a5,0
	mv	a0,a5
	lw	ra,492(sp)
	lw	s0,488(sp)
	addi	sp,sp,496
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU MCU Eclipse RISC-V Embedded GCC, 64-bit) 8.2.0"
