module IM
(
	input [31:0]IMaddr,
	input IMen,
	input clk,
	output reg [31:0]Instruction
);
	
	reg [31:0]IM [31:0];
	
	initial 
		begin
		Instruction=0;
		IM[0]=32'b1110_00_1_0100_1_0001_0010_0000_01110100;
		end
	
	always@(posedge clk)
		if(IMen)
			Instruction<=IM[IMaddr];
		else 
			Instruction<=Instruction;			
endmodule 