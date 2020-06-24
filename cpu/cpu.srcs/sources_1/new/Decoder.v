
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: Decoder
// Description: 
// 译码器
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Decoder(
    input clk,
    input rst,
    input [31:0] ins,
    output reg [`ROB_ITEM_INDEX] de_out
    );
   
    
    //开始译码
    always @(ins) begin
        //首先全部清零
        de_out <= `ROB_ITEM_LEN'b0;
        //寄存器rs1,rs2,rd直接赋值
        de_out[`RS1] <= ins[19:15];
        de_out[`RS2] <= ins[11:7];
        de_out[`DST] <= ins[24:20];
    
        //对IMMUSE,PART,OP1，OP2，IMM进行赋值
        case(ins[5:2])
            // 1 RAM
            4'h1: begin
                de_out[`RAM] <= 1'b1;
                de_out[`IMMUSE] <= 1'b1;
                if(!ins[6])
                    case(ins[14:12])
                        3'h0: //1 读字节 LB
                            begin
                                de_out[`OP1_2] <= 5'b00_000;
                                de_out[`IMM] <= {20'b0, ins[31:20]};
                            end
                        3'h1: //2 读半字 LH
                            begin
                                de_out[`OP1_2] <= 5'b00_010;
                                de_out[`IMM] <= {20'b0, ins[31:20]};
                            end
                        3'h2: //3 读字 LW
                            begin
                                de_out[`OP1_2] <= 5'b00_100;
                                de_out[`IMM] <= {20'b0, ins[31:20]};
                            end
                        3'h3: //4 读字节无符号 LBU
                            begin
                                de_out[`OP1_2] <= 5'b00_001;
                                de_out[`IMM] <= {20'b0, ins[31:20]};
                            end       
                        3'h4: //5 读半字无符号 LHU
                            begin
                                de_out[`OP1_2] <= 5'b00_011;
                                de_out[`IMM] <= {20'b0, ins[31:20]};
                            end
                        3'h5: //6 存字节 SB
                            begin
                                de_out[`OP1_2] <= 5'b00_001;
                                de_out[`IMM] <= {20'b0, ins[31:25],ins[11:7]};
                            end
                        3'h6: //7 存半字 SH
                            begin
                                de_out[`OP1_2] <= 5'b01_010;
                                de_out[`IMM] <= {20'b0, ins[31:25],ins[11:7]};
                            end
                        default://默认为 8 存字 SW
                            begin
                                de_out[`OP1_2] <= 5'b01_100;
                                de_out[`IMM] <= {20'b0, ins[31:25],ins[11:7]};
                            end
                    endcase
                else
                    if(!ins[12]) //9 浮点读数 FL
                        begin
                            de_out[`OP1_2] <= 5'b10_000;
                            de_out[`IMM] <= {20'b0, ins[31:20]};
                        end
                    else //10 浮点存数 FS
                        begin
                            de_out[`OP1_2] <= 5'b11_000;
                            de_out[`IMM] <= {20'b0, ins[31:25],ins[11:7]};
                        end
                end
//            4'h2: begin
            default:
                    de_out <= `ROB_ITEM_LEN'b0;
            endcase
    end
    
    
endmodule
