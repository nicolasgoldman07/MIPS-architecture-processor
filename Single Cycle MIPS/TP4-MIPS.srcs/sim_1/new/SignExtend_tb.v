`timescale 1ns / 1ps

module SignExtend_tb();
  reg [15:0] i_signExtend;
  wire [31:0] o_signExtend;

  SignExtend SignExtend_tb(.i_signExtend(i_signExtend), .o_signExtend(o_signExtend));

  initial
    begin
      #10 i_signExtend = 16'b1111111111111111;
      #10 i_signExtend = 16'b0000000000000000;
      #10 i_signExtend = 16'b0101010101010101;
      #10 i_signExtend = 16'b1010101010101010;
    end

endmodule

