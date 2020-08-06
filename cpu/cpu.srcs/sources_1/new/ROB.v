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

/* ***********************2020 07 21*******************************
    To simplify the hardware design, the number of each function part
    is only one and the number of rob member is 10, thus one bit can 
    indicate whether a part is busy or not.

    Global stall signal should be gen by tomasulo instead of exe. 
    Stall signal will not pause exe. When rob is full, global stall
    signal should be set valid, otherwise stall signal shoule be pull
    down.

    Flush signal is still gen by exe, when predict addr is not corres-
    ponding to actual branch addr. When flushing, all module include
    rob but except for pc is resetted. 

*************************modified by winters********************* */




module ROB (
    input                                       clk,
    input                                       rst,

    // global control signal
    input                                       ex_flush,
    output                                      rob_stall,

    // signal from exe to help dispatch
    input                                       ex_done,
    input       [14:0]                          func_part_done,

    input       [`ROB_ITEM_INDEX]               rob_info,
    input       [31:0]                          de_cur_pc,
    
    // send to issuer
    output      [3:0]                           end_pt,
    output      [3:0]                           head_pt,
    output      [9:0]                           related_busy,
    output      [9:0]                           related,
    output      [9:0]                           hw_relation,

    // issue signal from dis-gun
    input                                       issue_v,
    input       [3:0]                           iss_inst,
    input       [9:0]                           iss_flag,

    // func_part input result
    input       [31:0]                          ram_res,
    input       [31:0]                          branch_res,
    input       [31:0]                          shift_res,
    input       [31:0]                          logic_res,
    input       [31:0]                          cmp_res,
    input       [31:0]                          add_res,
    input       [31:0]                          mul_res,
    input       [31:0]                          div_res,
    input       [31:0]                          sp_res,
    input       [31:0]                          rinfo_res,
    input       [31:0]                          fadd_res,
    input       [31:0]                          fmul_res,
    input       [31:0]                          fdiv_res,
    input       [31:0]                          fsp_res,
    input       [31:0]                          fcmp_res,

    // signal output due from write back
    output      [3:0]                           wb_inst,
    output                                      wb_v

);



// simple rob writing content
reg         [`ROB_ITEM_INDEX]                   rob_info_stack      [9:0];
reg         [9:0]                               rob_inst_done;
reg         [14:0]                              rob_hw_tar;

// rob_stack_pt to and full signal
reg         [3:0]                               end_pt;
reg         [3:0]                               head_pt;
reg         [3:0]                               check_data_pt;
reg                                             rob_full;


// each func part map to one inst, one inst map to a rob
reg         [3:0]                               func2rob    [14:0];
reg         [3:0]                               done_inst;


// related to inst pc
reg         [31:0]                              last_pc;
reg         [31:0]                              cur_pc;


// related to data relation check
reg         [4:0]                               inst_dst        [9:0];
reg         [3:0]                               related_inst    [9:0];
reg         [9:0]                               related;
reg         [9:0]                               related_busy;
reg                                             check_data_done;
reg         [4:0]                               after_done_dcheck;


// related to hardware relation check
reg         [14:0]                              global_hw_use;
reg         [9:0]                               hw_relation;
reg                                             check_hw_done;
reg         [3:0]                               check_hw_pt;
reg         [4:0]                               tar_func_part   [9:0];


// combined with write back process
reg                                             wb_v;
reg         [31:0]                              wb_res;
reg         [4:0]                               wd_dst;
reg         [31:0]                              inst_reslt      [9:0];
reg         [3:0]                               wb_inst;


// combined with data forwarding
// static relation flag
reg         [9:0]                               forward_flag_rs1;
reg         [9:0]                               forward_flag_rs2;
// dynamic relation flag
reg         [9:0]                               related_rs1;
reg         [9:0]                               related_rs2;
reg         [3:0]                               related_inst_rs1     [9:0];
reg         [3:0]                               related_inst_rs2     [9:0];
reg         [31:0]                              forward_data_rs1     [9:0];
reg         [31:0]                              forward_data_rs2     [9:0];





// operations on func2rob
// operation starts when an inst is issued or 
// when an inst is write back
// combine a func_part with an inst
// when an inst is write back, free corresponding element
always @ (*) begin
    if(!rst) begin
        if(issue_v) begin
            if(rob_info_stack[iss_inst][`RAM])
                func2rob[0] = iss_inst;
            if(rob_info_stack[iss_inst][`BRANCH])
                func2rob[1] = iss_inst;
            if(rob_info_stack[iss_inst][`SHIFT])
                func2rob[2] = iss_inst;
            if(rob_info_stack[iss_inst][`LOGIC])
                func2rob[3] = iss_inst;
            if(rob_info_stack[iss_inst][`CMP])
                func2rob[4] = iss_inst;
            if(rob_info_stack[iss_inst][`ADD])
                func2rob[5] = iss_inst;
            if(rob_info_stack[iss_inst][`MUL])
                func2rob[6] = iss_inst;
            if(rob_info_stack[iss_inst][`DIV])
                func2rob[7] = iss_inst;
            if(rob_info_stack[iss_inst][`SP])
                func2rob[8] = iss_inst;
            if(rob_info_stack[iss_inst][`RINFO])
                func2rob[9] = iss_inst;
            if(rob_info_stack[iss_inst][`FADD])
                func2rob[10] = iss_inst;
            if(rob_info_stack[iss_inst][`FMUL])
                func2rob[11] = iss_inst;
            if(rob_info_stack[iss_inst][`FDIV])
                func2rob[12] = iss_inst;
            if(rob_info_stack[iss_inst][`FSP])
                func2rob[13] = iss_inst;
            if(rob_info_stack[iss_inst][`BRANCH])
                func2rob[14] = iss_inst;
        end

    end
    else begin
        func2rob[0] = 'd11;
        func2rob[1] = 'd11;
        func2rob[2] = 'd11;
        func2rob[3] = 'd11;
        func2rob[4] = 'd11;
        func2rob[5] = 'd11;
        func2rob[6] = 'd11;
        func2rob[7] = 'd11;
        func2rob[8] = 'd11;
        func2rob[9] = 'd11;
        func2rob[10] = 'd11;
        func2rob[11] = 'd11;
        func2rob[12] = 'd11;
        func2rob[13] = 'd11;
        func2rob[14] = 'd11;
    end
end





// set rob_inst_done flag
// when ex_done, set corresponding inst as done
// when an inst is write back, free corresponding element
always @ (func_part_done or wb_inst) begin
    if(!rst) begin
        if(ex_done) begin
            if (func_part_done[`RAM_USE]) begin
                done_inst = func2rob[`RAM_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`BRANCH_USE]) begin
                done_inst = func2rob[`BRANCH_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`SHIFT_USE]) begin
                done_inst = func2rob[`SHIFT_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`LOGIC_USE]) begin
                done_inst = func2rob[`LOGIC_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`CMP_USE]) begin
                done_inst = func2rob[`CMP_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`ADD_USE]) begin
                done_inst = func2rob[`ADD_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`MUL_USE]) begin
                done_inst = func2rob[`MUL_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`DIV_USE]) begin
                done_inst = func2rob[`DIV_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`SP_USE]) begin
                done_inst = func2rob[`SP_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`RINFO_USE]) begin
                done_inst = func2rob[`RINFO_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`FADD_USE]) begin
                done_inst = func2rob[`FADD_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`FMUL_USE]) begin
                done_inst = func2rob[`FMUL_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`FDIV_USE]) begin
                done_inst = func2rob[`FDIV_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`FSP_USE]) begin
                done_inst = func2rob[`FSP_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            if (func_part_done[`FCMP_USE]) begin
                done_inst = func2rob[`FCMP_USE];
                rob_inst_done[done_inst] = 'd1;
            end
            done_inst = 'd11;
        end

        if(wb_v) begin
            rob_inst_done[wb_inst] = 'b0;
        end

    end

    else begin
        done_inst = 'd11;
        rob_inst_done = 10'b0;
    end
end






// store current inst_pc and last inst_pc
always @ (posedge clk) begin
    if(!rst) begin
        cur_pc <= de_cur_pc;
    end
    else begin
        cur_pc <= 32'hffff_ffff;
    end
end

always @ (posedge clk) begin
    if(!rst) begin
       last_pc <= cur_pc; 
    end
    else begin
        last_pc <= 32'hffff_ffff;
    end
end




// write rob when decode info is valid
always @ (posedge clk) begin
    if(!rst) begin
        // let new inst in
        if (last_pc != de_cur_pc && rob_info != 'd0) begin
            rob_info_stack[head_pt] <= rob_info;
        end
    end
    else begin
        rob_info_stack[0] <= 'd0;
        rob_info_stack[1] <= 'd0;
        rob_info_stack[2] <= 'd0;
        rob_info_stack[3] <= 'd0;
        rob_info_stack[4] <= 'd0;
        rob_info_stack[5] <= 'd0;
        rob_info_stack[6] <= 'd0;
        rob_info_stack[7] <= 'd0;
        rob_info_stack[8] <= 'd0;
        rob_info_stack[9] <= 'd0;

    end
end





// set inst_reslt array to store inst's
// computing result. Write when ex_done.
always @ (func_part_done) begin
    if(!rst) begin
         // let inst result in
        if (ex_done) begin
            if(func_part_done[`RAM_USE]) begin
                inst_reslt[end_pt] <= ram_res;
            end
            
            if(func_part_done[`BRANCH_USE]) begin
                inst_reslt[end_pt] <= branch_res;
            end

            if(func_part_done[`SHIFT_USE]) begin
                inst_reslt[end_pt] <= shift_res;
            end

            if(func_part_done[`LOGIC_USE]) begin
                inst_reslt[end_pt] <= logic_res;
            end

            if(func_part_done[`CMP_USE]) begin
                inst_reslt[end_pt] <= cmp_res;
            end

            if(func_part_done[`ADD_USE]) begin
                inst_reslt[end_pt] <= add_res;
            end

            if(func_part_done[`MUL_USE]) begin
                inst_reslt[end_pt] <= mul_res;
            end

            if(func_part_done[`DIV_USE]) begin
                inst_reslt[end_pt] <= div_res;
            end

            if(func_part_done[`SP_USE]) begin
                inst_reslt[end_pt] <= sp_res;
            end

            if(func_part_done[`RINFO_USE]) begin
                inst_reslt[end_pt] <= rinfo_res;
            end

            if(func_part_done[`FADD_USE]) begin
                inst_reslt[end_pt] <= fadd_res;
            end

            if(func_part_done[`FMUL_USE]) begin
                inst_reslt[end_pt] <= fmul_res;
            end

            if(func_part_done[`FDIV_USE]) begin
                inst_reslt[end_pt] <= fdiv_res;
            end

            if(func_part_done[`FSP_USE]) begin
                inst_reslt[end_pt] <= fsp_res;
            end

            if(func_part_done[`FCMP_USE]) begin
                inst_reslt[end_pt] <= fcmp_res;
            end
        end
    end
    else begin
        inst_reslt[0] = 'd0;
        inst_reslt[1] = 'd0;
        inst_reslt[2] = 'd0;
        inst_reslt[3] = 'd0;
        inst_reslt[4] = 'd0;
        inst_reslt[5] = 'd0;
        inst_reslt[6] = 'd0;
        inst_reslt[7] = 'd0;
        inst_reslt[8] = 'd0;
        inst_reslt[9] = 'd0;
    end
