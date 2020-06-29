`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: TOP
// Description: 
// TOP
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP( );
    
//  clk
    reg clk;
    initial begin
        clk <= 0;
    end
        
    always #10 begin
        clk <= ~clk;
    end
    

//  rst
    reg rst;
    initial begin
       #1 rst <= 0;
       #1 rst <= 1;
       #1 rst <= 0;
    end
    
//#####################################################
//##########   IF   ###############################
//#####################################################
// DE to IF
    wire predict_is_taken;  
    wire [31:0]predict_pc; 
// IF to DE
    wire [31:0] pc;
    wire [31:0]IF_pip_reg;
    
// EX to IF
    wire EX_rst; //为 1 代表EX要清空流水线
    wire EX_block; //为1代表EX要阻塞
    wire EX_update;  //为 1 代表EX要写PC
    wire [31:0]EX_result_pc;  //为EX写PC的具体地址

// IF : PC，InsMem,IF_PipReg
    IF IF
    (
        .clk(clk),
        .rst(rst),
        .EX_block(EX_block),
        .EX_rst(EX_rst),
        .EX_write_pc(EX_update),
        .EX_addr(EX_result_pc),
        .BTB_write_pc(predict_is_taken),
        .BTB_addr(predict_pc),
        .pc(pc),
        .IF_pip_reg(IF_pip_reg)
        
    );

//#####################################################
//##########   DE   ###############################
//#####################################################
// DE to DISPATCH
    wire [`ROB_ITEM_INDEX] DE_pip_reg;
    
    //DE : Decoder，BTB, DE_PipReg
    DE DE
    (
        .clk(clk),
        .rst(rst),
        .EX_rst(EX_rst),
        .IF_pip_reg(IF_pip_reg),
        .pc(pc),
        .EX_update(EX_update),
        .EX_result_pc(EX_result_pc),
        .predict_is_taken(predict_is_taken),
        .predict_pc(predict_pc),
        .DE_pip_reg(DE_pip_reg)
    );

//#####################################################
//##########   DISPATCH   #########################
//#####################################################
// DISPATCH to EX
    wire [31:0]reg_A_w;
    wire [31:0]reg_B_w;
    wire [31:0]imm32_w;
    wire [4:0]opcode_w;    
    wire [`ROB_ITEM_INDEX] DISPATCH_pip_reg_w;
    wire EX_ADD_selected_w;
    wire EX_BRANCH_selected_w;
    wire EX_LS_RAM_selected_w;
    
    DISPATCH DIAPATCH
    (
        .clk_i(clk),
        .rst_i(rst),
        .DE_pip_reg_i(DE_pip_reg),
                
        //output EX_pip_reg_o,
        .reg_A_o(reg_A_w),
        .reg_B_o(reg_B_w),
        .imm32_o(imm32_w),
        .opcode_o(opcode_w),
        .DISPATCH_pip_reg_o(DISPATCH_pip_reg_w),
        .EX_ADD_selected_o(EX_ADD_selected_w),
        .EX_BRANCH_selected_o(EX_BRANCH_selected_w),
        .EX_LS_RAM_selected_o(EX_LS_RAM_selected_w)
    );


//#####################################################
//#####################################################
    wire [31:0]EX_result_w;
//##########   EX   ###############################
//##################################################### 
    EX EX
    (
        .clk_i(clk),
        .rst_i(rst),
        
        
        .reg_A_i(reg_A_w),
        .reg_B_i(reg_B_w),
        .imm32_i(imm32_w),
        .opcode_i(opcode_w),
        .DISPATCH_pip_reg_i(DISPATCH_pip_reg_w),

        //Enable
        .EX_ADD_selected_i(EX_ADD_selected_w),
        .EX_LS_RAM_selected_i(EX_LS_RAM_selected_w),
        .EX_BRANCH_selected_i(EX_LS_RAM_selected_w),
        
        // For Branch
        .EX_update(EX_update),
        .EX_result_pc_o(EX_result_pc),
        .EX_block(EX_block),
        // EX result
        .EX_result_o(EX_result_w)

    );
    
endmodule
