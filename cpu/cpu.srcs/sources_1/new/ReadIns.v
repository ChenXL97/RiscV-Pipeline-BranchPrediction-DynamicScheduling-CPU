`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: ReadIns
// Description: 
// �����ڷ����ʱ����ļ���ָ�InsMemory�У��ļ�
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ReadIns(
//    output ins
    );
    
    integer fp_r,fp_w;  
    integer count;   
    reg clk;
    reg [31:0] ins_mem[1024:0];
    reg[4:0] n;
    integer Write_Out_File;
    
    initial
    begin
        $readmemb("test_file/ins_input.txt",ins_mem);//��path·���µ�data.txt�������Զ����Ƶ���ʽд�뵽data_src_mem��
    	for(n=0;n<=1;n=n+1)   //�Ѱ˸��洢��Ԫ�����ֶ���ȡ������������������˸���Ԫ���x̬���������лῴ��
            $display("%b",ins_mem[n]);
    end
endmodule
