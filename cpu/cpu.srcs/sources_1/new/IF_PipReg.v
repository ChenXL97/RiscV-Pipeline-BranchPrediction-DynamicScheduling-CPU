//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: IF_PipReg
// Description: 
// 取值段流水线寄存器
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module IF_PipReg(
    input clk,
    input rst,
    input TOMA_rst,
    input [31:0]ins,
    output reg[31:0] IF_pip_reg
    );
    
    always@(posedge clk or posedge rst or posedge TOMA_rst)
        if(rst || TOMA_rst)
            IF_pip_reg<=0;
        else 
            IF_pip_reg<=ins;
    
endmodule
