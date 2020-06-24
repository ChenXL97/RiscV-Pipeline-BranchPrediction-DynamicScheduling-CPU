//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: PC
// Description: 
// 当前程序地址寄存器，本实验中采用的地址均为实际地址右移两位后的值，即每次 PC=PC+1 （而不是+4）
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input clk,
    input rst,
    input EX_block,
    input [1:0]op,  //用于指示取哪一个值写入pc。可以发现存在一个优先顺序，EX > BTB > pc+4，所以 1X 表示EX写， 01 表示BTB写，00表示pc+4
    input [31:0] EX_addr,
    input [31:0] BTB_addr,
    output reg [31:0]pc
    );
    
  always@(posedge clk or posedge rst)
          if(rst)
              pc<=0;
          else if(!EX_block)
              begin
                casex(op)
                    2'b1x:pc <= EX_addr;
                    2'b01:pc <= BTB_addr;
                    default :pc <= pc+1;
                endcase
              end
              
endmodule
