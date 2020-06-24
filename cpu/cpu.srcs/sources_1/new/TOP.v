`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: TOP
// Description: 
// �����ļ�
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP( );
    
//  ģ��clkʱ��
    reg clk;
    initial begin
        clk <= 0;
    end
        
    always #10 begin
        clk <= ~clk;
    end
    

//  ģ��rst�����ź�
    reg rst;
    initial begin
       #1 rst <= 0;
       #1 rst <= 1;
       #1 rst <= 0;
    end
    
//#####################################################
//##########   IFģ��   ###############################
//#####################################################
    //��DE�ε���
    wire predict_is_taken;  //Ϊ 1 ����BTBҪдPC
    wire [31:0]predict_pc;  //ΪBTBдPC�ľ����ַ

    wire [31:0] pc;
    wire [31:0]IF_pip_reg;
    
    //��EX�ε���
    wire EX_rst; //Ϊ 1 ����EXҪ�����ˮ��
    wire EX_block; //Ϊ1����EXҪ����
    wire EX_update;  //Ϊ 1 ����EXҪдPC
    wire [31:0]EX_result_pc;  //ΪEXдPC�ľ����ַ

    //IFģ�飬����PC��InsMem,IF_PipReg
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
//##########   DEģ��   ###############################
//#####################################################
    wire [`ROB_ITEM_INDEX] DE_pip_reg;
    
    //DEģ�飬����Decoder��BTB, DE_PipReg
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
//##########   EXģ��   ###############################
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
