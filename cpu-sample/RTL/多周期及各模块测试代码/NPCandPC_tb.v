`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/18 09:08:16
// Design Name: 
// Module Name: NPCandPC_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module NPCandPC_tb();
    reg clk,rst,PCwr;
    reg [1:0]NPCop;
    reg [31:0]Imm32;
    reg [31:0]PC;
    wire [31:0]NPC,PCout;

    NPC U_NPC
    (
       .Reset(rst),
       .NPCop(NPCop),
       .PC(PC),
       .Imm32(Imm32),
       .NPCout(NPC)
    );
    
    PC U_PC
    (
        .clk(clk),
        .rst(rst),
        .PCwr(PCwr),
        .NPC(NPC),
        .PCout(PCout)
    );
    
    
    always begin
        clk=0;
        #100
        clk=1;
        #100;
        end
        
        
        initial begin
           $monitor ($time," NPCop=%d PCout=%d",U_NPC.NPCop,U_PC.PCout);

        rst=0;
        PC=32'h10100100;
        Imm32=32'h00123400;
        PCwr=0;
        NPCop=0;
        #50;
        rst=1;
        PCwr=1;
        #200;
        PCwr=0;
        #100
        NPCop=1;
        #200;
        PCwr=1;
        end
        
     
    
    
    
    
    
    
endmodule
