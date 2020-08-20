`timescale 1ns / 1ps

module T_Datapath_tb();
  reg                   i_clk;
  reg                   i_reset;  
  reg                   i_regWrite;  
  reg                   i_ALUSrc;
  reg       [4:0]       i_ALUOp;
  reg                   i_PCSrc;  
  reg                   i_memRead;  
  reg                   i_memWrite;  
  reg                   i_memToReg;
  wire      [31:0]      o_PCSrc; 
  wire      [31:0]      o_PC;    
  wire      [31:0]      o_instrMem;    
  wire      [31:0]      o_regFile1;    
  wire      [31:0]      o_regFile2;    
  wire      [31:0]      o_ALU;    
  wire      [31:0]      o_muxMemToReg;    
   
    T_Datapath T_Datapath_tb(.i_clk(i_clk), .i_reset(i_reset),.i_regWrite(i_regWrite),.i_ALUSrc(i_ALUSrc),
        .i_ALUOp(i_ALUOp),.i_PCSrc(i_PCSrc),.i_memRead(i_memRead),.i_memWrite(i_memWrite),
        .i_memToReg(i_memToReg),
        .o_PCSrc(o_PCSrc), .o_PC(o_PC), .o_instrMem(o_instrMem), .o_regFile1(o_regFile1),
        .o_regFile2(o_regFile2), .o_ALU(o_ALU), .o_muxMemToReg(o_muxMemToReg)
        );

    initial
        begin
		  #0    i_reset = 1'b1; i_clk = 1'b0;
		  #1    i_reset = 1'b0;
		end 
		
	always  		
		begin
          #1  i_clk = ~i_clk;
        end
        
  
  initial
        #100 $finish;
endmodule
