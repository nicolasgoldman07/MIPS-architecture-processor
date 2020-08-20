`timescale 1ns / 1ps

module InstructionMemory
#(
  parameter	                    N_BUS_DATA   	= 32,
  parameter                     N_INST          = 128,
  parameter                     INST_FILE       = "instructions.mem"

)
(
  input         [N_BUS_DATA-1:0]      i_instructionAddr, 
  output        [N_BUS_DATA-1:0]      o_instruction
);

  reg   	    [N_BUS_DATA-1:0]      instructionRegisters [0: N_INST-1];
  
  initial
  begin
    $readmemh (INST_FILE, instructionRegisters, 0, N_INST-1);
  end
  
  assign    o_instruction = instructionRegisters[i_instructionAddr];


endmodule