module MUX_4_1
(
	input [WIDTH-1:0] MUXin1,
	input [WIDTH-1:0] MUXin2,
	input [WIDTH-1:0] MUXin3,
	input [WIDTH-1:0] MUXin4,
	input [1:0]MUXop,
	output reg [WIDTH-1:0] MUXout
);
parameter WIDTH=32;

	always@(*)
		case(MUXop)
			0:MUXout=MUXin1;
			1:MUXout=MUXin2;
			2:MUXout=MUXin3;
			3:MUXout=MUXin4;
		endcase
endmodule 