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

always @(posedge rst or posedge clk)
if(rst)
	begin
		Dmout=32'bx;
		for(index=0;index<6'd32;index=index+1'b1)
			DM[index]=index;
		DM[0]=6;
		DM[1]=1;
		DM[2]=1;
		DM[3]=13;
	end
else
	if(DMwr==1) begin
		DM[DMaddr>>2]<=DMin;
		Dmout<=32'bx;
	end
	else if(DMwr==0)
		Dmout<=DM[DMaddr>>2];
    else
        Dmout<=DMaddr;// Pass Value

	
		
		
endmodule 