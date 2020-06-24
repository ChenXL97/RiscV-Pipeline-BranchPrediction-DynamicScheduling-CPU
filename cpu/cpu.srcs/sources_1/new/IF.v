//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: IF
// Description: 
// 取指模块
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF(
    input clk,
    input rst,
    input EX_block, //用于EX阻塞流水线
    input EX_rst, //用于EX清空流水线
    input EX_write_pc,  //为 1 代表EX要写PC
    input [31:0]EX_addr,  //EX写PC的具体地址
    input BTB_write_pc,  //为 1 代表BTB要写PC
    input [31:0]BTB_addr,  //为BTB写PC的具体地址
    output [31:0] pc,
    output [31:0] IF_pip_reg
    );

    //pc模块
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
    
    //Ins_mem模块
    wire [31:0]ins;  //把指令输出到IF流水线寄存器
    InsMem InsMem
    (
        .clk(clk),
        .pc(pc),
        .ins(ins)
    );
    
    //IF流水线寄存器
    IF_PipReg IF_PipReg
    (
        .clk(clk),
        .rst(rst),
        .EX_rst(EX_rst),
        .ins(ins),
        .IF_pip_reg(IF_pip_reg)
    );
    
    
endmodule
