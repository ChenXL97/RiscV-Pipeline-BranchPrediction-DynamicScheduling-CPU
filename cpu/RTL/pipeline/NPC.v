`timescale 1ns / 1ps
module NPC
(
	input Reset,
	input [1:0]NPCop,
	input [31:0]Imm32,
	input [31:0]PC,
	output reg[31:0]NPCout
);
   
	always@(*)
		if(!Reset)
			NPCout=32'd0;
		else 
			case(NPCop)
		2'b00:
			NPCout=PC+32'd4;
		2'b01:
			NPCout=PC+Imm32;
		2'b10:
			NPCout=32'd4;
			
		default:
			NPCout=32'd0;
			
			endcase
endmodule 