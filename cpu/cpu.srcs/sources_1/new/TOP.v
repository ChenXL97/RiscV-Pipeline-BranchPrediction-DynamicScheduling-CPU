`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: TOP
// Description: 
// Top file
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP( );
    
//  Simulated clk clock
    reg clk;
    initial begin
        clk <= 0;
    end
        
    always #10 begin
        clk <= ~clk;
    end
        
    always #10 begin
        clk <= ~clk;
    end
    

//  Simulated Reset Signal 
    reg rst;
    initial begin
       #1 rst <= 0;
       #1 rst <= 1;
       #1 rst <= 0;
    end
    
//#####################################################
//##########   IF Module   ############################
//#####################################################
        //Wires to|from DE module
        wire predict_is_taken;  //1 when BTB need to write PC
        wire [31:0]predict_pc;  //Corresponding PC from BTB
    
        wire [31:0] pc;
        wire [31:0]IF_pip_reg;
        
        //Wires to|from EX module
        wire EX_rst; //1 when EX need to flush pipeline
        wire EX_block; //1 when EX need to be stalled
        wire EX_update;  //1 when EX need to write PC
        wire [31:0]EX_result_pc;  //Corresponding PC from EX
    
        //IF module, including PC, InsMem, IF_PipReg
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
//##########   DE Module   ###############################
//#####################################################
    wire [`ROB_ITEM_INDEX] DE_pip_reg;
    
    //DE MOdule,Includees Decoder,BTB, DE_PipReg
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
//##########   DISPATCH Module   #########################
//#####################################################
    wire [31:0]reg_A_w;
    wire [31:0]reg_B_w;
    wire [31:0]imm32_w;
    wire [4:0]opcode_w;    
    wire [`ROB_ITEM_INDEX] DISPATCH_pip_reg_w;
    wire EX_ADD_selected_w;
    wire EX_BRANCH_selected_w;
    wire EX_LS_RAM_selected_w;
    wire [31:0]EX_result_w;
    wire [`ROB_ITEM_INDEX]EX_pip_reg_w;
    
    DISPATCH DIAPATCH
    (
        .clk_i(clk),
        .rst_i(rst),
        .DE_pip_reg_i(DE_pip_reg),
        
        //input from EX_result for WB
        .EX_result_i(EX_result_w),
        .EX_pip_reg_i(EX_pip_reg_w),
                
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
//##########   EX Module  #############################
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
        .EX_result_o(EX_result_w),
        
        //Pipe_reg
        .EX_pip_reg_o(EX_pip_reg_w)

    );
    

    
    
endmodule
