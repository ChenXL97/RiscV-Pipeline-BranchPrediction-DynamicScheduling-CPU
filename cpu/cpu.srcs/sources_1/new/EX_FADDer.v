`timescale 1ns / 1ps
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


module EX_FADDer(
    //input                               clk,
    //input                               rst,

    // two operation number
//    input       [31:0]                  op1,
//    input       [31:0]                  op2,

    // give one clk postive signal, then start this module
    input                               start,

    // choose which compute part to use, there is two adder in this module
//    input       [1:0]                   use_part,

//    input       [1:0]                   op_mode1,
//    input       [2:0]                   op_mode2,

    output      reg                             done,
    output      reg     [31:0]                  res
    );
    
        reg clk;
        reg [31:0]op1;
        reg[31:0]op2;
        reg u_en;
        reg m_axis_result_tready;
    initial begin
        clk <= 1;
        op1<=32'h3f800000;
        op2<=32'h3f800000;
        m_axis_result_tready<=0;
        u_en<= 1;
        #6
        m_axis_result_tready<=1;
        # 14
        u_en<=0;
        op1<=32'h40000000;
        op2<=32'h40000000;
        # 20
        u_en<=1;
    end
        
    always begin
        #1;
        clk <= ~clk;
        end
    
//    always begin
//        #8;
//        m_axis_result_tready<=~m_axis_result_tready;
//        end
    
    
    wire [31:0] u_res;
    wire u_valid;
float_addsub float_addsub_u(
        .s_axis_a_tdata                      (op1),
        .s_axis_b_tdata                      (op2),
        .aclk                    (clk),
        .s_axis_operation_tdata                     (6'b000000),
        .aclken                     (u_en),
        .m_axis_result_tdata                      (u_res),
        //.m_axis_result_tready    (m_axis_result_tready),
        .m_axis_result_tvalid       (u_valid)
    );    
    
    always @ (posedge clk)
        res <= u_res;

    
    
    
endmodule


