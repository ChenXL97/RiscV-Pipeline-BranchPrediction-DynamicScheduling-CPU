module SignExtend
(
	input [23:0] imm,
	input [1:0] Extop,
	output [31:0] imm32
);
reg [31:0]Imm32;
assign imm32=Imm32;



initial 
Imm32=0;

always@(imm or Extop)
    case(Extop)	
    2'b00:
		begin
			Imm32={24'b0,imm[7:0]};
		end
    2'b01:
		begin
			Imm32={20'b0,imm[11:0]};
		end
	2'b10:
		begin
			if(imm[23]==1)
			Imm32={6'b111111,imm,2'b00};
			else 
			Imm32={6'b000000,imm,2'b00};
		end
	default:Imm32=0;
    endcase
		
endmodule 