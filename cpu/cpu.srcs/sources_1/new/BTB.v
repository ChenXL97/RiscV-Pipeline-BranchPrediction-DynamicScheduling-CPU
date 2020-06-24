`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: Decoder
// Description: 
// ·ÖÖ§Ô¤²âÆ÷
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BTB(
    input clk,
    input rst,
    input DE_is_branch, 
    input [31:0] DE_ins_pc, 
    input EX_update, 
    input [31:0] EX_ins_pc, 
    input [31:0] EX_result_pc,
    output reg predict_is_taken,
    output reg [31:0] predict_pc
    );
    
    initial begin
        predict_is_taken <= 0;
        predict_pc <= 0;
    end
    
    
endmodule
