`timescale 1ns / 1ps
module NPC
(
	input Reset,
	input [1:0]NPCop,
	input [31:0]Imm32,
	input [31:0]PC,
	output [31:0]NPCout
);
   reg [31:0]NPCOut;
   assign NPCout=NPCOut;
   
	always@(*)
		if(!Reset)
			NPCOut=32'b0;
		else if(NPCop==2'b00)
			NPCOut=PC+32'd4;
		else if(NPCop==2'b01)
			NPCOut=PC+32'd8+Imm32;
    
endmodule 