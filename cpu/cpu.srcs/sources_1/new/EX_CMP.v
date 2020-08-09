// /***************************************************************************************************
//                                 THE PROJECT IS DESIGNED AND CODED BY
//                                             WINTERS WEN
//                                 NATIONAL UNIVERSITY OF DEFENSE TECHNOLOGY

//                                             /
//                                           / -----------
//                                         /   \      /
//                                               \  /
//                                                /
//                                            /       \
//                                         /      *       \
//                                     /            *          \
//                                                *
//                                                  *
                                
// ***************************************************************************************************/
// `timescale 1ns/100ps


// module CMP_CMPU(
//     input                               clk,
//     input                               rst,

//     // two operation number
//     input       [31:0]                  op1,
//     input       [31:0]                  op2,

//     // give one clk postive signal, then start this module
//     input                               start,

//     // choose which compute part to use
//     // there is two cmp-signed and one cmp-unsigned in this module
//     // so the cmp-unsigned's use_part is 01 or 00
//     input       [1:0]                   use_part,

//     input       [1:0]                   op_mode1,
//     input       [2:0]                   op_mode2,

//     output      reg                             done,
//     output      reg     [31:0]                  res

// );





// // ux is signed and u_ux is unsigned part
// reg                                     u0_en;
// reg                                     u1_en;
// reg                                     u_u0_en;

// // u0 and u1's running conuter
// reg      [1:0]                          u0_run_cnter;
// reg      [1:0]                          u1_run_cnter;
// // u0 and u1's result reg
// wire     [31:0]                         u0_res;
// wire     [31:0]                         u1_res;
// wire     [31:0]                         u_u0_res;


// // unsigned compare
// wire                                    cmp_u_done;
// wire     [31:0]                         cmp_u_res;




// cmp_signed cmp_s_0(
//     .A                      (op1),
//     .B                      (op2),
//     .CLK                    (clk),
//     .CE                     (u0_en),
//     .S                      (u0_res)
// );


// cmp_signed cmp_s_1(
//     .A                      (op1),
//     .B                      (op2),
//     .CLK                    (clk),
//     .CE                     (u1_en),
//     .S                      (u1_res)
// );


// CMP_U_PART cmp_u_part(
//     .clk                    (clk),
//     .rst                    (rst),
//     .op1                    (op1),
//     .op2                    (op2),
//     .start                  (start),
//     .done                   (cmp_u_done),
//     .res                    (cmp_u_res)
// );




// always @ (posedge clk) begin
//     if(!rst) begin
//         case (use_part)
//         'b10: begin
//             if(start) begin
//                 // signed compare
//                 if(op_mode1[0] == 'd0) begin
//                     u1_en <= 'd1;
//                     u0_en <= u0_en;
//                     u_u0_en <= u_u0_en;
//                 end
//                 else begin
//                     u1_en <= 'd0;
//                     u0_en <= u0_en;
//                     u_u0_en <= u_u0_en;
//                 end
//             end

//             else if (u1_run_cnter == 'd0) begin
//                 u1_en <= 'd0;
//                 u0_en <= u0_en;
//                 u_u0_en <= u_u0_en;
//             end

//             else begin
//                 u1_en <= u1_en;
//                 u0_en <= u0_en;
//                 u_u0_en <= u_u0_en;
//             end
//         end

//         'b01: begin
//             if(start) begin
//                 // signed compare
//                 if(op_mode1[0] == 'd0) begin
//                     u0_en <= 'd1;
//                     u1_en <= u0_en;
//                     u_u0_en <= u_u0_en;
//                 end
//                 // unsigned compare
//                 else begin
//                     u1_en <= u1_en;
//                     u0_en <= u0_en;
//                     u_u0_en <= 'd1;
//                 end
//             end

//             else if (u0_run_cnter == 'd0) begin
//                 u1_en <= 'd0;
//                 u0_en <= u0_en;
//                 u_u0_en <= u_u0_en;
//             end

//             else if (cmp_u_done == 'd0) begin
//                 u1_en <= u1_en;
//                 u0_en <= u0_en;
//                 u_u0_en <= 'd0;
//             end

//             else begin
//                 u1_en <= u1_en;
//                 u0_en <= u0_en;
//                 u_u0_en <= u_u0_en;
//             end
//         end

//         default: begin
//             u1_en <= u1_en;
//             u0_en <= u0_en;
//             u_u0_en <= u_u0_en;
//         end
//         endcase
//     end
//     else begin
//         u1_en <= 'd0;
//         u0_en <= 'd0;
//         u_u0_en <= 'd0;
//     end
// end





// /* set running clock */
// always @ (posedge clk) begin
//     if(!rst) begin
//         if(u1_en) begin
//             if(u1_run_cnter == 'd0)
//                 u1_run_cnter <= 'd1;
//             else
//                 u1_run_cnter <= u1_run_cnter - 'd1;
//         end
//         else begin
//             u1_run_cnter <= 'd1;
//         end
//     end
//     else begin
//         u1_run_cnter <= 'd1;
//     end
// end
// always @ (posedge clk) begin
//     if(!rst) begin
//         if(u0_en) begin
//             if(u0_run_cnter == 'd0)
//                 u0_run_cnter <= 'd1;
//             else
//                 u0_run_cnter <= u0_run_cnter - 'd1;
//         end
//         else begin
//             u0_run_cnter <= 'd1;
//         end
//     end
//     else begin
//         u0_run_cnter <= 'd1;
//     end
// end





// always @ (posedge clk) begin
//     if(!rst) begin
//         if(u0_run_cnter == 'd0 || u1_run_cnter == 'd0 || cmp_u_done == 'd1) begin
//             done <= 'd1;
//         end
//         else begin
//             done <= 'd0;
//         end
//     end

//     else begin
//         done <= 'd0;
//     end
// end



// always @ (posedge clk) begin
//     if(!rst) begin
//         if(u0_run_cnter == 'd0 || u1_run_cnter == 'd0 || cmp_u_done == 'd1) begin
//             if(u0_run_cnter == 'd0) begin
//                 if(u0_res[31])
//                     res <= 'd1;
//                 else 
//                     res <= 'd0;
//             end

//             else if(u1_run_cnter == 'd0) begin
//                 if(u1_res[31])
//                     res <= 'd1;
//                 else 
//                     res <= 'd0;
//             end

//             else if (cmp_u_done == 'd1)
//                 res <= cmp_u_res;
//             else 
//                 res <= res;
//         end
//         else begin
//             res <= res;
//         end
//     end
//     else begin
//         res <= 'd0;
//     end
// end




// endmodule