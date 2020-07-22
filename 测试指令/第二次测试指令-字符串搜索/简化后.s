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
	addi	sp,sp,-48  		#栈指针前移12个字
	sw	ra,44(sp)			#返回地址存入栈[1]
	sw	s0,40(sp)			#老栈底存入栈[2]
	addi	s0,sp,48		#s0=新栈底
	sw	a0,-36(s0)			#将a0存入栈[9](传入参数，string的首地址)
	lw	a0,-36(s0)			
	call	strlen			#调用strlen(string) a0传入的应为字符串的首地址
	mv	a4,a0 				#a4=返回值 len
	lui	a5,%hi(len)
	sw	a4,%lo(len)(a5)		#将a4读入存入a5+len
	sw	zero,-20(s0)		#将0存入栈[5]
	j	.L2
.L3:
	lui	a5,%hi(len)				
	lw	a4,%lo(len)(a5)			#读len的地址到a4
	lui	a5,%hi(table)			
	lw	a3,-20(s0)				#a3=栈[5] 作为i
	slli	a3,a3,2				#
	addi	a5,a5,%lo(table)	#a5=table的首地址
	add	a5,a3,a5   				#a5+=a3，table[i]
	sw	a4,0(a5)				#将a4(len的值)存入a5中，table[i]=len
	lw	a5,-20(s0)				#栈[5]+=1（i++）
	addi	a5,a5,1				#
	sw	a5,-20(s0)				#
.L2:
	lw	a4,-20(s0)			#a4=栈[5]，
	li	a5,255				#a5=255
	bleu	a4,a5,.L3 		#无符号小于则跳转
	sw	zero,-20(s0) 		#栈[5]=0,i=0
	j	.L4
.L5:
	lui	a5,%hi(len)
	lw	a4,%lo(len)(a5)     #a4=len
	lw	a5,-20(s0)			#a5=栈[5]
	sub	a5,a4,a5 			#a5=a4-a5，即a5=len-i
	lw	a3,-36(s0)			#a3=栈[9]（string的首地址）
	lw	a4,-20(s0)			#a4=i
	add	a4,a3,a4 			#a4=string[i]
	lbu	a4,0(a4) 			#读字节，无符号
	mv	a3,a4 				#a3=a4
	addi	a4,a5,-1 		#a4=len-i-1
	lui	a5,%hi(table) 		
	slli	a3,a3,2 			#string[i]x4作为地址
	addi	a5,a5,%lo(table) 	#a5=table
	add	a5,a3,a5 			#a5=table[string[i]中字节的ascii码作为索引]
	sw	a4,0(a5)			#table[(unsigned char)string[i]] = len - i - 1;
	lw	a5,-20(s0)			#
	addi	a5,a5,1			#i++
	sw	a5,-20(s0)			#
.L4:
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)
	lw	a4,-20(s0)  		#
	bltu	a4,a5,.L5 		#i<len则 跳转
	lui	a5,%hi(findme)		
	lw	a4,-36(s0)			
	sw	a4,%lo(findme)(a5)	#findme = 栈[9]
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra							##返回父函数
	.size	init_search, .-init_search
	.align	1
	.globl	strsearch
	.type	strsearch, @function
strsearch:
	addi	sp,sp,-48		#栈指针前移12个字
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)			#老s1保存，s1作为pos
	sw	s2,32(sp) 			#老s2保存，s2作为shift
	addi	s0,sp,48		#s0=栈底
	sw	a0,-36(s0)			#栈[9]=string
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)		#a5=len
	addi	s1,a5,-1		#pos=len-1
	lw	a0,-36(s0)
	call	strlen
	sw	a0,-20(s0)			#栈[5] limit = strlen(string)
	j	.L7
.L10:	###pos+=shift
	add	s1,s1,s2 			
.L8: 	###while( pos < limit && (shift = table[(unsigned char)string[pos]]) > 0)
	lw	a5,-20(s0)			#
	bgeu	s1,a5,.L9 		#pos >= limit 大于等于则跳转
	lw	a5,-36(s0) 			#取string首地址
	add	a5,a5,s1 			#string+pos
	lbu	a5,0(a5)			#(unsigned char)string[pos]]
	mv	a4,a5 				#
	lui	a5,%hi(table)
	slli	a4,a4,2
	addi	a5,a5,%lo(table)  
	add	a5,a4,a5 				#
	lw	s2,0(a5) 				#shift = table + (unsigned char)string[pos]]
	bnez	s2,.L10 			#shift不等于0则跳转
