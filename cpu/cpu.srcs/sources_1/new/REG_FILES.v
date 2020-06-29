`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/28 22:00:54
// Design Name: 
// Module Name: REG_FILES
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module REG_FILES(
    input clk_i,
    input rst_i,
    input [31:0] rd0_value_i,
    input [4:0] rd0_i,
    input [4:0] ra0_i,
    input [4:0] rb0_i,
    output [31:0] ra0_value_o,
    output [31:0] rb0_value_o
    );
    
generate
begin: REGFILE
    reg [31:0] reg_r1_q;
    reg [31:0] reg_r2_q;
    reg [31:0] reg_r3_q;
    reg [31:0] reg_r4_q;
    reg [31:0] reg_r5_q;
    reg [31:0] reg_r6_q;
    reg [31:0] reg_r7_q;
    reg [31:0] reg_r8_q;
    reg [31:0] reg_r9_q;
    reg [31:0] reg_r10_q;
    reg [31:0] reg_r11_q;
    reg [31:0] reg_r12_q;
    reg [31:0] reg_r13_q;
    reg [31:0] reg_r14_q;
    reg [31:0] reg_r15_q;
    reg [31:0] reg_r16_q;
    reg [31:0] reg_r17_q;
    reg [31:0] reg_r18_q;
    reg [31:0] reg_r19_q;
    reg [31:0] reg_r20_q;
    reg [31:0] reg_r21_q;
    reg [31:0] reg_r22_q;
    reg [31:0] reg_r23_q;
    reg [31:0] reg_r24_q;
    reg [31:0] reg_r25_q;
    reg [31:0] reg_r26_q;
    reg [31:0] reg_r27_q;
    reg [31:0] reg_r28_q;
    reg [31:0] reg_r29_q;
    reg [31:0] reg_r30_q;
    reg [31:0] reg_r31_q;
    always @ (posedge clk_i or posedge rst_i)
        if (rst_i)
        begin
            reg_r1_q       <= 32'h00000033;
            reg_r2_q       <= 32'h00000033;
            reg_r3_q       <= 32'h00000033;
            reg_r4_q       <= 32'h00000033;
            reg_r5_q       <= 32'h00000000;
            reg_r6_q       <= 32'h00000000;
            reg_r7_q       <= 32'h00000000;
            reg_r8_q       <= 32'h00000000;
            reg_r9_q       <= 32'h00000000;
            reg_r10_q      <= 32'h00000000;
            reg_r11_q      <= 32'h00000000;
            reg_r12_q      <= 32'h00000000;
            reg_r13_q      <= 32'h00000000;
            reg_r14_q      <= 32'h00000000;
            reg_r15_q      <= 32'h00000000;
            reg_r16_q      <= 32'h00000000;
            reg_r17_q      <= 32'h00000000;
            reg_r18_q      <= 32'h00000000;
            reg_r19_q      <= 32'h00000000;
            reg_r20_q      <= 32'h00000000;
            reg_r21_q      <= 32'h00000000;
            reg_r22_q      <= 32'h00000000;
            reg_r23_q      <= 32'h00000000;
            reg_r24_q      <= 32'h00000000;
            reg_r25_q      <= 32'h00000000;
            reg_r26_q      <= 32'h00000000;
            reg_r27_q      <= 32'h00000000;
            reg_r28_q      <= 32'h00000000;
            reg_r29_q      <= 32'h00000000;
            reg_r30_q      <= 32'h00000000;
            reg_r31_q      <= 32'h00000000;
        end
        else
        begin
            if      (rd0_i == 5'd1) reg_r1_q <= rd0_value_i;
            if      (rd0_i == 5'd2) reg_r2_q <= rd0_value_i;
            if      (rd0_i == 5'd3) reg_r3_q <= rd0_value_i;
            if      (rd0_i == 5'd4) reg_r4_q <= rd0_value_i;
            if      (rd0_i == 5'd5) reg_r5_q <= rd0_value_i;
            if      (rd0_i == 5'd6) reg_r6_q <= rd0_value_i;
            if      (rd0_i == 5'd7) reg_r7_q <= rd0_value_i;
            if      (rd0_i == 5'd8) reg_r8_q <= rd0_value_i;
            if      (rd0_i == 5'd9) reg_r9_q <= rd0_value_i;
            if      (rd0_i == 5'd10) reg_r10_q <= rd0_value_i;
            if      (rd0_i == 5'd11) reg_r11_q <= rd0_value_i;
            if      (rd0_i == 5'd12) reg_r12_q <= rd0_value_i;
            if      (rd0_i == 5'd13) reg_r13_q <= rd0_value_i;
            if      (rd0_i == 5'd14) reg_r14_q <= rd0_value_i;
            if      (rd0_i == 5'd15) reg_r15_q <= rd0_value_i;
            if      (rd0_i == 5'd16) reg_r16_q <= rd0_value_i;
            if      (rd0_i == 5'd17) reg_r17_q <= rd0_value_i;
            if      (rd0_i == 5'd18) reg_r18_q <= rd0_value_i;
            if      (rd0_i == 5'd19) reg_r19_q <= rd0_value_i;
            if      (rd0_i == 5'd20) reg_r20_q <= rd0_value_i;
            if      (rd0_i == 5'd21) reg_r21_q <= rd0_value_i;
            if      (rd0_i == 5'd22) reg_r22_q <= rd0_value_i;
            if      (rd0_i == 5'd23) reg_r23_q <= rd0_value_i;
            if      (rd0_i == 5'd24) reg_r24_q <= rd0_value_i;
            if      (rd0_i == 5'd25) reg_r25_q <= rd0_value_i;
            if      (rd0_i == 5'd26) reg_r26_q <= rd0_value_i;
            if      (rd0_i == 5'd27) reg_r27_q <= rd0_value_i;
            if      (rd0_i == 5'd28) reg_r28_q <= rd0_value_i;
            if      (rd0_i == 5'd29) reg_r29_q <= rd0_value_i;
            if      (rd0_i == 5'd30) reg_r30_q <= rd0_value_i;
            if      (rd0_i == 5'd31) reg_r31_q <= rd0_value_i;
        end
        
        //-----------------------------------------------------------------
            // Asynchronous read
            //-----------------------------------------------------------------
            reg [31:0] ra0_value_r;
            reg [31:0] rb0_value_r;
            always @ *
            begin
                case (ra0_i)
                5'd1: ra0_value_r = reg_r1_q;
                5'd2: ra0_value_r = reg_r2_q;
                5'd3: ra0_value_r = reg_r3_q;
                5'd4: ra0_value_r = reg_r4_q;
                5'd5: ra0_value_r = reg_r5_q;
                5'd6: ra0_value_r = reg_r6_q;
                5'd7: ra0_value_r = reg_r7_q;
                5'd8: ra0_value_r = reg_r8_q;
                5'd9: ra0_value_r = reg_r9_q;
                5'd10: ra0_value_r = reg_r10_q;
                5'd11: ra0_value_r = reg_r11_q;
                5'd12: ra0_value_r = reg_r12_q;
                5'd13: ra0_value_r = reg_r13_q;
                5'd14: ra0_value_r = reg_r14_q;
                5'd15: ra0_value_r = reg_r15_q;
                5'd16: ra0_value_r = reg_r16_q;
                5'd17: ra0_value_r = reg_r17_q;
                5'd18: ra0_value_r = reg_r18_q;
                5'd19: ra0_value_r = reg_r19_q;
                5'd20: ra0_value_r = reg_r20_q;
                5'd21: ra0_value_r = reg_r21_q;
                5'd22: ra0_value_r = reg_r22_q;
                5'd23: ra0_value_r = reg_r23_q;
                5'd24: ra0_value_r = reg_r24_q;
                5'd25: ra0_value_r = reg_r25_q;
                5'd26: ra0_value_r = reg_r26_q;
                5'd27: ra0_value_r = reg_r27_q;
                5'd28: ra0_value_r = reg_r28_q;
                5'd29: ra0_value_r = reg_r29_q;
                5'd30: ra0_value_r = reg_r30_q;
                5'd31: ra0_value_r = reg_r31_q;
                default : ra0_value_r = 32'h00000000;
                endcase
        
                case (rb0_i)
                5'd1: rb0_value_r = reg_r1_q;
                5'd2: rb0_value_r = reg_r2_q;
                5'd3: rb0_value_r = reg_r3_q;
                5'd4: rb0_value_r = reg_r4_q;
                5'd5: rb0_value_r = reg_r5_q;
                5'd6: rb0_value_r = reg_r6_q;
                5'd7: rb0_value_r = reg_r7_q;
                5'd8: rb0_value_r = reg_r8_q;
                5'd9: rb0_value_r = reg_r9_q;
                5'd10: rb0_value_r = reg_r10_q;
                5'd11: rb0_value_r = reg_r11_q;
                5'd12: rb0_value_r = reg_r12_q;
                5'd13: rb0_value_r = reg_r13_q;
                5'd14: rb0_value_r = reg_r14_q;
                5'd15: rb0_value_r = reg_r15_q;
                5'd16: rb0_value_r = reg_r16_q;
                5'd17: rb0_value_r = reg_r17_q;
                5'd18: rb0_value_r = reg_r18_q;
                5'd19: rb0_value_r = reg_r19_q;
                5'd20: rb0_value_r = reg_r20_q;
                5'd21: rb0_value_r = reg_r21_q;
                5'd22: rb0_value_r = reg_r22_q;
                5'd23: rb0_value_r = reg_r23_q;
                5'd24: rb0_value_r = reg_r24_q;
                5'd25: rb0_value_r = reg_r25_q;
                5'd26: rb0_value_r = reg_r26_q;
                5'd27: rb0_value_r = reg_r27_q;
                5'd28: rb0_value_r = reg_r28_q;
                5'd29: rb0_value_r = reg_r29_q;
                5'd30: rb0_value_r = reg_r30_q;
                5'd31: rb0_value_r = reg_r31_q;
                default : rb0_value_r = 32'h00000000;
                endcase
            end
        
            assign ra0_value_o = ra0_value_r;
            assign rb0_value_o = rb0_value_r;
            
end
endgenerate
    
    
endmodule

