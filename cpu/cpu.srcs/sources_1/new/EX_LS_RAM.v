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

module RAM(
    input                               clk,
    input                               rst,

    // to be noticed:
    // when load data from data_ram, please set rs1(base) into op1 and imm_addr into imm_data
    // when store data into ram, please set rs1(base) into op1 and rs2(src_data) into op2
    input       [31:0]                  op1,
    input       [31:0]                  op2,
    input       [31:0]                  imm_data,

    // give one clk postive signal, then start this module
    input                               start,

    // choose which compute part to use, there is only one part in this module
    input       [1:0]                   use_part,

    input       [1:0]                   op_mode1,
    input       [2:0]                   op_mode2,

    output      reg                             done,
    output      [31:0]                           res

);


reg         [9:0]                       addr;
reg         [9:0]                       raddr;
reg         [9:0]                       waddr;
reg         [9:0]                       instant_addr;

// when loading half word, sometimes need accessing memory two times
reg         [2:0]                       half_word_extra;
// dout value for first accessing
reg         [31:0]                      dout_f;


// use to store op2
reg         [7:0]                       src_data        [3:0];
reg         [7:0]                       din_reg;
wire        [31:0]                       din;
assign din = op2;
wire        [31:0]                      dout;
reg                                     ram_en;
reg                                     wea;

// set operation clocks
reg         [3:0]                       load_cnt;
reg         [3:0]                       store_cnt;




DATA_Bram data_bram(
    .addra              (addr),
    .clka               (clk),
    .dina               (din),
    .douta              (res),
    .ena                (ram_en),
    .wea                (wea)
);





