module PC
(
	input clk,
	input rst,
	input PCwr,
	input [31:0]NPC,
	output reg [31:0]PCout
);
  always@(posedge clk or negedge rst)
		if(!rst)
			PCout<=0;
		else if(PCwr)
			PCout<=NPC;
			
			
endmodule 