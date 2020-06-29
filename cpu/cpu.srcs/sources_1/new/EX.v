`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: EX
// Description: 
// EX段模块
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EX(
    input clk,
    input rst,
    input [`ROB_ITEM_INDEX] DE_pip_reg,
    output reg EX_rst,
    output reg EX_block,
    output reg EX_update,
    output reg [31:0] EX_result_pc
    );
    
    initial begin
        EX_rst <= 0;
        EX_block <= 0;
        EX_update <= 0;
        EX_result_pc <= 0;
    end
    
    wire [4:0]op1_op2;
    wire [31:0]operand_A_i;
    wire [31:0]operand_B_i;
    wire [31:0]EX_ADD_result_o;
    wire [31:0]EX_CMP_result_o;
    wire [31:0]EX_BRANCH_result_o;
    wire [31:0]EX_LOGIC_result_o;
    wire [31:0]EX_LS_RAM_result_o;
    
//    assign operand_A_i = DE_pip_reg[]
    
//    EX_ADD EX_ADD(
//        .enable()
//        .op1_op2_i(op1_op2),
//        .operand_A_i(operand_A_i),
//        .operand_B_i(operand_B_i),
//        .EX_ADD_result_o(EX_ADD_result_o)
//        .Done()
//    );
    
//    EX_CMP EX_CMP(
//        .op1_op2_i(op1_op2),
//        .operand_A_i(operand_A_i),
//        .operand_B_i(operand_B_i),
//        .EX_CMP_result_o(EX_CMP_result_o)
//    );

//    EX_LOGIC EX_LOGIC(
//        .op1_op2_i(op1_op2),
//        .operand_A_i(operand_A_i),
//        .operand_B_i(operand_B_i),
//        .EX_LOGIC_result_o(EX_LOGIC_result_o)
//    );

//    EX_LS_RAM EX_LS_RAM(
//        .op1_op2_i(op1_op2),
//        .operand_A_i(operand_A_i),
//        .operand_B_i(operand_B_i),
//        .EX_LS_RAM_result_o(EX_LS_RAM_result_o)
//    );

//    EX_BRANCH EX_BRANCH(
//        .op1_op2_i(op1_op2),
//        .operand_A_i(operand_A_i),
//        .operand_B_i(operand_B_i),
//        .EX_BRANCH_result_o(EX_BRANCH_result_o)
//    );


//    //DE流水线寄存器
//    EX_PipReg EX_PipReg(
//        .clk(clk),
//        .rst(rst),
//        .EX_rst(EX_rst),
//        .predict_is_taken(predict_is_taken),
//        .de_out(de_out),
//        .pc(pc),
//        .predict_pc(predict_pc),
//        .DE_pip_reg(DE_pip_reg)
//        );  
        
      
endmodule
