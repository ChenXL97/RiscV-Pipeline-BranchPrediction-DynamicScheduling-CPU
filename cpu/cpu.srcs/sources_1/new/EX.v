`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: EX
// Description: 
// EX module
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define OFFSET 143

module EX(
    input                               clk,
    input                               rst,

    input       [31:0]                  op1,  // rs1
    input       [31:0]                  op2,  // rs2
    input       [31:0]                  imm_data,  // imm
    input       [31:0]                  cur_pc,

    input       [14:0]                  func_part,

    input       [1:0]                   op_mode1,
    input       [2:0]                   op_mode2,

    output                              ex_done,

    // when there's need to store the current pc or other addr, use res reg to 
    // transfer this addr, while tar_addr only be used to store branch target
    // address.
    output      reg     [31:0]                  ex_res,

    //  jmp info signal 
    output      [31:0]                  ex_tar_addr,
    output      reg                     ex_need_jmp,

    // set stall when some inst needs multiply clks
    output      reg                     ex_stall,
    
    // set flush when branch inst need jmp
    output      reg                     ex_flush
    );




reg         [14:0]                      func_start;
reg                                     func_busy;


// wire between sub module
wire                                    logic_done;
wire        [31:0]                      logic_res;
wire                                    add_done;
wire        [31:0]                      add_res;






reg         [1:0]                       use_part;





assign ex_done = add_done | logic_done;


always @ (posedge clk) begin
    if(!rst) begin
        // current inst is valid and not running 
        if(func_part != 'd0 && func_busy == 'd0) begin
            func_busy <= 'd1;
            func_start <= func_part;
            // ex_stall <= 'd0;
        end

        // current inst is running
        else if(func_part != 'd0 && func_busy == 'd1) begin
            func_start <= 'd0;

            if(ex_done) begin
                func_busy <= 'd0;
                // ex_stall <= 'd0;
            end
            else begin
                func_busy <= 'd1;
                // ex_stall <= 'd1;
            end
        end

        else begin
            func_busy <= func_busy;
            func_start <= 'd0;
            // ex_stall <= 'd0;
        end
    end

    else begin
        func_busy <= 'd0;
        func_start <= 'd0;
        // ex_stall <= 'd0;
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
            .op1                    (op1),
            .op2                    (op2),
            .start                  (func_start[`LOGIC - `OFFSET]),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (logic_done),
            .res                    (logic_res)
);


ADD_SUB add_sub(
            .clk                    (clk),
            .rst                    (rst),
            .op1                    (op1),
            .op2                    (op2),
            .start                  (func_start[`ADD - `OFFSET]),
            .use_part               (2'b01),
            .op_mode1               (op_mode1),
            .op_mode2               (op_mode2),
            .done                   (add_done),
            .res                    (add_res)
);



      
endmodule
