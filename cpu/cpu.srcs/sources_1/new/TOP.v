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
wire        [4:0]               ex_rd;

/* decode */
wire        [31:0]              de_cur_pc;






/* dispatch */
wire        [31:0]              dis_cur_pc;
wire        [4:0]               dis_rd;
wire                            dis_forward_a;
wire                            dis_forward_b;




    
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
        wire [31:0]ex_cur_pc_w;
        wire ex_is_branch_w;
        wire BTB_is_taken_w;
        wire [31:0] btb_predict_pc_w;
        wire revert_jump;
        wire [31:0] revert_addr;
        //IF module, including PC, InsMem, IF_PipReg
    IF IF
    (
        .clk(clk),
        .rst(rst),
        .revert_jump(revert_jump),
        .revert_addr(revert_addr),
        .EX_rst(ex_flush),
        .EX_pc_i(ex_cur_pc_w),
        .EX_block(ex_stall),
        .EX_write_pc(EX_update),
        .EX_addr(ex_tar_addr),
        .EX_is_branch(ex_is_branch_w),
        .ex_need_jump(ex_need_jmp),
//        .BTB_write_pc(predict_is_taken),
//        .BTB_addr(predict_pc),
        .pc(pc),
        .IF_pip_reg(IF_pip_reg),
        .BTB_is_taken(BTB_is_taken_w),
        .btb_predict_pc(btb_predict_pc_w)

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
        .ex_stall(ex_stall),
        .IF_pip_reg(IF_pip_reg),
        .BTB_is_taken(BTB_is_taken_w),
        .pc(pc),
        .EX_update(EX_update),
        .EX_result_pc(EX_result_pc),
        .predict_is_taken(predict_is_taken),
        .predict_pc(btb_predict_pc_w),
        .DE_pip_reg(DE_pip_reg),
        .de_cur_pc(de_cur_pc),
        .EX_rst(ex_flush),
        .ex_flush(ex_flush)
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
    wire BTB_dis_ex;
    wire [31:0]BTB_pc_dis_ex;
    DISPATCH DIAPATCH
    (
        .clk_i(clk),
        .rst_i(rst),
        .DE_pip_reg_i(DE_pip_reg),
        .de_cur_pc(de_cur_pc),
        
        //input from MEM_result for WB
        .ex_stall(ex_stall),
                
        //output EX_pip_reg_o,
        .reg_A_o(reg_A_w),
        .reg_B_o(reg_B_w),
        .imm32_o(imm32_w),
        .DISPATCH_pip_reg_o(DISPATCH_pip_reg_w),
        .dis_cur_pc(dis_cur_pc),
        .dis_rd(dis_rd),
        .ex_rd(ex_rd),
        .ex_done(ex_done),
        .ex_res(ex_res),
        .ex_flush(ex_flush),
        .BTB_is_taken(BTB_dis_ex),
        .btb_predict_pc(BTB_pc_dis_ex)
   );



/* *************************** REG_FILE *************************** */
REG_FILE regfile(
    .clk_i                      (clk),
    .rst_i                      (rst),
    .rd0_value_i                (),
    .rd0_i                      (),
    .ra0_i                      (),
    .rb0_i                      (),                 
    .wb_v                       (),
    .ra0_value_o                (),
    .rb0_value_o                ()
);






/* ************************** ROB *********************************/
ROB rob(
    .clk                        (),
    .rst                        (),

    // global control signal
    .ex_flush                   (),
    .rob_stall                  (),

    // signal from exe to help dispatch
    .ex_done                    (),
    .func_part_done             (),

    .rob_info                   (),
    .de_cur_pc                  (),
    
    // send to issuer
    .end_pt                     (),
    .head_pt                    (),
    .related_busy               (),
    .related                    (),
    .hw_relation                (),

    // issue signal from dis-gun
    .issue_v                    (),
    .iss_inst                   (),
    .iss_flag                   (),

    // func_part input result
    .ram_res                    (),
    .branch_res                 (),
    .shift_res                  (),
    .logic_res                  (),
    .cmp_res
    .add_res
    .mul_res
    .div_res
    .sp_res
    .rinfo_res
    .fadd_res
    .fmul_res
    .fdiv_res
    .fsp_res
    .fcmp_res

    // signal output due from write back
    .wb_inst
    .wb_v

    // forward data and it's control signal
    .forwd_data_rs1
    .forwd_data_rs2
    .forwd_data_rs1_v
    .forwd_data_rs2_v

    // prepare data at regfile
    .rs1
    .rs2
    .prepare_rs1_en
    .prepare_rs2_en

    // write data into regfile
    .dst
    .wb_res
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
    .imm_use                (DISPATCH_pip_reg_w[`IMMUSE]),
    .dis_rd                 (dis_rd),
    .op_mode1               (DISPATCH_pip_reg_w[`OP1]),
    .op_mode2               (DISPATCH_pip_reg_w[`OP2]),
    .func_part              (DISPATCH_pip_reg_w[157:143]),
    .ex_done                   (ex_done),
    .ex_res                    (ex_res),
    .ex_tar_addr               (ex_tar_addr),
    .ex_stall                   (ex_stall),
    .ex_flush                   (ex_flush),
    .ex_rd                      (ex_rd),
    .ex_cur_pc            (ex_cur_pc_w),
    .ex_is_branch          (ex_is_branch_w),
    .ex_need_jump           (ex_need_jmp),
    .BTB_is_taken(BTB_dis_ex),
    .BTB_predict_pc(BTB_pc_dis_ex),
    .revert_jump(revert_jump),
    .revert_addr(revert_addr)
    // dis_forward_a               (dis_forward_a),
    // dis_forward_b               (dis_forward_b)
);


endmodule
