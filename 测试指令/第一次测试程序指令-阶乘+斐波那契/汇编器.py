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
	print(ins[0:7],ins[7:12],ins[17:20],ins[20:25],ins[25:31])

# print(complement(2048))
def assemble(array):
	ins = 0
	if array[0]=="LW":
		imm = complement(int(array[1]))
		ins = f"{imm[20:32]}{reg_dic[array[2]]}010{reg_dic[array[3]]}0000100"
	if array[0]=="SW":
		imm = complement(int(array[1]))
		ins = f"{imm[20:27]}{reg_dic[array[3]]}{reg_dic[array[2]]}111{imm[27:]}0000100"
	if array[0]=="ADD":
		ins = f"0000000{reg_dic[array[2]]}{reg_dic[array[1]]}000{reg_dic[array[3]]}0011100"
	if array[0]=="SUB":
		ins = f"0000000{reg_dic[array[2]]}{reg_dic[array[1]]}010{reg_dic[array[3]]}0011100"
	if array[0]=="ADDI":
		imm = complement(int(array[1]))
		ins = f"{imm[20:32]}{reg_dic[array[2]]}100{reg_dic[array[3]]}0011100"
	if array[0]=="JALR":
		imm = complement(int(array[1]))
		ins = f"{imm[20:32]}{reg_dic[array[2]]}000{reg_dic[array[3]]}1001000"
	if array[0]=="JAL":
		imm = complement(int(array[1]))
		ins = f"{imm[11]}{imm[21:31]}{imm[20]}{imm[12:20]}{reg_dic[array[2]]}0001000"
	if array[0]=="BEQ":
		imm = complement(int(array[1]))
		ins = f"{imm[19]}{imm[21:27]}{reg_dic[array[3]]}{reg_dic[array[2]]}000{imm[27:31]}{imm[20]}0001100"
	if array[0]=="BLT":
		imm = complement(int(array[1]))
		ins = f"{imm[19]}{imm[21:27]}{reg_dic[array[3]]}{reg_dic[array[2]]}010{imm[27:31]}{imm[20]}0001100"
	if array[0]=="FCVT":
		ins = f"000000000000{reg_dic[array[1]]}000{reg_dic[array[2]]}0111000"
	if array[0]=="FCVTW":
		ins = f"100000000000{reg_dic[array[1]]}000{reg_dic[array[2]]}0111000"
	if array[0]=="FSUB":
		ins = f"1000000{reg_dic[array[2]]}{reg_dic[array[1]]}000{reg_dic[array[3]]}0110000"
	if array[0]=="FMUL":
		ins = f"0000000{reg_dic[array[2]]}{reg_dic[array[1]]}000{reg_dic[array[3]]}0110100"
	if array[0]=="FEQ":
		ins = f"0000000{reg_dic[array[2]]}{reg_dic[array[1]]}000{reg_dic[array[3]]}0111100"



	if(ins==0):
		print(array[0],'not define')
	else:
		p(ins)
	return ins
# for i in range(32):
	# print(f"'':'{i:05b}',")

ass = open('ass.txt','r')
o = open('o.txt','w')
line = ass.readline()
while line:
	array = line.split() #分割汇编语句
	# print(assemble(array))
	o.write(assemble(array)+'\n')
	line = ass.readline()
ass.close()
o.close()