/* set initial controling signal */
always @ (*) begin
    if(!rst) begin
        if(load_cnt == 'd0 || store_cnt == 'd0) begin
            ram_en <= 'd0;
            wea <= 'd0;
        end

        else if(start) begin
            case (op_mode1)
            // load data 
            'b00: begin
                wea <= 'd0;

                if(load_cnt == 'd0) begin
                    ram_en <= 'd0;
                end
                else begin
                    ram_en <= 'd1;
                end
            end     

            // store data
            'b01: begin
                ram_en <= 'd1;

                if(store_cnt == 'd0) begin
                    ram_en <= 'd0;
                    wea <= 'd0;
                end
                else begin
                    ram_en <= 'd1;
                    wea <= 'd1;
                end
            end

            default: begin
                wea <= wea;
                ram_en <= ram_en;
            end

            endcase
        end

        else begin
            wea <= wea;
            ram_en <= ram_en;
        end

    end

    else begin
        ram_en <= 'd0;
        wea <= 'd0;
    end
end


always @ (posedge clk) begin
    if(!rst) begin
        if(ram_en) begin
            if(wea) begin
                store_cnt <= 'd0;
            end
            else 
                load_cnt <= 'd0;
        end
        else begin
            load_cnt <= 'd1;
            store_cnt <= 'd1;
        end
    end
    else begin
        load_cnt <= 'd1;
        store_cnt <= 'd1;
    end
end




// always @ (*) begin
//     if(!rst) begin
//         if(load_cnt == 'd0 || store_cnt == 'd0) begin
//             ram_en = 'd0;
//             wea = 'd0;
//         end

//         else if(start) begin
//             case (op_mode1)
//             // load data 
//             'b00: begin
//                 wea = 'd0;

//                 if(load_cnt == 'd0) begin
//                     ram_en = 'd0;
//                 end
//                 else begin
//                     ram_en = 'd1;
//                 end
//             end     

//             // store data
//             'b01: begin
//                 ram_en = 'd1;

//                 if(store_cnt == 'd0 || store_cnt == 'd2 || store_cnt == 'd1) begin
//                     ram_en = 'd0;
//                     wea = 'd0;
//                 end
//                 else begin
//                     ram_en = 'd1;
//                     wea = 'd1;
//                 end
//             end

//             default: begin
//                 wea = wea;
//                 ram_en = ram_en;
//             end

//             endcase
//         end

//         else begin
//             wea = wea;
//             ram_en = ram_en;
//         end

//     end

//     else begin
//         ram_en = 'd0;
//         wea = 'd0;
//     end
// end





// /* set loading operation clk, done signal and output data choose */
// // set loading cnt and half_word_extra read flag
// always @ (posedge clk) begin
//     if(!rst) begin
//         if(ram_en && wea == 'd0) begin

//             if(load_cnt == 'd3) begin
//                 raddr <= op1 + imm_data;

//                 // read half word
//                 if(op_mode2 == 'b010 || op_mode2 == 'b011) begin
//                     case (instant_addr[1:0]) 
//                     // set extra loading flag for half_word loading
//                     // half_word_extra is set as 2
//                     'b11: begin
//                         load_cnt <= 'd2;
//                         half_word_extra <= 'd2;    
//                     end
//                     default: begin
//                         load_cnt <= load_cnt - 'd1;
//                         half_word_extra <= half_word_extra;    
//                     end
//                     endcase
//                 end
                
//                 // read word
//                 else if(op_mode2 == 'b100) begin
//                     case (instant_addr[1:0]) 
//                     // set extra loading flag for word loading
//                     // half_word_extra is set as different value
//                     'b00: begin
//                         load_cnt <= 'd1;
//                         half_word_extra <= 'd0;    
//                     end

//                     'b01: begin
//                         load_cnt <= 'd2;
//                         half_word_extra <= 'd3;
//                     end

//                     'b10: begin
//                         load_cnt <= 'd2;
//                         half_word_extra <= 'd4;
//                     end

//                     'b11: begin
//                         load_cnt <= 'd2;
//                         half_word_extra <= 'd5;
//                     end

//                     default: begin
//                         load_cnt <= load_cnt;
//                         half_word_extra <= half_word_extra;    
//                     end
//                     endcase
//                 end

//                 // read byte
//                 else if (op_mode2 == 'b000 || op_mode2 == 'b001) begin
//                     load_cnt <= 'd0;
//                     half_word_extra <= 'd0;
//                 end
                
//                 else begin
//                     load_cnt <= 'd0;
//                     half_word_extra <= 'd0;    
//                 end
//             end

//             else begin
//                 if(load_cnt == 'd0) begin
//                     load_cnt <= 'd3;
//                     raddr <= raddr;
//                 end
//                 else if (half_word_extra > 'd0 && load_cnt == 'd2) begin
//                     load_cnt <= load_cnt - 'd1;

//                     // + 'd3 to move current reading to next memory body
//                     raddr <= raddr + 'd3;
//                 end
//                 else begin
//                     load_cnt <= load_cnt - 'd1;
//                     raddr <= raddr;
//                 end

//                 half_word_extra <= half_word_extra;    
//             end
//         end
//         else begin
//             load_cnt <= 'd3;
//             half_word_extra <= 'd0; 
//             raddr <= raddr;
//         end
//     end

//     else begin
//         load_cnt <= 'd3;    
//         half_word_extra <= 'd0;
//         raddr <= 'd0;    
//     end
// end


// // using instant_addr to help generate half_word_extra and load_cnt
// always @ (*) begin
//     if(!rst) begin
//         if(ram_en == 'd1 && wea == 'd0) begin
            
//             if(load_cnt == 'd3) begin
//                 instant_addr = op1 + imm_data;
//             end

//             else begin
//                 instant_addr = 'd0;
//             end
//         end
//         else begin
//             instant_addr = 'd0;
//         end
//     end

//     else begin
//         instant_addr = 'd0;
//     end
// end


// generate done signal
always @ (posedge clk) begin
    if(!rst) begin
        if(load_cnt == 'd0 || store_cnt == 'd0) begin
            done <= 'd1;
        end
        else begin
            done <= 'd0;
        end
    end

    else begin
        done <= 'd0;  
    end
end


// // choose data to output
// // read half word is complex for it's accessing times can vary in 1 to 2
// always @ (done) begin
//     if(!rst) begin
//         if(done) begin
//             case (op_mode2)
//             // read byte
//             'b000: begin
//                 case (addr[1:0])
//                 'b00:
//                     res = {{24{dout[7]}}, dout[7:0]};

//                 'b01:
//                     res = {{24{dout[15]}}, dout[15:8]};

//                 'b10:
//                     res = {{24{dout[23]}}, dout[23:16]};

//                 'b11:
//                     res = {{24{dout[31]}}, dout[31:24]};
//                 endcase
//             end

//             // read half word
//             'b010: begin
//                 case (addr[1:0])
//                 // raddr will self-add for two-times reading
//                 'b00: begin
//                     if(half_word_extra == 'd2) begin
//                         res = {{16{dout[7]}}, dout[7:0], dout_f[31:24]};
//                     end
//                     else begin
//                         res = {{16{dout[15]}}, dout[15:0]};
//                     end
//                 end

//                 'b01:
//                     res = {{16{dout[23]}}, dout[23:8]};

//                 'b10:
//                     res = {{16{dout[31]}}, dout[31:16]};
                
//                 default: begin
//                     res = res;
//                 end
//                 endcase
//             end

//             // read word
//             'b100: begin
//                 case (half_word_extra)
//                 'd3: begin
//                     res = {dout[7:0], dout_f[31:8]};
//                 end

//                 'd4: begin
//                     res = {dout[15:0], dout_f[31:16]};
//                 end

//                 'd5: begin
//                     res = {dout[23:0], dout_f[31:24]};
//                 end

//                 default: begin
//                     res = dout;
//                 end

//                 endcase
//             end

//             // read byte unsigned
//             'b001: begin
//                 case (addr[1:0])
//                 'b00: 
//                     res = {24'b0, dout[7:0]};
//                 'b01:
//                     res = {24'b0, dout[15:8]};
//                 'b10:
//                     res = {24'b0, dout[23:16]};
//                 'b11:
//                     res = {24'b0, dout[31:24]};

//                 default: begin
//                     res = res;
//                 end
//                 endcase
//             end

//             // read half word unsigned
//             'b011: begin
//                case (addr[1:0])
//                 // raddr will self-add for two-times reading
//                 'b00: begin
//                     if(half_word_extra == 'd2) begin
//                         res = {16'b0, dout[7:0], dout_f[31:24]};
//                     end
//                     else begin
//                         res = {16'b0, dout[15:0]};
//                     end
//                 end

//                 'b01:
//                     res = {16'b0, dout[23:8]};

//                 'b10:
//                     res = {16'b0, dout[31:16]};
                
//                 default: begin
//                     res = res;
//                 end
//                 endcase
//             end

//             default: begin
//                 res = res;
//             end

//             endcase
//         end
//         else begin
//             res = res;
//         end
//     end

//     else begin
//         res = 'd0;
//     end
// end


// // handling bram dout when need extra half word loading
// always @ (*) begin
//     if(!rst) begin
//         if(wea == 'd0 && half_word_extra >= 'd2 && load_cnt == 'd1) begin
//             dout_f = dout;
//         end
//         else if (wea == 'd0 && half_word_extra >= 'd2) begin
//             dout_f = dout_f;
//         end
//         else begin
//             dout_f = 'd0;
//         end
//     end

//     else begin
//         dout_f = 'd0;    
//     end
// end


// // gengerate writing addr
// always @ (*) begin
//     if(!rst) begin
//         if(wea == 'd1 && ram_en == 'd1) begin
//             case (op_mode2)
//             // store byte
//             'b000: begin
//                 waddr = op1 + imm_data;    
//             end

//             // store half word
//             'b010: begin
//                 if(store_cnt == 'd2) begin
//                     waddr = op1 + imm_data;
//                 end
//                 else if (store_cnt == 'd1) begin
//                     waddr = waddr + 'd1;
//                 end
//                 else begin
//                     waddr = waddr;
//                 end
//             end

//             // store word
//             'b100: begin
//                 if(store_cnt == 'd5) begin
//                     waddr = op1 + imm_data;
//                 end
//                 else if (store_cnt >= 'd1) begin
//                     waddr = waddr + 'd1;
//                 end
//                 else begin
//                     waddr = waddr;
//                 end
//             end

//             default: begin
//                 waddr = waddr;
//             end

//             endcase
//         end    
//     end

//     else begin
//         waddr = 'd0;
//     end
// end


// control addr's value from raddr and waddr
always @ (*) begin
    if(!rst) begin
        // if(wea == 'd0) begin
        //     addr = raddr;
        // end
        // else begin
        //     addr = waddr;
        // end
        if(ram_en) 
            addr = op1 + imm_data;
        else 
            addr = 'd0;
    end

    else begin
        addr = 'd0;
    end
end





// /* generate writing data */
// // store incoming data 
// always @ (*) begin
//     if(!rst) begin
//         src_data[0] = op2[7:0];
//         src_data[1] = op2[15:8];
//         src_data[2] = op2[23:16];
//         src_data[3] = op2[31:24];
//     end

//     else begin
//         src_data[0] = 'd0;
//         src_data[1] = 'd0;
//         src_data[2] = 'd0;
//         src_data[3] = 'd0;
//     end
// end


// // choose writing data
// always @ (*) begin
//     if(!rst) begin
//         if( ram_en && wea ) begin
//             case (op_mode2)
//             'b100: begin
//                 case (store_cnt)
//                 'd5:
//                     din_reg = src_data[0];
//                 'd4:
//                     din_reg = src_data[1];
//                 'd3:
//                     din_reg = src_data[2];
//                 'd2:
//                     din_reg = src_data[3];
//                 default:
//                     din_reg = din_reg;
//                 endcase
//             end

//             'b010: begin
//                 case (store_cnt)
//                 'd2:
//                     din_reg = src_data[0];
//                 'd1:
//                     din_reg = src_data[1];
//                 default:
//                     din_reg = din_reg;
//                 endcase
//             end

//             'b000: begin
//                 din_reg = src_data[0];
//             end

//             endcase
//         end
//     end

//     else begin
//         din_reg = 'd0;
//     end
// end





// /* set storing operation clk, done signal and input data choose */
// always @ (posedge clk) begin
//     if(!rst) begin
//         if(ram_en && wea) begin
//             case (op_mode2)
//             // store byte
//             'b000: begin
//                 if(ram_en) begin
//                     if(store_cnt == 'd5) begin
//                         store_cnt <= 'd1;
//                     end
//                     else begin
//                         store_cnt <= store_cnt - 'd1;
//                     end
//                 end
//                 else begin
//                     store_cnt <= 'd5;
//                 end
//             end

//             // store half word
//             'b010: begin
//                 if(ram_en) begin
//                     if(store_cnt == 'd5) begin
//                         store_cnt <= 'd2;
//                     end
//                     else begin
//                         store_cnt <= store_cnt - 'd1;
//                     end
//                 end
//                 else begin
//                     store_cnt <= 'd5;
//                 end
//             end

//             // store word
//             'b100: begin
//                 if(ram_en) begin
//                     if(store_cnt == 'd5) begin
//                         store_cnt <= 'd4;
//                     end
//                     else begin
//                         store_cnt <= store_cnt - 'd1;
//                     end
//                 end
//                 else begin
//                     store_cnt <= 'd5;
//                 end
//             end

//             default: begin
//                 store_cnt <= 'd5;
//             end

//             endcase
        
//         end

//         else begin
//             store_cnt <= 'd5;
//         end
//     end

//     else begin
//         store_cnt <= 'd5;        
//     end
// end


endmodule