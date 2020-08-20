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
  input       [31:0]                i_fullInstr,
  output      [N_BUS_OUT-1:0]       o_ALUcontrol
);
    
  reg         [N_BUS_OUT-1:0]       ALUControlOut;
  
  always @(*)
    begin
        case({i_ALUOp1, i_ALUOp0})
            2'b00:  // LW & SW
                begin
                    ALUControlOut <= 4'b0000;           // ADD
                end
            2'b01:  // BRANCH EQ
                begin
                    ALUControlOut <= 4'b0001;            // SUBSTRACT
                end
            2'b10:  // ARIT-LOGIC
                begin
                    case(i_fullInstr[31:26])
                        6'd0:
                        begin
                            case(i_func)
                                6'b100000:
                                    begin
                                        ALUControlOut <= 4'b0000;    // ADD 
                                    end
                                6'b100010:
                                    begin
                                        ALUControlOut <= 4'b0001;    // SUBSTRACT
                                    end
                                6'b100100:
                                    begin
                                        ALUControlOut <= 4'b0010;    // AND 
                                    end
                                6'b100101:
                                    begin
                                        ALUControlOut <= 4'b0011;    // OR
                                    end
                                6'b101010:
                                    begin
                                        ALUControlOut <= 4'b1000;    // SLT 
                                    end
                                6'b000000:
                                    begin
                                        ALUControlOut <= 4'b0101;    // SLL
                                    end
                                6'b000010:
                                    begin
                                        ALUControlOut <= 4'b0110;    // SRL
                                    end
                                6'b000011:
                                    begin
                                        ALUControlOut <= 4'b0111;    // SRA
                                    end
                                6'b000100:
                                    begin
                                        ALUControlOut <= 4'b1011;    // SLLV
                                    end
                                6'b000110:
                                    begin
                                        ALUControlOut <= 4'b1100;    // SRLV
                                    end
                                6'b000111:
                                    begin
                                        ALUControlOut <= 4'b1101;    // SRAV
                                    end  
                                6'b100110:
                                    begin
                                        ALUControlOut <= 4'b0100;    // XOR
                                    end                      
                                6'b100111:
                                    begin
                                        ALUControlOut <= 4'b1010;    // NOR
                                    end
                                
                                6'b101011:
                                    begin
                                        ALUControlOut <= 4'b1001;    // SLTU
                                    end
                                6'b000010:
                                    begin
                                        ALUControlOut <= 4'b0110;    // SRL
                                    end                
                                default: ALUControlOut <= 4'bXXXX;  
                            endcase
                        end
                        6'b001000: // ADDI
                        begin
                            ALUControlOut <= 4'b0000;       // ADD  
                        end
                        6'b001100: // ANDI
                        begin
                            ALUControlOut <= 4'b0010;       // AND     
                        end
                        6'b001101: // ORI
                        begin
                            ALUControlOut <= 4'b0011;       // OR
                        end
                        6'b001110: // XORI
                        begin
                            ALUControlOut <= 4'b0100;       // XOR
                        end
                    endcase                     
                end
            default: ALUControlOut <= 4'bXXXX;  
        endcase
    end
    
    assign o_ALUcontrol = ALUControlOut;
endmodule