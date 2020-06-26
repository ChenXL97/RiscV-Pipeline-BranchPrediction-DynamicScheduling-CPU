`include "HeadFile.vh"
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2020/06/23 14:47:21
// Module Name: Decoder
// Description: 
// Decoder
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
    
    //Start decoding
    always @(*) begin
        //First, reset all to zero
        de_out = 168'b0;
        //assign values directly to reg 'rs1', 'rs2', 'rd'
        de_out[`RS1] = ins[19:15];
        de_out[`RS2] = ins[24:20];
        de_out[`DST] = ins[11:7];
    
        //assign values to IMMUSE, PART, OP1, OP2 and IMM
        case(ins[5:2])
            // 1 RAM ： Ins 1-10
            4'h1: 
            begin
                de_out[`RAM] = 1'b1;
                de_out[`IMMUSE] = 1'b1;
                if(!ins[6])
                    case(ins[14:12])
                        3'h0: //1 Load Byte LB
                            begin
                                de_out[`OP1_2] = 5'b00_000;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h1: //2 Load Half Byte LH
                            begin
                                de_out[`OP1_2] = 5'b00_010;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h2: //3 Load Word LW
                            begin
                                de_out[`OP1_2] = 5'b00_100;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h3: //4 Load Byte Unsigned LBU
                            begin
                                de_out[`OP1_2] = 5'b00_001;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end       
                        3'h4: //5 Load Half Byte Unsigned LHU
                            begin
                                de_out[`OP1_2] = 5'b00_011;
                                de_out[`IMM] = {20'b0, ins[31:20]};
                            end
                        3'h5: //6 Save Byte SB
                            begin
                                de_out[`OP1_2] = 5'b01_000;
                                de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                            end
                        3'h6: //7 Save Half Byte SH
                            begin
                                de_out[`OP1_2] = 5'b01_010;
                                de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                            end
                        default://Default as 8 Save Word SW
                            begin
                                de_out[`OP1_2] = 5'b01_100;
                                de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                            end
                    endcase
                else
                    if(!ins[12]) //9 Float Load FL
                        begin
                            de_out[`OP1_2] = 5'b10_000;
                            de_out[`IMM] = {20'b0, ins[31:20]};
                        end
                    else //10 Float Save FS
                        begin
                            de_out[`OP1_2] = 5'b11_000;
                            de_out[`IMM] = {20'b0, ins[31:25],ins[11:7]};
                        end
            end
            //2 BRANCH : Ins 11-12
            4'h2: 
            begin
                de_out[`BRANCH] = 1'b1;
                de_out[`IMMUSE] = 1'b1;
                if(!ins[6]) //11 Jump And Link JAL (PC += sign_extend(offset))
                    begin
                        de_out[`OP1_2] = 5'b00_000;
                        de_out[`IMM] = {11'b0, ins[31],ins[19:12],ins[20],ins[30:21],1'b0};
                    end
                else //12 Jump And Link Register JALR (x[rd]=pc+4, pc = x[rs1] + sign_extend(offset), pc[0] = 0)
                    begin
                        de_out[`OP1_2] = 5'b00_100;
                        de_out[`IMM] = {20'b0, ins[31:20]};
                    end
            end
            //2 BRANCH : Ins 13-19
            4'h3: 
            begin
                de_out[`BRANCH] = 1'b1;
                de_out[`IMMUSE] = 1'b1;
                if(!ins[6]) //13-18 Conditional Branch: BEQ BNE BLT BGE BLTU BGEU
                    begin
                        de_out[`OP1_2] = { 2'b01, ins[14:12]};
                        de_out[`IMM] = {19'b0, ins[31],ins[7],ins[30:25],ins[11:8],1'b0};
                    end
                else //19 Add Upper immediate to PC AUIPC (x[rd] = pc + sign_extend(immediate[31:12]<<12))
                    begin
                        de_out[`OP1_2] = 5'b11_000;
                        de_out[`IMM] = {ins[31:12], 12'b0};
                    end
            end
            //3 SHIFT : Ins 20-25
            4'h4: 
            begin
                de_out[`SHIFT] = 1'b1;
                if(!ins[14]) //20-22 R-type Shift Left/Right Logical SLL SRL 
                    de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                else //23-25 I-Type Shift Left/Right Logical Immediate, Shift Right Arithmetic Immediate SLLI SRLI SRAI
                    begin
                        de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {27'b0, ins[24:20]};
                    end
            end
            //4 LOGIC : Ins 26-31
            4'h5: 
            begin
                de_out[`LOGIC] = 1'b1;
                if(!ins[14]) //26-28 R-type XOR OR AND 
                    de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                else //29-31 I-type XORI ORI ANDI 
                    begin
                        de_out[`OP1_2] = { ins[14], 1'b0, ins[13:12], 1'b0   };
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {20'b0, ins[31:20]};
                    end
            end
            //5 CMP : Ins 32-35
            4'h6: 
            begin
                de_out[`CMP] = 1'b1;
                if(!ins[14]) //32-33 R-type SLT SLTU 
                    de_out[`OP1_2] = { ins[14:13],3'b0   };
                else //34-35 I-type SLTI SLTIU 
                    begin
                        de_out[`OP1_2] = { ins[14:13],3'b0   };
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {20'b0, ins[31:20]};
                    end
            end
            //6 ADD : Ins 36-39
            4'h7: 
            begin
                de_out[`ADD] = 1'b1;
                if(!ins[6])
                    if(!ins[14]) //36-37 R-type ADD SUB 
                        de_out[`OP1_2] = { 1'b0, ins[14:13],2'b0   };
                    else //38 I-type ADDI
                        begin
                            de_out[`OP1_2] = { 1'b0, ins[14:13],2'b0  };
                            de_out[`IMMUSE] = 1'b1;
                            de_out[`IMM] = {20'b0, ins[31:20]};
                        end
                else //39 Write upper immediate
                    begin
                        de_out[`OP1_2] = 5'b10_000;
                        de_out[`IMMUSE] = 1'b1;
                        de_out[`IMM] = {ins[31:12],12'b0};
                    end
            end
            //7 MUL : Ins40-43 MUL MULH MULHSU MULHU
            4'h8: 
            begin
                de_out[`MUL] = 1'b1;
                de_out[`OP1_2] = { ins[14:13],3'b0   };
            end
            //8 DIV : Ins44-45 DIV DIVU
            4'h9: 
            begin
                de_out[`DIV] = 1'b1;
                de_out[`OP1_2] = { ins[14:13],3'b0   };
            end
            //9 SP : Ins46-47 REM REMU
            4'd10: 
            begin
                de_out[`SP] = 1'b1;
                de_out[`OP1_2] = { ins[14:13],3'b0   };
            end
            //10 RINFO : Ins48-53 RDCYCLE RDCYCLEH RDTIME RDTIMEH RDINSTRET RDINSTRETH
            4'd11: 
            begin
                de_out[`RINFO] = 1'b1;
                de_out[`OP1_2] = { ins[14:12],2'b0   };
                de_out[`IMMUSE] = 1'b1;
                de_out[`IMM] = {20'b0,ins[31:20]};
            end
            //11 FADD : Ins54-55 FADD FSUB
            4'd12: 
            begin
                de_out[`FADD] = 1'b1;
                de_out[`OP1_2] = { ins[31:30], ins[14:12]  };
            end
            //12-13 FMUL/FDIV : Ins56-57 
            4'd13: 
            if(!ins[6]) //56 Float Multiply FMUL 
                begin
                    de_out[`FMUL] = 1'b1;
                    de_out[`OP1_2] = 5'b00_000;
                end
            else //57 Float Divide FDIV
                begin
                    de_out[`FDIV] = 1'b1;
                    de_out[`OP1_2] = 5'b10_000;
                end
            //14 FSP : Ins58 FSQRT
            4'd14: 
                begin
                    de_out[`FSP] = 1'b1;
                    de_out[`OP1_2] = 5'b00_000;
                end
            //15 FCMP : Ins59-61 FEQ FLT FLE
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
