`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: DE
// Description: 
// DE module
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DE(
    input clk,
    input rst,
    input EX_rst,
    //IF input
    input [31:0] IF_pip_reg,
    input [31:0] pc,
    input [31:0] IF_pc,
    input BTB_is_taken,
    input [31:0] BTB_pc,
    //EX input
    input EX_update,
    input [31:0] EX_ins_pc,
    input [31:0] EX_result_pc,
    input ex_stall,
    input ex_flush,
    // output
    output [`ROB_ITEM_INDEX] DE_pip_reg,
    output reg [31:0] de_cur_pc
    );
    
    //Decoder
    wire [`ROB_ITEM_INDEX] de_out;
    Decoder Decoder(
        .clk(clk),
        .rst(rst | ex_flush),
        .BTB_is_taken(BTB_is_taken),
        .ins(IF_pip_reg),
        .de_out(de_out)
        );
    
    //BTB
    wire [31:0] de_out_pc;

        
    //DE_PipReg
    DE_PipReg DE_PipReg(
        .clk(clk),
        .rst(rst | ex_flush),
        .EX_rst(EX_rst),
        .ex_stall(ex_stall),
        .predict_is_taken(BTB_is_taken),
        .predict_pc(BTB_pc),
        .de_out(de_out),
        .pc(IF_pc),
        .DE_pip_reg(DE_pip_reg)
        );
        

	always @ (posedge clk) begin
		if(!rst && !ex_flush) begin
            if(!ex_stall) begin
                de_cur_pc <= pc;
            end
            else begin
                de_cur_pc <= de_cur_pc;
            end
		end
		else begin
			de_cur_pc <= 32'hffff_ffff;
		end
	end
	
endmodule
