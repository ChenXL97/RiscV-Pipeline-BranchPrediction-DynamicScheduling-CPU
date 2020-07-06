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
        
    always begin
        #1;
        clk <= ~clk;
    end

        

//  Simulated Reset Signal 
    reg rst;
    initial begin
       rst <= 'd1;
       #3;
       rst <= 'd0;
    end




/* reg file wire */
wire        [31:0]              reg_file_rdata;
wire        [31:0]              reg_file_wdata;
wire                            reg_file_rw;
wire        [4:0]               reg_file_addr;



/* ex */
wire                            ex_done;
wire        [31:0]              ex_res;
wire        [31:0]              ex_tar_addr;               
wire                            ex_need_jmp;
wire                            ex_stall;
wire                            ex_flush;

/* decode */
wire        [31:0]              de_cur_pc;






/* dispatch */
wire        [31:0]              dis_cur_pc;




    
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
        .EX_rst(EX_rst),
        .EX_block(ex_stall),
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
        .ex_stall(ex_stall),
        .IF_pip_reg(IF_pip_reg),
        .pc(pc),
        .EX_update(EX_update),
        .EX_result_pc(EX_result_pc),
        .predict_is_taken(predict_is_taken),
        .predict_pc(predict_pc),
        .DE_pip_reg(DE_pip_reg),
        .de_cur_pc(de_cur_pc)
    );

//#####################################################
//##########   DISPATCH Module   #########################
//#####################################################
    wire [31:0]reg_A_w;
    wire [31:0]reg_B_w;
    wire [31:0]imm32_w;  
    wire [`ROB_ITEM_INDEX] DISPATCH_pip_reg_w;

    wire [31:0]EX_result_w;
    wire [`ROB_ITEM_INDEX] EX_pip_reg_w;
    wire [`ROB_ITEM_INDEX] MEM_pip_reg_w;
    wire [31:0]MEM_result_w;
    DISPATCH DIAPATCH
    (
        .clk_i(clk),
        .rst_i(rst),
        .DE_pip_reg_i(DE_pip_reg),
        .de_cur_pc(de_cur_pc),
        
        //input from MEM_result for WB
        .MEM_result_i(MEM_result_w),
        .MEM_pip_reg_i(MEM_pip_reg_w),
        .ex_stall(ex_stall),
                
        //output EX_pip_reg_o,
        .reg_A_o(reg_A_w),
        .reg_B_o(reg_B_w),
        .imm32_o(imm32_w),
        .DISPATCH_pip_reg_o(DISPATCH_pip_reg_w),
        .dis_cur_pc(dis_cur_pc)
        // .EX_ADD_selected_o(EX_ADD_selected_w),
        // .EX_BRANCH_selected_o(EX_BRANCH_selected_w),
        // .EX_LS_RAM_selected_o(EX_LS_RAM_selected_w)
   );


//#####################################################
//##########   EX Module  #############################
//#####################################################
EX ex (
    .clk                    (clk),
    .rst                    (rst),
    .op1                    (reg_A_w),
    .op2                    (reg_B_w),
    .imm_data               (imm32_w),
    .dis_cur_pc             (dis_cur_pc),
    .op_mode1               (DISPATCH_pip_reg_w[`OP1]),
    .op_mode2               (DISPATCH_pip_reg_w[`OP2]),
    .func_part              (DISPATCH_pip_reg_w[157:143]),
    .ex_done                   (ex_done),
    .ex_res                    (ex_res),
    .ex_tar_addr               (ex_tar_addr),
    .ex_need_jmp               (ex_need_jmp),
    .ex_stall                   (ex_stall),
    .ex_flush                   (ex_flush)
);



//#####################################################
//##########  REG FILE  ############################
//#####################################################

// REG_FILE reg_file(
//     .clk                        (clk),
//     .rst                        (rst),
//     .reg_addr                   (reg_file_addr),
//     .reg_rw                     (reg_file_rw),
//     .reg_wdata                  (reg_file_wdata),
//     .reg_rdata                  (reg_file_rdata)
// );


    
endmodule
