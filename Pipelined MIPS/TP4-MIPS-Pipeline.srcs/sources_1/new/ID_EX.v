`timescale 1ns / 1ps

module ID_EX
#( 
  // Parametros
  parameter	                    N_BUS_IN 	= 32,
  parameter                     N_BUS_MUX   = 5
)
(
  input                         i_global_enable, i_clk, i_reset, i_branchNop,
  // CONTROL WB:
  input                         i_ctrl_memtoReg_ID,
  input                         i_ctrl_regWrite_ID,
  output reg                    o_ctrl_memtoReg_EX,
  output reg                    o_ctrl_regWrite_EX,
  // CONTROL M:
  input                         i_ctrl_jumpReg_ID,
  input                         i_ctrl_jump_ID,
  input                         i_ctrl_memRead_ID,
  input      [3:0]              i_ctrl_memWrite_ID,
  input                         i_ctrl_branch_ID,
  input                         i_ctrl_notEqBranch_ID,
  output reg                    o_ctrl_jumpReg_EX,
  output reg                    o_ctrl_jump_EX,
  output reg                    o_ctrl_memRead_EX,
  output reg  [3:0]             o_ctrl_memWrite_EX,
  output reg                    o_ctrl_branch_EX,
  output reg                    o_ctrl_notEqBranch_EX,

  // CONTROL EX:
  input                         i_ctrl_ALUSrc_ID,
  input                         i_ctrl_ALUOp0_ID,
  input                         i_ctrl_ALUOp1_ID,
  input                         i_ctrl_regDst_ID,  
  output reg                    o_ctrl_ALUSrc_EX,
  output reg                    o_ctrl_ALUOp0_EX,
  output reg                    o_ctrl_ALUOp1_EX,
  output reg                    o_ctrl_regDst_EX,

  input       [N_BUS_IN-1:0]    i_pcJump_ID,
  input       [N_BUS_IN-1:0]    i_pcAdd_ID,
  input       [N_BUS_IN-1:0]    i_readData1_ID,
  input       [N_BUS_IN-1:0]    i_readData2_ID,
  input       [N_BUS_IN-1:0]    i_signExtend_ID,
  input       [N_BUS_MUX-1:0]   i_muxWrReg0_ID,
  input       [N_BUS_MUX-1:0]   i_muxWrReg1_ID,
  output reg  [N_BUS_IN-1:0]    o_pcJump_EX,  
  output reg  [N_BUS_IN-1:0]    o_pcAdd_EX,
  output reg  [N_BUS_IN-1:0]    o_readData1_EX,
  output reg  [N_BUS_IN-1:0]    o_readData2_EX,
  output reg  [N_BUS_IN-1:0]    o_signExtend_EX,
  output reg  [N_BUS_MUX-1:0]   o_muxWrReg0_EX,
  output reg  [N_BUS_MUX-1:0]   o_muxWrReg1_EX,
  
  // FORWARD UNIT:
  input       [N_BUS_MUX-1:0]   i_readReg1_ID,
  output reg  [N_BUS_MUX-1:0]   o_readReg1_EX,
  
  // FULL INST
  input       [N_BUS_IN-1:0]    i_fullInstr_ID,
  output reg  [N_BUS_IN-1:0]    o_fullInstr_EX

);
  
  always @(negedge i_clk) 
    begin
      if (i_reset)
        begin
          o_ctrl_memtoReg_EX        <= 1'b0;
          o_ctrl_regWrite_EX        <= 1'b0;
          o_ctrl_jumpReg_EX         <= 1'b0;
          o_ctrl_jump_EX            <= 1'b0;
          o_ctrl_memRead_EX         <= 1'b0;
          o_ctrl_memWrite_EX        <= 4'd0;
          o_ctrl_branch_EX          <= 1'b0;
          o_ctrl_notEqBranch_EX     <= 1'b0;
          o_ctrl_ALUSrc_EX          <= 1'b0;
          o_ctrl_ALUOp0_EX          <= 1'b0;
          o_ctrl_ALUOp1_EX          <= 1'b0;
          o_ctrl_regDst_EX          <= 1'b0;
          o_pcJump_EX               <= 32'b0;
          o_pcAdd_EX                <= 32'b0;
          o_readData1_EX            <= 32'b0;
          o_readData2_EX            <= 32'b0;
          o_signExtend_EX           <= 32'b0;
          o_muxWrReg0_EX            <= 5'b0;
          o_muxWrReg1_EX            <= 5'b0;
          o_readReg1_EX             <= 5'b0;
          o_fullInstr_EX            <= 32'b0;
        end
      else if (i_global_enable)
        begin
          if (i_branchNop)
            begin
              o_ctrl_memtoReg_EX        <= 1'b0;
              o_ctrl_regWrite_EX        <= 1'b0;
              o_ctrl_jumpReg_EX         <= 1'b0;
              o_ctrl_jump_EX            <= 1'b0;
              o_ctrl_memRead_EX         <= 1'b0;
              o_ctrl_memWrite_EX        <= 4'd0;
              o_ctrl_branch_EX          <= 1'b0;
              o_ctrl_notEqBranch_EX     <= 1'b0;          
              o_ctrl_ALUSrc_EX          <= 1'b0;
              o_ctrl_ALUOp0_EX          <= 1'b0;
              o_ctrl_ALUOp1_EX          <= 1'b0;
              o_ctrl_regDst_EX          <= 1'b0;
    //          o_pcAdd_EX                <= 32'b0;
    //          o_readData1_EX            <= 32'b0;
    //          o_readData2_EX            <= 32'b0;
    //          o_signExtend_EX           <= 32'b0;
    //          o_muxWrReg0_EX            <= 5'b0;
    //          o_muxWrReg1_EX            <= 5'b0;
    //          o_readReg1_EX             <= 5'b0;
            end
          else
            begin
              o_ctrl_memtoReg_EX        <= i_ctrl_memtoReg_ID;
              o_ctrl_regWrite_EX        <= i_ctrl_regWrite_ID;
              o_ctrl_jumpReg_EX         <= i_ctrl_jumpReg_ID;
              o_ctrl_jump_EX            <= i_ctrl_jump_ID;
              o_ctrl_memRead_EX         <= i_ctrl_memRead_ID; 
              o_ctrl_memWrite_EX        <= i_ctrl_memWrite_ID;
              o_ctrl_branch_EX          <= i_ctrl_branch_ID;
              o_ctrl_notEqBranch_EX     <= i_ctrl_notEqBranch_ID;
              o_ctrl_ALUSrc_EX          <= i_ctrl_ALUSrc_ID; 
              o_ctrl_ALUOp0_EX          <= i_ctrl_ALUOp0_ID; 
              o_ctrl_ALUOp1_EX          <= i_ctrl_ALUOp1_ID; 
              o_ctrl_regDst_EX          <= i_ctrl_regDst_ID; 
              o_pcJump_EX               <= i_pcJump_ID;
              o_pcAdd_EX                <= i_pcAdd_ID;        
              o_readData1_EX            <= i_readData1_ID;    
              o_readData2_EX            <= i_readData2_ID;   
              o_signExtend_EX           <= i_signExtend_ID;   
              o_muxWrReg0_EX            <= i_muxWrReg0_ID;    
              o_muxWrReg1_EX            <= i_muxWrReg1_ID;  
              o_readReg1_EX             <= i_readReg1_ID; 
              o_fullInstr_EX            <= i_fullInstr_ID;
            end
        end
      else
        begin
              o_ctrl_memtoReg_EX        <= o_ctrl_memtoReg_EX;
              o_ctrl_regWrite_EX        <= o_ctrl_regWrite_EX;
              o_ctrl_jumpReg_EX         <= o_ctrl_jumpReg_EX;
              o_ctrl_jump_EX            <= o_ctrl_jump_EX;
              o_ctrl_memRead_EX         <= o_ctrl_memRead_EX; 
              o_ctrl_memWrite_EX        <= o_ctrl_memWrite_EX;
              o_ctrl_branch_EX          <= o_ctrl_branch_EX;
              o_ctrl_notEqBranch_EX     <= o_ctrl_notEqBranch_EX;
              o_ctrl_ALUSrc_EX          <= o_ctrl_ALUSrc_EX; 
              o_ctrl_ALUOp0_EX          <= o_ctrl_ALUOp0_EX; 
              o_ctrl_ALUOp1_EX          <= o_ctrl_ALUOp1_EX; 
              o_ctrl_regDst_EX          <= o_ctrl_regDst_EX; 
              o_pcJump_EX               <= o_pcJump_EX;
              o_pcAdd_EX                <= o_pcAdd_EX;        
              o_readData1_EX            <= o_readData1_EX;    
              o_readData2_EX            <= o_readData2_EX;   
              o_signExtend_EX           <= o_signExtend_EX;   
              o_muxWrReg0_EX            <= o_muxWrReg0_EX;    
              o_muxWrReg1_EX            <= o_muxWrReg1_EX;  
              o_readReg1_EX             <= o_readReg1_EX; 
              o_fullInstr_EX            <= o_fullInstr_EX;
        end
    end

endmodule