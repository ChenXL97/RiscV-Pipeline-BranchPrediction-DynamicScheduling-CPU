//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: PC
// Description: 
// ��ǰ�����ַ
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input clk,
    input rst,
    input [1:0]op,  //����ָʾȡ��һ��ֵд��pc�����Է��ִ���һ������˳��TOMA > BTB > pc+4������ 1X ��ʾTOMAд�� 01 ��ʾBTBд��00��ʾpc+4
    input [31:0] TOMA_addr,
    input [31:0] BTB_addr,
    output reg [31:0]pc
    );
    
  always@(posedge clk or posedge rst)
          if(rst)
              pc<=0;
          else begin
            casex(op)
                2'b1x:pc <= TOMA_addr;
                2'b01:pc <= BTB_addr;
                default :pc <= pc+1;
            endcase
          end
              
endmodule
