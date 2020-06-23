module IM
(
	input [31:0]IMaddr,
	input IMen,
	input clk,
	output reg [31:0]Instruction
);
	
	reg [31:0]IM [127:0];
	wire [31:0]Imaddr;
	assign Imaddr=IMaddr>>2;
	initial 
		begin
		Instruction=0;
//		IM[0]=32'b11100011101100000001000000000000;    //쳲�����
//		IM[4]=32'b11100011101100000010000000000001;
//		IM[8]=32'b11100000100100100101000000000001;
//		IM[12]=32'b11100001101100000001000000000010;
//		IM[16]=32'b11100001101100000010000000000101;
//		IM[20]=32'b11100011010101010000000011101001;
//		IM[24]=32'b00011010111111111111111111111001;
//		IM[28]=32'b11101000111111111111111111111101;
		IM[1]=32'b11101000000000000000000000011010; //B jump to IM[30]
		IM[2]=32'b11100011101100000101000001001111;
		//IM[3]=32'b11100001101100000101001000000101;
		IM[3]=32'b11100011101100000100000001000000;
		IM[4]=32'b11100010100101010101000000000001;
		IM[5]=32'b11100010010101010101000000010000;
		IM[6]=32'b11100000100101010101000000000100;
		IM[7]=32'b11100101100000000100000000000000;
		IM[8]=32'b11100101100100000101000000000000;
		IM[9]=32'b11100011101100000001000011111100;
		IM[10]=32'b11100011101100000010000000111100;
		IM[11]=32'b11100000000100010101000000000010;
		IM[12]=32'b11100000001100010101000000000010;
		IM[13]=32'b11100001100100010101000000000010;
		IM[14]=32'b11100010000100010101000000001111;
		IM[15]=32'b11100010001100010101000000001111;
		IM[16]=32'b11100011100100010101000000001111;
		IM[17]=32'b11100011010101010000000011111111;
		IM[18]=32'b00011010111111111111111111101101;
		IM[19]=32'b11100011010101010000000011111111;
		IM[20]=32'b00001010111111111111111111101011;
	   
		IM[30]=32'he58da000; //STR R10 to DM[R13]
        IM[31]=32'he25dd004; //R13-4  28-4=24
		IM[32]=32'he58d1000; //STR R1 to DM[R13]
		IM[33]=32'he25dd004; //R13-4  28-4=24
		IM[34]=32'he58d2000; //STR R2 to DM[R13]
		IM[35]=32'he25dd004; //R13-4  24-4=20
		IM[36]=32'he58d5000; //STR R5 to DM[R13]
		IM[37]=32'he10fa000;//MRS
				
		IM[38]=32'he3b01000;    //쳲�����
		IM[39]=32'he3b02001;
		IM[40]=32'he0925001;
		IM[41]=32'he1b01002;
		IM[42]=32'he1b02005;
		IM[43]=32'he35500e9;
		IM[44]=32'h18fffff9;
        
        IM[45]=32'he12ff00a; //MSR
		IM[46]=32'he58d5000; //LDR R5 from DM[R13]
		IM[47]=32'he28dd004; //R13+4  20+4=24		
		IM[48]=32'he58d2000; //LDR R2 from DM[R13]
		IM[49]=32'he28dd004; //R13+4  24+4=28
		IM[50]=32'he58d1000; //LDR R1 from DM[R13]
		IM[51]=32'he28dd004; //R13+4 
		IM[52]=32'he58da000; //LDR R10 from DM[R13]
		IM[53]=32'b11100001101000001111000000001110;	//MOV R14 to R15	
	
		IM[54]=32'd0;
		IM[55]=32'd0;
		IM[56]=32'd0;
		
		//TEQ
//		IM[2]=32'he3a0100f;
//		IM[3]=32'he3a0200f;
//		IM[4]=32'he1310002;
//		IM[5]=32'h03a0500f;
//		IM[6]=32'h13a000e;
		
////		//RSB
//		IM[2]=32'he3a0100a;
//		IM[3]=32'he3a0200f;
//		IM[4]=32'he0615002;
//		IM[5]=32'he0415002;
		
		//ADC
//IM[2]=32'hE3A01001;
//IM[3]=32'hE3A02002;
//IM[4]=32'he0520001;
//IM[5]=32'he0a15002;

//IM[2]=32'hE3A05001;
//IM[3]=32'H00000000;
//IM[4]=32'H00000000;
//IM[5]=32'H00000000;
//IM[6]=32'HE5055001;
//IM[7]=32'HE5153001;
//IM[8]=32'H00000000;
//IM[9]=32'H00000000;
//IM[10]=32'H00000000;
//IM[11]=32'HE2856004;
//IM[12]=32'HE203700F;
//IM[13]=32'H00000000;
//IM[14]=32'H00000000;
//IM[15]=32'H00000000;
//IM[16]=32'HE1530007;
//IM[17]=32'H0AFFFFFF;
//IM[18]=32'HE0835007;
//IM[19]=32'HE3837000;
//IM[20]=32'H00000000;
//IM[21]=32'H00000000;
//IM[22]=32'HE2253000;
//IM[23]=32'HE2566001;
//IM[24]=32'H1BFFFFF7;


		end
	
	always@(posedge clk)
		if(IMen)
			Instruction<=IM[Imaddr];
		else 
			Instruction<=32'd0;			
endmodule 