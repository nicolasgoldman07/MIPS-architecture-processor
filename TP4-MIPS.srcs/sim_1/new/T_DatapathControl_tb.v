`timescale 1ns / 1ps

module T_DatapathControl_tb();
  reg                   i_clk;
  reg                   i_reset;
  wire      [31:0]      o_PCSrc;
  wire      [31:0]      o_PC;    
  wire      [31:0]      o_instrMem;    
  wire      [31:0]      o_regFile1;    
  wire      [31:0]      o_regFile2;    
  wire      [31:0]      o_ALU;    
  wire      [31:0]      o_MuxMemtoReg;    
   
    T_DatapathControl T_DatapathControl_tb(.i_clk(i_clk), .i_reset(i_reset),
        .o_PCSrc(o_PCSrc), .o_PC(o_PC), .o_instrMem(o_instrMem), .o_regFile1(o_regFile1),
        .o_regFile2(o_regFile2), .o_ALU(o_ALU), .o_MuxMemtoReg(o_MuxMemtoReg)
        );

    initial
        begin
		  #0      i_reset = 1'b1; i_clk = 1'b0;
		  #1      i_reset = 1'b0;
		end
		
    always  
    begin
        #1  i_clk = ~i_clk;
    end
        
  
  initial
        #10 $finish;
endmodule
