`timescale 1ns / 1ps

module Mux2Inputs
#(
    parameter               N_BUS   	    = 32
)
(
    input                   i_muxSelector,
    input   [N_BUS-1:0]     i_mux1,
    input   [N_BUS-1:0]     i_mux2,
    output  [N_BUS-1:0]     o_mux
);

    assign  o_mux = i_muxSelector   ?   i_mux2  :   i_mux1;
endmodule
