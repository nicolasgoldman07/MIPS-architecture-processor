`timescale 1ns / 1ps

module ALU_tb();
    reg         [31:0]      i_alu1;
    reg         [31:0]      i_alu2;
    reg         [5:0]       i_aluOP;   
    wire        [31:0]      o_aluResult;
    wire                    o_zero;
    
    ALU ALU_tb(.i_alu1(i_alu1), .i_alu2(i_alu2), .i_aluOP(i_aluOP), 
    .o_aluResult(o_aluResult), .o_zero(o_zero));
  
    initial
        begin

        // SUMA
        #25 i_alu1 = 32'd2; 
            i_alu2 = 32'd5; 
            i_aluOP = 4'd2;

        // AND
        #25 i_alu1 = 32'd7; 
            i_alu2 = 32'd1; 
            i_aluOP = 4'd0;

        // NOR
        #25 i_alu1 = 32'd0; 
            i_alu2 = 32'd4; 
            i_aluOP = 4'd12;
        
        // OR
        #25 i_alu1 = 32'd7; 
            i_alu2 = 32'd3; 
            i_aluOP = 4'd1;

        // SLT
        #25 i_alu1 = 32'd10; 
            i_alu2 = 32'd9; 
            i_aluOP = 4'd7;
        
        // RESTA
        #25 i_alu1 = 32'd10; 
            i_alu2 = 32'd4; 
            i_aluOP = 4'd6;
        //los resultados negativos los tira en complemento a 2
        end

    initial
        #300 $finish; //Duracion de la Simulacion
endmodule