`include "HeadFile.vh"
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
`timescale 1ns/100ps

`define OFFSET 143

module EX(
    input                               clk,
    input                               rst,

    input       [31:0]                  op1,  // rs1
    input       [31:0]                  op2,  // rs2
    input       [31:0]                  imm_data,  // imm
    input       [31:0]                  dis_cur_pc,

    input                               imm_use,
    input       [14:0]                  func_part,

    input       [1:0]                   op_mode1,
    input       [2:0]                   op_mode2,
    output                              ex_done,

    // when there's need to store the current pc or other addr, use res reg to 
    // transfer this addr, while tar_addr only be used to store branch target
    // address.
    //  jmp info signal 
    output      [31:0]                  ex_tar_addr,
    
    // set flush when branch inst need jmp
    output                              ex_need_jump,
    output       reg     [31:0]         ex_cur_pc,

    // Tell BTB is brannch
    output ex_is_branch,

    // signal to rob
    output      reg     [14:0]                          func_part_done,
    output      reg     [31:0]                          ram_res,
    output      reg     [31:0]                          branch_res,
    output      reg     [31:0]                          shift_res,
    output      reg     [31:0]                          logic_res,
    output      reg     [31:0]                          cmp_res,
    output      reg     [31:0]                          add_res,
    output      reg     [31:0]                          mul_res,
    output      reg     [31:0]                          div_res,
    output      reg     [31:0]                          sp_res,
    output      reg     [31:0]                          rinfo_res,
    output      reg     [31:0]                          fadd_res,
    output      reg     [31:0]                          fmul_res,
    output      reg     [31:0]                          fdiv_res,
    output      reg     [31:0]                          fsp_res,
    output      reg     [31:0]                          fcmp_res,

    input                                               issue_v,
    input                                               rob_flush

    );

// assign ex_flush = ex_need_jmp;

reg         [14:0]                      func_start;
reg         [14:0]                      func_working;
reg                                     func_busy;
reg         [31:0]                      imm_data_r;
reg         [31:0]                      op1_r;
reg         [31:0]                      op2_r;
//reg         [31:0]                      ex_cur_pc;
reg         [31:0]                      dis_cur_pc_r;
reg         [31:0]                      reg_a;
reg         [31:0]                      reg_b;
reg         [31:0]                      reg_imm;
reg                                     BTB_is_taken_r;
reg         [31:0]                      BTB_predict_pc_r;



// wire between sub module
wire                                    ex_flush_w;
wire                                    logic_done;
wire        [31:0]                      logic_res;
wire                                    shift_done;
wire        [31:0]                      shift_res;
wire                                    add_done;
wire        [31:0]                      add_res;
wire                                    ram_done;
wire        [31:0]                      ram_res;
wire                                    branch_done;
wire        [31:0]                      branch_res;
wire        [31:0]                      add_extra_data;
wire        [31:0]                      logic_extra_data;
wire        [31:0]                      shift_extra_data;
wire                                    fadd_done;
wire        [31:0]                      fadd_res;
wire                                    int_float_done;
wire        [31:0]                      int_float_res;
wire                                    fcmp_done;
wire        [31:0]                      fcmp_res;
wire                                    fmul_done;
wire        [31:0]                      fmul_res;
wire        [31:0]                      fsp_res;
wire                                    fsp_done;

reg                                     cmp_done;
reg                                     mul_done;
reg                                     div_done;
reg                                     sp_done;
reg                                     rinfo_done;
reg                                     fdiv_done;

always @ (posedge clk) begin
    if(!rst && !rob_flush) begin
        cmp_done <= cmp_done;
        mul_done <= mul_done;
        div_done <= div_done;
        sp_done <= sp_done;
        rinfo_done <= rinfo_done;
        fdiv_done <= fdiv_done;
    end
    else begin
        cmp_done <= 'd0;
        mul_done <= 'd0;
        div_done <= 'd0;
        sp_done <= 'd0;
        rinfo_done <= 'd0;
        fdiv_done <= 'd0;
    end
end



assign ex_is_branch = branch_done;



assign add_extra_data = imm_use ? imm_data : op2;
assign logic_extra_data = imm_use ? imm_data : op2;
assign shift_extra_data = imm_use ? imm_data : op2;




reg [31:0] opc;

reg         [1:0]                       use_part;
reg                                     trick;
reg         [3:0]                       stall_clk;




assign ex_done = add_done | logic_done | ram_done | branch_done
                | fadd_done | fsp_done | fcmp_done | fmul_done
                | shift_done ;



// prepare operation data and ex_cur_pc
always @ (posedge clk) begin
    if(!rst && !rob_flush) begin
        dis_cur_pc_r <= dis_cur_pc;
        reg_a <= op1;
        reg_b <= op2;
        reg_imm <= imm_data;
    end
    else begin
        dis_cur_pc_r <= 'd0;
        reg_a <= 'd0;
        reg_b <= 'd0;
        reg_imm <= 'd0;
    end
end


// generate func_part_done signal
always @ (*) begin
    if(!rst && !rob_flush) begin
        if(ram_done) begin
            func_part_done[`RAM_USE] = 'b1;
        end
        else begin
            func_part_done[`RAM_USE] = 'b0;
        end

        if(branch_done) begin
            func_part_done[`BRANCH_USE] = 'b1;
        end
        else begin
            func_part_done[`BRANCH_USE] = 'b0;
        end

        if(shift_done) begin
            func_part_done[`SHIFT_USE] = 'b1;
        end
        else begin
            func_part_done[`SHIFT_USE] = 'b0;
        end

        if(logic_done) begin
            func_part_done[`LOGIC_USE] = 'b1;
        end
        else begin
            func_part_done[`LOGIC_USE] = 'b0;
        end

        if(cmp_done) begin
            func_part_done[`CMP_USE] = 'b1;
        end
        else begin
            func_part_done[`CMP_USE] = 'b0;
        end

        if(add_done) begin
            func_part_done[`ADD_USE] = 'b1;
        end
        else begin
            func_part_done[`ADD_USE] = 'b0;
        end

        if(mul_done) begin
            func_part_done[`MUL_USE] = 'b1;
        end
        else begin
            func_part_done[`MUL_USE] = 'b0;
        end

        if(div_done) begin
            func_part_done[`DIV_USE] = 'b1;
        end
        else begin
            func_part_done[`DIV_USE] = 'b0;
        end

        if(sp_done) begin
            func_part_done[`SP_USE] = 'b1;
        end
        else begin
            func_part_done[`SP_USE] = 'b0;
        end

        if(rinfo_done) begin
            func_part_done[`RINFO_USE] = 'b1;
        end
        else begin
            func_part_done[`RINFO_USE] = 'b0;
        end

        if(fadd_done) begin
            func_part_done[`FADD_USE] = 'b1;
        end
        else begin
            func_part_done[`FADD_USE] = 'b0;
        end

        if(fmul_done) begin
            func_part_done[`FMUL_USE] = 'b1;
        end
        else begin
            func_part_done[`FMUL_USE] = 'b0;
        end

        if(fdiv_done) begin
            func_part_done[`FDIV_USE] = 'b1;
        end
        else begin
            func_part_done[`FDIV_USE] = 'b0;
        end

        if(fsp_done) begin
            func_part_done[`FSP_USE] = 'b1;
        end
        else begin
            func_part_done[`FSP_USE] = 'b0;
        end

        if(fcmp_done) begin
            func_part_done[`FCMP_USE] = 'b1;
        end
        else begin
            func_part_done[`FCMP_USE] = 'b0;
        end
    end
    else begin
        func_part_done = 15'b0;
    end
end



/* parts' control signal */
// start signal only keeps positive for 1 clk
always @ (negedge clk) begin
    if(!rst && !rob_flush) begin
        // current inst is valid and not running 
        if(func_part != 'd0 && func_start != 0) begin
            func_working <= func_part;
            trick <= 'd1;
        end

        // current inst is running
        else if(func_busy == 'd1) begin
            func_working <= func_working;
            trick <= 'd0;
        end

        else begin
            func_working <= 'd0;
            trick <= 'd0;
        end
    end

    else begin
        func_working <= 'd0;
        trick <= 'd0;
    end
end


always @ (negedge clk) begin
    if(!rst && !rob_flush) begin
        if(ex_cur_pc != dis_cur_pc ) begin
            ex_cur_pc <= dis_cur_pc;
        end
        
        else 
            ex_cur_pc <= ex_cur_pc;
    end
    else begin
        ex_cur_pc <= `INIT_PC;
    end
end



always @ (negedge clk) begin
    if(!rst && !rob_flush) begin
        // current inst is valid and not running 
        if(issue_v) begin
            func_start <= func_part;
        end
        else begin
            func_start <= 'd0;
        end
    end

    else begin
        func_start <= 'd0;
    end
end


always @ (negedge clk) begin
    if(!rst && !rob_flush) begin
        // current inst is valid and not running 
        if(func_part != 'd0) begin
            imm_data_r <= imm_data;
            op1_r <= op1;
            op2_r <= op2;
        end

        // current inst is running
        else if(ex_done) begin
            imm_data_r <= 'd0;
            op1_r <= 'd0;
            op2_r <= 'd0;
        end

        else begin
            imm_data_r <= imm_data_r;
            op1_r <= op1_r;
            op2_r <= op2_r;
        end
    end

    else begin
        imm_data_r <= 'd0;
        op1_r <= 'd0;
        op2_r <= 'd0;
    end
end



always @ (*) begin
    if(!rst && !rob_flush) begin
        // current inst is not running
        if(func_part != 'd0 && func_busy == 'd0) begin
            func_busy = 'd1;
        end

        // current inst is running
        else if(func_busy == 'd1) begin

            if(ex_done) begin
                func_busy = 'd0;
            end
            else begin
                func_busy = 'd1;
            end
        end

        else begin
            func_busy = func_busy;
        end
    end

    else begin
        func_busy = 'd0;
    end
end




LOGIC logic(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (logic_extra_data),
            .start                  (func_part[`LOGIC_USE]),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (logic_done),
            .res                    (logic_res)
);


SHIFT shift(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (shift_extra_data),
            .start                  (func_part[`SHIFT_USE]),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (shift_done),
            .res                    (shift_res)
);


ADD_SUB add_sub(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (add_extra_data),
            .start                  (func_part[`ADD_USE]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (add_done),
            .res                    (add_res)
);



RAM data_ram(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (op2),
            .imm_data               (imm_data),
            .start                  (func_part[`RAM_USE]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (ram_done),
            .res                    (ram_res)
);



BRANCH branch(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (op2),
            .imm_data               (imm_data + 'd4),
            .cur_pc                 (dis_cur_pc),
            .start                  (func_part[`BRANCH_USE]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (branch_done),
            .res                    (branch_res),
            .tar_addr               (ex_tar_addr),
            .need_jmp               (ex_need_jump)
);




FADD_SUB fadd_sub(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (op2),
            .start                  (func_part[`FADD_USE]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (fadd_done),
            .res                    (fadd_res)
);

INT_FLOAT int_float(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .start                  (func_part[`FSP_USE]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (fsp_done),
            .res                    (fsp_res)
);

FCMP fcmp(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (op2),
            .start                  (func_part[`FCMP_USE]),
            .use_part               (2'b01),
            .op_mode1               (2'b0),
            .op_mode2               (3'b0),
            .done                   (fcmp_done),
            .res                    (fcmp_res)
);

FMUL fmul(
            .clk                    (clk),
            .rst                    (rst | rob_flush),
            .op1                    (op1),
            .op2                    (op2),
            .start                  (func_part[`FMUL_USE]),
            .use_part               (2'b01),
            .op_mode1               (2'b0),
            .op_mode2               (3'b0),
            .done                   (fmul_done),
            .res                    (fmul_res)
);

      
endmodule
