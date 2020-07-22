# import numpy as np
from bitstring import Bits

def toAscii(s):
	return Bits(int=ord(s), length=8).bin

def toWord(n):
	return Bits(int=n, length=32).bin


def process(strings,start):
	index=[]
	body = []
	pos = 0

	for s in strings:
		if s != None:
			array = list(map(toAscii , list(s)))
			array.append('00000000')
			index.append(pos + start)
			body.append(array)
			pos += len(array)
		else:
			index.append(pos + start)
			body.append(['00000000'])
			break

	index = list(map(toWord,index))

	b = []
	for x in body:
		b += x


	while len(b)%4!=0:
		b.append('00000000')
	i_pos = len(b)//4

	body = []
	for i in range(i_pos):
		w = b[0]+b[1]+b[2]+b[3]
		b = b[4:]
		body.append(w)

	return index,body,i_pos*4+start

find_string = ["abb",  "you", "not", "it", "dad", "yoo", "hoo",
                              "oo", "oh", "xx", "xx", "x", "x", "field", "new", "row",
			      "regime", "boom", "that", "impact", "and", "zoom", "texture",
			      "magnet", "doom", "loom", "freq", "current", "phase",
			      "images", 
			      "appears", "phase", "conductor", "wavez", 
			      "normal", "free", "termed",
			      "provide", "for", "and", "struct", "about", "have",
			      "proper",
			      "involve",
			      "describedly",
			      "thats",
			      "spaces",
			      "circumstance",
			      "the",
			      "member",
			      "such",
			      "guide",
			      "regard",
			      "officers",
			      "implement",
			      "principalities", None]

search_string = ["cabbie", "your", "It isn't here",
                                "But it is here", "hodad", "yoohoo", "yoohoo",
                                "yoohoo", "yoohoo", "yoohoo", "xx", "x", ".", 
				"In recent years, the field of photonic ",
				"crystals has found new",
				"applications in the RF and microwave",
				"regime. A new type of metallic",
				"electromagnetic crystal has been", 
				"developed that is having a",
				"significant impact on the field of", 
				"antennas. It consists of a",
				"conductive surface, covered with a",
				"special texture which alters its",
				"electromagnetic properties. Made of solid",
				"metal, the structure",
				"conducts DC currents, but over a",
				"particular frequency range it does",
				"not conduct AC currents. It does not",
				"reverse the phase of reflected",
				"waves, and the effective image currents",

				"appear in-phase, rather than",
				"out-of-phase as they are on normal",
				"conductors. Furthermore, surface",
				"waves do not propagate, and instead",
				"radiate efficiently into free",
				"space. This new material, termed a",
				"high-impedance surface, provides",
				"a useful new ground plane for novel",
				"low-profile antennas and other",
				"electromagnetic structures.",
				"The recent protests about the Michigamua",
				"student organization have raised an",
				"important question as to the proper nature",
				"and scope of University involvement",
				"with student organizations. Accordingly",
				"the panel described in my Statement of",
				"February 25, 2000 that is considering the",
				"question of privileged space also will",
				"consider under what circumstances and in", 
				"what ways the University, its",
				"administrators and faculty members should",
				"be associated with such organizations",
				"and it will recommend guiding principles",
				"in this regard. The University's",
				"Executive Officers and I will then decide",
				"whether and how to implement such",
				"principles."	]


f1 = open('datamem3.coe','w')
f2 = open('datamem2.coe','w')
f3 = open('datamem1.coe','w')
f4 = open('datamem0.coe','w')
f = [f1,f2,f3,f4]
for x in f:
	x.write('memory_initialization_radix=2;\nmemory_initialization_vector=\n')

index,body,ip = process(find_string,0)
for x in body:
	for i in range(4):
		f[i].write(x[i*8:(i+1)*8]+'\n')
for x in index:
	for i in range(4):
		f[i].write(x[i*8:(i+1)*8]+'\n')

offset = (len(index)+len(body))*4
print('find_string的首地址为：',ip)

index,body,ip = process(search_string,offset)
for x in body:
	for i in range(4):
		f[i].write(x[i*8:(i+1)*8]+'\n')
for x in index:
	for i in range(4):
		f[i].write(x[i*8:(i+1)*8]+'\n')

offset = (len(index)+len(body))*4
print('search_string的首地址为：',ip)
	# l = len(s)



# print(len(find_string))
# print(len(search_string))
