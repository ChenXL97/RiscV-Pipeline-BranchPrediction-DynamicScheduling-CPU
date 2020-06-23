module Top
(
	//input clk,
	//input rst
	input CLK,
	input RST,
	output [7:0]r5,
	output [7:0]SMG_Data,
	output [3:0]Scan_Sig
);
	//reg [25:0]count;
	reg clk;
	reg rst;
  //  assign rst=!RST;
	
//	always@(posedge CLK or negedge rst)
//    if(!rst)
//        begin
//            clk<=0;
//            count<=0;
//         end
//         else
//	   if(count==26'd10_000_000)
//	       begin
//	           clk<=!clk;
//	           count<=0;
//	       end
//	   else
//	       count<=count+1;
	
	wire [1:0]NPCop;
	wire [31:0]Imm32;
	wire [31:0]PCout;
	 wire[31:0]NPCout;
	wire IMen;
	wire RegWrite;
	wire Cout,Nout,Zout,Vout;
	wire [3:0]ALUop;
    wire [1:0]Extop;
    	wire [31:0]B;
    wire [31:0]S;
    wire Z,N,V,C;
    	wire [31:0]Instruction;
    wire [31:0]RFin;
    wire [31:0]RFout1;
    wire [31:0]RFout2;
    wire PCwr;
        	wire [31:0]ALUout;
    wire DMwr;
    wire [31:0]DMout;
    wire [1:0]RFin_Mux;
    wire Rb_Mux;
        wire [3:0]Rb;
        wire PCtoBL;
        wire ALUB_Mux;
        wire [3:0]State;
        wire [31:0]R5;
  assign r5=R5[7:0];
        
	NPC U_NPC
	(
		.Reset(rst),
		.NPCop(NPCop),// NPC_Op
		.Imm32(Imm32),
		.PC(PCout),
		.NPCout(NPCout)
	);
	
	PC U_PC
	(
		.clk(clk),
		.rst(rst),
		.PCwr(PCwr),
		.NPC(NPCout),
		.PCout(PCout)
	);
	

	blk_mem_gen_0 U_IM (
      .clka(clk),    // input wire clka
      .ena(IMen),      // input wire ena
      .addra(PCout),  // input wire [31 : 0] addra
      .douta(Instruction)  // output wire [31 : 0] douta
    );

	
	RegFiles U_RegFiles
	(
		.clk(clk),
		.Reset(rst),
		.RegWrite(RegWrite),//RegWrite
		.RFin(RFin),
		.Ra(Instruction[19:16]),  //Rm
		.Rb(Rb),						  //Rn
		.Rw(Instruction[15:12]),  //Rm
		.RFout1(RFout1),
		.RFout2(RFout2),
		.PC(PCout),
		.PCtoBL(PCtoBL),
		.R5(R5)
	);
	

	
  	MUX_2_1 U_MUX_2_1
	(
			.MUXin1(RFout2),
			.MUXin2(Imm32),
			.MUXop(ALUB_Mux),  	//MUXop
			.MUXout(B)
	);
	

	
	ALUop U_ALU
	(
		.A(RFout1),
		.B(B),
		.ALUop(ALUop),		//ALUop
		.S(S),
		.Z(Z),
		.N(N),
		.V(V),
		.C(C)
	);
	
	
	ALUout U_ALUout
	(
		.clk(clk),
		.rst(rst),
		.S(S),
		.ALUout(ALUout)
	);
	
	CPSR U_CPSR
	(	
		.clk(clk),
		.rst(rst),
		.Nin(N),
		.Zin(Z),
		.Cin(C),
		.Vin(V),
		.Nout(Nout),
		.Zout(Zout),
		.Cout(Cout),
		.Vout(Vout)
	);
	
	DataMemory U_DataMemory
	(
		.clk(clk),
		.DMin(RFout2),
		.DMaddr(ALUout),
		.DMwr(DMwr),	//DMwr
		.DMout(DMout),
		.rst(rst)
	);
	
	
	MUX_4_1  U_RFin_Mux
	(
		.MUXin1(ALUout),
		.MUXin2(DMout),
		.MUXin3(Imm32),
		.MUXin4(0),
		.MUXop(RFin_Mux),//	MUX_Op	
		.MUXout(RFin)
	);
	
	
	
	
	MUX_2_1 #4 U_Rb_Mux
	(
		.MUXin1(Instruction[3:0]),
		.MUXin2(Instruction[15:12]),
		.MUXop(Rb_Mux),
		.MUXout(Rb)
	);
	
	SignExtend U_SignExtend
	(
			.imm(Instruction[23:0]),
			.Extop(Extop), 	//Extop
			.imm32(Imm32)
	);
	
	control  U_control
(
	.clk(clk),
	.rst(rst),
	.instruction(Instruction),
	.N(Nout),
	.V(Vout),
	.C(Cout),
	.Z(Zout),
	.PCwr(PCwr),
	.DMwr(DMwr),
	.RFwr(RegWrite),
	.ALUop(ALUop),
	.EXTop(Extop),
	.NPCop(NPCop),
	.RbSrc(Rb_Mux),
	.IMen(IMen),
	.Rw(RFin_Mux),
	.ALUBSrc(ALUB_Mux),
	.PCtoBL(PCtoBL),
	.State(State)
);


 smg_interface U_SMG
(
    .CLK(CLK),
	 .RSTn(rst),
	 .Number_Sig({8'h4f,r5}),
	 .SMG_Data(SMG_Data),
	 .Scan_Sig(Scan_Sig)
);


    always begin
        clk=0;
        #100 clk=1;
        #100;
        end
    initial begin
        rst=0;
        #50
        rst=1;
        end


endmodule 