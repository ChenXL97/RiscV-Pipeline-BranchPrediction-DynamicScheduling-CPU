module CPSR
(
	input clk,
	input rst,
	input Nin,
	input Zin,
	input Cin,
	input Vin,
	output reg Nout,
	output reg Zout,
	output reg Cout,
	output reg Vout
);


	always @ (posedge clk or negedge rst)
		if(!rst)
			begin
				Nout<=0;
				Zout<=0;
				Cout<=0;
				Vout<=0;
			end
		else 
			begin
				Nout<=Nin;
				Zout<=Zin;
				Cout<=Cin;
				Vout<=Vin;
			end
				
	endmodule 