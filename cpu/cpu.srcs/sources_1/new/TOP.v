`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: TOP
// Description: 
// 顶层文件
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP( );
    
//  模拟clk时钟
    reg clk;
    initial begin
        clk <= 0;
    end
        
    always #10 begin
        clk <= ~clk;
    end
    

//  模拟rst重置信号
    reg rst;
    initial begin
       #1 rst <= 0;
       #1 rst <= 1;
       #1 rst <= 0;
    end
    
//#####################################################
//##########   IF模块   ###############################
//#####################################################
    //连DE段的线
    wire predict_is_taken;  //为 1 代表BTB要写PC
    wire [31:0]predict_pc;  //为BTB写PC的具体地址

    wire [31:0] pc;
    wire [31:0]IF_pip_reg;
    
    //连EX段的线
    wire EX_rst; //为 1 代表EX要清空流水线
    wire EX_block; //为1代表EX要阻塞
    wire EX_update;  //为 1 代表EX要写PC
    wire [31:0]EX_result_pc;  //为EX写PC的具体地址

    //IF模块，包含PC，InsMem,IF_PipReg
    IF IF
    (
        .clk(clk),
        .rst(rst),
        .EX_block(EX_block),
        .EX_rst(EX_rst),
        .EX_write_pc(EX_update),
        .EX_addr(EX_result_pc),
        .pc(pc),
        .IF_pip_reg(IF_pip_reg)
    );

//#####################################################
//##########   DE模块   ###############################
//#####################################################
    wire [`ROB_ITEM_INDEX] DE_pip_reg;
    
    //DE模块，包含Decoder，BTB, DE_PipReg
    DE DE
    (
        .clk(clk),
        .rst(rst),
        .EX_rst(EX_rst),
        .IF_pip_reg(IF_pip_reg),
        .pc(pc),
        .EX_update(EX_update),
        .EX_result_pc(EX_result_pc),
        .predict_is_taken(predict_is_taken),
        .predict_pc(predict_pc),
        .DE_pip_reg(DE_pip_reg)
    );

//#####################################################
//##########   EX模块   ###############################
//#####################################################    
    EX EX
    (
        .clk(clk),
        .rst(rst),
        .DE_pip_reg(DE_pip_reg),
        .EX_rst(EX_rst),
        .EX_block(EX_block),
        .EX_update(EX_update),
        .EX_result_pc(EX_result_pc)
    );
    
endmodule
