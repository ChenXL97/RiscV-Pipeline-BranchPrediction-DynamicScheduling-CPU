`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/28 10:52:10
// Design Name: 
// Module Name: EX_LS_RAM
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
`define INS_LB  5'b00000
`define INS_LH  5'b00010
`define INS_LW  5'b00100
`define INS_LBU  5'b00001
`define INS_LHU  5'b00011
`define INS_SB  5'b01000
`define INS_SH  5'b01010
`define INS_SW  5'b01100
`define INS_FL  5'b10000
`define INS_FS  5'b11000

module EX_LS_RAM(
    // INPUTS
    input enable_i,
    input [4:0]op1_op2_i,
    input [31:0]reg_A_i,
    input [31:0]reg_B_i,
    input [31:0]imm32_i,
    
    // OUTPUTS
    output [31:0]EX_LS_RAM_address_o,
    output reg is_wr_o
    );
    
    reg [31:0] result_r;
   
    
    always @ (enable_i or op1_op2_i or reg_A_i or reg_B_i)
    if (enable_i) begin
        
    case (op1_op2_i)
                //TODO: LB LH ......
        `INS_LB: // x[rd] = sext(M[ x[rs1] +  imm][7:0])
        begin
            result_r = (reg_A_i + imm32_i); // Address Calculate
            is_wr_o = 0;
        end
        `INS_LH: // x[rd] = sext(M[ x[rs1] +  imm][15:0])
        begin
            result_r = (reg_A_i + imm32_i); // Address Calculate
            is_wr_o = 0;
        end
        `INS_LW: // x[rd] = sext(M[ x[rs1] +  imm][31:0])
         begin
            result_r = (reg_A_i + imm32_i); // Address Calculate
            is_wr_o = 0;
         end
        `INS_SW: // M[x[rs1] + sext(offset)]  = x[rs2][31:0]
         begin
            result_r = (reg_A_i + imm32_i); // Address Calculate
            is_wr_o = 1;
         end
    endcase
    end
    else begin
        result_r = 32'hx;
    end
    
    assign EX_LS_RAM_address_o = result_r;
endmodule
