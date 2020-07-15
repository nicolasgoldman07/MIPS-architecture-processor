`timescale 1ns / 1ps

module ForwardingUnit
#(
  parameter	                    N_BUS   	= 5,
  parameter                     N_BUS_MUX   = 2
)
(
  input       [N_BUS-1:0]       i_idEx_rsReg, 
  input       [N_BUS-1:0]       i_idEx_rtReg, 
  input       [N_BUS-1:0]       i_exMem_rdReg, 
  input       [N_BUS-1:0]       i_memWb_rdReg, 
  input                         i_exMem_regWrite, 
  input                         i_memWb_regWrite, 

  output reg  [N_BUS_MUX-1:0]   o_forwardA,
  output reg  [N_BUS_MUX-1:0]   o_forwardB
);

  
  always @(*)       
    begin
        if (i_exMem_regWrite && (i_exMem_rdReg != 5'b0) && (i_exMem_rdReg == i_idEx_rsReg))
            begin
                o_forwardA = 2'b10;
            end
        else if (i_memWb_regWrite && 
                    (i_memWb_rdReg != 5'b0) && 
                    //~(i_exMem_regWrite && (i_exMem_rdReg != 5'b0) &&
                    //(i_exMem_rdReg != i_idEx_rsReg)) &&
                    (i_memWb_rdReg == i_idEx_rsReg))
            begin
                o_forwardA = 2'b01;
            end
        else
            begin
                o_forwardA = 2'b00;
            end
            
         
        if (i_exMem_regWrite && (i_exMem_rdReg != 5'b0) && (i_exMem_rdReg == i_idEx_rtReg))
            begin
                o_forwardB = 2'b10;
            end
        else if (i_memWb_regWrite && 
                    (i_memWb_rdReg != 5'b0) && 
                    //~(i_exMem_regWrite && (i_exMem_rdReg != 5'b0) &&
                    //(i_exMem_rdReg != i_idEx_rtReg)) &&
                    (i_memWb_rdReg == i_idEx_rtReg))
            begin
                o_forwardB = 2'b01;
            end
        else
            begin
                o_forwardB = 2'b00;
            end
    end
    
endmodule
