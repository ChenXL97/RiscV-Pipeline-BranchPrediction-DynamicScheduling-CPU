module CPSR
(
	input clk,
	input rst,
	input Nin,
	input Zin,
	input Cin,
	input Vin,
	input S,
	output reg Nout,
	output reg Zout,
	output reg Cout,
	output reg Vout,
	input [31:0]Rm,
    input MSR
);


	always @ (posedge clk or negedge rst)
		if(!rst)
			begin
				Nout<=0;
				Zout<=0;
				Cout<=0;
				Vout<=0;
			end
		else if(MSR)
			begin
				Nout<=Rm[3];
				Zout<=Rm[2];
				Cout<=Rm[1];
				Vout<=Rm[0];
			end
		else if(S)
		  begin
        	   Nout<=Nin;
               Zout<=Zin;
               Cout<=Cin;
               Vout<=Vin;
		  end
		 else
		  begin
		  Nout<=Nout;
		  Zout<=Zout;
		  Cout<=Cout;
		  Vout<=Vout;
		  end
				
	endmodule 