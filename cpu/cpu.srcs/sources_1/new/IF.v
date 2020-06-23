//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: IF
// Description: 
// ȡָģ��
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF(
    input clk,
    input rst,
    input TOMA_rst, //����TOMA�����ˮ��
    input TOMA_write_pc,  //Ϊ 1 ����TOMAҪдPC
    input [31:0]TOMA_addr,  //TOMAдPC�ľ����ַ
    input BTB_write_pc,  //Ϊ 1 ����BTBҪдPC
    input [31:0]BTB_addr,  //ΪBTBдPC�ľ����ַ

    output [31:0] IF_pip_reg
    );

    //pcģ��
    wire [31:0]pc;  //pc��ַ
    PC PC
    (
        .clk(clk),
        .rst(rst),
        .op({TOMA_write_pc,BTB_write_pc}),
        .TOMA_addr(TOMA_addr),
        .BTB_addr(BTB_addr),
        .pc(pc)
    );
    
    //Ins_memģ��
    wire [31:0]ins;  //��ָ�������IF��ˮ�߼Ĵ���
    InsMem InsMem
    (
        .clk(clk),
        .pc(pc),
        .ins(ins)
    );
    
    //IF��ˮ�߼Ĵ���
    IF_PipReg IF_PipReg
    (
        .clk(clk),
        .rst(rst),
        .TOMA_rst(TOMA_rst),
        .ins(ins),
        .IF_pip_reg(IF_pip_reg)
    );
    
    
endmodule
