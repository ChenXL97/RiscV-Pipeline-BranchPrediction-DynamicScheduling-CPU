`include "headfile.v"


module ALUop
(
	input [31:0] A,
	input [31:0] b,
	input Cin,
	input s,
	input [3:0] ALUop,
	input [31:0]EX_IR,
	input [7:0]Rs,
	output reg [31:0]S,
	output reg C,V,Z,N
);

reg [31:0]B;
reg ShiftC;


parameter [31:0]F = 32'hffffffff;

always @(*)
	begin
		if(EX_IR[27:26]==2'b00)
			if(EX_IR[25])
			begin
				if(EX_IR[11:8]==0)
				begin
				B=b;
				ShiftC=C;
				end
				else
					begin
						B=(b<<((16-EX_IR[11:8])<<1))|(b>>(EX_IR[11:8]<<1));
						ShiftC=B[31];
					end
							
			end
			else 
			begin
				case(EX_IR[6:4])
					`LSLI:
						begin
						if(EX_IR[11:7]==0)
						begin
							B=b;
							ShiftC=C;
						end
						else
							begin
							B=b<<EX_IR[11:7];
							ShiftC=b[32-EX_IR[11:7]];
							end
						end
					`LSLR:
						begin
							if(Rs==0)
							begin
							B=b;
							ShiftC=C;
							end
							else if(Rs<32)
							begin
							B=b<<Rs;
							ShiftC=b[32-Rs];
							end
							else if(Rs==32)
							begin
							B=32'd0;
							ShiftC=b[0];
							end
							else 
							begin
							B=32'd0;
							ShiftC=1'b0;
							end
						end
					`LSRI: 
						begin
						if(EX_IR[11:7]==0)
						begin
							B=32'd0;
							ShiftC=b[31];
						end
						else
							begin
							B=b>>EX_IR[11:7];
							ShiftC=b[EX_IR[11:7]-1];
							end
						end
					`LSRR: 
						
						begin
							if(Rs==0)
							begin
							B=b;
							ShiftC=C;
							end
							else if(Rs<32)
							begin
							B=b>>Rs;
							ShiftC=b[Rs-1];
							end
							else if(Rs==32)
							begin
							B=32'd0;
							ShiftC=b[31];
							end
							else 
							begin
							B=32'd0;
							ShiftC=1'b0;
							end
						end
					`ASRI: 
						begin
							if(EX_IR[11:7]==0)
								if(b[31]==0)
									begin
									B=32'd0;
									ShiftC=b[31];
									end
								else
									begin
									B=32'hffffffff;
									ShiftC=b[31];
									end
							else 
								begin
								if(b[31]==0)
								begin
									B=b>>EX_IR[11:7];
									ShiftC=b[EX_IR[11:7]-1];
								end
								else
									begin
									B=(F<<(32-EX_IR[11:7]))|(b>>(EX_IR[11:7]));
									ShiftC=b[EX_IR[11:7]-1];
									end
								end					
						end
					`ASRR: 
						begin
							if(Rs==0)
									begin
									B=b;
									ShiftC=C;
									end

							else if(Rs<32) 
								begin
								if(b[31]==0)
									begin
									B=b>>Rs;
									ShiftC=b[Rs-1];
									end
								else
									begin
									B=(F<<(32-Rs))|(b>>Rs);
									ShiftC=b[Rs-1];
									end
								end
							else 
								if(b[31]==0)
									begin
									B=32'd0;
									ShiftC=b[31];
									end
								else
									begin
									B=32'hffffffff;
									ShiftC=b[31];
									end
						end
					`RORI: 
						begin
							if(EX_IR[11:7]==0)
							begin
								B={C,b[31:1]};
								ShiftC=b[0];
							end
							else
							begin
							B=(b<<(32-EX_IR[11:7]))|(b>>EX_IR[11:8]);
							ShiftC=b[EX_IR[11:7]-1];
							end
						end
					`RORR: 
						begin
							if(Rs==0)
								begin
								B=b;
								ShiftC=C;
								end
							else if(Rs[4:0]==0)
								begin
								B=b;
								ShiftC=b[31];
								end
							else if(Rs[4:0]>0)
								begin
								B=(b<<(32-Rs))|(b>>Rs);
								ShiftC=b[Rs-1];
								end
						end
					default:
					   begin
					       B=b;
					       ShiftC=C;
					   end
				endcase
			end
					
	end



always @(*)
	begin
		case(ALUop)
		`CMN,`ADD:
			begin
			if(s)
				begin
				{C,S}=A+B;
				if (C==!S[31])
					V=1'b1;
				else
					V=1'b0;
				end
			else
			begin
				S=A+B;
				C=C;
				V=V;
			end
			end
			
		`CMP,`SUB:
			begin
			if(s)
				begin
				{C,S}={1'b1,A}-B;
				if(C)
					V=1'b0;
				else
					V=1'b1;
			
				end
			else
			begin
				S=A-B;
				C=C;
				V=V;
			end
			end
			
			
		`RSB:
			begin
			if(s)
			begin
				{C,S}={1'b1,B}-A;
				if(C)
					V=1'b0;
				else
					V=1'b1;
			end
			else
			begin
			S=B-A;
			C=C;
			V=V;
			end
			end
			
			
		`ADC:
			begin
			 if(s)
			 begin
				{C,S}=A+B+Cin;
				if(C==!S[31])
					V=1'b1;
				else
					V=1'b0;
			end
			else
			begin
				S=A+B+Cin;
			
			C=C;
			V=V;
			end
			end
			
		`SBC:
			begin
			if(s)
				begin
				{C,S}={1'b1,A}-B-!Cin;
				if(C)
					V=1'b0;
				else
					V=1'b1;
			
				end
			else
				begin
				S=A-B-!Cin;
				
			C=C;
			V=V;
			end
			end
		
		
		`RSC:
			begin
			if(s)
			begin
				{C,S}={1'b1,B}-A-!Cin;
				if(C)
					V=1'b0;
				else
					V=1'b1;
			end
			else
			begin
			S=B-A-!Cin;
			
			C=C;
			V=V;
			end
			end
			
		`TST,`AND:
		if(s)
			begin
			S=A&B;
			C=ShiftC;
			V=V;
			end
		else
		begin
			S=A&B;
			C=C;
			V=V;
		end
		`ORR:
		if(s)
		begin
			S=A|B;
			C=ShiftC;
			V=V;
		end
		else
			begin
			S=A|B;
			
			C=C;
			V=V;
			end
		
		`TEQ,`EOR:
		if(s)
		begin
			S=A^B;
		
			C=ShiftC;
			V=V;
		end
		else
		begin
			S=A^B;
			C=C;
			V=V;
			end
			
		`MOV:	
		if(s)
		begin
			S=B;
			C=ShiftC;
			V=V;
		end
		else
			begin
			S=B;
		
			C=C;
			V=V;
			end
			
		`BIC:
		if(s)
		begin
			S=A&(~B);
			C=ShiftC;
			V=V;
		end
		else
		begin
			S=A&(~B);
			
			C=C;
			V=V;
		end
		
		`MVN:
		if(s)
		begin
			S=~B;
			C=ShiftC;
			V=V;
		end
		else
		begin
			S=~B;
			C=C;
			V=V;
			end
			

	
			
	   default:begin S=32'd0;
				C=C;
				V=V;
				end
			
		endcase
	end
		
		always@(*)
			if(s)
				begin
				if(S)
					Z=1'b0;
				else
					Z=1'b1;
				if(S[31])
					N=1'b1;
				else
					N=1'b0;
				
				end
			else
			begin
				Z=Z;
				N=N;
			end
			
endmodule 