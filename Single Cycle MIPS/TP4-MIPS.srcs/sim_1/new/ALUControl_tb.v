`timescale 1ns / 1ps

module ALUControl_tb();
  reg       [5:0]       i_func;    
  reg                   i_ALUOp0;
  reg                   i_ALUOp1;    
  wire      [3:0]       o_ALUcontrol; 
  
   
    ALUControl ALUControl_tb(.i_func(i_func), .i_ALUOp0(i_ALUOp0), .i_ALUOp1(i_ALUOp1), .o_ALUcontrol(o_ALUcontrol));

    initial
        begin
		  #0      i_ALUOp1 = 1'b0; i_ALUOp0 = 1'b0; i_func = 6'bxxxxxx;
		  #5      i_ALUOp1 = 1'b0; i_ALUOp0 = 1'b1; i_func = 6'bxxxxxx;
		  #5      i_ALUOp1 = 1'b1; i_ALUOp0 = 1'b0; i_func = 6'b100000;
		  #5      i_ALUOp1 = 1'b1; i_ALUOp0 = 1'b0; i_func = 6'b100010;
		  #5      i_ALUOp1 = 1'b1; i_ALUOp0 = 1'b0; i_func = 6'b100100;		  
		  #5      i_ALUOp1 = 1'b1; i_ALUOp0 = 1'b0; i_func = 6'b100101;
		  #5      i_ALUOp1 = 1'b1; i_ALUOp0 = 1'b0; i_func = 6'b101010;	  
		end 

  initial
        #35 $finish;
endmodule