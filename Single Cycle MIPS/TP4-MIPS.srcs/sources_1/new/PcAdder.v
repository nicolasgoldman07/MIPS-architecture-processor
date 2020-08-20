`timescale 1ns / 1ps

module PcAdder
#(
  parameter	                    N_BUS   	= 32
)
(
  input       [N_BUS-1:0]       i_add, 
  output      [N_BUS-1:0]       o_add
);

  reg   signed	[N_BUS-1:0] regR;

  always @(*)       
    begin
        regR 		<= 		i_add + 32'd4;
    end
    
assign o_add = regR;

endmodule
