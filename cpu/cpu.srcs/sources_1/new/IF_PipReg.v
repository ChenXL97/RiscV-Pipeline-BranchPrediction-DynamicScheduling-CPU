//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: IF_PipReg
// Description: 
// IF Pipeline Register
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module IF_PipReg(
    input clk,
    input rst,
    input EX_rst,
    input [31:0]ins,
    input [31:0]pc,
    input ex_stall,
    output reg[31:0] IF_pip_reg,
    output reg[31:0] IF_pc
    );
    
    always@(posedge clk or posedge rst or posedge EX_rst)
        if(rst || EX_rst) begin
            IF_pip_reg <= 'd0;
            IF_pc <= 'd0;
        end
        else if (ex_stall) begin
            IF_pip_reg <= IF_pip_reg;
            IF_pc <= IF_pc;
        end
        else begin
            IF_pip_reg <= ins;
            IF_pc <= pc;
        end
endmodule
