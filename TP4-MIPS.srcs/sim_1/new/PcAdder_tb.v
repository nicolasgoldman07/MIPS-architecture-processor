`timescale 1ns / 1ps

module PcAdder_tb();
  reg     [31:0]  i_add;
  wire    [31:0]  o_add;  

    PcAdder PcAdder_tb(.i_add(i_add), .o_add(o_add));

    initial
        begin

		#0 i_add = 32'd100;
                    
		#10 i_add = 32'd350;
          
		#10 i_add = 32'd480;

        end
  
  initial
        #100 $finish;
endmodule
