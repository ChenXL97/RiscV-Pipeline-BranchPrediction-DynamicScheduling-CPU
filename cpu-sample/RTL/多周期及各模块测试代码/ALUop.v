module ALUop
(
	input [31:0] A,
	input [31:0] B,
	input [3:0] ALUop,
	output reg [31:0]S,
	output Z,N,
	output reg C,V
);

reg [32:0]temp;

always @(*)
	begin
		case(ALUop)
		4'b0100:
			begin
			{C,S}=A+B;
			if (C==!S[31])
				V=1;
			else
				V=0;
			end
		4'b1010,4'b0010:
			begin
			{C,S}={1'b1,A}-B;
			if(C)
				V=0;
			else
				V=1;
			
			end
		4'b0000:
			S=A&B;
		4'b1100:
			S=A|B;
		4'b0001:
			S=A^B;
		4'b1101:
			S=B;
	   default:S=0;
			
		endcase
	end
		
		assign Z=S?1'b0:1'b1;
		assign N=S[31];
	
endmodule 