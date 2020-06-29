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

module TOP();
    
//  Simulated clk clock
    reg clk;
    initial begin
        clk <= 1;
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
       #5 rst <= 0;
       #5 rst <= 1;
       #5 rst <= 0;
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
    wire [`ROB_ITEM_INDEX] DISPATCH_pip_reg_w;

    wire [31:0]EX_result_w;
    wire [`ROB_ITEM_INDEX]EX_pip_reg_w;
    wire [`ROB_ITEM_INDEX] MEM_pip_reg_w;
    wire [31:0]MEM_result_w;
    DISPATCH DIAPATCH
    (
        .clk_i(clk),
        .rst_i(rst),
        .DE_pip_reg_i(DE_pip_reg),
        
        //input from MEM_result for WB
        .MEM_result_i(MEM_result_w),
        .MEM_pip_reg_i(MEM_pip_reg_w),
                
        //output EX_pip_reg_o,
        .reg_A_o(reg_A_w),
        .reg_B_o(reg_B_w),
        .imm32_o(imm32_w),
        .DISPATCH_pip_reg_o(DISPATCH_pip_reg_w)
//        .EX_ADD_selected_o(EX_ADD_selected_w),
//        .EX_BRANCH_selected_o(EX_BRANCH_selected_w),
//        .EX_LS_RAM_selected_o(EX_LS_RAM_selected_w)
    );


//#####################################################
//##########   EX Module  #############################
//#####################################################
    wire EX_is_wr_w;
    wire [31:0]ex_reg_B_w;
    EX EX
    (
        .clk_i(clk),
        .rst_i(rst),
        
        
        .reg_A_i(reg_A_w),
        .reg_B_i(reg_B_w),
        .imm32_i(imm32_w),
        .DISPATCH_pip_reg_i(DISPATCH_pip_reg_w),
        
        // For Branch
        .EX_update(EX_update),
        .EX_result_pc_o(EX_result_pc),
        .EX_block(EX_block),
        // EX result
        .EX_result_o(EX_result_w),
        .reg_B_o(ex_reg_B_w),
        //Pipe_reg
        .EX_pip_reg_o(EX_pip_reg_w),

        // write signal
        .EX_is_wr_o(EX_is_wr_w)

    );

//#####################################################
//##########   MEM Module  ############################
//#####################################################

MEM MEM(
        .clk_i(clk),
        .rst_i(rst),
        .EX_pip_reg_i(EX_pip_reg_w),
        .rs2_i(ex_reg_B_w),

        .EX_result_i(EX_result_w),//Address or ALU result
        .MEM_is_write_i(EX_is_wr_w),
        .MEM_pip_reg_o(MEM_pip_reg_w),
        .MEM_result_o(MEM_result_w)
);  
    
endmodule
