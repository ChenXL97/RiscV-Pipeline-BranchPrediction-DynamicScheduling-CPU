//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: TOP
// Description: 
// �����ļ�
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP( );
    
//  ģ��clkʱ��
    reg clk;
    initial begin
        clk <= 0;
    end
        
    always #10 begin
        clk <= ~clk;
    end
    

//  ģ��rst�����ź�
    reg rst;
    initial begin
       #1 rst <= 0;
       #1 rst <= 1;
       #1 rst <= 0;
    end
    
//#####################################################
//##########   IFģ��   ###############################
//#####################################################
    wire TOMA_rst; //TODO ��Ҫ����������TOMAģ�飬Ϊ 1 ����TOMAҪ�����ˮ��
    wire TOMA_write_pc;  //TODO ��Ҫ����������TOMAģ�飬Ϊ 1 ����TOMAҪдPC
    wire [31:0]TOMA_addr;  //TODO ��Ҫ����������TOMAģ�飬ΪTOMAдPC�ľ����ַ
    wire BTB_write_pc;  //TODO ��Ҫ����������BTBģ�飬Ϊ 1 ����BTBҪдPC
    wire [31:0]BTB_addr;  //TODO ��Ҫ����������BTBģ�飬ΪBTBдPC�ľ����ַ

    //TODO ��ʱ����Щ��ֵȫ��ɾ��
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
//##########   DEģ��   ###############################
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
//##########   BTBģ��   ###############################
//#####################################################
//    BTB BTB
//    (
//        .clk(clk),
//        .rst(rst),
//        .DE_pip_reg(DE_pip_reg),
//        .is_branch(is_branch),
//        .branch_addr(branch_addr)
//    );

    //BTBģ�� TODO��ʱ����Щ�Ĵ���������ģ������
    reg BTB_write_pc_reg;
    reg BTB_addr_reg;
    initial begin
        BTB_write_pc_reg <= 0;
        BTB_addr_reg <= 0;
    end
    
    
//#####################################################
//##########   TOMAģ��   ###############################
//#####################################################
    //TOMAģ�� TODO��ʱ����Щ�Ĵ���������ģ������
    reg TOMA_rst_reg;
    reg TOMA_write_pc_reg;
    reg TOMA_addr_reg;

    initial begin
        TOMA_rst_reg <= 0;
        TOMA_write_pc_reg <= 0;
        TOMA_addr_reg <= 0;
    end
    
    
endmodule