end





// control head_pt
always @ (posedge clk) begin
    if(!rst) begin
        if(last_pc != de_cur_pc && rob_info != 'd0) begin
            if(head_pt == 'd9) begin
                head_pt <= 'd0;
            end
            else begin
                head_pt <= head_pt + 'd1;
            end
        end
        else begin
            head_pt <= head_pt;
        end
    end
    else begin
        head_pt <= 'd0;
    end
end




// control end_pt and wb_v
// use this part to control write-back process
always @ (posedge clk) begin
    if(!rst) begin
        if(rob_inst_done[end_pt]) begin
            wb_v <= 'd1;
            wb_res <= inst_reslt[end_pt];
            wb_inst <= end_pt;
            if(end_pt == 'd9) begin
                end_pt <= 'd0;
            end
            else begin
                end_pt <= end_pt + 'd1;
            end
        end
        else begin
            wb_v <= 'd0;
            wb_res <= 'd0;
            end_pt <= end_pt;
            wb_inst <= 'd11;
        end
    end
    else begin
        end_pt <= 'd0;
        wb_v <= 'd0;
        wb_res <= 'd0;
        wb_inst <= 'd11;
    end
end




// check data relation
// when new inst come or when clk posedge arrive
// check existed inst first
// when an inst is write back, free element
always @ (*) begin
    if(!rst) begin
        // when a inst is write back, free
        if(wb_v) begin
            related[wb_inst] = 'd0;
            related_inst[wb_inst] = 'd11;
            related_busy[wb_inst] = 'd0;
        end

        // when a inst is done in exe
        if(ex_done) begin

            if(func_part_done[0]) begin
                after_done_dcheck = func2rob[0];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[1]) begin
                after_done_dcheck = func2rob[1];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[2]) begin
                after_done_dcheck = func2rob[2];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[3]) begin
                after_done_dcheck = func2rob[3];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[4]) begin
                after_done_dcheck = func2rob[4];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[5]) begin
                after_done_dcheck = func2rob[5];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[6]) begin
                after_done_dcheck = func2rob[6];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[7]) begin
                after_done_dcheck = func2rob[7];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[8]) begin
                after_done_dcheck = func2rob[8];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[9]) begin
                after_done_dcheck = func2rob[9];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[10]) begin
                after_done_dcheck = func2rob[10];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[11]) begin
                after_done_dcheck = func2rob[11];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[12]) begin
                after_done_dcheck = func2rob[12];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[13]) begin
                after_done_dcheck = func2rob[13];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

            if(func_part_done[14]) begin
                after_done_dcheck = func2rob[14];
                check_data_pt = end_pt;

                // check 1
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    // prepare forwarding data-flow
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 2
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 3
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 4
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 5
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 6
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 7
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 8
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end

                // check 9
                if((related_inst_rs1[check_data_pt] == after_done_dcheck || 
                    related_inst_rs2[check_data_pt] == after_done_dcheck) && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    if(related_inst_rs1[check_data_pt] == after_done_dcheck) begin
                        related_rs1[check_data_pt] = 'd0;
                        forward_data_rs1[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    if(related_inst_rs2[check_data_pt] == after_done_dcheck) begin
                        related_rs2[check_data_pt] = 'd0;
                        forward_data_rs2[check_data_pt] = inst_reslt[after_done_dcheck];
                    end
                    related[check_data_pt] = related_rs1[check_data_pt] | 
                                                related_rs2[check_data_pt];
                end
                if(check_data_pt == 'd9) begin
                    check_data_pt = 'd0;
                end
                else begin
                    check_data_pt = check_data_pt + 'd1;
                end
            end

        end


        // new inst come
        if(last_pc != de_cur_pc && rob_info != 'd0 && !related_busy[head_pt]) begin
            inst_dst[head_pt] = rob_info[`DST];
            related_busy[head_pt] = 'd1;

            // set zero before use
            // no need to free when write back
            forward_flag_rs1[head_pt] = 'd0;
            forward_flag_rs2[head_pt] = 'd0;
            related_rs1[head_pt] = 'b0;
            related_rs2[head_pt] = 'b0;
            related_inst_rs1[head_pt] = 'd11;
            related_inst_rs2[head_pt] = 'd11;

            check_data_done = 'd0;
            if(head_pt != 'd0)
                check_data_pt = head_pt - 'd1;
            else 
                check_data_pt = 'd9;
            
            // inst does not use imm_data
            // need to check rst1 and rst2
            // search order: from newest to oldest
            // from head_pt to end_pt
            if(!rob_info[`IMMUSE]) begin
                // 1 data check

                $display("nt");
                $display("nt");
                $display("nt");
                $display("%d", head_pt);

                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 1");
                        $display("cnm 1");
                        $display("cnm 1");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 2 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 2");
                        $display("cnm 2");
                        $display("cnm 2");
                        $display("%d", check_data_pt);

                       if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 3 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 3");
                        $display("cnm 3");
                        $display("cnm 3");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 4 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 4");
                        $display("cnm 4");
                        $display("cnm 4");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 5 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 ) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 5");
                        $display("cnm 5");
                        $display("cnm 5");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;
              
                // 6 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 6");
                        $display("cnm 6");
                        $display("cnm 6");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
    
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;
             

                // 7 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 7");
                        $display("cnm 7");
                        $display("cnm 7");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 8 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 8");
                        $display("cnm 8");
                        $display("cnm 8");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 9 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        $display("cnm 9");
                        $display("cnm 9");
                        $display("cnm 9");
                        $display("%d", check_data_pt);

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                        if(inst_dst[check_data_pt] == rob_info[`RS2] && 
                            !forward_flag_rs2[head_pt]) begin
                            forward_flag_rs2[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs2[head_pt] = 'b1;
                                related_inst_rs2[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs2[head_pt] = 'b0;
                                related_inst_rs2[head_pt] = check_data_pt;
                                forward_data_rs2[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // reset and set non-related in corresponding situation
                check_data_done = 'd0;
                // if (related_inst[head_pt] == 'd11) begin
                //     related[head_pt] = 'd0; 
                // end
                if(forward_flag_rs1[head_pt] || forward_flag_rs2[head_pt]) begin
                    related[head_pt] = 'b1;
                end
                else begin
                    related[head_pt] = 'd0;
                end
            end

            // inst uses imm_data
            // only check rst1
            else begin
                // 1 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 2 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 3 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 4 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 5 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 6 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 7 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 8 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // 9 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0) begin
                        check_data_done = 'd0;
                        related_inst[head_pt] = check_data_pt;
                        // related[head_pt] = 'd1;

                        if(inst_dst[check_data_pt] == rob_info[`RS1] && 
                            !forward_flag_rs1[head_pt]) begin
                            forward_flag_rs1[head_pt] = 'b1;
                            // related inst not done, cannot use it's value
                            if(!rob_inst_done[check_data_pt]) begin
                                related_rs1[head_pt] = 'b1;
                                related_inst_rs1[head_pt] = check_data_pt;
                            end
                            // related inst done, directly use it's value
                            else begin
                                related_rs1[head_pt] = 'b0;
                                related_inst_rs1[head_pt] = check_data_pt;
                                forward_data_rs1[head_pt] = inst_reslt[check_data_pt];
                            end
                        end
                    end
                if(check_data_pt == 'd0) 
                    check_data_pt = 'd9;
                else 
                    check_data_pt = check_data_pt - 'd1;

                // reset and set non-related in corresponding situation
                check_data_done = 'd0;
                check_data_pt = 4'hf;
                // if (related_inst[head_pt] == 'd11) begin
                //     related[head_pt] = 'd0; 
                // end
                if(forward_flag_rs1[head_pt] || forward_flag_rs2[head_pt]) begin
                    related[head_pt] = 'b1;
                end
                else begin
                    related[head_pt] = 'd0;
                end
            end
        end

    end
    else begin
        check_data_pt = 4'hf;
        check_data_done = 'd0;
        after_done_dcheck = 'd31;

        inst_dst[0] = 'd0;
        inst_dst[1] = 'd0;
        inst_dst[2] = 'd0;
        inst_dst[3] = 'd0;
        inst_dst[4] = 'd0;
        inst_dst[5] = 'd0;
        inst_dst[6] = 'd0;
        inst_dst[7] = 'd0;
        inst_dst[8] = 'd0;
        inst_dst[9] = 'd0;

        func2rob[0] = 'd11;
        func2rob[1] = 'd11;
        func2rob[2] = 'd11;
        func2rob[3] = 'd11;
        func2rob[4] = 'd11;
        func2rob[5] = 'd11;
        func2rob[6] = 'd11;
        func2rob[7] = 'd11;
        func2rob[8] = 'd11;
        func2rob[9] = 'd11;

        related_inst[0] = 'd11;
        related_inst[1] = 'd11;
        related_inst[2] = 'd11;
        related_inst[3] = 'd11;
        related_inst[4] = 'd11;
        related_inst[5] = 'd11;
        related_inst[6] = 'd11;
        related_inst[7] = 'd11;
        related_inst[8] = 'd11;
        related_inst[9] = 'd11;

        related = 10'd0;

        related_busy = 10'd0;

        forward_flag_rs1[0] = 'd0;
        forward_flag_rs1[1] = 'd0;
        forward_flag_rs1[2] = 'd0;
        forward_flag_rs1[3] = 'd0;
        forward_flag_rs1[4] = 'd0;
        forward_flag_rs1[5] = 'd0;
        forward_flag_rs1[6] = 'd0;
        forward_flag_rs1[7] = 'd0;
        forward_flag_rs1[8] = 'd0;
        forward_flag_rs1[9] = 'd0;

        forward_flag_rs2[0] = 'd0;
        forward_flag_rs2[1] = 'd0;
        forward_flag_rs2[2] = 'd0;
        forward_flag_rs2[3] = 'd0;
        forward_flag_rs2[4] = 'd0;
        forward_flag_rs2[5] = 'd0;
        forward_flag_rs2[6] = 'd0;
        forward_flag_rs2[7] = 'd0;
        forward_flag_rs2[8] = 'd0;
        forward_flag_rs2[9] = 'd0;

        related_inst_rs1[0] = 'd11;
        related_inst_rs1[1] = 'd11;
        related_inst_rs1[2] = 'd11;
        related_inst_rs1[3] = 'd11;
        related_inst_rs1[4] = 'd11;
        related_inst_rs1[5] = 'd11;
        related_inst_rs1[6] = 'd11;
        related_inst_rs1[7] = 'd11;
        related_inst_rs1[8] = 'd11;
        related_inst_rs1[9] = 'd11;

        related_inst_rs2[0] = 'd11;
        related_inst_rs2[1] = 'd11;
        related_inst_rs2[2] = 'd11;
        related_inst_rs2[3] = 'd11;
        related_inst_rs2[4] = 'd11;
        related_inst_rs2[5] = 'd11;
        related_inst_rs2[6] = 'd11;
        related_inst_rs2[7] = 'd11;
        related_inst_rs2[8] = 'd11;
        related_inst_rs2[9] = 'd11;

        related_rs1 = 10'b0;
        related_rs2 = 10'b0;

        forward_data_rs1[0] = 'd0;
        forward_data_rs1[1] = 'd0;
        forward_data_rs1[2] = 'd0;
        forward_data_rs1[3] = 'd0;
        forward_data_rs1[4] = 'd0;
        forward_data_rs1[5] = 'd0;
        forward_data_rs1[6] = 'd0;
        forward_data_rs1[7] = 'd0;
        forward_data_rs1[8] = 'd0;
        forward_data_rs1[9] = 'd0;

        forward_data_rs2[0] = 'd0;
        forward_data_rs2[1] = 'd0;
        forward_data_rs2[2] = 'd0;
        forward_data_rs2[3] = 'd0;
        forward_data_rs2[4] = 'd0;
        forward_data_rs2[5] = 'd0;
        forward_data_rs2[6] = 'd0;
        forward_data_rs2[7] = 'd0;
        forward_data_rs2[8] = 'd0;
        forward_data_rs2[9] = 'd0;
    end
end




// freshing global hardware and set global_hw_use
// when an inst is issued or ex_done
// when an inst is issued, set hw_use
// when an inst is ex_done, free hw_use
always @ (*) begin
    if(!rst) begin
        
        // when an inst is issued, set hw_use
        // and set hw_relation at the same time
        if (issue_v) begin
            
            if(rob_info_stack[iss_inst][`RAM]) begin
                check_hw_pt = end_pt;
                global_hw_use[`RAM_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] ) begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] ) begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] ) begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] ) begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] ) begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`BRANCH]) begin
                check_hw_pt = end_pt;
                global_hw_use[`BRANCH_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`SHIFT]) begin
                check_hw_pt = end_pt;
                global_hw_use[`SHIFT_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`LOGIC]) begin
                check_hw_pt = end_pt;
                global_hw_use[`LOGIC_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`CMP]) begin
                check_hw_pt = end_pt;
                global_hw_use[`CMP_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`ADD]) begin

                check_hw_pt = end_pt;
                global_hw_use[`ADD_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`MUL]) begin
                check_hw_pt = end_pt;
                global_hw_use[`MUL_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`DIV]) begin
                check_hw_pt = end_pt;
                global_hw_use[`DIV_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`SP]) begin
                check_hw_pt = end_pt;
                global_hw_use[`SP_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`RINFO]) begin
                check_hw_pt = end_pt;
                global_hw_use[`RINFO_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`FADD]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FADD_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`FMUL]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FMUL_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`FDIV]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FDIV_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`FSP]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FSP_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end

            if(rob_info_stack[iss_inst][`FCMP]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FCMP_USE] = 'b1;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b1;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end
        end

        // ex_done signal free func_parts which means this time
        // may free hw_relation
        if(ex_done) begin

            if(func_part_done[`RAM_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`RAM_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `RAM_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`BRANCH_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`BRANCH_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `BRANCH_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt] )begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`SHIFT_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`SHIFT_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `SHIFT_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end
            

            if(func_part_done[`LOGIC_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`LOGIC_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `LOGIC_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`CMP_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`CMP_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `CMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`ADD_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`ADD_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `ADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`MUL_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`MUL_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `MUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`DIV_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`DIV_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `DIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`SP_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`SP_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `SP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`RINFO_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`RINFO_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `RINFO_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`FADD_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FADD_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FADD_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`FMUL_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FMUL_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FMUL_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`FDIV_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FDIV_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FDIV_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end
            

            if(func_part_done[`FSP_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FSP_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FSP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end


            if(func_part_done[`FCMP_USE]) begin
                check_hw_pt = end_pt;
                global_hw_use[`FCMP_USE] = 'b0;

                // inst 1
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 2
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 3
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 4
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 5
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 6
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 7
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 8
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 9
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end

                // inst 10
                if(tar_func_part[check_hw_pt] == `FCMP_USE && 
                    related_busy[check_hw_pt] && !iss_flag[check_hw_pt]) begin
                    hw_relation[check_hw_pt] = 'b0;
                end
                if(check_hw_pt == 'd9) begin
                    check_hw_pt = 'd0;
                end
                else begin
                    check_hw_pt = check_hw_pt + 'd1;
                end
            end
            
            
        end

        // new inst arrive
        // set tar_func_part, hw_relation and hw_relation busy
        if (last_pc != de_cur_pc && rob_info != 'd0) begin
            if(rob_info[`RAM]) begin
                tar_func_part[head_pt] = 'd0;
                if(global_hw_use[`RAM_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`BRANCH]) begin
                tar_func_part[head_pt] = 'd1;
                if(global_hw_use[`BRANCH_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`SHIFT]) begin
                tar_func_part[head_pt] = 'd2;
                if(global_hw_use[`SHIFT_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`LOGIC]) begin
                tar_func_part[head_pt] = 'd3;
                if(global_hw_use[`LOGIC_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`CMP]) begin
                tar_func_part[head_pt] = 'd4;
                if(global_hw_use[`CMP_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`ADD]) begin
                tar_func_part[head_pt] = 'd5;
                if(global_hw_use[`ADD_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`MUL]) begin
                tar_func_part[head_pt] = 'd6;
                if(global_hw_use[`MUL_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`DIV]) begin
                tar_func_part[head_pt] = 'd7;
                if(global_hw_use[`DIV_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`SP]) begin
                tar_func_part[head_pt] = 'd8;
                if(global_hw_use[`SP_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`RINFO]) begin
                tar_func_part[head_pt] = 'd9;
                if(global_hw_use[`RINFO_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`FADD]) begin
                tar_func_part[head_pt] = 'd10;
                if(global_hw_use[`FADD_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`FMUL]) begin
                tar_func_part[head_pt] = 'd11;
                if(global_hw_use[`FMUL_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`FDIV]) begin
                tar_func_part[head_pt] = 'd12;
                if(global_hw_use[`FDIV_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`FSP]) begin
                tar_func_part[head_pt] = 'd13;
                if(global_hw_use[`FSP_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end

            if(rob_info[`FCMP]) begin
                tar_func_part[head_pt] = 'd14;
                if(global_hw_use[`FCMP_USE]) begin
                    hw_relation[head_pt] = 'd1;
                end
                else begin
                    hw_relation[head_pt] = 'd0;
                end
            end
        end

    end

    else begin
        global_hw_use = 'd0;
        hw_relation = 10'b0;

        tar_func_part[0] = 'd16;
        tar_func_part[1] = 'd16;
        tar_func_part[2] = 'd16;
        tar_func_part[3] = 'd16;
        tar_func_part[4] = 'd16;
        tar_func_part[5] = 'd16;
        tar_func_part[6] = 'd16;
        tar_func_part[7] = 'd16;
        tar_func_part[8] = 'd16;
        tar_func_part[9] = 'd16;
    end
end


endmodule
