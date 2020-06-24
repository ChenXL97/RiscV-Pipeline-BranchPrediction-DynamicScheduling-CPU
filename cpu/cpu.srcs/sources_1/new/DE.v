`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: DE
// Description: 
// DE段模块
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
    //BTB的输入
    input EX_update,
    input [31:0] EX_ins_pc,
    input [31:0] EX_result_pc,
    //输出
    output predict_is_taken,
    output [31:0] predict_pc,
    output [`ROB_ITEM_INDEX] DE_pip_reg
    );
    
    //Decoder模块
    wire [`ROB_ITEM_INDEX] de_out;
    Decoder Decoder(
        .clk(clk),
        .rst(rst),
        .ins(IF_pip_reg),
        .de_out(de_out)
        );
    
    //BTB模块
    wire branch_is_taken;
    wire DE_is_branch;
    wire [31:0] de_out_pc;

    BTB BTB(
        .clk(clk),
        .rst(rst),
        .DE_is_branch(DE_is_branch), 
        .de_out_pc(de_out_pc), 
        .EX_update(EX_update), 
        .EX_ins_pc(EX_ins_pc), 
        .EX_result_pc(EX_result_pc), 
        .predict_is_taken(predict_is_taken),
        .predict_pc(predict_pc)
        );
        
    //DE流水线寄存器
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
        
     //测试指令是否正确
     reg [`ROB_ITEM_INDEX] de_ins_mem[64:0];
     wire right;
     wire [71:0] act_ins;
     wire [71:0] right_ins;
     wire [31:0] de_imm;
     wire [31:0] imm;
     wire [31:0] right_imm;
     initial begin
        #5
        $readmemb("test_file/de_output.txt",de_ins_mem);//将path路径下得data.txt的数据以二进制的形式写入到data_src_mem中
        $display("%b",de_ins_mem[0]);
        
     end
     
     assign act_ins = DE_pip_reg[167:96];
     assign right_ins = de_ins_mem[pc-2][167:96];
     assign right = (DE_pip_reg[167:96]==right_ins);
//     assign de_imm = de_out[`IMM];
     assign imm = DE_pip_reg[`IMM];
     assign right_imm = de_ins_mem[pc-2][`IMM];
     
endmodule
