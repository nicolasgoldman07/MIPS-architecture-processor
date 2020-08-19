`timescale 1ns / 1ps


// CONTROL UNIT + (BRANCH&ZERO) // ALU control is other module
module ControlUnit
#(
  parameter	                    N_BUS_IN   	= 6,
  parameter                     N_BUS_INST  = 32,
  parameter	                    N_BUS_OUT 	= 12,
  parameter	                    N_BUS_OP   	= 2

)
(
  input       [N_BUS_IN-1:0]        i_controlUnit,
  input       [N_BUS_INST-1:0]      i_fullInstr,
  output reg  [N_BUS_INST-1:0]      o_fullInstr,
  output      reg                   o_jumpReg,  
  output      reg                   o_jump,
  output      reg                   o_regDst,
  output      reg                   o_ALUSrc,  
  output      reg                   o_memtoReg,  
  output      reg                   o_regWrite,  
  output      reg                   o_memRead,  
  output      reg                   o_memWrite,  
  output      reg                   o_branch,
  output      reg                   o_notEqBranch,
  output      reg                   o_ALUOp1,
  output      reg                   o_ALUOp0

  
);
    
  reg         [N_BUS_OUT-1:0]       control_signals;
  
  
  always @(*)
    begin
    assign o_fullInstr = i_fullInstr;
        if(i_fullInstr == 32'd0)
        begin
            control_signals <= 12'b000000000000;
        end
       
        else
        begin       
            case(i_controlUnit)
                
                // R-TYPE INSTRUCTIONs 
                6'b000000:
                    begin
                        case(i_fullInstr[N_BUS_IN-1:0])
                            6'b001000: // JR
                            begin
                                control_signals <= 12'b110000000001;
                                
                            end
                            6'b001001: // JALR
                            begin
                                control_signals <= 12'b111001000001;
                            end
                            default:
                            begin
                                control_signals <= 12'b001001000010;
                            end
                         endcase
                    end
                
                // I-TYPE INSTRUCTIONs 
                6'b100000: // LB
                    begin
                        control_signals <= 12'b000111100000;
                    end
                6'b100001: // LH
                    begin
                        control_signals <= 12'b000111100000;
                    end    
                6'b100011: // LW
                    begin
                        control_signals <= 12'b000111100000;
                    end
                6'b100111: // LWU
                    begin
                        control_signals <= 12'b000111100000;
                    end
                6'b100100: // LBU
                    begin
                        control_signals <= 12'b000111100000;
                    end
                6'b100101: // LHU
                    begin
                        control_signals <= 12'b000111100000;
                    end
                6'b101000: // SB
                    begin
                        control_signals <= 12'b000100010000;
                    end
                6'b101001: // SH
                    begin
                        control_signals <= 12'b000100010000;
                    end
                6'b101011: // SW
                    begin
                        control_signals <= 12'b000100010000;
                    end
                6'b001000: // ADDI
                    begin
                        control_signals <= 12'b000101000010;
                    end
                /*6'b: // ADDIU
                    begin
                        control_signals <= 9'b100100010;
                    end*/
                6'b001100: // ANDI
                    begin
                        control_signals <= 12'b000101000010;
                    end
                6'b001101: // ORI
                    begin
                        control_signals <= 12'b000101000010;
                    end
                6'b001110: // XORI
                    begin
                        control_signals <= 12'b000101000010;
                    end
                6'b001111: // LUI
                    begin
                        control_signals <= 12'b000101000000;
                    end
                6'b001010: // SLTI
                    begin
                        control_signals <= 12'b000101000010;
                    end
                /*6'b: // SLTIU
                    begin
                        control_signals <= 9'b100100010;
                    end*/
                6'b000100: // BEQ
                    begin
                        control_signals <= 12'b000000001001;
                    end
                6'b000101: // BNE
                    begin
                        control_signals <= 12'b000000000101;
                    end
                6'b000010: // J
                    begin
                        control_signals <= 12'b010000000001;
                    end
                6'b000011: // JAL
                    begin
                        control_signals <= 12'b011001000001;
                    end
                 6'b111111: // NOP
                    begin
                        control_signals <= 12'b000000000000;
                    end   
                 6'b101010: // HALT
                    begin
                        control_signals <= 12'b000000000000;
                    end
    
                                
                default: control_signals <= 12'b000000000000;
            endcase
        end
    {o_jumpReg, o_jump, o_regDst, o_ALUSrc, o_memtoReg, o_regWrite, o_memRead, o_memWrite, o_branch, o_notEqBranch, o_ALUOp1, o_ALUOp0} = control_signals;
    
    end
    
    

endmodule
