`timescale 1ns / 1ps



module ShiftLeft2_tb();
    reg     [31:0] i_shiftLeft;
    wire    [31:0] o_shiftLeft;

  ShiftLeft2 ShiftLeft2_tb(.i_shiftLeft(i_shiftLeft), .o_shiftLeft(o_shiftLeft));

  initial
    begin
      #10 i_shiftLeft = 32'b11111111111111111111111111111111;
      #10 i_shiftLeft = 32'b00000000000000000000000000000000;
      #10 i_shiftLeft = 32'b01010101010101010101010101010101;
      #10 i_shiftLeft = 32'b10101010101010101010101010101010;
    end

endmodule