`include "ProgramCounter.v"
`include "InstructionMemory.v"
`include "PcAdder.v"
`include "ControlUnit.v"
`include "RegisterFile.v"
`include "SignExtend.v"
`include "ShiftLeft2.v"
`include "BranchAdder.v"
`include "ALUControl.v"
`include "ALU.v"
`include "DataMemory.v"
`include "Mux2Inputs.v"
`include "Mux2Inputs5bit.v"

`timescale 1ns / 1ps

module T_DatapathControl
#(
    parameter                   N_ALU_OP        = 4,
    parameter                   N_IN_REGFILE    = 5,
    parameter                   N_BUS           = 32,
    parameter                   N_SLJUMP        = 28
)
(    
    input                           i_clk,
    input                           i_reset,
    output      [31:0]              o_PCSrc,
    output      [31:0]              o_PC,    
    output      [31:0]              o_instrMem,    
    output      [31:0]              o_regFile1,    
    output      [31:0]              o_regFile2,    
    output      [31:0]              o_ALU,    
    output      [31:0]              o_MuxMemtoReg
);
    
    wire        [N_BUS-1:0]         w_in_pc, w_out_pc, w_out_im, w_out_pcAdd, w_out_branchAdd, w_out_muxPcSrc; 
    wire        [N_BUS-1:0]         w_in_rf_wrData, w_out_rf_rData1, w_out_rf_rData2, w_out_signExtend;
    wire        [N_BUS-1:0]         w_out_sl2, w_out_ALUSrc, w_out_ALURes, w_out_ALUZero, w_out_dm_rData;
    wire        [N_IN_REGFILE-1:0]  w_out_muxRegDst;
    wire        [N_ALU_OP-1:0]      w_out_ALUControl;
    wire                            w_control_pcSrc, w_control_regDst, w_control_regWrite, w_control_ALUSrc, w_control_memWrite, w_control_memRead, w_control_jump;
    wire        [N_SLJUMP-1:0]      w_out_sl2Jump;
    
    // BLOQUES BASANDONOS EN FILE "Pipeline.pptx" CON LA CONSIGNA DEL TP
    // Instruction Fetch
    ProgramCounter      ProgramCounter1     (w_in_pc, i_clk, i_reset, w_out_pc);
    InstructionMemory   InstructionMemory1  (w_out_pc, w_out_im);
    PcAdder             PcAdder1            (w_out_pc, w_out_pcAdd);
    Mux2Inputs          MuxPcSrc1           (w_control_pcSrc, w_out_pcAdd, w_out_branchAdd, w_out_muxPcSrc);
    
    // Instruction Decode
    Mux2Inputs5bit      MuxRegDst1          (w_control_regDst, w_out_im[20:16], w_out_im[15:11], w_out_muxRegDst);
    RegisterFile        RegisterFile1       (i_clk, w_out_im[25:21], w_out_im[20:16], w_out_muxRegDst, w_in_rf_wrData, w_control_regWrite, w_out_rf_rData1, w_out_rf_rData2);
    SignExtend          SignExtend1         (w_out_im[15:0], w_out_signExtend);
    
    // Execute
    ShiftLeft2          ShiftLeft21         (w_out_signExtend, w_out_sl2);
    BranchAdder         BranchAdder1        (w_out_pcAdd, w_out_sl2, w_out_branchAdd);
    Mux2Inputs          MuxALUSrc1          (w_control_ALUSrc, w_out_rf_rData2, w_out_signExtend, w_out_ALUSrc);
    ALU                 ALU1                (w_out_rf_rData1, w_out_ALUSrc, w_out_ALUControl, w_out_ALURes, w_out_ALUZero); 
    
    // Memory Acces
    DataMemory          DataMemory1         (i_clk, w_control_memWrite, w_control_memRead, w_out_ALURes, w_out_rf_rData2, w_out_dm_rData);
    
    // Write Back
    Mux2Inputs          MuxMemToReg         (w_control_memtoReg, w_out_ALURes, w_out_dm_rData, w_in_rf_wrData);
    
    // Control Unit
    ControlUnit         ControlUnit1        (w_out_im[31:26], w_out_ALUZero, w_control_regDst, w_control_ALUSrc, w_control_memtoReg, 
                                                w_control_regWrite, w_control_memRead, w_control_memWrite, 
                                                w_control_ALUOp1, w_control_ALUOp0,w_control_jump, w_control_pcSrc);
    ALUControl          ALUControl1         (w_out_im[5:0], w_control_ALUOp0, w_control_ALUOp1, w_out_ALUControl);
       
    // Jump
    ShiftLeft2Jump      ShiftLeft2Jump1     (w_out_im[25:0], {w_out_pcAdd[31:28], w_out_sl2Jump});
    Mux2Inputs          MuxJump             (w_control_jump, w_out_muxPcSrc, {w_out_pcAdd[31:28], w_out_sl2Jump}, w_in_pc);

    assign o_PCSrc      =   w_in_pc;        
    assign o_PC         =   w_out_pc;
    assign o_instrMem   =   w_out_im;  
    assign o_regFile1   =   w_out_rf_rData1;  
    assign o_regFile2   =   w_out_rf_rData2;
    assign o_ALU        =   w_out_ALURes;       
    assign o_MuxMemtoReg=   w_in_rf_wrData;
    
endmodule
