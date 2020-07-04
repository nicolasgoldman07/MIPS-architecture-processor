`timescale 1ns / 1ps

module InstructionMemory_tb();
  reg     [31:0]  i_instructionAddr;
  wire    [31:0]  o_instruction;  

    InstructionMemory InstructionMemory_tb(.i_instructionAddr(i_instructionAddr), 
    .o_instruction(o_instruction));

    initial
        begin
		
          #10 i_instructionAddr = 32'd0;

          #10 i_instructionAddr = 32'd1;
                          
          #10 i_instructionAddr = 32'd2;
                
          #10 i_instructionAddr = 32'd3;

          #10 i_instructionAddr = 32'd4;

          #10 i_instructionAddr = 32'd5;

          #10 i_instructionAddr = 32'd6;

          #10 i_instructionAddr = 32'd7;

          #10 i_instructionAddr = 32'd8;

          #10 i_instructionAddr = 32'd9;

          #10 i_instructionAddr = 32'd10;

          #10 i_instructionAddr = 32'd11;

          #10 i_instructionAddr = 32'd12;

          #10 i_instructionAddr = 32'd13;

          #10 i_instructionAddr = 32'd14;


        end
  
  initial
        #250 $finish;
endmodule
