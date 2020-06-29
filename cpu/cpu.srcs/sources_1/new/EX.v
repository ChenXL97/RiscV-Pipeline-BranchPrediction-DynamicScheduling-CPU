`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: EX
// Description: 
// EX module
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EX(
    input clk_i,
    input rst_i,

    input [31:0]reg_A_i,
    input [31:0]reg_B_i,
    input [31:0]imm32_i,
    input [`ROB_ITEM_INDEX] DISPATCH_pip_reg_i,
//    input [4:0]opcode_i,
    
//    input EX_ADD_selected_i,
//    input EX_BRANCH_selected_i,
//    input EX_LS_RAM_selected_i,
    
    output reg EX_rst,
    output reg EX_block,
    output reg EX_update,
    output reg [31:0] EX_result_pc_o,
    output reg [31:0] EX_result_o,
    output [`ROB_ITEM_INDEX] EX_pip_reg_o,
    output [31:0] reg_B_o,
    output reg EX_is_wr_o
    );
    
    initial begin

    end
    
    reg [31:0]REG_A;
    reg [31:0]REG_B;
    reg [31:0]IMM32;
    always @ (posedge clk_i)
    begin
        REG_A <= reg_A_i;
        REG_B <= reg_B_i;
        IMM32 <= imm32_i;  
    end
    assign reg_B_o = REG_B;
    
    wire EX_ADD_selected_i = DISPATCH_pip_reg_i[`ADD];
    wire EX_BRANCH_selected_i=DISPATCH_pip_reg_i[`BRANCH];
    wire EX_LS_RAM_selected_i=DISPATCH_pip_reg_i[`RAM];
    wire [4:0]opcode_i = DISPATCH_pip_reg_i[`OP1_2];
    wire [31:0]PC_i = DISPATCH_pip_reg_i[`OPC];
   
    wire [31:0]EX_ADD_result_o;
    wire [31:0]EX_CMP_result_o;
    wire [31:0]EX_BRANCH_result_o;
    wire [31:0]EX_LOGIC_result_o;
    wire [31:0]EX_LS_RAM_result_o;
    wire EX_BRANCH_Flag;
//    assign operand_A_i = DE_pip_reg[]
    
    EX_ADD EX_ADD(
        .enable_i(EX_ADD_selected_i),
        .op1_op2_i(opcode_i),
        .reg_A_i(REG_A),
        .reg_B_i(REG_B),
        .imm32_i(IMM32),
        .EX_ADD_result_o(EX_ADD_result_o)
        //.Done()
    );
    
    wire LS_RAM_is_wr_o;
    EX_LS_RAM EX_LS_RAM(
        .enable_i(EX_LS_RAM_selected_i),
        .op1_op2_i(opcode_i),
        .reg_A_i(REG_A),
        .reg_B_i(REG_B),
        .imm32_i(IMM32),
        .EX_LS_RAM_address_o(EX_LS_RAM_result_o),
        .is_wr_o(LS_RAM_is_wr_o)
    );

    EX_BRANCH EX_BRANCH(
        .enable_i(EX_BRANCH_selected_i),
        .pc_i(PC_i),
        .op1_op2_i(opcode_i),
        .reg_A_i(REG_A),
        .reg_B_i(REG_B),
        .imm32_i(IMM32),
        .EX_BRANCH_result_o(EX_BRANCH_result_o),
        .EX_BRANCH_Flag(EX_BRANCH_Flag)
    );
    wire [`ROB_ITEM_INDEX]EX_pip_reg_w;
      EX_PipReg EXPipReg(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .DISPATCH_PipReg_i(DISPATCH_pip_reg_i),
      .EX_pipreg_o(EX_pip_reg_w)
      );
    assign EX_pip_reg_o = EX_pip_reg_w;
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        // reset
        EX_rst <= 0;
        EX_block <= 0;
        EX_update <= 0;
        EX_result_pc_o <= 0;
        EX_result_o <= 0;
        EX_is_wr_o <= 1'bx; // 0 read 1 write
    end
    else begin
    
        if (EX_ADD_selected_i) begin
            EX_result_o <= EX_ADD_result_o;
            EX_is_wr_o <= 1'bx;
            EX_update <=  0;
        end    
        if (EX_BRANCH_selected_i) begin
            EX_result_pc_o <= EX_BRANCH_result_o;
            EX_result_o <= EX_BRANCH_result_o;
            EX_is_wr_o<= 1'bx;
            EX_update <=  EX_BRANCH_Flag;
        end
        if (EX_LS_RAM_selected_i) begin
            EX_update<= 0;
            EX_result_o <= EX_LS_RAM_result_o;
            EX_is_wr_o <= LS_RAM_is_wr_o;
        end
    end
end


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



//    // EX Pipeline Register
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
