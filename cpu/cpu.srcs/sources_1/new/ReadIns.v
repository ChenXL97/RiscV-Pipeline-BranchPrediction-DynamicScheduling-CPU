`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: ReadIns
// Description: 
// 用于在仿真的时候从文件读指令到InsMemory中，文件
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
        $readmemb("test_file/ins_input.txt",ins_mem);//将path路径下得data.txt的数据以二进制的形式写入到data_src_mem中
    	for(n=0;n<=1;n=n+1)   //把八个存储单元的数字都读取出来，若存的数不到八个单元输出x态，程序结果中会看到
            $display("%b",ins_mem[n]);
    end
endmodule
