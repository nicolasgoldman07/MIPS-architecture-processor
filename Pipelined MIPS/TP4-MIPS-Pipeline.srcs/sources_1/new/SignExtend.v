`timescale 1ns / 1ps

module SignExtend
#(
    parameter	                    N_BUS_IN   	    = 16,
    parameter                       N_BUS_OUT       = 32
)
(
    input         [N_BUS_IN-1:0]          i_signExtend, 
    output        [N_BUS_OUT-1:0]         o_signExtend
);
    
    assign o_signExtend = { {16{i_signExtend[15]}}, i_signExtend };

endmodule