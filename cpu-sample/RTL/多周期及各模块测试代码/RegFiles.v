module RegFiles
(
input clk,
input Reset,
input RegWrite,
input [31:0]RFin,
input [3:0]Ra,
input [3:0]Rb,
input [3:0]Rw,
input [31:0]PC,

input PCtoBL,

output [31:0]RFout1,
output [31:0]RFout2,
output [31:0]R5
);
reg [31:0] RF[15:0];
reg [4:0]index;
always @(posedge clk or negedge Reset)
	if(!Reset)
		begin
			for(index=0;index<16;index=index+1)
				RF[index]=0;
		end

	else begin
	if(RegWrite)
		RF[Rw]<=RFin;
		
	if(PCtoBL)
		RF[14]<=RF[15]+4;	
	RF[15]=PC-4;
	end

	
assign RFout1=RF[Ra];
assign RFout2=RF[Rb];
assign R5=RF[5];
		
endmodule 	