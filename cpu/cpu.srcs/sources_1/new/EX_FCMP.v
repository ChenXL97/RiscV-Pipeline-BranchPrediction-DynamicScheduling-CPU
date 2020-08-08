`timescale 1ns / 100ps
`include "HeadFile.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/28 10:52:10
// Design Name: 
// Module Name: EX_FADDer
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


module FCMP(
    input                               clk,
    input                               rst,

    // two operation number
    input       [31:0]                  op1,
    input       [31:0]                  op2,

    // give one clk postive signal, then start this module
    input                               start,

    // choose which compute part to use, there is two adder in this module
    input       [1:0]                   use_part,

    input       [1:0]                   op_mode1,
    input       [2:0]                   op_mode2,

    output      reg                             done,
    output      reg     [31:0]                  res
    );

// enable
reg                                     en;
// running conuter
reg      [2:0]                          run_cnter;

reg     aresetn;

wire [7:0]  u_res;

initial begin
    en = 0;
    aresetn=1'b1;
    run_cnter = `FLOAT_DELAY;
    
    #1 aresetn=0;
    #3 aresetn=1;
end



reg [31:0]  op1_r;
reg [31:0]  op2_r;

always @ (start) begin
    if(!rst) begin
        if(start) begin
            op1_r = op1;
            op2_r = op2;
        end
        else begin
            op1_r = op1_r;
            op2_r = op2_r;
        end
    end
    else begin
        op1_r = 'd0;
        op2_r = 'd0;
    end
end


fcmper fcmper_u(
        .aclk                       (clk),
        .aresetn                    (1'b1),
        .s_axis_a_tvalid            (1'b1),
        .s_axis_a_tdata             (op1_r),
        .s_axis_b_tvalid            (1'b1),
        .s_axis_b_tdata             (op2_r),
        .s_axis_operation_tvalid    (1'b1),
        .s_axis_operation_tdata     (6'b010100),
        .m_axis_result_tready       (1'b1),
        .m_axis_result_tdata        (u_res)
    );    

always @ (*) begin
    if(!rst) begin
        if(start) begin
            en = 'd1;
        end
        else if(run_cnter == 'd0) begin
            en = 'd0;
        end
    end   
    else begin
        en = 'd0;
    end
end


always @ (posedge clk) begin
    if(!rst) begin
        if(en) begin
            if(run_cnter == 'd0)
                run_cnter = `FLOAT_DELAY - 1;
            else
                run_cnter = run_cnter - 'd1;
        end
        else begin
            run_cnter = `FLOAT_DELAY;
        end
    end
    else begin
        run_cnter = `FLOAT_DELAY;
    end
end


always @ (posedge clk) begin
    if(!rst) begin
        if(run_cnter == 'd0) begin
            done = 'd1;
            res = {24'b0,u_res};
        end
        else begin
            done = 'd0;
            res = 0;
        end
    end
    else begin
        done = 'd0;
        res = 0;
    end
end

endmodule


