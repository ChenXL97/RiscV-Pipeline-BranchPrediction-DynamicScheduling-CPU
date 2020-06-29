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


module CMP_U_PART(
    input                       clk,
    input                       rst,

    // two operation number
    input       [31:0]                  op1,
    input       [31:0]                  op2,

    input                               start,

    output      reg                             done,
    output      reg     [31:0]                  res
);


reg         [2:0]                         delay;
reg                                       u0_en;
wire         [32:0]                        cmp_res;


cmp_u cmp_u_0(
    .A                      ({1'b0, op1}),
    .B                      ({1'b0, op2}),
    .CLK                    (clk),
    .CE                     (u0_en),
    .S                      (cmp_res)
);





always @ (posedge clk) begin
    if(!rst) begin
        if(start) begin
            u0_en <= 'd1;
        end
        else if (delay == 'd0) begin
            u0_en <= 'd0;
        end
        else begin
            u0_en <= u0_en;
        end
    end
    else begin
        u0_en <= 'd0;
    end
end







/* set running clock */
always @ (posedge clk) begin
    if(!rst) begin
        if(u0_en) begin
            if(delay == 'd0)
                delay <= 'd1;
            else
                delay <= delay - 'd1;
        end
        else begin
            delay <= 'd1;
        end
    end
    else begin
        delay <= 'd1;
    end
end




always @ (posedge clk) begin
    if(!rst) begin
        if(delay == 'd0) begin
            done = 'd1;
        end
        else begin
            done = 'd0;
        end
    end
    else begin
        done <= 'd0;
    end
end




always @ (posedge clk) begin
    if(!rst) begin
        if(delay == 'd0) begin
            if(cmp_res[32])
                res <= 'd1;
            else 
                res <= 'd0;
        end
        else begin
            res <= res;
        end
    end
    else begin
        res <= 'd0;
    end
end




endmodule