module ALUout
(
	input clk,
	input rst,
	input [31:0]S,
	output reg [31:0]ALUout
);

always @(negedge rst or posedge clk)
	if(!rst)
	ALUout<=0;
	else
	ALUout<=S;
	
endmodule 