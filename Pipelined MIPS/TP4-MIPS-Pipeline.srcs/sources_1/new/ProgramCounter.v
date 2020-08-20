`timescale 1ns / 1ps

module ProgramCounter
#( 
  // Parametros
  parameter	                    N_BUS_IN 	= 32
)
(
  // ENTRADAS:
  input                         i_global_en,
  input       [N_BUS_IN-1:0]    i_pc,
  input                         i_clk, i_reset,
  input                         i_pcWrite,
  input                         i_pcHalt,
  // SALIDAS: 
  output      [N_BUS_IN-1:0]    o_pc
);

  reg         [N_BUS_IN-1:0]    regR;
  
  always @(posedge i_clk) 
    begin
      if (i_reset)
        begin
            regR <= 32'b0;
        end
      else if (!i_pcWrite || !i_global_en || i_pcHalt )
        begin
            regR <= o_pc;   
        end
      else
        begin
          regR <= i_pc;
        end
    end

  assign o_pc = regR;

endmodule

