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
input [3:0]EX_IR_rs,
input PCtoBL,
input [3:0] CPSR,

output [31:0]RFout1,
output [31:0]RFout2,
output [31:0]R5,

input PCwr,
input [31:0]NPC,
output  [31:0]PCout,


output [7:0]Rs
);


reg [31:0] RF[15:0];
reg [4:0]index;


always @(posedge clk or negedge Reset)
	if(!Reset)
		begin
			for(index=5'd0;index<5'd16;index=index+1'b1)
				if(index==13)
				RF[index]=32'd28;
				else if(index==15)
				RF[index]=32'd8;
				else
				RF[index]=32'd0;
		end

	else begin
	if(RegWrite && Rw!=4'd15)
		RF[Rw]<=RFin;
	else 
		RF[Rw]<=RF[Rw];
	
	if(PCtoBL)
		begin
		RF[14]<=RF[15]+8;	
		end
		else
		begin
		RF[14]<=RF[14];
		end
		
	if(Rw==4'd15 && RegWrite)
	   RF[15]<=RFin;
	else if(PCwr)
		RF[15]<=NPC;
	else
		RF[15]<=RF[15];
	end		
			

	
	
assign RFout1=RF[Ra];
assign RFout2=RF[Rb];
assign R5=RF[5];
assign Rs=RF[EX_IR_rs][7:0];
assign PCout=RF[15];
		
endmodule 	