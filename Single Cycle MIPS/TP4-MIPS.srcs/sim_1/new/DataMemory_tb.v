`timescale 1ns / 1ps

module DataMemory_tb();
  reg	                    i_clk;
  reg                       i_writeEnable;
  reg                       i_readEnable;
  reg         [31:0]        i_address;
  reg         [31:0]        i_writeData;
  wire        [31:0]        o_readData;
  
    DataMemory DataMemory_tb(.i_clk(i_clk), .i_writeEnable(i_writeEnable),
        .i_readEnable(i_readEnable), .i_address(i_address), .i_writeData(i_writeData),
        .o_readData(o_readData));

    initial
        begin

		#0  i_clk = 1'b0; i_writeEnable = 1'b0; i_readEnable = 1'b1;
         
        // Apuntamos a addr 0, para verificar que lo tenemos en 0
        #5  i_address = 32'd0; 

        // Apuntamos a addr random, para verificar lo que tenemos        
        #5  i_address = 32'd15; 
          
        // Escribimos un 7 en el registro 15        
		#10   i_writeEnable = 1'b1;
		      i_readEnable = 1'b0;
		      i_writeData = 32'd7;
		      i_address = 32'd15;
		
		#3    i_writeEnable = 1'b0;
		      i_readEnable = 1'b1;
		      
		#5    i_address = 32'd15; 
		
		// Escribimos un 50 en el registro 100        
		#10   i_address = 32'd100;
		      i_readEnable = 1'b0;
		      i_writeEnable = 1'b1;
		      i_writeData = 32'd50;
		
		#3    i_writeEnable = 1'b0;
		      i_readEnable = 1'b1;
		
		#5    i_address = 32'd15; 
		#5    i_address = 32'd100;
            
        
        end
    
    always  
    begin
        #1  i_clk = ~i_clk;
    end
  
    initial
        #100 $finish;
        
endmodule