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



/* **********2020 07 20****************************************
    change original ram to four-body ram consisted by four
    bram generator, each owns 8 bit bandwidth and 1024 storage
    depth. This module not only control these bram, but also
    translate outer linear addr to inner-bram non-linear addr
                               modified by winters
*************************************************************** */

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


reg         [11:0]                       out_addr;
reg         [9:0]                       addr_0;
reg         [9:0]                       addr_1;
reg         [9:0]                       addr_2;
reg         [9:0]                       addr_3;

reg         [9:0]                       raddr;
reg         [9:0]                       waddr;
reg         [9:0]                       instant_addr;


// use to store op2
reg         [7:0]                       src_data        [3:0];
reg         [7:0]                       din_reg;
wire        [31:0]                       din;
wire        [7:0]                       din_0;
wire        [7:0]                       din_1;
wire        [7:0]                       din_2;
wire        [7:0]                       din_3;
assign din = op2;
wire        [31:0]                      dout;
wire        [7:0]                       dout_0;
wire        [7:0]                       dout_1;
wire        [7:0]                       dout_2;
wire        [7:0]                       dout_3;

reg                                     ram_en;
reg                                     wea_0;
reg                                     wea_1;
reg                                     wea_2;
reg                                     wea_3;

// set operation clocks
reg         [3:0]                       load_cnt;
reg         [3:0]                       store_cnt;





four_body_bram_sp ram_0(
    .addra              (addr_0),
    .clka               (clk),
    .dina               (din_0),
    .douta              (dout_0),
    .ena                (ram_en),
    .wea                (wea_0)
);


four_body_ram ram_1(
    .addra              (addr_1),
    .clka               (clk),
    .dina               (din_1),
    .douta              (dout_1),
    .ena                (ram_en),
    .wea                (wea_1)
);


four_body_ram ram_2(
    .addra              (addr_2),
    .clka               (clk),
    .dina               (din_2),
    .douta              (dout_2),
    .ena                (ram_en),
    .wea                (wea_2)
);


four_body_ram ram_3(
    .addra              (addr_3),
    .clka               (clk),
    .dina               (din_3),
    .douta              (dout_3),
    .ena                (ram_en),
    .wea                (wea_3)
);





/* set initial controling signal 
    ram_en and wea */
