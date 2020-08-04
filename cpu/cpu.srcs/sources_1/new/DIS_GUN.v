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
	output				[9:0]					iss_flag
);




reg			[3:0]								inst_search_pt;
reg												check_iss_done;
reg												issue;
reg			[9:0]								iss_flag;




// search for proper inst to issue
// search start from end_pt to head_pt - 1
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

	end
	else begin
		inst_search_pt = 'd11;
		check_iss_done = 'd0;
		issue = 'd0;
		iss_inst = 'd11;
		iss_flag = 10'd0;
	end
end






always @ (*) begin
	if(!rst) begin
		issue_v = issue;
	end
	else begin
		issue_v = 'd0;
	end
end













endmodule
