`include "HeadFile.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/28 12:50:59
// Design Name: 
// Module Name: DISPATCH
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


module DISPATCH(
    input clk_i,
    input rst_i,
    input  [`ROB_ITEM_INDEX]DE_pip_reg_i,
    
    //output EX_pip_reg_o,
    output [31:0]op_A_o,
    output [31:0]op_B_o,
    output [4:0]opcode
    );


wire [31:0] imm_value_w = DE_pip_reg_i[`IMM];


//---------------------------------------------------------------------
//Register File
//---------------------------------------------------------------------
wire [4:0] dispatch_ra_index_w = DE_pip_reg_i[`RS1];
wire [4:0] dispatch_rb_index_w = DE_pip_reg_i[`RS2];
wire [4:0] pipe_rd_wb_w; // data forwarding
wire [31:0] pipe_result_wb_w; //data forwarding


wire [31:0] dispatch_ra_value_w;
wire [31:0] dispatch_rb_value_w;


REG_FILES REG_FILES
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    // Write ports
    .rd0_value_i(pipe_result_wb_w),
    .rd0_i(pipe_rd_wb_w),

    // Read ports
    .ra0_i(dispatch_ra_index_w),
    .rb0_i(dispatch_rb_index_w),
    .ra0_value_o(dispatch_ra_value_w),
    .rb0_value_o(dispatch_rb_value_w)
);

assign op_A_o = dispatch_ra_value_w;
assign op_B_o = dispatch_rb_value_w;

endmodule