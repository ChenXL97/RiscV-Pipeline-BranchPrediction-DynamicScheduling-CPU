`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 10:11:35
// Design Name: 
// Module Name: DISPATCH_PipReg
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


module EX_PipReg(
	input clk_i,
	input rst_i,
    input [`ROB_ITEM_INDEX] DISPATCH_PipReg_i,
    output reg[`ROB_ITEM_INDEX] EX_pipreg_o
    );

	always@(posedge clk_i or posedge rst_i)
        if(rst_i)
            EX_pipreg_o<=0;
        else 
            begin   
                EX_pipreg_o<=DISPATCH_PipReg_i;
            end


endmodule
