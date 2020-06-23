//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: InsMem
// Description: 
// ָ��洢��
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InsMem(
    input clk,
    input [31:0] pc,
    output [31:0] ins
    );
    
    reg [31:0] ins_mem[64:0];
    reg [4:0] n;
    
    initial begin
        $readmemb("test_file/ins_input.txt",ins_mem);//��path·���µ�data.txt�������Զ����Ƶ���ʽд�뵽data_src_mem��
    	for(n=0;n<4;n=n+1)   //�Ѱ˸��洢��Ԫ�����ֶ���ȡ������������������˸���Ԫ���x̬���������лῴ��
            $display("%b",ins_mem[n]);
    end
    
    assign ins = ins_mem[pc];
            

endmodule
