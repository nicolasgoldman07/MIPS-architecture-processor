`timescale 1ns / 1ps

module ProgramCounter_tb();
  reg			  i_reset, i_clk, i_pcWrite;
  reg     [31:0]  i_pc;
  wire    [31:0]  o_pc;  

    ProgramCounter ProgramCounter_tb(.i_reset(i_reset), .i_clk(i_clk),
                                     .i_pc(i_pc), .o_pc(o_pc), .i_pcWrite(i_pcWrite));

    initial
        begin

		#0 i_clk = 1'b0; i_reset = 1'b0; i_pc = 32'd100;
          
        #5 i_reset = 1'b1;
          
		#5 i_reset = 1'b0;
          
		#10 i_pc = 32'd350;
		    i_pcWrite = 1'b0;
        
        #10 i_pcWrite = 1'b1;
          
		#10 i_pc = 32'd480;

        end
always  
    begin
        #1
        i_clk = ~i_clk;
    end
  
  initial
        #100 $finish;
endmodule
