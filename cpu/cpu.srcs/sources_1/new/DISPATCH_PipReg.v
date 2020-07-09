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
    input [31:0]imm_value_w,
    output reg [`ROB_ITEM_INDEX] DISPATCH_pipreg_o,
    output reg [31:0] imm_value_r,
    input ex_flush,
    input [31:0] reg_a,
    input [31:0] reg_b,
    output reg [31:0] reg_a_o,
    output reg [31:0] reg_b_o
    );




always @ (posedge clk_i or posedge rst_i) begin
    if(rst_i || ex_flush)
        DISPATCH_pipreg_o<=32'hx;
    else if(ex_stall)
        DISPATCH_pipreg_o <= DISPATCH_pipreg_o;
    else begin   
        DISPATCH_pipreg_o<=DE_PipReg_i;
    end
end

always @ (posedge clk_i or posedge rst_i) begin
    if(rst_i || ex_flush)
        imm_value_r<=0;
    else if(ex_stall)
        imm_value_r <= imm_value_r;
    else begin   
        imm_value_r <= imm_value_w;
    end
end


always @ (posedge clk_i or posedge rst_i) begin
    if(rst_i || ex_flush)
        imm_value_r<=0;
    else if(ex_stall)
        imm_value_r <= imm_value_r;
    else begin   
        imm_value_r <= imm_value_w;
    end
end


always @ (posedge clk_i or posedge rst_i) begin
    if(rst_i || ex_flush)
        reg_a_o <= 'd0;
    else if(ex_stall)
        reg_a_o <= reg_a_o;
    else begin   
        reg_a_o <= reg_a;
    end
end


always @ (posedge clk_i or posedge rst_i) begin
    if(rst_i || ex_flush)
        reg_b_o <= 'd0;
    else if(ex_stall)
        reg_b_o <= reg_b_o;
    else begin   
        reg_b_o <= reg_b;
    end
end



endmodule
