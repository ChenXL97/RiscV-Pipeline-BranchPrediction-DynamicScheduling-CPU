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
    input  [`ROB_ITEM_INDEX] DE_pip_reg_i,
    input [31:0] MEM_result_i,
    input [`ROB_ITEM_INDEX] MEM_pip_reg_i,
    input [31:0] de_cur_pc,
    input ex_stall,
    
    output [31:0]reg_A_o,
    output [31:0]reg_B_o,
    output [31:0]imm32_o,
    output [4:0]opcode_o,
    output [`ROB_ITEM_INDEX]DISPATCH_pip_reg_o,
    output reg [31:0] dis_cur_pc
    
    //Select Unit to calculate
//    output  EX_ADD_selected_o,
//    output  EX_BRANCH_selected_o,
//    output  EX_LS_RAM_selected_o
    );


always @ (posedge clk_i) begin
    if(!rst_i) begin
        dis_cur_pc <= de_cur_pc;
    end 
    else begin
        dis_cur_pc <= 'd0;
    end
end


wire [31:0] imm_value_w = DE_pip_reg_i[`IMM];


//---------------------------------------------------------------------
//Register File
//---------------------------------------------------------------------
wire [4:0] dispatch_ra_index_w = DE_pip_reg_i[`RS1];
wire [4:0] dispatch_rb_index_w = DE_pip_reg_i[`RS2];
wire [4:0] opcode_w = DE_pip_reg_i[`OP1_2];
wire [4:0] pipe_rd_wb_w = MEM_pip_reg_i[`DST]; // data forwarding & write back
wire [31:0] pipe_result_wb_w = MEM_result_i; //write back signal


wire [31:0] dispatch_ra_value_w;
wire [31:0] dispatch_rb_value_w;
wire [`ROB_ITEM_INDEX]DISPATCH_pip_reg_w;


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


// TODO Bypass
//reg [31:0] issue_ra_value_r;
//reg [31:0] issue_rb_value_r;

//always@*
//begin
//    issue_ra_value_r = dispatch_ra_value_w;
//    issue_rb_value_r = dispatch_rb_value_w;
    
//    //Bypass - WB
//    if (pipe_rd_wb_w == dispatch_ra_index_w)
//        issue_rb_value_r = pipe_result_wb_w;
//    if (pipe_rd_wb_w==dispatch_rb_index_w)
//        issue_rb_value_r = pipe_result_wb_w;



//end



DISPATCH_PipReg DISPATCH_PipReg
(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .DE_PipReg_i(DE_pip_reg_i),
    .ex_stall(ex_stall),
    .DISPATCH_pipreg_o(DISPATCH_pip_reg_w)

);


// Dispatcher



//assign EX_ADD_selected_o = EX_ADD_selected_w;
//assign EX_BRANCH_selected_o = EX_BRANCH_selected_w;
//assign EX_LS_RAM_selected_o = EX_LS_RAM_selected_w;

// Abundunt code, maybe useful in future.
//Dispatcher Dispatcher
//(
//    .clk_i(clk_i),
//    .rst_i(rst_i),
//    .DE_PipReg_i(DE_pip_reg_i),
//    .EX_ADD_selected_o(EX_ADD_selected_w),
//    .EX_BRANCH_selected_o(EX_BRANCH_selected_w),
//    .EX_LS_RAM_selected_o(EX_LS_RAM_selected_w)
//);


assign reg_A_o = dispatch_ra_value_w;
assign reg_B_o = dispatch_rb_value_w;
assign DISPATCH_pip_reg_o = DISPATCH_pip_reg_w;
assign imm32_o = imm_value_w;
assign opcode_o = opcode_w;
endmodule