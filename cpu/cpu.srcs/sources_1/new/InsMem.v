//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: InsMem
// Description: 
// 指令存储器
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
        $readmemb("test_file/ins_input.txt",ins_mem);//将path路径下得data.txt的数据以二进制的形式写入到data_src_mem中
        $display("%b",ins_mem[0]);
    end
    
    assign ins = ins_mem[pc>>2];
            

endmodule
