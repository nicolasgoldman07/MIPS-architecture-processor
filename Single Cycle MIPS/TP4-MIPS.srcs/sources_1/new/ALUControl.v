`timescale 1ns / 1ps

module ALUControl
#(
  parameter	                    N_BUS_FUNC  = 6,
  parameter	                    N_BUS_OUT   = 4

)
(
  input       [N_BUS_FUNC-1:0]      i_func,
  input                             i_ALUOp0,
  input                             i_ALUOp1,
  output      [N_BUS_OUT-1:0]       o_ALUcontrol
);
    
  reg         [N_BUS_OUT-1:0]       ALUControlOut;
  
  always @(*)
    begin
        case({i_ALUOp1, i_ALUOp0})
            2'b00:  // LW & SW
                begin
                    ALUControlOut <= 4'b0010;           // ADD
                end
            2'b01:  // BRANCH EQ
                begin
                    ALUControlOut <= 4'b0110;            // SUBSTRACT
                end
            2'b10:  // ARIT-LOGIC
                begin
                    case(i_func)
                        6'b100000:
                            begin
                                ALUControlOut <= 4'b0010;    // ADD 
                            end
                        6'b100010:
                            begin
                                ALUControlOut <= 4'b0110;    // SUBSTRACT
                            end
                        6'b100100:
                            begin
                                ALUControlOut <= 4'b0000;    // AND 
                            end
                        6'b100101:
                            begin
                                ALUControlOut <= 4'b0001;    // OR
                            end
                        6'b101010:
                            begin
                                ALUControlOut <= 4'b0111;    // STL 
                            end
                        default: ALUControlOut <= 4'bXXXX;  
                    endcase                           
                end
            default: ALUControlOut <= 4'bXXXX;  
        endcase
    end
    
    assign o_ALUcontrol = ALUControlOut;
endmodule