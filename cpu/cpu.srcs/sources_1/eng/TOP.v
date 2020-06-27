`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: TOP
// Description: 
// Top File
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TOP( );
    
//  Simulated clk clock
    reg clk;
    initial begin
        clk <= 0;
        $dumpfile("test.vcd");
        $dumpvars(0, TOP);
        # 10000
        $finish;
    end
        
    always #10 begin
        clk <= ~clk;
    end
    

//  Simulated Reset Signal 
    reg rst;
    initial begin
       #1 rst <= 0;
       #1 rst <= 1;
       #1 rst <= 0;
    end
    
//#####################################################
//##########   IF Module   ############################
//#####################################################
    //Wires to|from DE module
    wire predict_is_taken;  //1 when BTB need to write PC
    wire [31:0]predict_pc;  //Corresponding PC from BTB

    wire [31:0] pc;
    wire [31:0]IF_pip_reg;
    
    //Wires to|from EX module
    wire EX_rst; //1 when EX need to flush pipeline
    wire EX_block; //1 when EX need to be stalled
    wire EX_update;  //1 when EX need to write PC
    wire [31:0]EX_result_pc;  //Corresponding PC from EX

    //IF module, including PC, InsMem, IF_PipReg
    IF IF
    (
        .clk(clk),
        .rst(rst),
        .EX_block(EX_block),
        .EX_rst(EX_rst),
        .EX_write_pc(EX_update),
        .EX_addr(EX_result_pc),
        .BTB_write_pc(predict_is_taken),
        .BTB_addr(predict_pc),
        .pc(pc),
        .IF_pip_reg(IF_pip_reg)
        
        
        
    );

//#####################################################
//##########   DEModule   #############################
//#####################################################
    wire [`ROB_ITEM_INDEX] DE_pip_reg;
    
    //DE module, Including Decode, BTB, DE_PipReg
    DE DE
    (
        .clk(clk),
        .rst(rst),
        .EX_rst(EX_rst),
        .IF_pip_reg(IF_pip_reg),
        .pc(pc),
        .EX_update(EX_update),
        .EX_result_pc(EX_result_pc),
        .predict_is_taken(predict_is_taken),
        .predict_pc(predict_pc),
        .DE_pip_reg(DE_pip_reg)
    );

//#####################################################
//##########   EXModule   #############################
//#####################################################    
    EX EX
    (
        .clk(clk),
        .rst(rst),
        .DE_pip_reg(DE_pip_reg),
        .EX_rst(EX_rst),
        .EX_block(EX_block),
        .EX_update(EX_update),
        .EX_result_pc(EX_result_pc)
    );
    
endmodule
