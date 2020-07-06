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

module REG_FILE(
    input                               clk,
    input                               rst,

    input       [4:0]                   reg_addr,
    input                               reg_rw,  // true is write and false is read
    input       [31:0]                  reg_wdata,

    output      reg     [31:0]                  reg_rdata
);



reg         [31:0]                  reg_heat    [31:0];




always @ (posedge clk) begin
    if(!rst) begin
        // write regfile
        if(reg_rw) begin
            case (reg_addr)
            'd0: begin
                reg_heat[0] <= 'd0;
            end
            'd1: begin
                reg_heat[1] <= reg_wdata;
            end
            'd2: begin
                reg_heat[2] <= reg_wdata;
            end
            'd3: begin
                reg_heat[3] <= reg_wdata;
            end
            'd4: begin
                reg_heat[4] <= reg_wdata;
            end
            'd5: begin
                reg_heat[5] <= reg_wdata;
            end
            'd6: begin
                reg_heat[6] <= reg_wdata;
            end
            'd7: begin
                reg_heat[7] <= reg_wdata;
            end
            'd8: begin
                reg_heat[8] <= reg_wdata;
            end
            'd9: begin
                reg_heat[9] <= reg_wdata;
            end
            'd10: begin
                reg_heat[10] <= reg_wdata;
            end
            'd11: begin
                reg_heat[11] <= reg_wdata;
            end
            'd12: begin
                reg_heat[12] <= reg_wdata;
            end
            'd13: begin
                reg_heat[13] <= reg_wdata;
            end
            'd14: begin
                reg_heat[14] <= reg_wdata;
            end
            'd15: begin
                reg_heat[15] <= reg_wdata;
            end
            'd16: begin
                reg_heat[16] <= reg_wdata;
            end
            'd17: begin
                reg_heat[17] <= reg_wdata;
            end
            'd18: begin
                reg_heat[18] <= reg_wdata;
            end
            'd19: begin
                reg_heat[19] <= reg_wdata;
            end
            'd20: begin
                reg_heat[20] <= reg_wdata;
            end
            'd21: begin
                reg_heat[21] <= reg_wdata;
            end
            'd22: begin
                reg_heat[22] <= reg_wdata;
            end
            'd23: begin
                reg_heat[23] <= reg_wdata;
            end
            'd24: begin
                reg_heat[24] <= reg_wdata;
            end
            'd25: begin
                reg_heat[25] <= reg_wdata;
            end
            'd26: begin
                reg_heat[26] <= reg_wdata;
            end
            'd27: begin
                reg_heat[27] <= reg_wdata;
            end
            'd28: begin
                reg_heat[28] <= reg_wdata;
            end
            'd29: begin
                reg_heat[29] <= reg_wdata;
            end
            'd30: begin
                reg_heat[30] <= reg_wdata;
            end
            'd31: begin
                reg_heat[31] <= reg_wdata;
            end

            endcase
        end

        // read regfile
        else begin
            reg_rdata <= reg_heat[reg_addr];
        end
    end

    else begin
        reg_heat[0] <= 'd0;
        reg_heat[1] <= 'd0;
        reg_heat[2] <= 'd0;
        reg_heat[3] <= 'd0;
        reg_heat[4] <= 'd0;
        reg_heat[5] <= 'd0;
        reg_heat[6] <= 'd0;
        reg_heat[7] <= 'd0;
        reg_heat[8] <= 'd0;
        reg_heat[9] <= 'd0;
        reg_heat[10] <= 'd0;
        reg_heat[11] <= 'd0;
        reg_heat[12] <= 'd0;
        reg_heat[13] <= 'd0;
        reg_heat[14] <= 'd0;
        reg_heat[15] <= 'd0;
        reg_heat[16] <= 'd0;
        reg_heat[17] <= 'd0;
        reg_heat[18] <= 'd0;
        reg_heat[19] <= 'd0;
        reg_heat[20] <= 'd0;
        reg_heat[21] <= 'd0;
        reg_heat[22] <= 'd0;
        reg_heat[23] <= 'd0;
        reg_heat[24] <= 'd0;
        reg_heat[25] <= 'd0;
        reg_heat[26] <= 'd0;
        reg_heat[27] <= 'd0;
        reg_heat[28] <= 'd0;
        reg_heat[29] <= 'd0;
        reg_heat[30] <= 'd0;
        reg_heat[31] <= 'd0;
    end
end
 



endmodule