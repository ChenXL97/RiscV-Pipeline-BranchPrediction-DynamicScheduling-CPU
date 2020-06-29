`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 17:01:41
// Design Name: 
// Module Name: MEM
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


module MEM(
    input clk_i,
    input rst_i,
    input [`ROB_ITEM_INDEX]EX_pip_reg_i,
    input [31:0]rs2_i,
    input [31:0]EX_result_i,//Address
    input MEM_is_write_i,
    output reg [`ROB_ITEM_INDEX]MEM_pip_reg_o,
    output [31:0] MEM_result_o
    );
    
reg [31:0]DMin;
always @ (posedge clk_i) 
    DMin<=rs2_i;
    
DataMemory DataMemory(
    .clk(clk_i),
    .rst(rst_i),
    .DMin(DMin),
    .DMaddr(EX_result_i),
    .DMwr(MEM_is_write_i),
    .DMout(MEM_result_o)
);

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        MEM_pip_reg_o <= 32'bx;
    end
    else begin
        MEM_pip_reg_o <= EX_pip_reg_i;
    end
end

endmodule
