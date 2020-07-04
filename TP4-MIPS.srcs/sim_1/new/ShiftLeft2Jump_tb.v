`timescale 1ns / 1ps

module ShiftLeft2Jump_tb();
    reg     [25:0] i_shiftLeft;
    wire    [27:0] o_shiftLeft;

  ShiftLeft2Jump ShiftLeft2Jump_tb(.i_shiftLeft(i_shiftLeft), .o_shiftLeft(o_shiftLeft));

  initial
    begin
      #10 i_shiftLeft = 26'b11111111111111111111111111;
    end
endmodule
