`timescale 1ns / 1ps

module MEM_WB
#( 
  // Parametros
  parameter	                    N_BUS_IN 	= 32,
  parameter                     N_BUS_MUX   = 5
)
(
  input                         i_global_en, i_clk, i_reset,
  output                        o_memWb_working,
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
  
  reg                           working;
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

    always@ (*)
    begin
        working <=      (i_ctrl_memtoReg_MEM | 
                        i_ctrl_regWrite_MEM |
                        o_ctrl_memtoReg_WB | 
                        o_ctrl_regWrite_WB );
    end
    
    
    assign o_memWb_working = working;  
  /*always@ (*)
    begin
        wb_working <=   (|o_readDataMem_WB) | 
                        (|o_ALUResult_WB)  |
                        (|o_muxRegDst_WB);
    end*/
    
    
endmodule
