//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: PC
// Description: 
// Current Program Counter Register. 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//    Note: In this project, we divide it by 4, Which means we do PC +=1 
//          instead of PC +=4
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input clk,
    input rst,
    input EX_block,
    input [1:0]op,  //Indicate which value to write in PC. 
                    //The priority is : EX > BTB > PC+4. 
                    //2'b1x represents EX write, 2'b01 represents BTB write, 2'b00 represents PC+4.
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
                    default :pc <= pc+1; // Read Notes in the heading.
                endcase
              end
              
endmodule
