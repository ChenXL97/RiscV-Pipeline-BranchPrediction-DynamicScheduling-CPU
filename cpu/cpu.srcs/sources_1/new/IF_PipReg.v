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
    output reg[31:0] IF_pip_reg
    );
    
    always@(posedge clk or posedge rst or posedge EX_rst)
        if(rst || EX_rst)
            IF_pip_reg<=32'bx;
        else 
            IF_pip_reg<=ins;
    
endmodule
