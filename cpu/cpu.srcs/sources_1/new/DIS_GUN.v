/***************************************************************************************************
                                THE PROJECT IS DESIGNED AND CODED BY
                                            WINTERS WEN
                                NATIONAL UNIVERSITY OF DEFENSE TECHNOLOGY

                                            /
                                          / -----------
                                        /   \      /
                                              \  /
                                               /
                                           /       \
                                        /      *       \
                                    /            *          \
                                               *
                                                 *
                                
***************************************************************************************************/
`include "HeadFile.vh"
`timescale 1ns/100ps


module ISSUSER_GUN(
    input                                       clk,
    input                                       rst,
	
	// rob control flag
	input		[3:0]							end_pt,
	input		[3:0]							head_pt,

	// data relation control signal
	input 		[9:0]							related,
	input		[9:0]							related_busy,

	// hardware relation control signal
	input		[9:0]							hw_relation,
	input		[9:0]							hw_relation_busy,

	// issue valid signal and inst-issued's number
	output		reg								issue_v,
	output		reg		[3:0]					iss_inst,
	output				[9:0]					iss_flag,

	// signal input from rob due from write back
	input		[3:0]							wb_inst,
	input										wb_v,

	// forward data, both input and output
	input		[31:0]							forwd_data_rs1,
	input		[31:0]							forwd_data_rs2,
	input										forwd_data_rs1_v,
	input										forwd_data_rs2_v,
	output		[31:0]							forward_data_rs1_w,
	output		[31:0]							forward_data_rs2_w,
	output		[31:0]							forward_data_rs1_v_w,
	output		[31:0]							forward_data_rs2_v_w,

	// singal to start ex
	input		[14:0]							rob_func_part_start,
	output		reg		[14:0]					func_part_start,
	
	// pc related
	input		[31:0]							rob_iss_inst_pc,
	output		reg [31:0]							iss_iss_inst_pc,

	// related to imm data and imm use
	input		[31:0]							rob_imm_data,
	input		[9:0]							rob_imm_use,
	output		reg [31:0]							iss_imm_data,
	output		reg								iss_imm_use,

	// transfer op mode from rob to ex
	input		[1:0]							rob_op_mode1,
	input		[2:0]							rob_op_mode2,
	output		reg [1:0]							iss_op_mode1,
	output		reg [2:0]							iss_op_mode2
);




reg			[3:0]								inst_search_pt;
reg												check_iss_done;
reg												issue;
reg			[9:0]								iss_flag;

reg			[31:0]								forward_data_rs1;
reg			[31:0]								forward_data_rs2;
reg												forward_data_rs1_v;
reg												forward_data_rs2_v;





// search for proper inst to issue
// search start from end_pt to head_pt - 1
// when an inst is write back, free an unit
// when issue an inst, set func_part_start
always @ (posedge clk) begin
	if(!rst) begin
		// initialize
		inst_search_pt = end_pt;
		check_iss_done = 'd0;
		issue = 'd0;
		iss_inst = 'd11;

		// check 1
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
			
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;
		
		// check 2
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;
		
		// check 3
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;

		// check 4
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;
		
		// check 5
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;

		// check 6
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;

		// check 7
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;

		// check 8
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;

		// check 9
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;

		// check 10
		if(!hw_relation[inst_search_pt] &&
			related_busy[inst_search_pt] && !related[inst_search_pt] && 
			!check_iss_done && !iss_flag[inst_search_pt]) begin
			issue = 'd1;
			check_iss_done = 'd1;
			iss_inst = inst_search_pt;	
			iss_flag[inst_search_pt] = 'd1;
		end
		if(inst_search_pt == 'd9)
			inst_search_pt = 'd0;
		else
			inst_search_pt = inst_search_pt + 'd1;

		// when an inst is write back, free an unit
		if(wb_v) begin
			iss_flag[wb_inst] = 'd0;
		end

	end
	else begin
		inst_search_pt = 'd11;
		check_iss_done = 'd0;
		issue = 'd0;
		iss_inst = 'd11;
		iss_flag = 10'd0;
	end
end





// issue valid signal
always @ (*) begin
	if(!rst) begin
		issue_v = issue;
	end
	else begin
		issue_v = 'd0;
	end
end




// store forwarding data
always @ (posedge clk) begin
	if(!rst) begin
		forward_data_rs1 <= forwd_data_rs1;
		forward_data_rs2 <= forwd_data_rs2;
		forward_data_rs1_v <= forwd_data_rs1_v;
		forward_data_rs2_v <= forwd_data_rs2_v;
	end
	else begin
		forward_data_rs1 <= 'd0;
		forward_data_rs2 <= 'd0;
		forward_data_rs1_v <= 'd0;
		forward_data_rs2_v <= 'd0;
	end
end
assign forward_data_rs1_v_w = forward_data_rs1_v;
assign forward_data_rs1_w = forwd_data_rs1;
assign forward_data_rs2_v_w = forward_data_rs2_v;
assign forward_data_rs2_w = forward_data_rs2;




// store imm_data and imm_use
always @ (posedge clk) begin
	if(!rst) begin
		if(issue) begin
			iss_imm_use <= rob_imm_use[iss_inst];
			iss_imm_data <= rob_imm_data;
		end
		else begin
			iss_imm_use <= 'd0;
			iss_imm_data <= 'd0;
		end
	end
	else begin
		iss_imm_use <= 'd0;
		iss_imm_data <= 'd0;
	end
end





// func_part_start and iss_inst_pc to start ex
always @ (posedge clk) begin
	if(!rst) begin
		if(issue) begin
			func_part_start <= rob_func_part_start;
			iss_iss_inst_pc <= rob_iss_inst_pc;
		end
		else begin
			func_part_start <= 15'b0;
			iss_iss_inst_pc <= iss_iss_inst_pc;
		end
	end
	else begin
		func_part_start <= 'd0;
		iss_iss_inst_pc <= 32'hffff_ffff;
	end
end




// op_mode1 and op_mode2
always @ (posedge clk) begin
	if(!rst) begin
		if(issue) begin
			iss_op_mode1 <= rob_op_mode1;
			iss_op_mode2 <= rob_op_mode2;
		end
		else begin
			iss_op_mode1 <= 2'b11;
			iss_op_mode2 <= 3'b111;
		end
	end
	else begin
		iss_op_mode1 <= 2'b11;
		iss_op_mode2 <= 3'b111;
	end
end


endmodule
