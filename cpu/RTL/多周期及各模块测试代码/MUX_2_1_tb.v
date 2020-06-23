`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/18 11:23:47
// Design Name: 
// Module Name: MUX_2_1_tb
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


module MUX_2_1_tb(

    );
        reg [31:0]A,B;
        reg op;
        reg [3:0]Rm,Rd;
        wire [3:0]Rb;
        wire [31:0]out;
    MUX_2_1 #32 U_MUX_2_1
    (
         .MUXin1(A),
         .MUXin2(B),
        .MUXop(op),
        .MUXout(out)
    );
    
    MUX_2_1 #4 U_MUX_2_1_Rb
    (
        .MUXin1(Rm),
        .MUXin2(Rd),
        .MUXop(op),
        .MUXout(Rb)
    
    );
    
    initial 
        begin
        op=1'b0;
        A=32'd123;
        Rm=4'b1100;
        Rd=4'b0011;
        B=32'd321;
        #100;
        op=1'b1;
        
        end
    
    
    
endmodule
