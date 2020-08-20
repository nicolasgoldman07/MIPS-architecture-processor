`timescale 1ns / 1ps

module BranchAdder
#(
       parameter N_BUS = 32
   )
   (
       input  signed    [N_BUS - 1 : 0] i_A,
       input  signed    [N_BUS - 1 : 0] i_B,
       output reg       [N_BUS - 1 : 0] o_add
   );

  always@(*) begin
    o_add = i_A + i_B;
  end

endmodule