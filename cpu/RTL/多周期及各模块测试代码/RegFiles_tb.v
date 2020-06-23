`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/18 20:45:18
// Design Name: 
// Module Name: RegFiles_tb
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


module RegFiles_tb(

    );
    
    reg clk,Reset,RegWrite;
    reg[3:0]Ra,Rb,Rw;
    reg[31:0]PC,RFin;
    reg PCtoBL;
    wire [31:0]RFout1,RFout2;    
    
    
    RegFiles U_RegFiles
    (
    .clk(clk),
    .Reset(Reset),
    .RegWrite(RegWrite),
    .RFin(RFin),
    .Ra(Ra),
    .Rb(Rb),
    .Rw(Rw),
    .PC(PC),
    
    .PCtoBL(PCtoBL),
    
    .RFout1(RFout1),
    .RFout2(RFout2) 
    
    );
    
    always begin
        clk=0;
        #50
        clk=1;
        #50;
        end
        
        
    initial begin
     Reset=0;
     PC=32'h12345678;
     PCtoBL=0;
     Rw=4'b0000;
     Ra=4'b0000;
     Rb=4'b0001;
     RFin=32'h43210000;
     
     RegWrite=0;
     #25
     Reset=1;
     RegWrite=1;
     #100
     RegWrite=0;
     Rw=4'b0001;
     RFin=32'h00004321;
     #100
     RegWrite=1;
     #100
     RegWrite=0;
     #100
     Ra=4'd14;
     Rb=4'd15;
     #100
     PCtoBL=1;
     end
     
        
    
    
endmodule
