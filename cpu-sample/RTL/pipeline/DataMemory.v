module DataMemory
(
	input clk,
	input [31:0]DMin,
	input [31:0]DMaddr,
	input DMwr,
	output  [31:0]DMout,
	input rst
);

reg [31:0]Dmout;

reg [6:0]index;
reg [31:0] DM[31:0];
assign DMout=Dmout;

always @(negedge rst or posedge clk)
if(!rst)
	begin
		Dmout=0;
		for(index=0;index<6'd32;index=index+1'b1)
			DM[index]=0;
	end
else
	if(DMwr==1)
		DM[DMaddr]<=DMin;
	else if(!DMwr)
		Dmout<=DM[DMaddr];

	
		
		
endmodule 