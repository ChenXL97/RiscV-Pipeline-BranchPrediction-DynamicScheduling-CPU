module control 
(
	input clk,
	input rst,
	input [31:0]instruction,
	input N,V,C,Z,
	output reg PCwr,
	output reg DMwr,
	output reg RFwr,
	output reg[3:0]ALUop,
	output reg[1:0]EXTop,
	output reg[1:0]NPCop,
	output reg RbSrc,
	output reg IMen,
	output reg[1:0]Rw,
	output reg ALUBSrc,
	output reg PCtoBL,
	output [3:0]State
	
);
	wire [3:0]cond;
	wire [1:0]op;
	wire [5:0]funct;
    reg [3:0]state;
    reg [3:0]next;
	assign cond=instruction[31:28];
	assign op=instruction [27:26];
	assign funct = instruction [25:20];
	assign State=state;

	parameter [3:0] IF   = 4'b0000,
						 DCD  = 4'b0001,
						 MA   = 4'b0010,
						 MR   = 4'b0011,
						 MEMWB= 4'b0100,
						 MW   = 4'b0101,
						 EXE  = 4'b0110,
						 ALUWB= 4'b0111,
						 BR   = 4'b1000;
						 
						 
	wire LDR,STR,ADD,SUB,AND,ORR,EOR,MOV,CMP,B,BL,BX; //各指令关键字
		assign LDR=(instruction[20]==1'b1)?1'b1:1'b0;
		assign STR=(instruction[20]==1'b0)?1'b1:1'b0;
		assign ADD=(instruction[24:21]==4'b0100)?1'b1:1'b0;
		assign SUB=(instruction[24:21]==4'b0010)?1'b1:1'b0;
		assign AND=(instruction[24:21]==4'b0000)?1'b1:1'b0;
		assign ORR=(instruction[24:21]==4'b1100)?1'b1:1'b0;
		assign EOR=(instruction[24:21]==4'b0001)?1'b1:1'b0;
		assign MOV=(instruction[24:21]==4'b1101)?1'b1:1'b0;
		assign CMP=(instruction[24:20]==5'b10101)?1'b1:1'b0;
		assign B=(instruction[25:24]==2'b00)?1'b1:1'b0;
		assign BL=(instruction[25:24]==2'b10) ? 1'b1:1'b0;
		assign BX=(instruction[27:20]==8'b00010010)?1'b1:1'b0;
	
	wire EQ,NE,CS,CC,MI,PL,VS,VC,HI,LS,GE,LT,GT,LE,AL; //条件执行
		assign EQ=(cond==4'b0000)?1:0;
		assign NE=(cond==4'b0001)?1:0;
		assign CS=(cond==4'b0010)?1:0;
		assign CC=(cond==4'b0011)?1:0;
		assign MI=(cond==4'b0100)?1:0;
		assign PL=(cond==4'b0101)?1:0;
		assign VS=(cond==4'b0110)?1:0;
		assign VC=(cond==4'b0111)?1:0;
		assign HI=(cond==4'b1000)?1:0;
		assign LS=(cond==4'b1001)?1:0;
		assign GE=(cond==4'b1010)?1:0;
		assign LT=(cond==4'b1011)?1:0;
		assign GT=(cond==4'b1100)?1:0;
		assign LE=(cond==4'b1101)?1:0;
		assign AL=(cond==4'b1110)?1:0;
		

	always @(*)
		case (state)
			IF:	begin
					IMen=1;
					NPCop=2'b00;
					PCwr=1;
					next=DCD;
					PCtoBL=0;
					RFwr=0;
					DMwr=0;
					end
					
			DCD:	if((EQ&&Z)||(NE&&!Z)||(CS&&C)||(CC&&!C)||(MI&&N)||(PL&&!N)||(VS&&V)||(VC&&!V)||(HI&&(!Z&&C))||(LS&&(Z||!C))||(GE&&!(N^V))||(LT&&(N^V))||(LE&&(Z||(N^V)))||AL)
			begin
			
               IMen=0;
					case(op)
					2'b00: 
						begin
						RFwr=0;
						next=EXE;
						ALUop=0;	//ADD...
						if(ADD||SUB||AND||ORR||EOR||MOV||CMP)
							begin
								PCwr=0;
								if(instruction[25])
									begin
										EXTop=2'b00;
										ALUBSrc=1'b1;
									end
								else
									begin
										RbSrc=1'b0;
										ALUBSrc=1'b0;
									end
							end
								
						end
						
						
					2'b01://STR/LDR
					   begin
							PCwr=0;
							RFwr=0;
							next=MA;
							ALUop=0;	
						if(LDR||STR)
							begin
								
								if(!instruction[25])
									begin
										PCwr=0;
										EXTop=2'b01;
										ALUBSrc=1'b1;
									end
								else
									begin
										RbSrc=1'b0;
										ALUBSrc=1'b0;
									end
							end
						end
						
					2'b10://Branch
						begin
							EXTop=2'b10;
							PCwr=0;
							RFwr=0;
							if(B)
								begin
								next=BR;	
								end
							else if(BL)
								begin
								next=BR;
								end
						end
				
					endcase
					end
				else
				    next=IF;
					
				
				MA:			
					begin
						if(instruction[23])
							ALUop=4'b0100;
						else
							ALUop=4'b0010;
					if(STR)
						next=MW;
					else if(LDR)
						next=MR;
					end
				
				MR:
					begin
						PCwr=0;
						next=MEMWB;
						if(LDR)
							DMwr=0;
					end
					
				MEMWB:
					begin
						PCwr=0;
						next=IF;
						if(LDR)
							begin
							RFwr=1;
							Rw=2'b01;
							end
					end
				MW:
					begin
						RbSrc=1'b1;
						DMwr=1'b1;
						next=IF;
						PCwr=0;
					end
				
				EXE:
					begin
						if(ADD||SUB||ORR||EOR||AND||MOV)
							begin
							PCwr=0;
							next=ALUWB;
							ALUop=instruction[24:21];
							end
						else if(CMP)
							begin
							PCwr=0;
							ALUop=CMP;
							next=IF;
							end
					end
								
			ALUWB:
				begin
				next=IF;
					if(ADD||SUB||ORR||EOR||AND||MOV)
						begin
							PCwr=0;
							RFwr=1;
							Rw=2'b00;
						end
				end
			BR:
				begin
					NPCop=1;
					next=IF;
					PCwr=1;
					if(BL)
						PCtoBL=1;
				end		
			
			default: next=IF;
			
			
			endcase
			
			
			
			
	always @(posedge clk or negedge rst)
		if(!rst)
			state<=IF;
		else
			state<=next;
			
	
endmodule 