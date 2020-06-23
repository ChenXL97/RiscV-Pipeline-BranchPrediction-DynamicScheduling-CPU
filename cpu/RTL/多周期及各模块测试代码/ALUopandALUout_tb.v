`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/17 18:17:05
// Design Name: 
// Module Name: ALUop_tb
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


module ALUopandALUout_tb();
    reg clk;
    reg rst;
    
    reg [31:0]A,B;
    wire [31:0]S,ALUout;
    wire Z,N,C,V;
    reg [3:0]ALUop;

     ALUop U_ALUop
    (
        .A(A),
        .B(B),
        .ALUop(ALUop),
        .S(S),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );
    
    ALUout U_ALUout
    ( 
    
        .clk(clk),
        .rst(rst),
        .S(S),
        .ALUout(ALUout)
    
    
    );
    
    parameter PERIOD=10;
    always begin
        clk=1'b0;
        #PERIOD
        clk=1'b1;
        #PERIOD;
        end
     
     initial begin
        clk=1'b0;
        rst=1'b0;
        A=32'hffffffff;
        B=32'h00000001;
        ALUop=4'b0100;
        #100;
        rst=1'b1;
        
              A=32'd35;
         B=32'd100;
        ALUop=4'b0010;
        #100;
        A=32'd100;
        B=32'd100;
        ALUop=4'b1010;
        #100;
        A=32'hffff;
        B=32'h0ff0;
        ALUop=4'b0000;
        #100
        ALUop=4'b1100;
        #100
        ALUop=4'b0001;
        #100
        ALUop=4'b1101;
        
        
        end
         
       
endmodule
