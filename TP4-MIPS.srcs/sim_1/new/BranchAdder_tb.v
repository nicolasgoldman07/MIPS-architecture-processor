`timescale 1ns / 1ps

module BranchAdder_tb();
  reg     [31:0]  i_A;
  reg     [31:0]  i_B;
  wire    [31:0]  o_add;  

    BranchAdder BranchAdder_tb(.i_A(i_A), .i_B(i_B), .o_add(o_add));

    initial
        begin

		#0    i_A = 32'd1;
		      i_B = 32'd1;
                    
		#10   i_A = 32'd350;
              i_B = 32'd50;
              
		#10   i_A = 32'd4;
		      i_B = 32'd4294967290;
	
		#10   i_A = 32'd6;
		      i_B = 32'd4294967290;

		#10   i_A = 32'd20;
		      i_B = 32'd4294967290;		      

        end
  
  initial
        #100 $finish;
endmodule
