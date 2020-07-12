//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: IF
// Description: 
// IF
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF(
    input clk,
    input rst,
    // EX input
    input EX_block,
    input EX_rst,
    
    //BTB update
    input [31:0]EX_pc_i,
    input EX_write_pc,  //taken or not
    input [31:0]EX_addr,
    input EX_is_branch,
    

    output [31:0] pc,
    output [31:0] IF_pip_reg
    );

    // BTB input
    wire BTB_write_pc;
    wire [31:0]BTB_addr;
    
    //pc
    PC PC
    (
        .clk(clk),
        .rst(rst),
        .EX_rst(EX_rst),
        .EX_block(EX_block),
        .op({EX_write_pc,BTB_write_pc}),
        .EX_addr(EX_addr),
        .BTB_addr(BTB_addr),
        .pc(pc)
    );
    
    //Ins_mem
    // InsMem to IF PipReg
    wire [31:0]ins;
    InsMem InsMem
    (
        .clk(clk),
        .pc(pc),
        .ins(ins)
    );
    
    //IF
    IF_PipReg IF_PipReg
    (
        .clk(clk),
        .rst(rst),
        .ex_stall(EX_block),
        .EX_rst(EX_rst),
        .ins(ins),
        .IF_pip_reg(IF_pip_reg)
    );
   
    BTB BTB(
    .clk(clk),
    .rst(rst),
    .cur_pc(pc), 
    .EX_is_branch(EX_is_branch),
    .EX_branch_taken(EX_rst), 
    .EX_ins_pc(EX_pc_i), 
    .EX_result_pc(EX_addr), 

    //output
    .btb_taken(BTB_write_pc),
    .predict_pc(BTB_addr)
    );
    
endmodule
