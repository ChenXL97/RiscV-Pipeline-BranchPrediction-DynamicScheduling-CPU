module MUX_2_1
(
	input [WIDTH-1:0] MUXin1,
	input [WIDTH-1:0] MUXin2,
	input MUXop,
	output reg [WIDTH-1:0] MUXout
);
parameter WIDTH=32;

	always@(MUXin1 or MUXop or MUXin2)
		if(MUXop==1'b0)
			MUXout=MUXin1;
		else 
			MUXout=MUXin2;
			
endmodule 