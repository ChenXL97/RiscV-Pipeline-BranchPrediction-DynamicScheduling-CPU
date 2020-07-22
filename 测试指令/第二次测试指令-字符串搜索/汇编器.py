# -*- coding: utf-8 -*-
# import numpy as np
from bitstring import Bits

reg_dic = {
'zero':'00000',
'ra':'00001',
'sp':'00010',
'gp':'00011',
'tp':'00100',
't0':'00101',
't1':'00110',
't2':'00111',
's0':'01000',
's1':'01001',
'a0':'01010',
'a1':'01011',
'a2':'01100',
'a3':'01101',
'a4':'01110',
'a5':'01111',
'a6':'10000',
'a7':'10001',
's2':'10010',
's3':'10011',
's4':'10100',
's5':'10101',
's6':'10110',
's7':'10111',
's8':'11000',
's9':'11001',
's10':'11010',
's11':'11011',
't3':'11100',
't4':'11101',
't5':'11110',
't6':'11111',
}

def complement(n):
	return Bits(int=n, length=32).bin

def p(ins):
	return ins[0:7],ins[7:12],ins[12:17],ins[17:20],ins[20:25],ins[25:31]

# print(complement(2048))
def assemble(array,n):
	ins = 0
	if array[0] in ["lb","lh","lw","lbu","lhu"]:
		mode = {'lb':'000','lh':'001','lw':'010','lbu':'011','lhu':'100'}
		imm = complement(int(array[2]))
		ins = imm[20:32]+reg_dic[array[3]]+mode[array[0]]+reg_dic[array[1]]+'0000100'
	if array[0]=="sw": 
		imm = complement(int(array[2]))
		ins = imm[20:27]+reg_dic[array[1]]+reg_dic[array[3]]+'111'+imm[27:]+'0000100'
	if array[0]=="add":
		ins = "0000000"+reg_dic[array[3]]+reg_dic[array[2]]+'000'+reg_dic[array[1]]+"0011100"
	if array[0]=="sub":
		ins = "0000000"+reg_dic[array[3]]+reg_dic[array[2]]+'010'+reg_dic[array[1]]+"0011100"
	if array[0]=="addi":
		imm = complement(int(array[3]))
		ins = imm[20:32]+reg_dic[array[2]]+'100'+reg_dic[array[1]]+"0011100"
	if array[0]=="jalr":
		imm = complement(int(array[3]))
		ins = imm[20:32]+reg_dic[array[2]]+'000'+reg_dic[array[1]]+"1001000"
	if array[0]=="jal":
		if array[2][0]=='@' or array[2][0]=='.':
			imm = complement(int(label[array[2]] - n + 4))
		else:
			imm = complement(int(array[2])) 
		ins = "{imm[11]}{imm[21:31]}{imm[20]}{imm[12:20]}{reg_dic[array[1]]}0001000"
	if array[0] in ["beq","bne","blt","bge","bltu","bgeu"]:
		if array[3][0]=='@' or array[3][0]=='.':
			imm = complement(int(label[array[3]] - n + 4))
		else:
			imm = complement(int(array[3])) 
		mode = {'beq':'000','bne':'001','blt':'010','bge':'011','bltu':'100','bgeu':'110'}
		ins = imm[19]+imm[21:27]+reg_dic[array[2]]+reg_dic[array[1]]+mode[array[0]]+imm[27:31]+imm[20]+"0001100"
	if array[0] in ["slli","srli","srai"]:
		imm = complement(int(array[3])) 
		mode = {'slli':'100','srli':'101','srai':'110'}
		ins = "0000000"+imm[27:32]+reg_dic[array[2]]+mode[array[0]]+reg_dic[array[1]]+"0010000"

	# if array[0]=="FCVT":
	# 	ins = f"000000000000{reg_dic[array[1]]}000{reg_dic[array[2]]}0111000"
	# if array[0]=="FCVTW":
	# 	ins = f"100000000000{reg_dic[array[1]]}000{reg_dic[array[2]]}0111000"
	# if array[0]=="FSUB":
	# 	ins = f"1000000{reg_dic[array[2]]}{reg_dic[array[1]]}000{reg_dic[array[3]]}0110000"
	# if array[0]=="FMUL":
	# 	ins = f"0000000{reg_dic[array[2]]}{reg_dic[array[1]]}000{reg_dic[array[3]]}0110100"
	# if array[0]=="FEQ":
	# 	ins = f"0000000{reg_dic[array[2]]}{reg_dic[array[1]]}000{reg_dic[array[3]]}0111100"


	if(ins==0):
		print(array[0],'not define')
	else:
		p(ins)
	return ins
# for i in range(32):
	# print(f"'':'{i:05b}',")

main = 0

#处理标签
ass = open('ass.s','r',encoding='utf-8')
label = {}
n = 0
line = ass.readline()
while line:
	if line[0]=='@' or line[0]=='.':
		l = line.split(':')
		label[l[0]] = n
		if l[0]=="@main":
			main=n
		print(l[0])
	else:
		n+=1
	line = ass.readline()
ass.close()

#输出指令
ass = open('ass.s','r',encoding='utf-8')
o = open('insmem.txt','w')
line = ass.readline()
n=0
while line:
	if line[0] =="." or line[0] =="@" : 
		pass
	else:
		array = line.split() #分割汇编语句
		if array != []:
			# print(assemble(array,n))
			ins = assemble(array,n)
			print(line[0:-1],":")
			print('\t\t\t\t\t\t',p(ins))
			if ins != 0:
				o.write(ins+'\n')
		n+=1
	line = ass.readline()
ass.close()
o.close()

print(n)
print(main*4)
