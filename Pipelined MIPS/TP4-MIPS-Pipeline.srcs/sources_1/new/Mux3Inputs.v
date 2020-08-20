`timescale 1ns / 1ps

module Mux3Inputs
#(
    parameter               N_BUS   	    = 32,
    parameter               N_BUS_SEL       = 2
)
(
    input       [N_BUS_SEL-1:0] i_muxSelector,
    input       [N_BUS-1:0]     i_mux1,
    input       [N_BUS-1:0]     i_mux2,
    input       [N_BUS-1:0]     i_mux3,
    output      [N_BUS-1:0]     o_mux
);
    reg         [N_BUS-1:0]     o_mux_reg;
    always@(*)
    begin
        case (i_muxSelector)
            2'b00:   o_mux_reg 		<= 		i_mux1;		// idEx		
			2'b01:   o_mux_reg 		<= 		i_mux2;		// memWb
			2'b10:   o_mux_reg 		<= 		i_mux3;		// exMem
			default: o_mux_reg 	    <= 		32'd0;
			
	    endcase
    end
    
    assign o_mux = o_mux_reg;

endmodule

