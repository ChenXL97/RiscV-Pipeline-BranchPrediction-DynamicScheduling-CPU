`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: DE
// Description: 
// DE��ģ��
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DE(
    input clk,
    input rst,
    input EX_rst,
    input [31:0] IF_pip_reg,
    input [31:0] pc,
    //BTB������
    input EX_update,
    input [31:0] EX_ins_pc,
    input [31:0] EX_result_pc,
    //���
    output predict_is_taken,
    output [31:0] predict_pc,
    output reg [`ROB_ITEM_LEN] DE_pip_reg
    );
    
    //Decoderģ��
    wire [`DE_OUT_LEN] de_out;
    Decoder Decoder(
        .clk(clk),
        .rst(rst),
        .ins(IF_pip_reg),
        .de_out(de_out)
        );
    
    //BTBģ��
    wire branch_is_taken;
    wire DE_is_branch;
    wire [31:0] DE_ins_pc;

    BTB BTB(
        .clk(clk),
        .rst(rst),
        .DE_is_branch(DE_is_branch), 
        .DE_ins_pc(DE_ins_pc), 
        .EX_update(EX_update), 
        .EX_ins_pc(EX_ins_pc), 
        .EX_result_pc(EX_result_pc), 
        .predict_pc(predict_pc)
        );
        
    //DE��ˮ�߼Ĵ���
    DE_PipReg DE_PipReg(
        .clk(clk),
        .rst(rst),
        .EX_rst(EX_rst),
        .predict_is_taken(predict_is_taken),
        .de_out(de_out),
        .pc(pc),
        .predict_pc(predict_pc),
        .DE_pip_reg(DE_pip_reg)
        );
        
endmodule
