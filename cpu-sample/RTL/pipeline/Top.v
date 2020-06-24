module Top
(
	input CLK,
	input RST,
	//input IRQ,
	output [7:0]r5,
	output [7:0]SMG_Data,
	output [3:0]Scan_Sig
);
	reg [25:0]count;
	reg clk;
//	wire rst;
//    assign rst=RST;
	 wire IRq;
	 assign IRq=~IRQ;
	reg IRQ; 
	reg rst;
	// wire [7:0]r5;
	always@(posedge CLK or negedge rst)
    if(!rst)
        begin
            clk<=0;
	         count<=0;
         end
   		else
	   if(count==26'd10_000_000)
	       begin
	           clk<=~clk;
	           count<=0;
	       end
	   else
	       count<=count+1'b1;
	
	wire [1:0]NPCop;
	wire [31:0]Imm32_EX,Imm32_ID,Imm32_WB;

	wire IMen;
	wire RegWrite;
	wire Cout,Nout,Zout,Vout;
	wire [3:0]ALUop;
    wire [1:0]Extop_EX,Extop_ID,Extop_WB;
    	wire [31:0]A,B;
    wire [31:0]S;
    wire Z,N,V,C;
    	wire [31:0]Instruction;
    wire [31:0]RFin;
    wire [31:0]RFout1;
    wire [31:0]RFout2;
   // reg [31:0]DMin;
    wire PCwr;
        	wire [31:0]ALUout;
    wire DMwr;
    wire [31:0]DMout;
    wire [1:0]RFin_Mux;
    wire Rb_Mux;
        wire [3:0]Rb;
        wire PCtoBL;
        wire [1:0]ALUA_Mux;
        wire [2:0]ALUB_Mux;
        wire [3:0]State;
        wire [31:0]R5;
        wire [31:0]PCout;
        wire[31:0]NPCout;
	    wire[31:0]ID_IR,EX_IR,MEM_IR,WB_IR;
        reg[31:0] ALUA,ALUB,ALU_MEM;
        wire [31:0]B0,B1;
	    wire s;
	    wire [7:0]ALUrs;
        reg [3:0]CPSR;
        
            

	 assign s=EX_IR[20];
            
        
  assign r5=R5[7:0];
    
    always @(posedge clk or negedge rst)
        if(!rst)
        begin
            ALUA<=32'd0;
            ALUB<=32'd0;
            ALU_MEM<=32'd0;
            CPSR<=32'd0;
          //  DMin<=32'd0;
        end
        else
            begin
            ALUA<=A;
            ALUB<=B;
            ALU_MEM<=ALUout;
            CPSR<={Nout,Zout,Cout,Vout};
         //   DMin<=RFout2;
            end
        
	NPC U_NPC
	(
		.Reset(rst),
		.NPCop(NPCop),// NPC_Op
		.Imm32(Imm32_EX),
		.PC(PCout),
		.NPCout(NPCout)
	);
	
//	PC U_PC
//	(
//		.clk(clk),
//		.rst(rst),
//		.PCwr(PCwr),
//		.NPC(NPCout),
//		.PCout(PCout)
//	);
	
//
//	blk_mem_gen_0 U_IM (
//      .clka(clk),    // input wire clka
//      .ena(IMen),      // input wire ena
//      .addra(PCout),  // input wire [31 : 0] addra
//      .douta(Instruction)  // output wire [31 : 0] douta
//    );
	
	IM U_IM(
		.IMaddr(PCout),
		.IMen(IMen),
		.clk(clk),
		.Instruction(Instruction)
	);
	
	RegFiles U_RegFiles
	(
		.clk(clk),
		.Reset(rst),
		.RegWrite(RegWrite),//RegWrite
		.RFin(RFin),
		.Ra(ID_IR[19:16]),  //Rn
		.Rb(Rb),						  //Rm
		.Rw(WB_IR[15:12]),  //Rd
		//.Rstore(MEM_IR[15:12]),
		.RFout1(RFout1),
		.RFout2(RFout2),
		.PC(PCout),
		.PCtoBL(PCtoBL),
		.R5(R5),
		.Rs(ALUrs),
		.EX_IR_rs(EX_IR[11:8]),
		.PCwr(PCwr),
		.NPC(NPCout),
		.PCout(PCout)
		//.RStore(RStore)
	);
	
      	MUX_4_1 U_A
  (
          .MUXin1(RFout1),
          .MUXin2(S),
          .MUXin3(ALUout),
          .MUXin4(RFin),
          .MUXop(ALUA_Mux),      //MUXop
          .MUXout(A)
  );
	
	MUX_2_1 U_B0
	(
	       .MUXin1(RFout2),
	       .MUXin2(Imm32_ID),
	       .MUXop(ALUB_Mux[0]),
	       .MUXout(B0)
	);
	
  	MUX_4_1 U_B1
	(
			.MUXin1(32'd0),
			.MUXin2(S),
			.MUXin3(ALUout),
			.MUXin4(RFin),
			.MUXop(ALUB_Mux[1:0]),  	//MUXop
			.MUXout(B1)
	);
	
	
        MUX_2_1 U_B
        (
               .MUXin1(B0),
               .MUXin2(B1),
               .MUXop(ALUB_Mux[2]),
               .MUXout(B)
        );

	
	ALUop U_ALU
	(
		.A(ALUA),
		.b(ALUB),
		.Cin(Cout),
		.s(s),
		.ALUop(ALUop),		//ALUop
		.S(S),
		.Z(Z),
		.N(N),
		.V(V),
		.C(C),
		.EX_IR(EX_IR),
		.Rs(ALUrs)
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
		.Vout(Vout),
		.Rm(RFout2),
		.MSR(MSR),
		.S(s)
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
		.MUXin1(ALU_MEM),
		.MUXin2(DMout),
		.MUXin3(Imm32_WB),
		.MUXin4({28'd0,CPSR}),
		.MUXop(RFin_Mux),//	MUX_Op	
		.MUXout(RFin)
	);
	
	
	
	
	MUX_2_1 #4 U_Rb_Mux
	(
		.MUXin1(ID_IR[3:0]),
		.MUXin2(MEM_IR[15:12]),
		.MUXop(Rb_Mux),
		.MUXout(Rb)
	);
	
	SignExtend U_WB_SignExtend
	(
			.imm(WB_IR[23:0]),
			.Extop(Extop_WB), 	//Extop
			.imm32(Imm32_WB)
	);
	
	SignExtend U_ID_SignExtend
	(
			.imm(ID_IR[23:0]),
			.Extop(Extop_ID), 	//Extop
			.imm32(Imm32_ID)
	);

	SignExtend U_EX_SignExtend
	(
			.imm(EX_IR[23:0]),
			.Extop(Extop_EX), 	//Extop
			.imm32(Imm32_EX)
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
	.NPCop(NPCop),
	.RbSrc(Rb_Mux),
	.IMen(IMen),
	.Rw(RFin_Mux),
	.ALUBSrc(ALUB_Mux),
	.ALUASrc(ALUA_Mux),
	.PCtoBL(PCtoBL),
	.ID_IR(ID_IR),
	.EX_IR(EX_IR),
	.MEM_IR(MEM_IR),
	.WB_IR(WB_IR),
	.EXTop_EX(Extop_EX),
	.EXTop_ID(Extop_ID),
	.EXTop_WB(Extop_WB),
	.IRQ(IRq),
	.MSR(MSR)
);


 smg_interface U_SMG
(
     .CLK(CLK),
	 .RSTn(rst),
	 .Number_Sig({8'h00,R5[7:0]}),
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
        IRQ=1;
        #50
        rst=1;
        #1000
        IRQ=0;
        end


endmodule 