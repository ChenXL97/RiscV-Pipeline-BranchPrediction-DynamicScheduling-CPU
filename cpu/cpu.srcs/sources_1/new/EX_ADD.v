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


module ADD_SUB(
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



// u0 and u1's enable
reg                                     u0_en;
reg                                     u1_en;
// u0 and u1's function choosing
// 1 is add and 0 is sub
reg                                     u0_add;
reg                                     u1_add;
// u0 and u1's running conuter
reg      [1:0]                          u0_run_cnter;
reg      [1:0]                          u1_run_cnter;
// u0 and u1's result reg
wire     [31:0]                         u0_res;
wire     [31:0]                         u1_res;






adder_suber addsub_no_u_0(
    .A                      (op1),
    .B                      (op2),
    .CLK                    (clk),
    .ADD                    (u0_add),
    .CE                     (u0_en),
    .S                      (u0_res)
);

adder_suber addsub_no_u_1(
    .A                      (op1),
    .B                      (op2),
    .CLK                    (clk),
    .ADD                    (u1_add),
    .CE                     (u1_en),
    .S                      (u1_res)
);






// always @ (posedge clk) begin
//     if(!rst) begin
//         case (use_part)
//         'b10: begin
//             if(start) begin
//                 u1_en <= 'd1;
//                 u0_en <= 'd0;
//                 u0_add <= u0_add;
//                 // sub
//                 if(op_mode2[2] == 'b1) begin
//                     u1_add <= 'd0;
//                 end
//                 else begin
//                     u1_add <= 'd1;
//                 end
//             end
//             else if(u1_run_cnter == 'd0) begin
//                 u1_en <= 'd0;
//                 u1_add <= u1_add;
//                 u1_add <= u1_add;
//                 u0_add <= u0_add;
//             end
//             else begin
//                 u1_en <= u1_en;
//                 u0_en <= u0_en;
//                 u0_add <= u0_add;
//                 u1_add <= u1_add;
//             end
//         end

//         'b01: begin
//             if(start) begin
//                 u0_en <= 'b1;
//                 u1_en <= u1_en;
//                 u1_add <= u1_add;
//                 // sub
//                 if(op_mode2[2] == 'b1) begin
//                     u0_add <= 'd0;
//                 end
//                 else begin
//                     u0_add <= 'd1;
//                 end
//             end
//             else if(u0_run_cnter == 'd0) begin
//                 u0_en <= 'd0;
//                 u0_add <= u0_add;
//                 u1_add <= u1_add;
//                 u1_en <= u1_en;
//             end
//             else begin
//                 u0_en <= u0_en;
//                 u0_add <= u0_add;
//                 u1_add <= u1_add;
//                 u1_en <= u1_en;
//             end
//         end

//         default: begin
//             u1_en <= 'b0;
//             u1_add <= 'b1;
//             u0_en <= 'd0;
//             u0_add <= 'b1;
//         end
//         endcase
//     end   
//     else begin
//         u1_en <= 'd0;
//         u1_add <= 'd1;
//         u0_en <= 'd0;
//         u0_add <= 'd1;
//     end
// end




always @ (*) begin
    if(!rst) begin
        case (use_part)
        'b10: begin
            if(start) begin
                u1_en = 'd1;
                u0_en = 'd0;
                u0_add = u0_add;
                // sub
                if(op_mode2[2] == 'b1) begin
                    u1_add = 'd0;
                end
                else begin
                    u1_add = 'd1;
                end
            end
            else if(u1_run_cnter == 'd0) begin
                u1_en = 'd0;
                u1_add = u1_add;
                u1_add = u1_add;
                u0_add = u0_add;
            end
            else begin
                u1_en = u1_en;
                u0_en = u0_en;
                u0_add = u0_add;
                u1_add = u1_add;
            end
        end

        'b01: begin
            if(start) begin
                u0_en = 'b1;
                u1_en = u1_en;
                u1_add = u1_add;
                // sub
                if(op_mode2[2] == 'b1) begin
                    u0_add = 'd0;
                end
                else begin
                    u0_add = 'd1;
                end
            end
            else if(u0_run_cnter == 'd0) begin
                u0_en = 'd0;
                u0_add = u0_add;
                u1_add = u1_add;
                u1_en = u1_en;
            end
            else begin
                u0_en = u0_en;
                u0_add = u0_add;
                u1_add = u1_add;
                u1_en = u1_en;
            end
        end

        default: begin
            u1_en = 'b0;
            u1_add = 'b1;
            u0_en = 'd0;
            u0_add = 'b1;
        end
        endcase
    end   
    else begin
        u1_en = 'd0;
        u1_add = 'd1;
        u0_en = 'd0;
        u0_add = 'd1;
    end
end









 
/* set running clock */
always @ (posedge clk) begin
    if(!rst) begin
        if(u1_en) begin
            if(u1_run_cnter == 'd0)
                u1_run_cnter <= 'd1;
            else
                u1_run_cnter <= u1_run_cnter - 'd1;
        end
        else begin
            u1_run_cnter <= 'd1;
        end
    end
    else begin
        u1_run_cnter <= 'd1;
    end
end
always @ (posedge clk) begin
    if(!rst) begin
        if(u0_en) begin
            if(u0_run_cnter == 'd0)
                u0_run_cnter <= 'd1;
            else
                u0_run_cnter <= u0_run_cnter - 'd1;
        end
        else begin
            u0_run_cnter <= 'd1;
        end
    end
    else begin
        u0_run_cnter <= 'd1;
    end
end





always @ (posedge clk) begin
    if(!rst) begin
        if(u0_run_cnter == 'd0 || u1_run_cnter == 'd0) begin
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




always @ (*) begin
    if(!rst) begin
        if(u0_run_cnter == 'd0 || u1_run_cnter == 'd0) begin
            if(u0_run_cnter == 'd0)
                res <= u0_res;
            else 
                res <= u1_res;
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
