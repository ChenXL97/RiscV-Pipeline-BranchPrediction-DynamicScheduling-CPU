`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/19 20:43:58
// Design Name: 
// Module Name: DM_tb
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


module DM_tb(

    );
    reg clk,DMwr,rst;
    reg [31:0]DMin,DMaddr;
    wire [31:0]DMout;
        
    
    DataMemory U_DataMemory
    (
        .clk(clk),
        .DMin(DMin),
        .DMaddr(DMaddr),
        .DMwr(DMwr),
        .DMout(DMout),
        .rst(rst)
    );
    
    always begin
    clk=0;
    #100
    clk=1;
    #100;
    end
    
    initial begin
        rst=0;
        DMwr=0;
        DMin=32'h12345678;
        DMaddr=32'd15;
                
        #25
        rst=1;
        #100;
        DMwr=1;
        #300
        DMwr=0;
            
   
        
    end
    
    
endmodule
