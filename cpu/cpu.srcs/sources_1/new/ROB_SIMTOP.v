/***************************************************************************************************
                                THE PROJECT IS DESIGNED AND CODED BY
                                            WINTERS WEN
                                NATIONAL UNIVERSITY OF DEFENSE TECHNOLOGY

                                            /
                                          / -----------
                                        /   \      /
                                              \  /
                                               /
                                           /       \
                                        /      *       \
                                    /            *          \
                                               *
                                                 *
                                
***************************************************************************************************/
`include "HeadFile.vh"
`timescale 1ns/100ps


/* THIS MODULE IS USED TO SIMULATE ROB FUNCTION */


module rob_top();

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



reg         [14:0]                  func_part_done;
reg         [31:0]                  de_cur_pc;
reg         [`ROB_ITEM_INDEX]       rob_info;
reg         [31:0]                  cnter;
reg                                 ex_done;


reg       [31:0]                          ram_res;
reg       [31:0]                          branch_res;
reg       [31:0]                          shift_res;
reg       [31:0]                          logic_res;
reg       [31:0]                          cmp_res;
reg       [31:0]                          add_res;
reg       [31:0]                          mul_res;
reg       [31:0]                          div_res;
reg       [31:0]                          sp_res;
reg       [31:0]                          rinfo_res;
reg       [31:0]                          fadd_res;
reg       [31:0]                          fmul_res;
reg       [31:0]                          fdiv_res;
reg       [31:0]                          fsp_res;
reg       [31:0]                          fcmp_res;





always @ (posedge clk) begin
    if(!rst) begin
        cnter <= cnter + 'd1;
    end
    else begin
        cnter <= 'd0;
    end
end



always @ (posedge clk) begin
    if(!rst) begin
        if(cnter == 'd3)
            de_cur_pc <= de_cur_pc + 'd1;
        if(cnter == 'd4)
            de_cur_pc <= de_cur_pc + 'd1;
        if(cnter == 'd5)
            de_cur_pc <= de_cur_pc + 'd1;
        if(cnter == 'd6)
            de_cur_pc <= de_cur_pc + 'd1;
    end
    else  begin
        de_cur_pc <= 'd12;
    end
end



/* test serial: 
    adder r2, r2, r3
    fadd  r7, r7, r7
    adder r3, r7, r7
    adder r3, r7, r5
     */
always @ (posedge clk) begin
    if(!rst) begin
        if(cnter == 'd3) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd3;
            rob_info[`RS1] <= 'd2;
            rob_info[`RS2] <= 'd2;
            rob_info[`ADD] <= 'd1;
        end

        else if(cnter == 'd4) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd7;
            rob_info[`RS1] <= 'd7;
            rob_info[`RS2] <= 'd7;
            rob_info[`FADD] <= 'd1;
        end

        else if(cnter == 'd5) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd7;
            rob_info[`RS1] <= 'd7;
            rob_info[`RS2] <= 'd3;
            rob_info[`ADD] <= 'd1;
        end

        else if(cnter == 'd6) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd5;
            rob_info[`RS1] <= 'd3;
            rob_info[`RS2] <= 'd7;
            rob_info[`ADD] <= 'd1;
        end

        else begin
            rob_info <= 'd0;
        end

    end
    else  begin
        rob_info <= 'd0;
    end
end






always @ (posedge clk) begin
    if(!rst) begin
        if(cnter == 'd6) begin
            ex_done <= 'd1;
            func_part_done[`ADD_USE] <= 'b1;
            add_res <= 'd1234;
        end
        else if(cnter == 'd7) begin
            ex_done <= 'd1;
            func_part_done[`FADD_USE] <= 'b1;
            func_part_done[`ADD_USE] <= 'b0;
            fadd_res <= 'd5678;
        end
        else if(cnter == 'd10) begin
            ex_done <= 'd1;
            func_part_done[`FADD_USE] <= 'b0;
            func_part_done[`ADD_USE] <= 'b1;
            add_res <= 'd7890;
        end

        else begin
            ex_done <= 'd0;
            func_part_done <= 'd0;
            add_res <= 'd0;
            fadd_res <= 'd0;
        end
    end
    else begin
        ex_done <= 'd0;
        func_part_done <= 'd0;
        add_res <= 'd0;
        fadd_res <= 'd0;
    end
end






wire        [3:0]                       end_pt;
wire        [3:0]                       head_pt;
wire        [9:0]                       related;
wire        [9:0]                       related_busy;
wire        [9:0]                       hw_relation;
wire        [9:0]                       hw_relation_busy;
wire                                    issue_v;
wire        [3:0]                       iss_inst;
wire        [9:0]                       iss_flag;
wire        [3:0]                       wb_inst;
wire                                    wb_v;





ROB rob(
    .clk                            (clk),
    .rst                            (rst),
    .rob_info                       (rob_info),
    .de_cur_pc                      (de_cur_pc),
    .ex_done                        (ex_done),
    .func_part_done                 (func_part_done),
    .end_pt                         (end_pt),
    .head_pt                        (head_pt),
    .related_busy                   (related_busy),
    .related                        (related),
    .hw_relation                    (hw_relation),
    .issue_v                        (issue_v),
    .iss_inst                       (iss_inst),
    .iss_flag                       (iss_flag),
    .ram_res                        (ram_res),
    .branch_res                     (branch_res),
    .shift_res                      (shift_res),
    .logic_res                      (logic_res),
    .cmp_res                        (cmp_res),
    .add_res                        (add_res),
    .mul_res                        (mul_res),
    .div_res                        (div_res),
    .sp_res                         (sp_res),
    .rinfo_res                      (rinfo_res),
    .fadd_res                       (fadd_res),
    .fmul_res                       (fmul_res),
    .fdiv_res                       (fdiv_res),
    .fsp_res                        (fsp_res),
    .fcmp_res                       (fcmp_res),
    .wb_v                           (wb_v),
    .wb_inst                        (wb_inst)
);





ISSUSER_GUN issuer(
    .clk                            (clk),
    .rst                            (rst),
    .end_pt                         (end_pt),
    .head_pt                        (head_pt),
    .related                        (related),
    .related_busy                   (related_busy),
    .hw_relation                    (hw_relation),
    .issue_v                        (issue_v),
    .iss_inst                       (iss_inst),
    .iss_flag                       (iss_flag),
    .wb_v                           (wb_v),
    .wb_inst                        (wb_inst)
);





endmodule