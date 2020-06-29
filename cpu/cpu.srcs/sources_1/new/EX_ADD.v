`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/28 10:52:10
// Design Name: 
// Module Name: EX_ADD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define INS_ADD 5'b00000
`define INS_SUB 5'b00100
`define INS_ADDI 5'b01000
`define INS_LUI 5'b10000

module EX_ADD(
    // INPUTS
    input enable_i,
    input [4:0]op1_op2_i,
    input [31:0]reg_A_i,
    input [31:0]reg_B_i,
    input [31:0]imm32_i,
    
    // OUTPUTS
    output [31:0]EX_ADD_result_o
    );
    reg [31:0] result_r;
    
    
    always @ (op1_op2_i or reg_A_i or reg_B_i)
    if (enable_i) begin
        
    case (op1_op2_i)
        `INS_ADD:
        begin
            result_r = (reg_A_i + reg_B_i);
        end
        `INS_SUB:
        begin
            result_r = (reg_A_i - reg_B_i);
        end
        `INS_ADDI:
         begin
            result_r = (reg_A_i + imm32_i);
         end
        `INS_LUI:
         begin
            result_r = imm32_i << 12;
         end
    endcase
    end
    else begin
        result_r = 32'hx;
    end
    
    assign EX_ADD_result_o = result_r;
endmodule
