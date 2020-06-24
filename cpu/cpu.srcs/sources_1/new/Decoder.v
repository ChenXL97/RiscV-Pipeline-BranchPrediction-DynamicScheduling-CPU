`include "HeadFile.vh"
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
    output reg [167:0] de_out //TODO    
    );
    
    //开始译码
    always @(*) begin
        //首先全部清零
        de_out = 168'b0;
        //寄存器rs1,rs2,rd直接赋值
        de_out[`RS1] = ins[19:15];
        de_out[`RS2] = ins[24:20];
        de_out[`DST] = ins[11:7];
    
        //对IMMUSE,PART,OP1，OP2，IMM进行赋值
        case(ins[5:2])
            // 1 RAM ： 指令1-10
            4'h1: 
            begin
                de_out[`RAM] = 1'b1;
                de_out[`IMMUSE] = 1'b1;
                if(!ins[6])
                    case(ins[14:12])
                        3'h0: //1 读字节 LB
                            begin
                                de_out[`OP1_2] = 5'b00_000;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h1: //2 读半字 LH
                            begin
                                de_out[`OP1_2] = 5'b00_010;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h2: //3 读字 LW
                            begin
                                de_out[`OP1_2] = 5'b00_100;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h3: //4 读字节无符号 LBU
                            begin
                                de_out[`OP1_2] = 5'b00_001;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end       
                        3'h4: //5 读半字无符号 LHU
                            begin
                                de_out[`OP1_2] = 5'b00_011;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h5: //6 存字节 SB
                            begin
                                de_out[`OP1_2] = 5'b01_000;
                                de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                            end
                        3'h6: //7 存半字 SH
                            begin
                                de_out[`OP1_2] = 5'b01_010;
                                de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                            end
                        default://默认为 8 存字 SW
                            begin
                                de_out[`OP1_2] = 5'b01_100;
                                de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                            end
                    endcase
                else
                    if(!ins[12]) //9 浮点读数 FL
                        begin
                            de_out[`OP1_2] = 5'b10_000;
                            de_out[`IMM] = {20'b0, ins[31:20]};
                        end
                    else //10 浮点存数 FS
                        begin
                            de_out[`OP1_2] = 5'b11_000;
                            de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                        end
            end
            //2 BRANCH : 指令11-12
            4'h2: 
            begin
                de_out[`BRANCH] = 1'b1;
                de_out[`IMMUSE] = 1'b1;
                if(!ins[6]) //11 相对PC跳转 JAL
                    begin
                        de_out[`OP1_2] = 5'b00_000;
                        de_out[`IMM] = {11'b0, ins[31],ins[19:12],ins[20],ins[30:21],1'b0};
                    end
                else //12 绝对跳转 JALR
                    begin
                        de_out[`OP1_2] = 5'b00_100;
                        de_out[`IMM] = {20'b0, ins[31:20]};
                    end
            end
            //2 BRANCH : 指令13-19
            4'h3: 
            begin
                de_out[`BRANCH] = 1'b1;
                de_out[`IMMUSE] = 1'b1;
                if(!ins[6]) //13-18 有条件分支 BEQ BNE BLT BGE BLTU BGEU
                    begin
                        de_out[`OP1_2] = { 2'b01, ins[14:12]};
                        de_out[`IMM] = {19'b0, ins[31],ins[7],ins[30:25],ins[11:8],1'b0};
                    end
                else //19 加高位立即数到PC AUIPC
                    begin
                        de_out[`OP1_2] = 5'b11_000;
                        de_out[`IMM] = {ins[31:12], 12'b0};
                    end
            end
            //3 SHIFT : 指令20-25
            4'h4: 
            begin
                de_out[`SHIFT] = 1'b1;
                if(!ins[14]) //20-22 移位寄存器 SLL SRL 
                    de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                else //23-25 移位立即数 SLLI SRLI SRAI
                    begin
                        de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {27'b0, ins[24:20]};
                    end
            end
            //4 LOGIC : 指令26-31
            4'h5: 
            begin
                de_out[`LOGIC] = 1'b1;
                if(!ins[14]) //26-28 寄存器 XOR OR AND 
                    de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                else //29-31 立即数 XORI ORI ANDI 
                    begin
                        de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {20'b0, ins[31:20]};
                    end
            end
            //5 CMP : 指令32-35
            4'h6: 
            begin
                de_out[`CMP] = 1'b1;
                if(!ins[14]) //32-33 寄存器 SLT SLTU 
                    de_out[`OP1_2] = { ins[14:13],3'b0   };
                else //34-35 寄存器 SLTI SLTIU 
                    begin
                        de_out[`OP1_2] = { ins[14:13],3'b0   };
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {20'b0, ins[31:20]};
                    end
            end
            //6 ADD : 指令36-39
            4'h7: 
            begin
                de_out[`ADD] = 1'b1;
                if(!ins[6])
                    if(!ins[14]) //36-37 加减 ADD SUB 
                        de_out[`OP1_2] = { 1'b0, ins[14:13],2'b0   };
                    else //38 加立即数 ADDI
                        begin
                            de_out[`OP1_2] = { 1'b0, ins[14:13],2'b0  };
                            de_out[`IMMUSE] = 1'b1;
                            de_out[`IMM] = {20'b0, ins[31:20]};
                        end
                else //39 写高位立即数
                    begin
                        de_out[`OP1_2] = 5'b10_000;
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {ins[31:12],12'b0};
                    end
            end
            //7 MUL : 指令40-43 MUL MULH MULHSU MULHU
            4'h8: 
            begin
                de_out[`MUL] = 1'b1;
                de_out[`OP1_2] = { ins[14:13],3'b0   };
            end
            //8 DIV : 指令44-45 DIV DIVU
            4'h9: 
            begin
                de_out[`DIV] = 1'b1;
                de_out[`OP1_2] = { ins[14:13],3'b0   };
            end
            //9 SP : 指令46-47 REM REMU
            4'd10: 
            begin
                de_out[`SP] = 1'b1;
                de_out[`OP1_2] = { ins[14:13],3'b0   };
            end
            //10 RINFO : 指令48-53 RDCYCLE RDCYCLEH RDTIME RDTIMEH RDINSTRET RDINSTRETH
            4'd11: 
            begin
                de_out[`RINFO] = 1'b1;
                de_out[`OP1_2] = { ins[14:12],2'b0   };
                de_out[`IMMUSE] = 1'b1;
                de_out[`IMM] = {20'b0,ins[31:20]};
            end
            //11 FADD : 指令54-55 FADD FSUB
            4'd12: 
            begin
                de_out[`FADD] = 1'b1;
                de_out[`OP1_2] = { ins[31:30], ins[14:12]  };
            end
            //12-13 FMUL/FDIV : 指令56-57 
            4'd13: 
            if(!ins[6]) //56 浮点乘 FMUL 
                begin
                    de_out[`FMUL] = 1'b1;
                    de_out[`OP1_2] = 5'b00_000;
                end
            else //57 浮点除 FDIV
                begin
                    de_out[`FDIV] = 1'b1;
                    de_out[`OP1_2] = 5'b10_000;
                end
            //14 FSP : 指令58 FSQRT
            4'd14: 
                begin
                    de_out[`FSP] = 1'b1;
                    de_out[`OP1_2] = 5'b00_000;
                end
            //15 FCMP : 指令59-61 FEQ FLT FLE
            4'd15: 
                begin
                    de_out[`FCMP] = 1'b1;
                    de_out[`OP1_2] = {ins[14:13],3'b0};
                end
            default:
                    de_out = `ROB_ITEM_LEN'bxxxx;
            endcase
    end
    
    
endmodule
