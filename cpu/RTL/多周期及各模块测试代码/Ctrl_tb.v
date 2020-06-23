`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/19 21:56:01
// Design Name: 
// Module Name: Ctrl_tb
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


module Ctrl_tb(

    );
    reg clk,rst,N,V,C,Z;
    reg [31:0]instruction;
    wire PCwr,DMwr,RFwr;
    wire [3:0]ALUop;
    wire [1:0]EXTop,NPCop,Rw;
    wire RbSrc,IMen,ALUBSrc,PCtoBL;
    wire [3:0]State;
    
    
     control U_ctrl 
    (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .N(N),
        .V(V),
        .C(C),
        .Z(Z),
        .PCwr(PCwr),
        .DMwr(DMwr),
        .RFwr(RFwr),
        .ALUop(ALUop),
        .EXTop(EXTop),
        .NPCop(NPCop),
        .RbSrc(RbSrc),
        .IMen(IMen),
        .Rw(Rw),
        .ALUBSrc(ALUBSrc),
        .PCtoBL(PCtoBL),
        .State(State)
         
    );



    always begin
        clk=0;
     #100 clk=1;
        #100 clk=0;
       end 
     
     initial begin
        rst=0;
        instruction=32'b1100_01011001_0000_0000_1010_1010_1010; //LDR(I)
        #25;
        rst=1;
        #1000;
        instruction=32'b1100_01010000_0000_0000_1000_0111_0101;//STR(I)
        #1000;
        instruction=32'b1100_000_0100_1_0100_0111_00000000_0101;//ADD(R)
        #1000;
        instruction=32'b1100_1010_1111_1111_1111_1111_0000_0000;//B
        
     end  
     
     
     
     endmodule
