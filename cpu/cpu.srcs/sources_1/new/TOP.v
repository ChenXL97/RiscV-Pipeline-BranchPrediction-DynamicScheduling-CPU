//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: TOP
// Description: 
// 顶层文件
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP( );
    
//  模拟clk时钟
    reg clk;
    initial begin
        clk <= 0;
    end
        
    always #10 begin
        clk <= ~clk;
    end
    

//  模拟rst重置信号
    reg rst;
    initial begin
       #1 rst <= 0;
       #1 rst <= 1;
       #1 rst <= 0;
    end
    
//#####################################################
//##########   IF模块   ###############################
//#####################################################
    wire TOMA_rst; //TODO 需要将该线连到TOMA模块，为 1 代表TOMA要清空流水线
    wire TOMA_write_pc;  //TODO 需要将该线连到TOMA模块，为 1 代表TOMA要写PC
    wire [31:0]TOMA_addr;  //TODO 需要将该线连到TOMA模块，为TOMA写PC的具体地址
    wire BTB_write_pc;  //TODO 需要将该线连到BTB模块，为 1 代表BTB要写PC
    wire [31:0]BTB_addr;  //TODO 需要将该线连到BTB模块，为BTB写PC的具体地址

    //TODO 到时候这些赋值全部删除
    assign TOMA_rst = TOMA_rst_reg;
    assign TOMA_write_pc = TOMA_write_pc_reg;
    assign BTB_write_pc = BTB_write_pc_reg;
    assign TOMA_addr = TOMA_addr_reg;
    assign BTB_addr = BTB_addr_reg;
    
    wire [31:0]IF_pip_reg;
    
    IF IF
    (
        .clk(clk),
        .rst(rst),
        .TOMA_rst(TOMA_rst),
        .TOMA_write_pc(TOMA_write_pc),
        .TOMA_addr(TOMA_addr),
        .BTB_write_pc(BTB_write_pc),
        .BTB_addr(BTB_addr),
        .IF_pip_reg(IF_pip_reg)
    );

//#####################################################
//##########   DE模块   ###############################
//#####################################################
    wire [134:0] DE_pip_reg;
    wire is_branch;
    DE DE
    (
        .clk(clk),
        .rst(rst),
        .IF_pip_reg(IF_pip_reg),
        .is_branch(is_branch),
        .branch_addr(branch_addr),
        .DE_pip_reg(DE_pip_reg)
    );
    


//#####################################################
//##########   BTB模块   ###############################
//#####################################################
//    BTB BTB
//    (
//        .clk(clk),
//        .rst(rst),
//        .DE_pip_reg(DE_pip_reg),
//        .is_branch(is_branch),
//        .branch_addr(branch_addr)
//    );

    //BTB模块 TODO到时候这些寄存器都做到模块里面
    reg BTB_write_pc_reg;
    reg BTB_addr_reg;
    initial begin
        BTB_write_pc_reg <= 0;
        BTB_addr_reg <= 0;
    end
    
    
//#####################################################
//##########   TOMA模块   ###############################
//#####################################################
    //TOMA模块 TODO到时候这些寄存器都做到模块里面
    reg TOMA_rst_reg;
    reg TOMA_write_pc_reg;
    reg TOMA_addr_reg;

    initial begin
        TOMA_rst_reg <= 0;
        TOMA_write_pc_reg <= 0;
        TOMA_addr_reg <= 0;
    end
    
    
endmodule
