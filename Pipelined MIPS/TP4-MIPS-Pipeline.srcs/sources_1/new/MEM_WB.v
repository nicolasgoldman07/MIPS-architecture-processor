`timescale 1ns / 1ps

module MEM_WB
#( 
  // Parametros
  parameter	                    N_BUS_IN 	= 32,
  parameter                     N_BUS_MUX   = 5
)
(
  input                         i_global_en, i_clk, i_reset,
  // CONTROL WB:
  input                         i_ctrl_memtoReg_MEM,
  input                         i_ctrl_regWrite_MEM,
  output reg                    o_ctrl_memtoReg_WB,
  output reg                    o_ctrl_regWrite_WB,

  input         [N_BUS_IN-1:0]  i_readDataMem_MEM,
  output reg    [N_BUS_IN-1:0]  o_readDataMem_WB,
    
  input         [N_BUS_IN-1:0]  i_ALUResult_MEM,
  output reg    [N_BUS_IN-1:0]  o_ALUResult_WB,
  
  input         [N_BUS_MUX-1:0] i_muxRegDst_MEM,
  output reg    [N_BUS_MUX-1:0] o_muxRegDst_WB
);
  
  always @(posedge i_clk) 
    begin
      if (i_reset)
        begin
          o_ctrl_memtoReg_WB        <= 1'b0;
          o_ctrl_regWrite_WB        <= 1'b0;
          o_readDataMem_WB          <= 32'b0;          
          o_ALUResult_WB            <= 32'b0;         
          o_muxRegDst_WB            <= 5'b0;          
        end 
      else
        begin
          o_ctrl_memtoReg_WB        <= i_ctrl_memtoReg_MEM;
          o_ctrl_regWrite_WB        <= i_ctrl_regWrite_MEM;
          o_readDataMem_WB          <= i_readDataMem_MEM;            
          o_ALUResult_WB            <= i_ALUResult_MEM;             
          o_muxRegDst_WB            <= i_muxRegDst_MEM;    
        end
    end

endmodule
