`timescale 1ns / 1ps

module Mux2Inputs_tb();
  reg              i_muxSelector;
  reg   [31:0]     i_mux1;
  reg   [31:0]     i_mux2;
  wire  [31:0]     o_mux;

  Mux2Inputs Mux2Inputs_tb(.i_muxSelector(i_muxSelector), .i_mux1(i_mux1), .i_mux2(i_mux2),.o_mux(o_mux));

  initial
    begin
      #10   i_muxSelector   = 1'b0;
            i_mux1          = 32'd15;
            i_mux2          = 32'd1005;
            
      #10   i_muxSelector   = 1'b1;
            i_mux1          = 32'd15;
            i_mux2          = 32'd1005;  
      
      #10   i_muxSelector   = 1'b0;
            i_mux1          = 32'd8888888;
            i_mux2          = 32'd1005;
      
      #10   i_muxSelector   = 1'b1;
            i_mux1          = 32'd15;
            i_mux2          = 32'd1000005;      

    end

endmodule
