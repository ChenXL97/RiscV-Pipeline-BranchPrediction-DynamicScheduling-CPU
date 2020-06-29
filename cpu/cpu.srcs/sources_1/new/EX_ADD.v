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
`define ADD 5'b00000
`define SUB 5'b00100
`define ADDI 5'b01000
`define LUI 5'b10000

module EX_ADD(
    // INPUTS
    input is_selected_i,
    input [4:0]op1_op2_i,
    input [31:0]operand_A_i,
    input [31:0]operand_B_i,
    
    // OUTPUTS
    output [31:0]EX_ADD_result_o
    );
    reg [31:0] result_r;
    
    
    always @ (op1_op2_i or operand_A_i or operand_B_i)
    begin
        
    case (op1_op2_i)
        `ADD:
        begin
            result_r = (operand_A_i + operand_B_i);
        end
        `SUB:
        begin
            result_r = (operand_A_i - operand_B_i);
        end
        `ADDI:
         begin
            result_r = (operand_A_i + operand_B_i);
         end
        `LUI:
         begin
            result_r = (operand_A_i + operand_B_i);
         end
    endcase
    end
    assign EX_ADD_result_o = result_r;
endmodule
