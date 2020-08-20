`timescale 1ns / 1ps

module DataMemory
#(
  parameter	                    N_BUS   	    = 32,
  parameter                     MEMORY_SIZE     = 128 

)
(
  input                                 i_clk,
  input                                 i_writeEnable,
  input                                 i_readEnable,
  input         [N_BUS-1:0]             i_address, 
  input         [N_BUS-1:0]             i_writeData,
  output        [N_BUS-1:0]             o_readData
);

  // MEMORIA DE 32 BIT CON 128 DIRECCIONES (VER)   
  reg   	    [N_BUS-1:0]             dataMemory [0: MEMORY_SIZE];
  reg           [N_BUS-1:0]             readData;
  
//  initial
//    begin
//        readData      = 32'd8;
//        dataMemory[1] = 32'd8;
//        dataMemory[2] = 32'd8;
//   end
  
  always @(negedge i_clk)       
    begin
        if(i_writeEnable)
        begin
           dataMemory[i_address] <= i_writeData;
        end
	end
  
  always @(*)       
    begin
        if(i_readEnable)
        begin
           readData = dataMemory[i_address][N_BUS-1:0];
        end
	end	
    assign o_readData = readData;
    //assign o_readData = dataMemory[i_address][N_BUS-1:0];

endmodule
