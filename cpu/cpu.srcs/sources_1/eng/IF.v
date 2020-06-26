//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: IF
// Description: 
// Instruction Fetch module
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF(
    input clk,
    input rst,
    input EX_block, //To stall pipeline
    input EX_rst, //To clean pipeline
    input EX_write_pc,  //If 1, means module EX need to Write PC 
    input [31:0]EX_addr,  //Specific PC Address that module EX claims
    input BTB_write_pc,  //If 1, means BTB need to write PC
    input [31:0]BTB_addr,  //Specific PC Address that module BTB claims
    output [31:0] pc,
    output [31:0] IF_pip_reg
    );

    //pc Module
    PC PC
    (
        .clk(clk),
        .rst(rst),
        .EX_block(EX_block),
        .op({EX_write_pc,BTB_write_pc}),
        .EX_addr(EX_addr),
        .BTB_addr(BTB_addr),
        .pc(pc)
    );
    
    //Ins_mem Module
    wire [31:0]ins;  //Output instruction to IF pipeline register
    InsMem InsMem
    (
        .clk(clk),
        .pc(pc),
        .ins(ins)
    );
    
    //IF Pipeline Register
    IF_PipReg IF_PipReg
    (
        .clk(clk),
        .rst(rst),
        .EX_rst(EX_rst),
        .ins(ins),
        .IF_pip_reg(IF_pip_reg)
    );
    
    
endmodule
