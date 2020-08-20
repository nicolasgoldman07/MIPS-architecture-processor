`timescale 1ns / 1ps


// CONTROL UNIT + (BRANCH&ZERO) // ALU control is other module
module ControlUnit
#(
  parameter	                    N_BUS_IN   	= 6,
  parameter	                    N_BUS_OUT 	= 10,
  parameter	                    N_BUS_OP   	= 2

)
(
  input       [N_BUS_IN-1:0]        i_controlUnit,
  input                             i_zero,
  output      reg                   o_regDst,
  output      reg                   o_ALUSrc,  
  output      reg                   o_memtoReg,  
  output      reg                   o_regWrite,  
  output      reg                   o_memRead,  
  output      reg                   o_memWrite,  
  output      reg                   o_ALUOp1,
  output      reg                   o_ALUOp0,
  output      reg                   o_jump,
  output                            o_pcSrc
  
);
    
  reg         [N_BUS_OUT-1:0]       control_signals;
  reg                               branch;
  
  always @(*)
    begin
        case(i_controlUnit)
            6'b000000: // R-TYPE
                begin
                    control_signals <= 10'b1001000100;
                end
            6'b100011: // LW
                begin
                    control_signals <= 10'b0111100000;
                end
            6'b101011: // SW
                begin
                    control_signals <= 10'b0100010000;
                end
            6'b000100: // BEQ
                begin
                    control_signals <= 10'b0000001010;
                end
            6'b000010: // JUMP
                begin
                    control_signals <= 10'b0000000001;
                end    
            
            default: control_signals <= 10'b0000000000;
        endcase
    
    {o_regDst, o_ALUSrc, o_memtoReg, o_regWrite, o_memRead, o_memWrite, branch, o_ALUOp1, o_ALUOp0, o_jump} = control_signals;
    
    end
    
    assign o_pcSrc = branch & i_zero;
  

endmodule
