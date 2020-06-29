`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/28 10:52:10
// Design Name: 
// Module Name: EX_CMP
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
`define INS_BLT 5'b01010

module EX_BRANCH(
    // INPUTS
    input enable_i,
    input [4:0]op1_op2_i,
    input [31:0]pc_i,
    input [31:0]reg_A_i,
    input [31:0]reg_B_i,
    input [31:0]imm32_i,
    // OUTPUTS
    output [31:0]EX_BRANCH_result_o,
    output EX_BRANCH_Flag
    );
    
    reg [31:0]result_r;    
    reg branch_flag;
    always @ (enable_i or op1_op2_i or reg_A_i or reg_B_i)
    if (enable_i) begin
   
    case (op1_op2_i)
        `INS_BLT:
        begin
            if (reg_A_i < reg_B_i)  begin
                result_r = pc_i + imm32_i;
                branch_flag = 1;
           end
           else begin
                result_r = pc_i;
                branch_flag=0;
           end
        end
    endcase
    end
    else begin
        result_r = 32'hx;
        branch_flag = 0;
    end
    assign EX_BRANCH_result_o = result_r;
    assign EX_BRANCH_Flag=branch_flag;
endmodule
