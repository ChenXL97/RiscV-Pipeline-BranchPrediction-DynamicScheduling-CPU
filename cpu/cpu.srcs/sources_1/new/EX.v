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

    input       [14:0]                  func_part,

    input       [1:0]                   op_mode1,
    input       [2:0]                   op_mode2,
    input       [4:0]                   dis_rd,

    output                              ex_done,

    // when there's need to store the current pc or other addr, use res reg to 
    // transfer this addr, while tar_addr only be used to store branch target
    // address.
    output      reg     [31:0]                  ex_res,

    //  jmp info signal 
    output      [31:0]                  ex_tar_addr,
    output                              ex_need_jmp,

    // set stall when some inst needs multiply clks
    output      reg                     ex_stall,
    
    // set flush when branch inst need jmp
    output      reg                     ex_flush,

    output      reg     [4:0]           ex_rd
    );




reg         [14:0]                      func_start;
reg         [14:0]                      func_working;
reg                                     func_busy;
reg         [31:0]                      imm_data_r;
reg         [31:0]                      op1_r;
reg         [31:0]                      op2_r;
reg         [31:0]                      ex_cur_pc;


// wire between sub module
wire                                    logic_done;
wire        [31:0]                      logic_res;
wire                                    add_done;
wire        [31:0]                      add_res;
wire                                    ram_done;
wire        [31:0]                      ram_res;
wire                                    branch_done;
wire        [31:0]                      branch_res;




reg         [1:0]                       use_part;
reg                                     trick;
reg         [3:0]                       stall_clk;




assign ex_done = add_done | logic_done | ram_done | branch_done;



/* parts' control signal */
// start signal only keeps positive for 1 clk
always @ (posedge clk) begin
    if(!rst) begin
        // current inst is valid and not running 
        if(func_part != 'd0 && func_start != 0) begin
            func_working <= func_part;
            ex_rd <= dis_rd;
            trick <= 'd1;
        end

        // current inst is running
        else if(func_busy == 'd1) begin
            func_working <= func_working;
            ex_rd <= ex_rd;
            trick <= 'd0;
        end

        else begin
            func_working <= 'd0;
            ex_rd <= ex_rd;
            trick <= 'd0;
        end
    end

    else begin
        func_working <= 'd0;
        ex_rd <= 'd0;
        trick <= 'd0;
    end
end


always @ (posedge clk) begin
    if(!rst) begin
        if(func_part != 'd0 && ex_cur_pc != dis_cur_pc)
            ex_cur_pc <= dis_cur_pc;
        else 
            ex_cur_pc <= ex_cur_pc;
    end
    else begin
        ex_cur_pc <= 32'hffff_ffff;
    end
end



always @ (*) begin
    if(!rst) begin
        // current inst is valid and not running 
        if(dis_cur_pc != ex_cur_pc) begin
            func_start = func_part;
        end

        // current inst is running
        else if(func_busy == 'd1) begin
            if(trick)
                func_start = 'd0;
            else 
                func_start = func_start;
        end

        else begin
            func_start = 'd0;
        end
    end

    else begin
        func_start = 'd0;
    end
end


always @ (*) begin
    if(!rst) begin
        // current inst is valid and not running 
        if(func_part != 'd0 && func_busy == 'd0) begin
            imm_data_r = imm_data;
            op1_r = op1;
            op2_r = op2;
        end

        // current inst is running
        else if(ex_done) begin
            imm_data_r = 'd0;
            op1_r = 'd0;
            op2_r = 'd0;
        end

        else begin
            imm_data_r = imm_data_r;
            op1_r = op1_r;
            op2_r = op2_r;
        end
    end

    else begin
        imm_data_r = 'd0;
        op1_r = 'd0;
        op2_r = 'd0;
    end
end



always @ (*) begin
    if(!rst) begin
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


always @ (*) begin
    if(!rst) begin
        // when inst is done, keep fetching
        if(ex_done) begin
            ex_stall = 'd0;
        end

        // some inst can be done in 1 clk so there's no need to set stall
        // while some inst cannot done in 1 clk and stall the whole pipeline
        else begin
            // add & sub need multiple clk
            if(func_part[`ADD - `OFFSET] && func_busy) begin
                ex_stall = 'd1;
            end
            else if (func_part[`RAM - `OFFSET] && func_busy) begin
                ex_stall = 'd1;
            end
            else begin
                ex_stall = 'd0;
            end
        end
    end
    else begin
        ex_stall = 'd0;
    end
end




/* choosing output res */
always @ (*) begin
    if(!rst) begin
        if(add_done) begin
            ex_res = add_res;
        end
        
        else if (logic_done) begin
            ex_res = logic_res;
        end

        else if (ram_done) begin
            ex_res = ram_res;
        end

        else if (branch_done) begin
            ex_res = branch_res;
        end

        else begin
            ex_res = ex_res;
        end
    end

    else begin
        ex_res = 'd0;
    end
end




LOGIC logic(
            .clk                    (clk),
            .rst                    (rst),
            .op1                    (op1_r),
            .op2                    (op2_r),
            .start                  (func_start[`LOGIC - `OFFSET]),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (logic_done),
            .res                    (logic_res)
);


ADD_SUB add_sub(
            .clk                    (clk),
            .rst                    (rst),
            .op1                    (op1_r),
            .op2                    (op2_r),
            .start                  (func_start[`ADD - `OFFSET]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (add_done),
            .res                    (add_res)
);



RAM data_ram(
            .clk                    (clk),
            .rst                    (rst),
            .op1                    (op1_r),
            .op2                    (op2_r),
            .imm_data               (imm_data_r),
            .start                  (func_start[`RAM - `OFFSET]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (ram_done),
            .res                    (ram_res)
);



BRANCH branch(
            .clk                    (clk),
            .rst                    (rst),
            .op1                    (op1_r),
            .op2                    (op2_r),
            .imm_data               (imm_data_r),
            .cur_pc                 (dis_cur_pc),
            .start                  (func_start[`BRANCH - `OFFSET]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (branch_done),
            .res                    (branch_res),
            .tar_addr               (ex_tar_addr),
            .need_jmp               (ex_need_jmp)
);





      
endmodule
