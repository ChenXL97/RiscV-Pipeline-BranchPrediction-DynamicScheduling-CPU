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
`timescale 1ns/100ps

module SHIFT(
    input                               clk,
    input                               rst,

    // op1 <- rs1
	// op2 represents shift amounts, occupy lowest 5 bit of op2
    input       [31:0]                  op1,
    input       [31:0]                  op2,

    // give one clk postive signal, then start this module
    input                               start,

    // all operation is done in one clk
	// so there only need one shift part in this module
    input       [1:0]                   use_part,

    input       [1:0]                   op_mode1,
    input       [2:0]                   op_mode2,

    output      reg                             done,
    output      reg     [31:0]                  res

);


always @ (posedge clk) begin
	if(!rst) begin
		if(start) begin
			done <= 'd1;
			
			// SLL
			if(op_mode1 == 'd0 && op_mode2 == 'd0) begin
				res <= op1 << op2;
			end

			// SRL
			else if (op_mode1 == 'd0 && op_mode2 == 'b010) begin
				res <= op1 >> op2;
			end

			// SLLI
			else if (op_mode1 == 'b10 && op_mode2 == 'b000) begin
				res <= op1 << op2;
			end

			// SRLI
			else if (op_mode1 == 'b10 && op_mode2 == 'b010) begin
				res <= op1 >> op2;
			end

			// SRA & SRAI
			else if ( op_mode1 == 'b00 && op_mode2 == 'b100 ) begin
				case (op2)
				'd0: begin
					res <= op1;
				end
				'd1: begin
					res <= {op1[31], op1[31:1]};
				end
				'd2: begin
					res <= {{2{op1[31]}}, op1[31:2]};
				end
				'd3: begin
					res <= {{3{op1[31]}}, op1[31:3]};
				end
				'd4: begin
					res <= {{4{op1[31]}}, op1[31:4]};
				end
				'd5: begin
					res <= {{5{op1[31]}}, op1[31:5]};
				end
				'd6: begin
					res <= {{6{op1[31]}}, op1[31:6]};
				end
				'd7: begin
					res <= {{7{op1[31]}}, op1[31:7]};
				end
				'd8: begin
					res <= {{8{op1[31]}}, op1[31:8]};
				end
				'd9: begin
					res <= {{9{op1[31]}}, op1[31:9]};
				end
				'd10: begin
					res <= {{10{op1[31]}}, op1[31:10]};
				end
				'd11: begin
					res <= {{11{op1[31]}}, op1[31:11]};
				end
				'd12: begin
					res <= {{12{op1[31]}}, op1[31:12]};
				end
				'd13: begin
					res <= {{13{op1[31]}}, op1[31:13]};
				end
				'd14: begin
					res <= {{14{op1[31]}}, op1[31:14]};
				end
				'd15: begin
					res <= {{15{op1[31]}}, op1[31:15]};
				end
				'd16: begin
					res <= {{16{op1[31]}}, op1[31:16]};
				end
				'd17: begin
					res <= {{17{op1[31]}}, op1[31:17]};
				end
				'd18: begin
					res <= {{18{op1[31]}}, op1[31:18]};
				end
				'd19: begin
					res <= {{19{op1[31]}}, op1[31:19]};
				end
				'd20: begin
					res <= {{20{op1[31]}}, op1[31:20]};
				end
				'd21: begin
					res <= {{21{op1[31]}}, op1[31:21]};
				end
				'd22: begin
					res <= {{22{op1[31]}}, op1[31:22]};
				end
				'd23: begin
					res <= {{23{op1[31]}}, op1[31:23]};
				end
				'd24: begin
					res <= {{24{op1[31]}}, op1[31:24]};
				end
				'd25: begin
					res <= {{25{op1[31]}}, op1[31:25]};
				end
				'd26: begin
					res <= {{26{op1[31]}}, op1[31:26]};
				end
				'd27: begin
					res <= {{27{op1[31]}}, op1[31:27]};
				end
				'd28: begin
					res <= {{28{op1[31]}}, op1[31:28]};
				end
				'd29: begin
					res <= {{29{op1[31]}}, op1[31:29]};
				end
				'd30: begin
					res <= {{30{op1[31]}}, op1[31:30]};
				end
				'd31: begin
					res <= {{31{op1[31]}}, op1[31:31]};
				end
				default: begin
					res <= res;
				end

				endcase
			end

			else if ( op_mode1 == 'b10 && op_mode2 == 'b100 ) begin
				case (op2)
				'd0: begin
					res <= op1;
				end
				'd1: begin
					res <= {op1[31], op1[31:1]};
				end
				'd2: begin
					res <= {{2{op1[31]}}, op1[31:2]};
				end
				'd3: begin
					res <= {{3{op1[31]}}, op1[31:3]};
				end
				'd4: begin
					res <= {{4{op1[31]}}, op1[31:4]};
				end
				'd5: begin
					res <= {{5{op1[31]}}, op1[31:5]};
				end
				'd6: begin
					res <= {{6{op1[31]}}, op1[31:6]};
				end
				'd7: begin
					res <= {{7{op1[31]}}, op1[31:7]};
				end
				'd8: begin
					res <= {{8{op1[31]}}, op1[31:8]};
				end
				'd9: begin
					res <= {{9{op1[31]}}, op1[31:9]};
				end
				'd10: begin
					res <= {{10{op1[31]}}, op1[31:10]};
				end
				'd11: begin
					res <= {{11{op1[31]}}, op1[31:11]};
				end
				'd12: begin
					res <= {{12{op1[31]}}, op1[31:12]};
				end
				'd13: begin
					res <= {{13{op1[31]}}, op1[31:13]};
				end
				'd14: begin
					res <= {{14{op1[31]}}, op1[31:14]};
				end
				'd15: begin
					res <= {{15{op1[31]}}, op1[31:15]};
				end
				'd16: begin
					res <= {{16{op1[31]}}, op1[31:16]};
				end
				'd17: begin
					res <= {{17{op1[31]}}, op1[31:17]};
				end
				'd18: begin
					res <= {{18{op1[31]}}, op1[31:18]};
				end
				'd19: begin
					res <= {{19{op1[31]}}, op1[31:19]};
				end
				'd20: begin
					res <= {{20{op1[31]}}, op1[31:20]};
				end
				'd21: begin
					res <= {{21{op1[31]}}, op1[31:21]};
				end
				'd22: begin
					res <= {{22{op1[31]}}, op1[31:22]};
				end
				'd23: begin
					res <= {{23{op1[31]}}, op1[31:23]};
				end
				'd24: begin
					res <= {{24{op1[31]}}, op1[31:24]};
				end
				'd25: begin
					res <= {{25{op1[31]}}, op1[31:25]};
				end
				'd26: begin
					res <= {{26{op1[31]}}, op1[31:26]};
				end
				'd27: begin
					res <= {{27{op1[31]}}, op1[31:27]};
				end
				'd28: begin
					res <= {{28{op1[31]}}, op1[31:28]};
				end
				'd29: begin
					res <= {{29{op1[31]}}, op1[31:29]};
				end
				'd30: begin
					res <= {{30{op1[31]}}, op1[31:30]};
				end
				'd31: begin
					res <= {{31{op1[31]}}, op1[31:31]};
				end
				default: begin
					res <= res;
				end

				endcase
			end


			else begin
				res <= res;
			end

		end

		else begin
			done <= 'd0;
			res <= res;
		end
	end

	else begin
		done <= 'd0;
		res <= 'd0;
	end
end




endmodule