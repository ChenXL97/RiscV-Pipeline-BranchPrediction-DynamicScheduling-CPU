`timescale 1ns / 100ps
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


module INT_FLOAT(
    input                               clk,
    input                               rst,

    // one operation number
    input       [31:0]                  op1,

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
reg     mode;
reg     aresetn;

wire  [31:0] u_res_int_to_float;
wire  [31:0] u_res_float_to_int;

initial begin
    en = 0;
    mode = 0;
    aresetn=1'b1;
    run_cnter = `FLOAT_DELAY;
    
    #1 aresetn=0;
    #3 aresetn=1;
end


reg [31:0]  op1_r;

always @ (start) begin
    if(!rst) begin
        if(start) begin
            op1_r = op1;
        end
        else begin
            op1_r = op1_r;
        end
    end
    else begin
        op1_r = 'd0;
    end
end




int_to_float int_to_float_u(
        .aclk                       (clk),
        .aresetn                    (1'b1),
        .s_axis_a_tvalid            (1'b1),
        .s_axis_a_tdata             (op1_r),
        .m_axis_result_tready       (1'b1),
        .m_axis_result_tdata        (u_res_int_to_float)
    );    

float_to_int float_to_int_u(
        .aclk                       (clk),
        .aresetn                    (1'b1),
        .s_axis_a_tvalid            (1'b1),
        .s_axis_a_tdata             (op1_r),
        .m_axis_result_tready       (1'b1),
        .m_axis_result_tdata        (u_res_float_to_int)
    );    

always @ (*) begin
    if(!rst) begin
        if(start) begin
            en = 'd1;
            mode = op_mode1[1];
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
            if(mode)
                res = u_res_float_to_int;
            else
                res = u_res_int_to_float;
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
