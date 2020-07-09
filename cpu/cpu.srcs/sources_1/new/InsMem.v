//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: InsMem
// Description: 
// Instruction Memory
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
    initial begin
        $readmemb("test_file/o.txt",ins_mem);//Read data in '*.txt' as binary form to ins_mem
        $display("%b",ins_mem[0]);
    end
    
    assign ins = ins_mem[pc>>2];
            

endmodule
