`timescale 1ns / 1ps

module EX_MEM
#( 
  // Parametros
  parameter	                    N_BUS_IN 	= 32,
  parameter                     N_BUS_MUX   = 5
)
(
  input                         i_clk, i_reset, i_branchNop,
  // CONTROL WB:
  input                         i_ctrl_memtoReg_EX,
  input                         i_ctrl_regWrite_EX,
  output reg                    o_ctrl_memtoReg_MEM,
  output reg                    o_ctrl_regWrite_MEM,
  // CONTROL M:
  input                         i_ctrl_jumpReg_EX,
  input                         i_ctrl_jump_EX,
  input                         i_ctrl_memRead_EX,
  input       [3:0]             i_ctrl_memWrite_EX,
  input                         i_ctrl_branch_EX,
  input                         i_ctrl_notEqBranch_EX,
  output reg                    o_ctrl_jumpReg_MEM,
  output reg                    o_ctrl_jump_MEM,
  output reg                    o_ctrl_memRead_MEM,
  output reg   [3:0]            o_ctrl_memWrite_MEM,
  output reg                    o_ctrl_branch_MEM,
  output reg                    o_ctrl_notEqBranch_MEM,
  
  input                         i_ctrl_ALUZero_EX,
  output reg                    o_ctrl_ALUZero_MEM,
  
  input         [N_BUS_IN-1:0]  i_pcJump_EX,
  input         [N_BUS_IN-1:0]  i_branchAdd_EX,
  input         [N_BUS_IN-1:0]  i_ALUResult_EX,
  input         [N_BUS_IN-1:0]  i_readData2_EX,
  input         [N_BUS_MUX-1:0] i_muxRegDst_EX,
  output reg    [N_BUS_IN-1:0]  o_pcJump_MEM,
  output reg    [N_BUS_IN-1:0]  o_branchAdd_MEM,
  output reg    [N_BUS_IN-1:0]  o_ALUResult_MEM,
  output reg    [N_BUS_IN-1:0]  o_readData2_MEM,
  output reg    [N_BUS_MUX-1:0] o_muxRegDst_MEM
);
  
  always @(negedge i_clk) 
    begin
      if (i_reset)
        begin
          o_ctrl_memtoReg_MEM       <= 1'b0;
          o_ctrl_regWrite_MEM       <= 1'b0;
          o_ctrl_jumpReg_MEM        <= 1'b0;
          o_ctrl_jump_MEM           <= 1'b0;
          o_ctrl_memRead_MEM        <= 1'b0;          
          o_ctrl_memWrite_MEM       <= 4'd0;         
          o_ctrl_branch_MEM         <= 1'b0;  
          o_ctrl_notEqBranch_MEM    <= 1'b0;        
          o_ctrl_ALUZero_MEM        <= 1'b0;          
          o_pcJump_MEM              <= 32'b0;          
          o_branchAdd_MEM           <= 32'b0;          
          o_ALUResult_MEM           <= 32'b0;          
          o_readData2_MEM           <= 32'b0;
          o_muxRegDst_MEM           <= 5'b0;
        end
      else if (i_branchNop)
        begin
          o_ctrl_memtoReg_MEM       <= 1'b0;
          o_ctrl_regWrite_MEM       <= 1'b0;
          o_ctrl_jumpReg_MEM        <= 1'b0;
          o_ctrl_jump_MEM           <= 1'b0;
          o_ctrl_memRead_MEM        <= 1'b0;          
          o_ctrl_memWrite_MEM       <= 4'd0;         
          o_ctrl_branch_MEM         <= 1'b0; 
          o_ctrl_notEqBranch_MEM    <= 1'b0;         
          o_ctrl_ALUZero_MEM        <= 1'b0;
//          o_branchAdd_MEM           <= 32'b0;          
//          o_ALUResult_MEM           <= 32'b0;          
//          o_readData2_MEM           <= 32'b0;
//          o_muxRegDst_MEM           <= 5'b0;
        end
      else
        begin
          o_ctrl_memtoReg_MEM       <= i_ctrl_memtoReg_EX;
          o_ctrl_regWrite_MEM       <= i_ctrl_regWrite_EX;
          o_ctrl_jumpReg_MEM        <= i_ctrl_jumpReg_EX;
          o_ctrl_jump_MEM           <= i_ctrl_jump_EX;
          o_ctrl_memRead_MEM        <= i_ctrl_memRead_EX;          
          o_ctrl_memWrite_MEM       <= i_ctrl_memWrite_EX;        
          o_ctrl_branch_MEM         <= i_ctrl_branch_EX;  
          o_ctrl_notEqBranch_MEM    <= i_ctrl_notEqBranch_EX;         
          o_ctrl_ALUZero_MEM        <= i_ctrl_ALUZero_EX;    
          o_pcJump_MEM              <= i_pcJump_EX;     
          o_branchAdd_MEM           <= i_branchAdd_EX;          
          o_ALUResult_MEM           <= i_ALUResult_EX;          
          o_readData2_MEM           <= i_readData2_EX;
          o_muxRegDst_MEM           <= i_muxRegDst_EX;
        end
    end

endmodule