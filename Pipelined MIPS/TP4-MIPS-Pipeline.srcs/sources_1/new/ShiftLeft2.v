`timescale 1ns / 1ps

module ShiftLeft2
#(
    parameter	                  N_BUS   	  = 32
)
(
    input         [N_BUS-1:0]           i_shiftLeft, 
    output        [N_BUS-1:0]           o_shiftLeft
);
    
    assign o_shiftLeft = i_shiftLeft << 2;

endmodule
