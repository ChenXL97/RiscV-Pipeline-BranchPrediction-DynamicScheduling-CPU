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

/* ***********************2020 07 21*******************************
    To simplify the hardware design, all function part will be set 
    only one time, thus one bit can indicate whether a part is busy
    or not.

    Global stall signal should be gen by tomasulo instead of exe. 
    Stall signal will not pause exe. When rob is full, global stall
    signal should be set valid, otherwise stall signal shoule be pull
    down.

    Flush signal is still gen by exe, when predict addr is not corres-
    ponding to actual branch addr. When flushing, all module include
    rob but except for pc is resetted. 

*************************modified by winters********************* */




module ROB (
    input                                       clk,
    input                                       rst,

    // global control signal
    input                                       ex_flush,
    output                                      rob_stall,

    // signal from exe to help dispatch
    input                                       ex_done,
    input       [14:0]                          func_part_done,

    input       [`ROB_ITEM_INDEX]               rob_info,
    input       [31:0]                          de_cur_pc
);




reg         [`ROB_ITEM_INDEX]                   rob_info_stack      [9:0]










endmodule
