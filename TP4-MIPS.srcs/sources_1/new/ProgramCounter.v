`timescale 1ns / 1ps

module ProgramCounter
#( 
  // Parametros
  parameter	                    N_BUS_IN 	= 32
)
(
  // ENTRADAS:
  input       [N_BUS_IN-1:0]    i_pc,
  input                         i_clk, i_reset,
  // SALIDAS: 
  output      [N_BUS_IN-1:0]    o_pc
);

  reg         [N_BUS_IN-1:0]    regR;
  
  always @(negedge i_clk) 
    begin
      if (i_reset)
        begin
          regR <= 32'b0;
        end
      else
        begin
          regR <= i_pc;
        end
    end

  assign o_pc = regR;

endmodule