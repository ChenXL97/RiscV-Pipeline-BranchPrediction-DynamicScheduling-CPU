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
    input [31:0] de_cur_pc,
    input ex_stall,
    input ex_flush,

    
    output  [31:0]reg_A_o,
    output  [31:0]reg_B_o,
    output [31:0]imm32_o,
    output [4:0]opcode_o,
    output [`ROB_ITEM_INDEX]DISPATCH_pip_reg_o,
    output reg [31:0]btb_predict_pc,
    output reg [31:0] dis_cur_pc,
    output reg [4:0] dis_rd,
    input [4:0] ex_rd,
    input ex_done,
    input [31:0] ex_res,
    output reg BTB_is_taken
    );



reg [31:0] reg_A_tmp;
reg [31:0] reg_B_tmp;



always @ (posedge clk_i) begin
    if(!rst_i && !ex_flush) begin
        if(!ex_stall)
            dis_cur_pc <= de_cur_pc;
        else
            dis_cur_pc <= dis_cur_pc;
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


wire [31:0] dispatch_ra_value_w;
wire [31:0] dispatch_rb_value_w;
wire [`ROB_ITEM_INDEX]DISPATCH_pip_reg_w;


REG_FILES REG_FILES
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    // Write ports
    .rd0_value_i(ex_res),
    .rd0_i(ex_rd),

    // Read ports
    .ra0_i(dispatch_ra_index_w),
    .rb0_i(dispatch_rb_index_w),
    .ra0_value_o(dispatch_ra_value_w),
    .rb0_value_o(dispatch_rb_value_w),
    .ex_done(ex_done)
);


always @ (posedge clk_i) begin
    if(!rst_i && !ex_flush) begin
        if(ex_stall) begin
            dis_rd <= dis_rd;
        end
        else begin
            dis_rd <= DE_pip_reg_i[`DST];
        end
    end
    else begin
        dis_rd <= 'd0;
    end
end



//end



//BTB
//wire BTB_is_taken_w = DE_pip_reg_i[`PREDICT];
always @ (posedge clk_i) begin
    
end

always @ (posedge clk_i) begin
    if(!rst_i && !ex_flush) begin
        if(ex_stall) begin
            BTB_is_taken <= BTB_is_taken;
            btb_predict_pc <=btb_predict_pc;
        end
        else begin
            BTB_is_taken <= DE_pip_reg_i[`PREDICT];
            btb_predict_pc<=DE_pip_reg_i[`PPC];
        end
    end
    else begin
        BTB_is_taken <= 'd0;
        btb_predict_pc<=32'd9999;
    end
end


DISPATCH_PipReg DISPATCH_PipReg
(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .DE_PipReg_i(DE_pip_reg_i),
    .ex_stall(ex_stall),
    .DISPATCH_pipreg_o(DISPATCH_pip_reg_w),
    .imm_value_r(imm32_o),
    .imm_value_w(imm_value_w),
    .reg_a(reg_A_tmp),
    .reg_b(reg_B_tmp),
    .ex_flush(ex_flush),
    .reg_a_o(reg_A_o),
    .reg_b_o(reg_B_o)
);


// Dispatcher

reg forward_a;
reg forward_b;



always @ (negedge clk_i) begin
    if(!rst_i && !ex_flush) begin

         if((ex_rd == dispatch_ra_index_w
            || forward_a)  && ex_rd != 'd0) begin
            reg_A_tmp = ex_res;
        end
          else  if (ex_stall) begin
                reg_A_tmp = reg_A_tmp;
            end 
        else begin
            reg_A_tmp = dispatch_ra_value_w;
        end
    end
    else begin
        reg_A_tmp = 'd0;
    end
end



always @ (posedge clk_i) begin
    if(!rst_i && !ex_flush) begin
        if(ex_rd == dispatch_ra_index_w && ex_rd != 'd0 && ex_done) begin
            forward_a <= 'd1;
        end
        else if (ex_rd == dispatch_ra_index_w && ex_stall) begin
            forward_a <= forward_a;
        end
        else begin
            forward_a <= 'd0;
        end
    end
    else begin
        forward_a <= 'd0;
    end
end


always @ (posedge clk_i) begin
    if(!rst_i && !ex_flush) begin
        if(ex_rd == dispatch_rb_index_w && ex_rd != 'd0 && ex_done) begin
            forward_b <= 'd1;
        end
        else if (ex_rd == dispatch_rb_index_w && ex_stall) begin
            forward_b <= forward_b;
        end
        else begin
            forward_b <= 'd0;
        end
    end
    else begin
        forward_b <= 'd0;
    end
end






always @ (*) begin
    if(!rst_i && !ex_flush) begin
        if(ex_rd == dispatch_rb_index_w || forward_b && ex_rd != 'd0) begin
            reg_B_tmp = ex_res;
        end
        else if (ex_stall) begin
            reg_B_tmp <= reg_B_tmp;
        end
        else begin
            reg_B_tmp = dispatch_rb_value_w;
        end
    end
    else begin
        reg_B_tmp = 'd0;
    end
end





// assign reg_A_o = dispatch_ra_value_w;
// assign reg_B_o = dispatch_rb_value_w;
assign DISPATCH_pip_reg_o = DISPATCH_pip_reg_w;
assign opcode_o = opcode_w;
endmodule