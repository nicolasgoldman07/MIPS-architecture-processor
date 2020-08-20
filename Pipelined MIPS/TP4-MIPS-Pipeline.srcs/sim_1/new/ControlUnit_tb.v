`timescale 1ns / 1ps

module ControlUnit_tb();

  reg       [5:0]       i_controlUnit;
  reg                   i_zero;
  wire                  o_regDst; 
  wire                  o_ALUSrc;
  wire                  o_memtoReg;
  wire                  o_regWrite;
  wire                  o_memRead;
  wire                  o_memWrite;
  wire                  o_ALUOp1;
  wire                  o_ALUOp0; 
  wire                  o_pcSrc; 

  ControlUnit ControlUnit_tb(.i_controlUnit(i_controlUnit), .i_zero(i_zero),
    .o_regDst(o_regDst), .o_ALUSrc(o_ALUSrc), .o_memtoReg(o_memtoReg),
    .o_regWrite(o_regWrite), .o_memRead(o_memRead), .o_memWrite(o_memWrite),
    .o_ALUOp1(o_ALUOp1), .o_ALUOp0(o_ALUOp0), .o_pcSrc(o_pcSrc));

  initial
    begin
        #0      i_controlUnit = 6'b000000;  i_zero = 1'b0;
        #5      i_controlUnit = 6'b100011; 
        #5      i_controlUnit = 6'b101011;
        #5      i_controlUnit = 6'b000100;  i_zero = 1'b1;
        #5      i_controlUnit = 6'b000100;  i_zero = 1'b0;
        #5      i_controlUnit = 6'b111111;
    end
    
    
    initial
        #30 $finish;
endmodule

