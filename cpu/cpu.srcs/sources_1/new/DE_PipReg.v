
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: DE_PipReg
// Description: 
// DEÁ÷Ë®Ïß¼Ä´æÆ÷
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DE_PipReg(
    input clk,
    input rst,
    input EX_rst,
    input predict_is_taken,
    input [`DE_OUT_LEN]de_out,
    input [31:0] pc,
    input [31:0] predict_pc,
    output reg [`ROB_ITEM_LEN] DE_pip_reg
    );
    
    always@(posedge clk or posedge rst or posedge EX_rst)
        if(rst || EX_rst)
            DE_pip_reg<=0;
        else 
            DE_pip_reg <= {predict_is_taken,de_out,32'b0, pc, predict_pc};
    

endmodule
