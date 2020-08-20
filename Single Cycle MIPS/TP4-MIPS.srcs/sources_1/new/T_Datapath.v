`include "ProgramCounter.v"
`include "InstructionMemory.v"
`include "PcAdder.v"
`include "RegisterFile.v"
`include "SignExtend.v"
`include "ShiftLeft2.v"
`include "BranchAdder.v"
`include "ALU.v"
`include "DataMemory.v"
`include "Mux2Inputs.v"

`timescale 1ns / 1ps

module T_Datapath
#(
    parameter                   ALUOp = 4,
    parameter                   N_BUS = 32
)
(    
    input                       i_clk,
    input                       i_reset,
    input                       i_regWrite,
    input                       i_ALUSrc,
    input       [ALUOp-1:0]     i_ALUOp,
    input                       i_PCSrc,
    input                       i_memRead,
    input                       i_memWrite,
    input                       i_memToReg,
    output      [N_BUS-1:0]     o_PCSrc,
    output      [N_BUS-1:0]     o_PC,
    output      [N_BUS-1:0]     o_instrMem,
    output      [N_BUS-1:0]     o_regFile1,
    output      [N_BUS-1:0]     o_regFile2,
    output      [N_BUS-1:0]     o_ALU,
    output      [N_BUS-1:0]     o_muxMemToReg
);
    
    wire        [N_BUS-1:0]     w_in_pc, w_out_pc, w_out_im, w_out_pcAdd, w_out_branchAdd; 
    wire        [N_BUS-1:0]     w_in_rf_wrData, w_out_rf_rData1, w_out_rf_rData2, w_out_signExtend;
    wire        [N_BUS-1:0]     w_out_sl2, w_out_ALUSrc, w_out_ALURes, w_out_ALUZero;
    
    // BLOQUES BASANDONOS EN FILE "Pipeline.pptx" CON LA CONSIGNA DEL TP
    // Instruction Fetch
    ProgramCounter      ProgramCounter1     (w_in_pc, i_clk, i_reset, w_out_pc);
    InstructionMemory   InstructionMemory1  (w_out_pc, w_out_im);
    PcAdder             PcAdder1            (w_out_pc, w_out_pcAdd);
    Mux2Inputs          MuxPcSrc1           (i_PCSrc, w_out_pcAdd, w_out_branchAdd, w_in_pc);
    
    // Instruction Decode
    RegisterFile        RegisterFile1       (i_clk, w_out_im[25:21], w_out_im[20:16], w_out_im[15:11], w_in_rf_wrData, i_regWrite, w_out_rf_rData1, w_out_rf_rData2);
    SignExtend          SignExtend1         (w_out_im[15:0], w_out_signExtend);
    
    // Execute
    ShiftLeft2          ShiftLeft21         (w_out_signExtend, w_out_sl2);
    BranchAdder         BranchAdder1        (w_out_pcAdd, w_out_sl2, w_out_branchAdd);
    Mux2Inputs          MuxALUSrc1          (i_ALUSrc, w_out_rf_rData2, w_out_signExtend, w_out_ALUSrc);
    ALU                 ALU1                (w_out_rf_rData1, w_out_ALUSrc, i_ALUOp, w_out_ALURes, w_out_ALUZero); 
    
    // Memory Acces
    DataMemory          DataMemory1         (i_clk, i_memWrite, i_memRead, w_out_ALURes, w_out_rf_rData2, w_out_dm_rData);
    
    // Write Back
    Mux2Inputs          MuxMemToReg         (i_memToReg, w_out_ALURes, w_out_dm_rData, w_in_rf_wrData);
    
    assign o_PCSrc       =  w_in_pc;
    assign o_PC          =  w_out_pc;
    assign o_instrMem    =  w_out_im;
    assign o_regFile1    =  w_out_rf_rData1;
    assign o_regFile2    =  w_out_rf_rData2;
    assign o_ALU         =  w_out_ALURes;
    assign o_muxMemToReg =  w_in_rf_wrData;      

endmodule
