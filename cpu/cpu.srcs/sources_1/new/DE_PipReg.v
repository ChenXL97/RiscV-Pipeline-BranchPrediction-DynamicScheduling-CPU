
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: DE_PipReg
// Description: 
// DE pipline register
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DE_PipReg(
    input clk,
    input rst,
    input EX_rst,
    input ex_stall,
    input predict_is_taken,
    input [31:0] pc,
    input [31:0] predict_pc,
    input [`ROB_ITEM_INDEX] de_out,
    output reg [`ROB_ITEM_INDEX] DE_pip_reg
    );
    
    always@(posedge clk or posedge rst or posedge EX_rst)
        if(rst || EX_rst)
            DE_pip_reg <= 0;
        else if(ex_stall) begin
            DE_pip_reg <= DE_pip_reg;
        end
        else begin   
            DE_pip_reg <= de_out;
            DE_pip_reg[`PREDICT] <= predict_is_taken;
            DE_pip_reg[`OPC] <= pc;
            DE_pip_reg[`PPC] <= predict_pc;
        end

endmodule
