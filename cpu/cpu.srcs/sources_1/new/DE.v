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
    //EX input
    input EX_update,
    input [31:0] EX_ins_pc,
    input [31:0] EX_result_pc,
    input ex_stall,
    input ex_flush,
    // output
    output predict_is_taken,
    output [31:0] predict_pc,
    output [`ROB_ITEM_INDEX] DE_pip_reg,
    output reg [31:0] de_cur_pc
    );
    
    //Decoder
    wire [`ROB_ITEM_INDEX] de_out;
    Decoder Decoder(
        .clk(clk),
        .rst(rst | ex_flush),
        .ins(IF_pip_reg),
        .de_out(de_out)
        );
    
    //BTB
    wire branch_is_taken;
    wire DE_is_branch;
    wire [31:0] de_out_pc;

    BTB BTB(
        .clk(clk),
        .rst(rst),
        .DE_is_branch(DE_is_branch), 
        .de_out_pc(de_out_pc), 
        .EX_update(EX_update), 
        .EX_ins_pc(EX_ins_pc), 
        .EX_result_pc(EX_result_pc), 
        .predict_is_taken(predict_is_taken),
        .predict_pc(predict_pc)
        );
        
    //DE_PipReg
    DE_PipReg DE_PipReg(
        .clk(clk),
        .rst(rst | ex_flush),
        .EX_rst(EX_rst),
        .ex_stall(ex_stall),
        .predict_is_taken(predict_is_taken),
        .de_out(de_out),
        .pc(pc),
        .predict_pc(predict_pc),
        .DE_pip_reg(DE_pip_reg)
        );
        
	//test
	reg [`ROB_ITEM_INDEX] de_ins_mem[64:0];
	wire right;
	wire [71:0] right_de_out;
	wire [71:0] act_de_out;
	wire [31:0] test_pc;
	wire [`ROB_ITEM_INDEX] right_ins;
	wire [31:0] de_imm;
	wire [31:0] imm;
	wire [31:0] right_imm;
	initial begin
	#5
	$readmemb("test_file/de_output_fb.txt",de_ins_mem);
	$display("%b",de_ins_mem[0]);
	
	end
	
	assign test_pc = pc >> 2;
	assign right_ins = de_ins_mem[test_pc-2];
	assign right_de_out = right_ins[167:96];
	assign act_de_out = DE_pip_reg[167:96];
	assign right = (DE_pip_reg[167:96]==right_ins[167:96]);
//     assign de_imm = de_out[`IMM];
	assign imm = DE_pip_reg[`IMM];
	assign right_imm = de_ins_mem[test_pc-2][`IMM];

	always @ (posedge clk) begin
		if(!rst && !ex_flush) begin
            if(!ex_stall)
                de_cur_pc <= pc;
            else
                de_cur_pc <= de_cur_pc;
		end
		else begin
			de_cur_pc <= 'd0;
		end
	end
	
endmodule
