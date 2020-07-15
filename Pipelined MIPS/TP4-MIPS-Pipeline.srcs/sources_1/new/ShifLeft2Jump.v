`timescale 1ns / 1ps

module ShiftLeft2Jump
#(
    parameter           N_BUS_IN        = 26,
    parameter           N_BUS_OUT       = 28          
)
(
    input         [N_BUS_IN-1:0]            i_shiftLeft, 
    output        [N_BUS_OUT-1:0]           o_shiftLeft
);
    
    assign o_shiftLeft = i_shiftLeft << 2;

endmodule
