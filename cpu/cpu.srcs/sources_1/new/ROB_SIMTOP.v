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


/* THIS MODULE IS USED TO SIMULATE ROB FUNCTION */


module rob_top();

//  Simulated clk clock
reg clk;
initial begin
    clk <= 1;
end
    
always begin
    #1;
    clk <= ~clk;
end


//  Simulated Reset Signal 
reg rst;
initial begin
    rst <= 'd1;
    #3;
    rst <= 'd0;
end



reg         [14:0]                  func_part_done;
reg         [31:0]                  de_cur_pc;
reg         [`ROB_ITEM_INDEX]       rob_info;
reg         [31:0]                  cnter;




always @ (posedge clk) begin
    if(!rst) begin
        cnter <= cnter + 'd1;
    end
    else begin
        cnter <= 'd0;
    end
end



always @ (posedge clk) begin
    if(!rst) begin
        de_cur_pc <= de_cur_pc + 'd1;
    end
    else  begin
        de_cur_pc <= 'd0;
    end
end



/* test serial: 
    adder r2, r2, r3
    logic r3, r2, r4
    shift r3, r3, r5
    fadd  r4, r4, r4
     */
always @ (posedge clk) begin
    if(!rst) begin
        if(cnter == 'd3) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd3;
            rob_info[`RS2] <= 'd2;
            rob_info[`RS1] <= 'd2;
            rob_info[`ADD] <= 'd1;
        end

        else if(cnter == 'd4) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd4;
            rob_info[`RS2] <= 'd3;
            rob_info[`RS1] <= 'd2;
            rob_info[`LOGIC] <= 'd1;
        end

        else if(cnter == 'd5) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd5;
            rob_info[`RS2] <= 'd3;
            rob_info[`RS1] <= 'd3;
            rob_info[`SHIFT] <= 'd1;
        end

        else if(cnter == 'd6) begin
            rob_info <= 'd0;
            rob_info[`DST] <= 'd4;
            rob_info[`RS2] <= 'd4;
            rob_info[`RS1] <= 'd4;
            rob_info[`FADD] <= 'd1;
        end

        else begin
            rob_info <= 'd0;
        end

    end
    else  begin
        rob_info <= 'd0;
    end
end






ROB rob(
    .clk                            (clk),
    .rst                            (rst),
    .rob_info                       (rob_info),
    .de_cur_pc                      (de_cur_pc)
);






endmodule