`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: BTB
// Description: 
// Branch Table Buffer
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////





module BTB(
    input clk,
    input rst, 
    input [31:0] cur_pc, 
    input EX_is_branch, //is a branch instruction
    input EX_branch_taken, //branch is taken or not
    input [31:0] EX_ins_pc, 
    input [31:0] EX_result_pc,

    // output
    output reg btb_taken,
    output reg [31:0] predict_pc
    );
//localparam BTBW = 5;
reg [31:0] btb [255:0];

    
    
reg [1:0] counter [255:0];
reg [8-1:0]entry;

wire [8-1:0]set_tb_entry;
wire [8-1:0]tb_entry;
assign set_tb_entry = EX_ins_pc[8+2-1:2];
assign tb_entry = cur_pc[8+2-1:2];

always @(posedge clk or posedge rst)
    if(rst)
         for(entry=0; entry < 256; entry=entry+1) // reset BTB entries
            counter[entry] <= 2'b00;
        else if(EX_is_branch && EX_branch_taken && counter[set_tb_entry] != 2'b11) begin
             counter[set_tb_entry] <= counter[set_tb_entry] + 2'b01;
        end
        else if(EX_is_branch && !EX_branch_taken && counter[set_tb_entry] != 2'b00) begin
             counter[set_tb_entry] <= counter[set_tb_entry] - 2'b01;
    end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset
        for (entry=0; entry<256; entry=entry+1)
            btb[entry] <=32'd9999;
        end
    else if (EX_is_branch) begin
        btb[set_tb_entry] <= EX_result_pc;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        btb_taken<=0;// reset
    end
    else  begin
        btb_taken <= counter[tb_entry][1]; //Take high bit for BOOL
    end
end

always @(posedge clk or posedge rst)
    if(rst)
        predict_pc<=32'd9999;
    else
        predict_pc <= btb[tb_entry];
   
endmodule
