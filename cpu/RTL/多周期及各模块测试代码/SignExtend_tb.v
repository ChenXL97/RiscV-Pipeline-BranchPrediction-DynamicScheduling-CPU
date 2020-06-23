`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/18 20:34:03
// Design Name: 
// Module Name: SignExtend_tb
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


module SignExtend_tb(

    );
    reg [23:0]imm;
    reg [1:0]Extop;
    wire [31:0]imm32;
    
    
     SignExtend U_SignExtend
    (
        .imm(imm),
        .Extop(Extop),
        .imm32(imm32)
    );
    
    
    initial
    begin 
        imm=24'h123456;
        Extop=2'b00;
        #100
        Extop=2'b01;
        #100
        Extop=2'b10;
        #100
        imm=24'hffffff;
        Extop=2'b00;
        #100
        Extop=2'b01;
        #100
        Extop=2'b10;
    end
        
endmodule
