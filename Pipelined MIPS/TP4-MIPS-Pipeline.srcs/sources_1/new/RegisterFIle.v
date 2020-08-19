`timescale 1ns / 1ps

module RegisterFile
#(
  parameter	                    N_BUS_DATA   	= 32,
  parameter                     N_BUS_REG       = 5
)
(
  input                               i_clk,
  input         [N_BUS_REG-1:0]       i_readReg1, 
  input         [N_BUS_REG-1:0]       i_readReg2,
  input         [N_BUS_REG-1:0]       i_writeReg,
  input         [N_BUS_DATA-1:0]      i_writeData,
  input                               i_writeEnable,
  output        [N_BUS_DATA-1:0]      o_readData1,
  output        [N_BUS_DATA-1:0]      o_readData2
);

  reg   	    [N_BUS_DATA-1:0]      dataRegisters [0: N_BUS_DATA-1];
  reg           [N_BUS_DATA-1:0]      readData1, readData2; 
  
  // Inicializo registros
  generate
    integer i;
        initial   
            for (i = 0; i < 32; i = i + 1)
               dataRegisters[i] = 32'd0;
  endgenerate 
  
  always @(*)       
    begin
        if (i_readReg1 == 5'd0)
            readData1 = 32'd0;
        /* Logica para leer datos que se estan por escribir*/
        else if ((i_readReg1 == i_writeReg) && i_writeEnable)
            readData1 = i_writeData;        
        
        else
            readData1 = dataRegisters[i_readReg1][N_BUS_DATA-1:0];
    end
    
    always @(*)       
    begin
        if (i_readReg2 == 5'd0)
            readData2 = 32'd0;
        /* Logica para leer datos que se estan por escribir*/
        else if ((i_readReg2 == i_writeReg) && i_writeEnable)
            readData2 = i_writeData;        
        
        else
            readData2 = dataRegisters[i_readReg2][N_BUS_DATA-1:0];
    end
    
    assign o_readData1 = readData1;
    assign o_readData2 = readData2;
    
    always @(negedge i_clk)
    begin
		if (i_writeEnable && i_writeReg != 5'd0) 
		begin
			dataRegisters [i_writeReg] <= i_writeData;
		end
	end

endmodule