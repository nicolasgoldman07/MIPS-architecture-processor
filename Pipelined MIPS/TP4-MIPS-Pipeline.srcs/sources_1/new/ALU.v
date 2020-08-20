`timescale 1ns / 1ps

module ALU
#(
  parameter	                    N_BUS_DATA   	    = 32,
  parameter                     N_BUS_OP            = 4,
  parameter                     N_SHAMT             = 5
)
(
  input         [N_BUS_DATA-1:0]        i_alu1,
  input         [N_BUS_DATA-1:0]        i_alu2,
  input         [N_BUS_OP-1:0]          i_aluOP,  
  input         [N_SHAMT-1:0]           i_shamt, 
  output        [N_BUS_DATA-1:0]        o_aluResult,
  output                                o_zero
);

  reg           [N_BUS_DATA-1:0]        aluResult;      
  reg signed    [N_BUS_DATA-1:0]        alu1;
  reg signed    [N_BUS_DATA-1:0]        alu2;
    
  always @(*) 
  begin
    alu1 = i_alu1;
    alu2 = i_alu2;
  end
    
  always @(*) begin
		case (i_aluOP)
            4'b0000:  aluResult           <=          i_alu1   +     i_alu2;		       /* ADDU  */
            4'b0001:  aluResult 		  <=          i_alu1   -     i_alu2;			   /* SUBU  */
            4'b0010:  aluResult 		  <=          i_alu1   &     i_alu2;		       /* AND   */
            4'b0011:  aluResult 		  <=          i_alu1   |     i_alu2;		       /* OR    */
            4'b0100:  aluResult 		  <=          i_alu1   ^     i_alu2;		       /* XOR   */ 
            4'b0101:  aluResult 		  <=          i_alu1   <<    i_shamt;		       /* SLL   */ 
            4'b0110:  aluResult 		  <=          i_alu1   >>    i_shamt;		       /* SRL   */ 
            4'b0111:  aluResult 		  <= $signed (alu1   >>>     i_shamt);		       /* SRA   */ 
            4'b1000:  aluResult 		  <=          alu1     <     alu2 ? 1 : 0;	       /* SLT   */
            4'b1001:  aluResult 		  <=          i_alu1   <     i_alu2 ? 1 : 0;	   /* SLTU  */		
            4'b1010:  aluResult 		  <=          ~(i_alu1 |     i_alu2);		       /* NOR   */
            4'b1011:  aluResult           <=          i_alu1   <<    i_alu2;               /* SLLV  */ 
            4'b1100:  aluResult           <=          i_alu1   >>    i_alu2;               /* SRLV  */ 
            4'b1101:  aluResult           <= $signed  (alu1     >>>  i_alu2);              /* SRAV  */ 
		
			default: aluResult 	    <= 		0;
		endcase
	end
	
	assign o_zero = (aluResult == 0);
	assign o_aluResult = aluResult;
	
endmodule