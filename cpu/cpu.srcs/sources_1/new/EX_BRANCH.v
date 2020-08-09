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

module BRANCH (
    input                               clk,
    input                               rst,

    input       [31:0]                  op1,  // rs1
    input       [31:0]                  op2,  // rs2
    input       [31:0]                  imm_data,  // imm
    input       [31:0]                  cur_pc,

    // give one clk postive signal, then start this module
    input                               start,

    // choose which compute part to use, there is only one part in this module
    input       [1:0]                   use_part,

    input       [1:0]                   op_mode1,
    input       [2:0]                   op_mode2,

    output      reg                             done,

    // when there's need to store the current pc or other addr, use res reg to 
    // transfer this addr, while tar_addr only be used to store branch target
    // address.
    output      reg     [31:0]                  res,
    output      reg     [31:0]                  tar_addr,

    output      reg                             need_jmp
);




// used to compare unsigned data
reg         [32:0]                      op1_u;
reg         [32:0]                      op2_u;
reg         [32:0]                      op1_r;
reg         [32:0]                      op2_r;


always @ (start) begin
    if(!rst) begin
        if(start) begin
            op1_r = op1;
            op2_r = op2;
        end
        else begin
            op1_r = op1_r;
            op2_r = op2_r;
        end
    end
    else begin
        op1_r = 'd0;
        op2_r = 'd0;
    end
end



// store unsigned data
always @ (*) begin
    if(!rst) begin
        if(op_mode2[2]) begin
            op1_u = {1'b0, op1_r};
            op2_u = {1'b0, op2_r};
        end
    end

    else begin
        op1_u = 'd0;
        op2_u = 'd0;
    end
end



// control done signal
always @ (posedge clk) begin
    if(!rst) begin
        if(start) begin
            done <= 'd1;
        end
        else begin
            done <= 'd0;
        end
    end
    else begin
        done <= 'd0;
    end
end




// control res value
always @ (posedge clk) begin
    if(!rst) begin
        if(start) begin
            case (op_mode1)
            // jal & jalr
            'b00: begin
                res <= cur_pc;
            end

            // auipc
            'b11: begin
                if(op_mode2 == 'd0) begin
                    res <= cur_pc;
                end
                else begin
                    res <= res;
                end
            end

            default: begin
                res <= res;
            end

            endcase
        end

        else begin
            res <= res;
        end
    end
    else begin
        res <= 'd0;
    end
end




// compute branch addr
always @ (posedge clk) begin
    if(!rst) begin
        if(start) begin
            case (op_mode1)
            // JAL & JALR
            'b00: begin
                need_jmp <= 'd1;

                // JAL relative jump
                if(op_mode2[2] == 'd0) begin
                    tar_addr <= imm_data + cur_pc;
                end

                // JALR absolute jump
                else begin
                    tar_addr <= op1_r + imm_data;
                end
            end

            // conditional branch
            'b01: begin
                case (op_mode2) 
                // beq
                'b000: begin
                    if(op1_r == op2_r) begin
                        need_jmp <= 'd1;
                        tar_addr <= imm_data + cur_pc;
                    end
                    else begin
                        need_jmp <= 'd0;
                        tar_addr <= imm_data + cur_pc;
                    end
                end

                // bne
                'b001: begin
                    if(op1_r != op2_r) begin
                        need_jmp <= 'd1;
                        tar_addr <= imm_data + cur_pc;
                    end
                    else begin
                        need_jmp <= 'd0;
                        tar_addr <= imm_data + cur_pc;
                    end
                end

                // blt
                'b010: begin
                    if(op1_r < op2_r) begin
                        need_jmp <= 'd1;
                        tar_addr <= imm_data + cur_pc;
                    end
                    else begin
                        need_jmp <= 'd0;
                        tar_addr <= imm_data + cur_pc;
                    end
                end

                // bge
                'b011: begin
                    if(op1_r >= op2_r) begin
                        need_jmp <= 'd1;
                        tar_addr <= imm_data + cur_pc;
                    end
                    else begin
                        need_jmp <= 'd0;
                        tar_addr <= imm_data + cur_pc;
                    end
                end

                // bltu
                'b100: begin
                    if(op1_u < op2_u) begin
                        need_jmp <= 'd1;
                        tar_addr <= imm_data + cur_pc;
                    end
                    else begin
                        need_jmp <= 'd0;
                        tar_addr <= imm_data + cur_pc;
                    end
                end

                // bgeu
                'b110: begin
                    if(op1_u >= op2_u) begin
                        need_jmp <= 'd1;
                        tar_addr <= imm_data + cur_pc;
                    end
                    else begin
                        need_jmp <= 'd0;
                        tar_addr <= imm_data + cur_pc;
                    end
                end

                default: begin
                    need_jmp <= 'd0;
                    tar_addr <= 'd0;
                end

                endcase
            end

            // auipc
            'b11: begin
                if(op_mode2 == 3'b000) begin
                    tar_addr <= imm_data + cur_pc;
                    need_jmp <= 'd1;
                end
                else begin
                    tar_addr <= imm_data + cur_pc;
                    need_jmp <= 'd0;
                end
            end

            default: begin
                tar_addr <= 'd0;
                need_jmp <= 'd0;
            end

            endcase
        end
        else begin
            tar_addr <= 'd0;
            need_jmp <= 'd0;
        end
    end

    else begin
        tar_addr <= 'd0;
        need_jmp <= 'd0;
    end
end



endmodule
