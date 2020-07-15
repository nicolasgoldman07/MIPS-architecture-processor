`timescale 1ns / 1ps

module RegisterFile_tb();
  reg	                  i_clk;
  reg         [4:0]       i_readReg1;
  reg         [4:0]       i_readReg2;
  reg         [4:0]       i_writeReg;
  reg         [31:0]      i_writeData;
  reg                     i_writeEnable;
  wire        [31:0]      o_readData1;
  wire        [31:0]      o_readData2;

    RegisterFile RegisterFile_tb(.i_clk(i_clk), .i_readReg1(i_readReg1),
        .i_readReg2(i_readReg2), .i_writeReg(i_writeReg), .i_writeData(i_writeData),
        .i_writeEnable(i_writeEnable), .o_readData1(o_readData1),
        .o_readData2(o_readData2));

    initial
        begin

		#0    i_clk = 1'b0; i_writeEnable = 1'b0; 
		      i_readReg1 = 5'd1; 
              i_readReg2 = 5'd2;
         
        // Apuntamos a addr 0, para verificar que lo tenemos en 0
        #5  i_readReg1 = 5'd0; 
            i_readReg2 = 5'd0;

        #5  i_readReg1 = 5'd1; 
            i_readReg2 = 5'd2;
                        
        // Apuntamos a addr random, para verificar lo que tenemos        
        #5  i_readReg1 = 5'd15; 
            i_readReg2 = 5'd25;
          
        // Escribimos un 7 en el registro 15        
		#10   i_writeEnable = 1'b1;
		      i_writeData = 32'd7;
		      i_writeReg = 5'd15;
		
		#1    i_writeEnable = 1'b0;
		
		#5  i_readReg1 = 5'd15; 
            i_readReg2 = 5'd25;
            
        #5  i_readReg1 = 5'd25; 
            i_readReg2 = 5'd15;
        end
    
    always  
    begin
        #1  i_clk = ~i_clk;
    end
  
    initial
        #100 $finish;
        
endmodule