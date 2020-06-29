`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 10:54:13
// Design Name: 
// Module Name: Dispatcher
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


module Dispatcher(
    input clk_i,
    input rst_i,
    input [`ROB_ITEM_INDEX] DE_PipReg_i,
    output EX_ADD_selected_o,
    output EX_BRANCH_selected_o,
    output EX_LS_RAM_selected_o
    );


assign EX_ADD_selected_o = DE_PipReg_i[`ADD];
assign EX_BRANCH_selected_o = DE_PipReg_i[`BRANCH];
assign EX_LS_RAM_selected_o = DE_PipReg_i[`RAM];

endmodule