.L9: 	##if (0 == shift)
	bnez	s2,.L7 				#shift不等于0 
	lui	a5,%hi(findme)
	lw	a3,%lo(findme)(a5) 		#a3 <- &findme
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)			#a5 <- &len
	sub	a5,s1,a5
	addi	a5,a5,1
	lw	a4,-36(s0) 			
	add	a5,a4,a5 			#a5 = string+pos-len+1
	sw	a5,-24(s0) 			#a5存入栈[6] here
	lui	a5,%hi(len)
	lw	a5,%lo(len)(a5)   	
	mv	a2,a5 				#a2 = len
	lw	a1,-24(s0) 			#a1 = here(栈6)
	mv	a0,a3 				#a0 = findme
	call	strncmp
	mv	a5,a0
	bnez	a5,.L11  		#如果返回值不等于0则
	lw	a5,-24(s0)
	j	.L12
.L11:
	addi	s1,s1,1
.L7:
	lw	a5,-20(s0)
	bltu	s1,a5,.L8 		#pos<limit则跳转
	li	a5,0 				#a5=NULL
.L12:
	mv	a0,a5     			#a5作为返回值
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
...
.LC106:
	.word	.LC0
...
.LC54:
	.string	"cabbie"
	.align	2
...
.LC107:
	.word	.LC54
...
main:
	addi	sp,sp,-496					#栈指针后移124个字
	sw	ra,492(sp)						#返回地址ra压栈
	sw	s0,488(sp)						#将s0压栈
	addi	s0,sp,496					#栈底地址存到s0中
	lui	a5,%hi(.LC106)					#将find_string首地址的高位存入a5中
	addi	a4,s0,-256					#将栈中第64个字的地址存入a4中
	addi	a5,a5,%lo(.LC106)			#将find_string首地址的低位加到a5中
	li	a3,232							#将232写到a3中(find_string列表的长度*4)
	mv	a2,a3							#令a2=a3
	mv	a1,a5							#令a1=a5
	mv	a0,a4							#令a0=a4
	call	memcpy						#（to=栈的第64个字,from=find_string，size=232）
	lui	a5,%hi(.LC107)					#将search_string的首地址高位存入a5中
	addi	a4,s0,-484					#将栈中第121个字的地址存入a4中
	addi	a5,a5,%lo(.LC107)			#将search_string的首地址低位加到a5中
	li	a3,228							#将228写到a3中(search_string列表的长度*4)
	mv	a2,a3
	mv	a1,a5
	mv	a0,a4
	call	memcpy
	sw	zero,-20(s0)					#将0写到栈中第5个字的位置
	j	.L15 							#跳转到L15
.L16:
	lw	a5,-20(s0) 			#将栈[5]读入a5							
	slli	a5,a5,2			#a5左移两位		即乘4		
	addi	a4,s0,-16		#将栈[4]读入a4					
	add	a5,a4,a5			#a5=a4+a5				
	lw	a5,-240(a5)			#将a5-240处的地址读入a5	即地址-60			
	mv	a0,a5				#a0=a5
	call	init_search		#调用init_search(a5)  a5为find_strings[i]			
	lw	a5,-20(s0)			
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-468(a5)			#将a5地址减-117存入a5中
	mv	a0,a5
	call	strsearch     	#调用strsearch(a5) a5为search_strings[i]
	sw	a0,-24(s0)			#将返回值存入栈[6]中
	lw	a5,-20(s0)			#将栈[5]读入a5, a5即为i
	addi	a5,a5,1			#i++
	sw	a5,-20(s0)			#将a[5]存入栈[5]
.L15:	
	lw	a5,-20(s0)			#将栈[5]读入a5
	slli	a5,a5,2			#a5左移两位
	addi	a4,s0,-16		#将栈[4]读入a4
	add	a5,a4,a5 			#a5=a4+a5
	lw	a5,-240(a5) 		#将a5-240处的地址读入a5
	bnez	a5,.L16 			#如果a5不等于0，就跳转到.L16
	li	a5,0 			#（若不跳转）将a5置0，此处应执行输出
	mv	a0,a5  				#a0=a5
	lw	ra,492(sp) 			#返回
	lw	s0,488(sp)
	addi	sp,sp,496
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU MCU Eclipse RISC-V Embedded GCC, 64-bit) 8.2.0"
