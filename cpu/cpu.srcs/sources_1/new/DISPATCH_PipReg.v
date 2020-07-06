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


module DISPATCH_PipReg(
	input clk_i,
	input rst_i,
    input [`ROB_ITEM_INDEX] DE_PipReg_i,
    input ex_stall,
    output reg[`ROB_ITEM_INDEX] DISPATCH_pipreg_o
    );




always @ (posedge clk_i or posedge rst_i) begin
    if(rst_i)
        DISPATCH_pipreg_o<=0;
    else if(ex_stall)
        DISPATCH_pipreg_o <= DISPATCH_pipreg_o;
    else begin   
        DISPATCH_pipreg_o<=DE_PipReg_i;
    end
end


endmodule
