`timescale 1ns / 1ps

module ALU
#(
  parameter	                    N_BUS_DATA   	    = 32,
  parameter                     N_BUS_OP            = 4
)
(
  input signed  [N_BUS_DATA-1:0]        i_alu1,
  input signed  [N_BUS_DATA-1:0]        i_alu2,
  input         [N_BUS_OP-1:0]          i_aluOP,   
  output        [N_BUS_DATA-1:0]        o_aluResult,
  output                                o_zero
);

  reg           [N_BUS_DATA-1:0]      aluResult;      
    
  always @(*) begin
		case (i_aluOP)
			4'd2:  aluResult 		<= 		i_alu1 + i_alu2;				/* SUMA */
			4'd0:  aluResult 		<= 		i_alu1 & i_alu2;				/* AND */
			4'd12: aluResult 		<= 		~(i_alu1 | i_alu2);				/* NOR */
			4'd1:  aluResult 		<= 		i_alu1 | i_alu2;				/* OR */
			4'd7:  aluResult 		<= 		i_alu1 < i_alu2 ? 1 : 0;	    /* SLT */
			4'd6:  aluResult 		<= 		i_alu1 - i_alu2;			    /* RESTA */
			default: aluResult 	    <= 		0;
		endcase
	end
	
	assign o_zero = (aluResult == 0);
	assign o_aluResult = aluResult;
	
endmodule