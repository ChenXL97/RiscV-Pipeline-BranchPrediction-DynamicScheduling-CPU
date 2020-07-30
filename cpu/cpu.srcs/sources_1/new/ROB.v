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
    output      [9:0]                           related

);



// simple rob writing content
reg         [`ROB_ITEM_INDEX]                   rob_info_stack      [9:0];
reg         [9:0]                               rob_busy;
reg         [9:0]                               rob_inst_done;


// rob_stack_pt to and full signal
reg         [3:0]                               end_pt;
reg         [3:0]                               head_pt;
reg         [3:0]                               check_data_pt;
reg                                             rob_full;


// each func part map to one inst, one inst map to a rob
reg         [3:0]                               func2rob    [14:0];


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




// store current inst_pc and last inst_pc
always @ (posedge clk) begin
    if(!rst) begin
        cur_pc <= de_cur_pc;
        if(last_pc != de_cur_pc) begin
            last_pc <= de_cur_pc;
        end
        else begin
            last_pc <= last_pc;
        end
    end
    else begin
        last_pc <= 32'hffff_ffff;
        cur_pc <= 32'hffff_ffff;
    end
end




// write rob when decode info is valid
always @ (posedge clk) begin
    if(!rst) begin
        if( last_pc != de_cur_pc && rob_info != 'd0) begin
            rob_info_stack[head_pt] <= rob_info;
        end
        else begin
            rob_info_stack[0] <= rob_info_stack[0];
            rob_info_stack[1] <= rob_info_stack[1];
            rob_info_stack[2] <= rob_info_stack[2];
            rob_info_stack[3] <= rob_info_stack[3];
            rob_info_stack[4] <= rob_info_stack[4];
            rob_info_stack[5] <= rob_info_stack[5];
            rob_info_stack[6] <= rob_info_stack[6];
            rob_info_stack[7] <= rob_info_stack[7];
            rob_info_stack[8] <= rob_info_stack[8];
            rob_info_stack[9] <= rob_info_stack[9];
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




// control head_pt
always @ (posedge clk) begin
    if(!rst) begin
        if( last_pc != de_cur_pc && rob_info != 'd0) begin
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




// control end_pt
always @ (posedge clk) begin
    if(!rst) begin
        if(ex_done) begin
            
        end
    end
    else begin
        end_pt <= 'd0;
    end
end




// check data relation
// when new inst come or when ex_done arrive
always @ (*) begin
    if(!rst) begin
        // new inst come
        if(last_pc != de_cur_pc && rob_info != 'd0) begin
            inst_dst[head_pt] = rob_info[`DST];
            related_busy[head_pt] = 'd1;

            check_data_done = 'd0;
            check_data_pt = head_pt - 'd1;
            
            // inst does not use imm_data
            // need to check rst1 and rst2
            // search order: from newest to oldest
            // from head_pt to end_pt
            if(!rob_info[`IMMUSE]) begin
                // 1 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 2 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 3 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 4 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 5 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 6 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 7 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 8 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 9 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1] || 
                    inst_dst[check_data_pt] == rob_info[`RS2]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // reset and set non-related in corresponding situation
                check_data_done = 'd0;
                if (related_inst[head_pt] == 'd11) begin
                    related[head_pt] = 'd0; 
                end
            end

            // inst uses imm_data
            // only check rst1
            else begin
                // 1 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 2 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 3 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 4 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 5 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 6 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 7 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 8 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // 9 data check
                if(related_busy[check_data_pt] && 
                    (inst_dst[check_data_pt] == rob_info[`RS1]) && 
                    inst_dst[check_data_pt] != 'd0 &&
                    !check_data_done ) begin
                        check_data_done = 'd1;
                        related_inst[head_pt] = check_data_pt;
                        related[head_pt] = 'd1;
                    end
                else begin
                    if(check_data_pt == 'd0) 
                        check_data_pt = 'd9;
                    else 
                        check_data_pt = check_data_pt - 'd1;
                end

                // reset and set non-related in corresponding situation
                check_data_done = 'd0;
                check_data_pt = 4'hf;
                if (related_inst[head_pt] == 'd11) begin
                    related[head_pt] = 'd0; 
                end
            end
        end

        // when a inst is done in exe
        if(ex_done) begin
            // ram done
            if(func_part_done[0]) begin
                after_done_dcheck = func2rob[0];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;

            end

            // branch done
            if(func_part_done[1]) begin
                after_done_dcheck = func2rob[1];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // shift done
            if(func_part_done[2]) begin
                after_done_dcheck = func2rob[2];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // logic done
            if(func_part_done[3]) begin
                after_done_dcheck = func2rob[3];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // cmp done
            if(func_part_done[4]) begin
                after_done_dcheck = func2rob[4];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // add done
            if(func_part_done[5]) begin
                after_done_dcheck = func2rob[5];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // mul done
            if(func_part_done[6]) begin
                after_done_dcheck = func2rob[6];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end
            
            // div done
            if(func_part_done[7]) begin
                after_done_dcheck = func2rob[7];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // sp done
            if(func_part_done[8]) begin
                after_done_dcheck = func2rob[8];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // rinfo done
            if(func_part_done[9]) begin
                after_done_dcheck = func2rob[9];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // fadd done
            if(func_part_done[10]) begin
                after_done_dcheck = func2rob[10];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // fmul done
            if(func_part_done[11]) begin
                after_done_dcheck = func2rob[11];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // fdiv done
            if(func_part_done[12]) begin
                after_done_dcheck = func2rob[12];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // fsp done
            if(func_part_done[13]) begin
                after_done_dcheck = func2rob[13];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
            end

            // fcmp done
            if(func_part_done[14]) begin
                after_done_dcheck = func2rob[14];

                check_data_pt = 'd0;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd1;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd2;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd3;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd4;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd5;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd6;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd7;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd8;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd9;
                if(related_inst[check_data_pt] == after_done_dcheck && 
                    related_busy[check_data_pt]) begin
                    // cancel related flag
                    related[check_data_pt] = 'd0;
                end

                check_data_pt = 'd0;
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
    end
end




// check hardware relation
// when a new inst come or when ex_done arrive or
// when issue an inst
always @ (*) begin
    if(!rst) begin
        check_hw_done = 'd0;

        // new inst come
        if(last_pc != de_cur_pc && rob_info != 'd0) begin
            // check 1 part
            if(rob_info[`RAM] && global_hw_use[0] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 2 part
            if(rob_info[`BRANCH] && global_hw_use[1] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 3 part
            if(rob_info[`SHIFT] && global_hw_use[2] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 4 part
            if(rob_info[`LOGIC] && global_hw_use[3] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 5 part
            if(rob_info[`CMP] && global_hw_use[4] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 6 part
            if(rob_info[`ADD] && global_hw_use[5] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 7 part
            if(rob_info[`MUL] && global_hw_use[6] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 8 part
            if(rob_info[`DIV] && global_hw_use[7] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 9 part
            if(rob_info[`SP] && global_hw_use[8] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 10 part
            if(rob_info[`RINFO] && global_hw_use[9] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 11 part
            if(rob_info[`FADD] && global_hw_use[10] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 12 part
            if(rob_info[`FMUL] && global_hw_use[11] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 13 part
            if(rob_info[`FDIV] && global_hw_use[12] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 14 part
            if(rob_info[`FSP] && global_hw_use[13] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            // check 15 part
            if(rob_info[`FCMP] && global_hw_use[14] && !check_hw_done) begin
                check_hw_done = 'd1;
                hw_relation[head_pt] = 'd1;
            end

            check_hw_done = 'd0;
        end

        // when a inst is done in exe
        if (ex_done) begin
            
        end



        // after issuing a inst
    end
    else begin
        check_hw_done = 'd0;
        hw_relation = 10'd0;
        global_hw_use = 15'd0; 

    end
end




endmodule
