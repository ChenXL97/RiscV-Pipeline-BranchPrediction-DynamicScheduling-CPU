module PC
(
	input clk,
	input rst,
	input PCwr,
	input [31:0]NPC,
	output  [31:0]PCout
);
    reg [31:0]PCOut;
    assign PCout=PCOut;
	always@(posedge clk or negedge rst)
		if(!rst)
			PCOut<=0;
		else if(PCwr)
			PCOut<=NPC;
			
			
endmodule 