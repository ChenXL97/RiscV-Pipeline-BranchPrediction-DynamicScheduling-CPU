`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: EX
// Description: 
// EX¶ÎÄ£¿é
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EX(
    input clk,
    input rst,
    input DE_pip_reg,
    output reg EX_rst,
    output reg EX_block,
    output reg EX_update,
    output reg [31:0] EX_result_pc
    );
    
    initial begin
        EX_rst <= 0;
        EX_block <= 0;
        EX_update <= 0;
        EX_result_pc <= 0;
    end
        
endmodule
