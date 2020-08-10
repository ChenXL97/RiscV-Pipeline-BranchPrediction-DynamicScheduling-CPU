//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: PC
// Description: 
// Current Program Counter Register. 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input clk,
    input rst,
    input EX_block,
    input [2:0]op,  //Indicate which value to write in PC. 
                        //The priority is : RE > EX > BTB > PC+4. 
                        //3'b1xx revert jump 3'b01x represents EX write, 3'b01 represents BTB write, 3'b00 represents PC+4.
    input [31:0] revert_addr,
    input BTB_write_pc,
    input [31:0] EX_addr,
    input [31:0] BTB_addr,
    input EX_rst,
    input EX_need_jump,
    output reg [31:0]pc
    );
    
  always@(posedge clk or posedge rst)
          if(rst)
              pc<= `INIT_PC;
          else if (op[2])
               pc <= revert_addr;
//            pc <= pc + 'd4;
          else if (EX_rst && op[1]) begin
              pc <= EX_addr;
          end
          else if (EX_block) begin
              pc <= pc;
          end
          else if (op[0]) begin
               pc <= BTB_addr;
//              pc <= pc + 'd4;
          end
          else begin
              pc <= pc + 'd4;
          end
              
endmodule
