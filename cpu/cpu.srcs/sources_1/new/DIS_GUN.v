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
	output		[31:0]							forward_data_rs2_v_w

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

endmodule