always @ (*) begin
    if(!rst) begin
        if(load_cnt == 'd0 || store_cnt == 'd0) begin
            ram_en <= 'd0;
            wea_0 <= 'd0;
            wea_1 <= 'd0;
            wea_2 <= 'd0;
            wea_3 <= 'd0;
        end

        else if(start) begin
            case (op_mode1)
            // load word 
            'b00: begin
                wea_0 <= 'd0;
                wea_1 <= 'd0;
                wea_2 <= 'd0;
                wea_3 <= 'd0;

                if(load_cnt == 'd0) begin
                    ram_en <= 'd0;
                end
                else begin
                    ram_en <= 'd1;
                end
            end     

            // store data
            'b01: begin
                if(store_cnt == 'd0) begin
                    ram_en <= 'd0;
                    wea_0 <= 'd0;
                    wea_1 <= 'd0;
                    wea_2 <= 'd0;
                    wea_3 <= 'd0;
                end
                else begin
                    ram_en <= 'd1;
                    // store word
                    if(op_mode2 == 'b100) begin
                        wea_0 <= 'd1;
                        wea_1 <= 'd1;
                        wea_2 <= 'd1;
                        wea_3 <= 'd1;
                    end
                    // store byte
                    else begin
                        case (out_addr[1:0])
                        'b00: begin
                            wea_0 <= 'd1;
                            wea_1 <= 'd0;
                            wea_2 <= 'd0;
                            wea_3 <= 'd0;
                        end

                        'b01: begin
                            wea_0 <= 'd0;
                            wea_1 <= 'd1;
                            wea_2 <= 'd0;
                            wea_3 <= 'd0;
                        end

                        'b10: begin
                            wea_0 <= 'd0;
                            wea_1 <= 'd0;
                            wea_2 <= 'd1;
                            wea_3 <= 'd0;
                        end

                        'b11: begin
                            wea_0 <= 'd0;
                            wea_1 <= 'd0;
                            wea_2 <= 'd0;
                            wea_3 <= 'd1;
                        end
                        endcase
                    end
                end
            end

            default: begin
                ram_en <= ram_en;
                wea_0 <= wea_0;
                wea_1 <= wea_1;
                wea_2 <= wea_2;
                wea_3 <= wea_3;
            end

            endcase
        end

        else begin
            ram_en <= ram_en;
            wea_0 <= wea_0;
            wea_1 <= wea_1;
            wea_2 <= wea_2;
            wea_3 <= wea_3;
        end

    end

    else begin
        ram_en <= 'd0;
        wea_0 <= 'd0;
        wea_1 <= 'd0;
        wea_2 <= 'd0;
        wea_3 <= 'd0;
    end
end


// set load_cnt or store_cnt
always @ (posedge clk) begin
    if(!rst) begin
        if(ram_en) begin
            if( wea_0 || wea_1 || wea_2 || wea_3 ) begin
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




/* control multiple granularity memory access operation */
// set addr
// set dout
// set din
always @ (*) begin
    if(!rst) begin
        if(ram_en) begin
            out_addr = op1 + imm_data;
            case (op_mode2)
            // operation on word
            'b100: begin
                addr_0 = out_addr;
                addr_1 = out_addr;
                addr_2 = out_addr;
                addr_3 = out_addr;
            end

            // operation on byte
            'b000: begin
                case (out_addr[1:0])
                'b00: begin
                    addr_0 = out_addr[11:2];
                    addr_1 = 'd0;
                    addr_2 = 'd0;
                    addr_3 = 'd0;
                end

                'b01: begin
                    addr_0 = 'd0;
                    addr_1 = out_addr[11:2];
                    addr_2 = 'd0;
                    addr_3 = 'd0;
                end

                'b10: begin
                    addr_0 = 'd0;
                    addr_1 = 'd0;
                    addr_2 = out_addr[11:2];
                    addr_3 = 'd0;
                end

                'b11: begin
                    addr_0 = 'd0;
                    addr_1 = 'd0;
                    addr_2 = 'd0;
                    addr_3 = out_addr[11:2];
                end

                endcase
                
            end

            default: begin
                addr_0 = 'd0;
                addr_1 = 'd0;
                addr_2 = 'd0;
                addr_3 = 'd0;
            end

            endcase
        end
            
        else begin
            addr_0 = 'd0;
            addr_1 = 'd0;
            addr_2 = 'd0;
            addr_3 = 'd0;
        end
    end

    else begin
        addr_0 = 'd0;
        addr_1 = 'd0;
        addr_2 = 'd0;
        addr_3 = 'd0;
    end
end


assign res = (op_mode2 == 'b100) ? {dout_3, dout_2, dout_1, dout_0} :
                (out_addr[1:0] == 'b00) ? {24'b0, dout_0} :
                (out_addr[1:0] == 'b01) ? {24'b0, dout_1} :
                (out_addr[1:0] == 'b10) ? {24'b0, dout_2} :
                {24'b0, dout_3};


assign din_0 = (op_mode2 == 'b100) ? din[7:0] :
                (out_addr[1:0] == 'b00) ? {din[7:0]} :
                (out_addr[1:0] == 'b01) ? {8'b0} :
                (out_addr[1:0] == 'b10) ? {8'b0} :
                {8'b0};


assign din_1 = (op_mode2 == 'b100) ? din[15:8] :
                (out_addr[1:0] == 'b00) ? {8'b0} :
                (out_addr[1:0] == 'b01) ? {din[7:0]} :
                (out_addr[1:0] == 'b10) ? {8'b0} :
                {8'b0};


assign din_2 = (op_mode2 == 'b100) ? din[23:16] :
                (out_addr[1:0] == 'b00) ? {8'b0} :
                (out_addr[1:0] == 'b01) ? {8'b0} :
                (out_addr[1:0] == 'b10) ? {din[7:0]} :
                {8'b0};

assign din_3 = (op_mode2 == 'b100) ? din[31:24] :
                (out_addr[1:0] == 'b00) ? {8'b0} :
                (out_addr[1:0] == 'b01) ? {8'b0} :
                (out_addr[1:0] == 'b10) ? {8'b0} :
                {din[7:0]};




endmodule