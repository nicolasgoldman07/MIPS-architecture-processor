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
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "Mux3Inputs.v"
`include "ForwardingUnit.v"
`include "HazardDetectionUnit.v"

`timescale 1ns / 1ps

module T_DatapathControl
#(
    parameter                   N_ALU_OP        = 4,
    parameter                   N_IN_REGFILE    = 5,
    parameter                   N_BUS           = 32,
    parameter                   N_SLJUMP        = 28,
    parameter                   N_MUX_FU        = 2,
    parameter                   N_MUX_CTRL      = 12
)
(   
    input                           i_stepEnableBtn,
    input                           i_global_en, 
    input                           i_clk,
    input                           i_reset,
    
    input       [31:0]              i_inst_instMem,
    input       [3:0]               i_wEn_instMem,
    input       [31:0]              i_addr_instMem,
    
    output                          o_halt
);

    wire        [N_BUS-1:0]         w_in_pc, w_out_pc, w_out_im, w_out_pcAdd, w_out_exMem_branchAdd, w_out_exMem_jump, w_out_mux_pc, w_source_pc;
    wire                            w_control_pcSrc, w_out_hd_pcWrite;
    
    wire        [N_BUS-1:0]         w_out_ifId_im, w_out_ifId_pcAdd;
    wire                            w_out_hd_ifIdWrite;
    
    wire                            w_out_hd_muxStall;
    
    wire        [N_BUS-1:0]         w_out_muxMemtoReg, w_out_rf_rData1, w_out_rf_rData2, w_out_signExtend;
    wire        [N_IN_REGFILE-1:0]  w_out_memWb_muxRegDst;
    wire                            w_out_memWb_regWrite;

    wire        [N_BUS-1:0]         w_out_fullInst_ctrl, w_out_fullInst_EX;
    wire                            w_control_jump, w_control_jumpReg, w_control_regDst, w_control_ALUSrc, w_control_memtoReg, w_control_regWrite, w_control_memRead, 
                                        w_control_memWrite, w_control_branch, w_control_notEqBranch, w_control_ALUOp1, w_control_ALUOp0;
           
    wire        [N_MUX_CTRL-1:0]    w_out_controlMux;
                                        
    wire        [N_BUS-1:0]         w_out_idEx_jump, w_out_idEx_pcAdd, w_out_idEx_rData1, w_out_idEx_rData2, w_out_idEx_signExtend;
    wire        [N_IN_REGFILE-1:0]  w_out_idEx_muxWrReg0, w_out_idEx_muxWrReg1, w_out_idEx_rReg1;
    wire                            w_out_idEx_memtoReg, w_out_idEx_regWrite, w_out_idEx_ctrl_jumpReg, w_out_idEx_ctrl_jump, w_out_idEx_memRead, w_out_idEx_branch, w_out_idEx_notEqBranch,
                                        w_out_idEx_ALUSrc, w_out_idEx_ALUOp0, w_out_idEx_ALUOp1, w_out_idEx_regDst;
    
    wire        [N_BUS-1:0]         w_out_mux3_1, w_out_mux3_2;
    wire        [N_MUX_FU-1:0]      w_out_fu1, w_out_fu2;
                                        
    wire        [N_BUS-1:0]         w_out_sl2, w_out_branchAdd, w_out_muxALUSrc, w_out_ALURes;
    wire        [N_IN_REGFILE-1:0]  w_out_muxRegDst;
    wire        [N_ALU_OP-1:0]      w_out_ALUControl;
    wire                            w_out_ALUZero;
    
    wire        [N_BUS-1:0]         w_out_exMem_ALURes, w_out_exMem_rData2, w_out_sl2_ALURes, w_out_jumpMux;
    wire        [N_IN_REGFILE-1:0]  w_out_exMem_muxRegDst;
    wire                            w_out_exMem_memtoReg, w_out_exMem_regWrite, w_out_exMem_ctrl_jumpReg, w_out_exMem_ctrl_jump, w_out_exMem_memRead, w_out_exMem_branch, w_out_exMem_notEqBranch, w_out_exMem_ALUZero;
    wire        [3:0]               w_out_idEx_memWrite, w_out_exMem_memWrite;
    
    wire        [N_BUS-1:0]         w_out_dm_rData;
    
    wire        [N_BUS-1:0]         w_out_memWb_rData, w_out_memWb_ALURes;
    wire                            w_out_memWb_memtoReg;
    
    wire        [N_SLJUMP-1:0]      w_out_sl2Jump;
    
    reg                             halt_detected, pc_halt, executingBranch;
    wire                            w_halt, w_idEx_working, w_exMem_working, w_memWb_working;
    
    // BLOQUES BASANDONOS EN FILE "Pipeline.pptx" CON LA CONSIGNA DEL TP
    // Instruction Fetch
    ProgramCounter      ProgramCounter1            (i_global_en, w_in_pc, i_clk, i_reset, w_out_hd_pcWrite, pc_halt, w_out_pc);
    
    //InstructionMemory   InstructionMemory1         (w_out_pc, w_out_im);
    PcAdder             PcAdder1                   (w_out_pc, w_out_pcAdd);
    Mux2Inputs          MuxPcSrc1                  (w_control_pcSrc, w_out_pcAdd, w_out_exMem_branchAdd, w_out_mux_pc);
   
    // Mid-Reg IF/I
    IF_ID               IF_ID1                     (i_global_en, i_clk, i_reset, w_control_pcSrc, w_out_im, w_out_pcAdd, w_out_hd_ifIdWrite, w_out_ifId_im, w_out_ifId_pcAdd);
   
    // HAZARD DETECTION UNI
    HazardDetectionUnit HazardDetectionUnit1       (w_out_ifId_im[25:21], w_out_ifId_im[20:16], w_out_idEx_muxWrReg0, w_out_idEx_memRead, w_control_pcSrc, w_out_hd_pcWrite, w_out_hd_ifIdWrite, w_out_hd_muxStall); 
   
    // Instruction Decod
    RegisterFile        RegisterFile1              (i_clk, w_out_ifId_im[25:21], w_out_ifId_im[20:16], w_out_memWb_muxRegDst, w_out_muxMemtoReg, w_out_memWb_regWrite, w_out_rf_rData1, w_out_rf_rData2);
    SignExtend          SignExtend1                (w_out_ifId_im[15:0], w_out_signExtend);
    // Control Uni
    ControlUnit         ControlUnit1               (w_out_ifId_im[31:26], w_out_ifId_im,  w_out_fullInst_ctrl, w_control_jumpReg, w_control_jump, w_control_regDst, w_control_ALUSrc, w_control_memtoReg, 
                                                       w_control_regWrite, w_control_memRead, w_control_memWrite, 
                                                       w_control_branch, w_control_notEqBranch,
                                                       w_control_ALUOp1, w_control_ALUOp0);
   
    Mux2Inputs9bit      Mux2Inputs9bit1            (w_out_hd_muxStall, 12'd0, {w_control_jumpReg, w_control_jump, w_control_regDst, w_control_ALUSrc, w_control_memtoReg, 
                                                       w_control_regWrite, w_control_memRead, w_control_memWrite, w_control_branch, w_control_notEqBranch,
                                                       w_control_ALUOp1, w_control_ALUOp0}, w_out_controlMux);
    // Mid-Reg ID/E
    ID_EX               ID_EX1                     (i_global_en, i_clk, i_reset, w_control_pcSrc, w_idEx_working,
                                                       w_out_controlMux[7], w_out_controlMux[6], w_out_idEx_memtoReg, w_out_idEx_regWrite,
                                                       w_out_controlMux[11], w_out_controlMux[10], w_out_controlMux[5], {4{w_out_controlMux[4]}}, w_out_controlMux[3], w_out_controlMux[2], w_out_idEx_ctrl_jumpReg, w_out_idEx_ctrl_jump, w_out_idEx_memRead, w_out_idEx_memWrite, w_out_idEx_branch, w_out_idEx_notEqBranch,
                                                       w_out_controlMux[8], w_out_controlMux[0], w_out_controlMux[1], w_out_controlMux[9], w_out_idEx_ALUSrc, w_out_idEx_ALUOp0, w_out_idEx_ALUOp1, w_out_idEx_regDst,
                                                       {w_out_ifId_pcAdd[31:28], w_out_sl2Jump}, w_out_ifId_pcAdd, w_out_rf_rData1, w_out_rf_rData2, w_out_signExtend, w_out_ifId_im[20:16], w_out_ifId_im[15:11],
                                                       w_out_idEx_jump, w_out_idEx_pcAdd, w_out_idEx_rData1, w_out_idEx_rData2, w_out_idEx_signExtend, w_out_idEx_muxWrReg0, w_out_idEx_muxWrReg1,
                                                       w_out_ifId_im[25:21], w_out_idEx_rReg1,
                                                       w_out_fullInst_ctrl, w_out_fullInst_EX);
    // 3 Inputs Mu
    Mux3Inputs          Mux3Inputs1                (w_out_fu1, w_out_idEx_rData1, w_out_muxMemtoReg, w_out_exMem_ALURes, w_out_mux3_1);          
    Mux3Inputs          Mux3Inputs2                (w_out_fu2, w_out_idEx_rData2, w_out_muxMemtoReg, w_out_exMem_ALURes, w_out_mux3_2);          

   
    // Execut
    ShiftLeft2          ShiftLeft21                (w_out_idEx_signExtend, w_out_sl2);
    BranchAdder         BranchAdder1               (w_out_idEx_pcAdd, w_out_sl2, w_out_branchAdd);
    Mux2Inputs          MuxALUSrc1                 (w_out_idEx_ALUSrc, w_out_mux3_2, w_out_idEx_signExtend, w_out_muxALUSrc);
    ALU                 ALU1                       (w_out_mux3_1, w_out_muxALUSrc, w_out_ALUControl, w_out_idEx_signExtend[10:6], w_out_ALURes, w_out_ALUZero); 
   
    ALUControl          ALUControl1                (w_out_idEx_signExtend[5:0], w_out_idEx_ALUOp0, w_out_idEx_ALUOp1, w_out_fullInst_EX, w_out_ALUControl);
    Mux2Inputs5bit      MuxRegDst1                 (w_out_idEx_regDst, w_out_idEx_muxWrReg0, w_out_idEx_muxWrReg1, w_out_muxRegDst);
   
    ForwardingUnit      ForwardingUnit1            (w_out_idEx_rReg1, w_out_idEx_muxWrReg0, w_out_exMem_muxRegDst, w_out_memWb_muxRegDst, w_out_exMem_regWrite, w_out_memWb_regWrite, w_out_fu1, w_out_fu2);
   
    // Mid-Reg EX/ME
    EX_MEM              EX_MEM1                    (i_global_en, i_clk, i_reset, w_control_pcSrc, w_exMem_working,
                                                       w_out_idEx_memtoReg, w_out_idEx_regWrite, w_out_exMem_memtoReg, w_out_exMem_regWrite,
                                                       w_out_idEx_ctrl_jumpReg, w_out_idEx_ctrl_jump, w_out_idEx_memRead, w_out_idEx_memWrite, w_out_idEx_branch, w_out_idEx_notEqBranch, w_out_exMem_ctrl_jumpReg, w_out_exMem_ctrl_jump, w_out_exMem_memRead, w_out_exMem_memWrite, w_out_exMem_branch, w_out_exMem_notEqBranch,
                                                       w_out_ALUZero, w_out_exMem_ALUZero, w_out_idEx_jump, w_out_branchAdd, w_out_ALURes, w_out_mux3_2, w_out_muxRegDst, w_out_exMem_jump, w_out_exMem_branchAdd, w_out_exMem_ALURes, w_out_exMem_rData2, w_out_exMem_muxRegDst);
   
    // Memory Acce
    //DataMemory          DataMemory1                (i_clk, w_out_exMem_memWrite, w_out_exMem_memRead, w_out_exMem_ALURes, w_out_exMem_rData2, w_out_dm_rData);
   
    // Mid-Reg MEM/W
    MEM_WB              MEM_WB1                    (i_global_en, i_clk, i_reset, w_memWb_working,
                                                       w_out_exMem_memtoReg, w_out_exMem_regWrite, w_out_memWb_memtoReg, w_out_memWb_regWrite, 
                                                       w_out_dm_rData, w_out_memWb_rData,
                                                       w_out_exMem_ALURes, w_out_memWb_ALURes,
                                                       w_out_exMem_muxRegDst, w_out_memWb_muxRegDst);
   
    // Write Bac
    Mux2Inputs          MuxMemToReg                (w_out_memWb_memtoReg, w_out_memWb_ALURes, w_out_memWb_rData, w_out_muxMemtoReg);
   
   
    
    // Jump
    ShiftLeft2Jump      ShiftLeft2Jump1            (w_out_ifId_im[25:0], w_out_sl2Jump);
    Mux2Inputs          MuxJump                    (w_out_exMem_ctrl_jump, w_out_mux_pc, w_out_jumpMux, w_in_pc);
    
    // Memories
    blk_mem_gen_0       InstMemory1                 (.clka(~i_clk), .wea(i_wEn_instMem), .addra(w_source_pc), .dina(i_inst_instMem), .douta(w_out_im) );

    //DataMemory          DataMemory1                (i_clk, w_out_exMem_memWrite, w_out_exMem_memRead, w_out_exMem_ALURes, w_out_exMem_rData2, w_out_dm_rData);    
    blk_mem_gen_1       DataMemory1                 (.clka(~i_clk), .wea(w_out_exMem_memWrite), .addra(w_out_exMem_ALURes << 2), .dina(w_out_exMem_rData2), .douta(w_out_dm_rData) );
    
    // Jump Register
    ShiftLeft2          ShiftLeft2JumpReg           (w_out_exMem_ALURes, w_out_sl2_ALURes);
    Mux2Inputs          MuxJumpReg                  (w_out_exMem_ctrl_jumpReg, w_out_exMem_jump, w_out_sl2_ALURes, w_out_jumpMux);
    
    assign w_control_branchEq       = (w_out_exMem_branch & w_out_exMem_ALUZero);
    assign w_control_branchNotEq    = (w_out_exMem_notEqBranch & !w_out_exMem_ALUZero);
    assign w_control_pcSrc          = (w_control_branchEq || w_control_branchNotEq || w_out_exMem_ctrl_jump);
    assign w_source_pc              = (i_wEn_instMem == 4'b1111)  ?   i_addr_instMem    : w_out_pc;
    
    assign w_halt                   = pc_halt;
    assign o_halt                   = halt_detected;
    
    // Frena el PC cuando la isntrucción es un HALT, y no se está ejecutando un flush del registro IF/ID
    always @ (negedge i_clk)
        begin
            if((w_out_ifId_im[31:26] == 6'b101010) && executingBranch == 1'b0) 
                pc_halt <= 1'b1;
            /*else
                pc_halt <= 1'b0;*/
        end
    
    // Si el HALT fue activado, se comprueba que los registros del pipeline esten vacíos y en ese caso se finaliza la ejecución    
    always@(*)
    begin
        if(w_halt && ~(w_idEx_working | w_exMem_working | w_memWb_working) && !executingBranch)
            halt_detected <= 1'b1;
        else
            halt_detected <= 1'b0;
    end
    
    initial
    begin
        executingBranch <= 1'b0;
        pc_halt <= 1'b0;
    end
    
    always@(*)
    begin
        if(w_control_pcSrc)
            executingBranch <= 1'b1;
    end
    
    always@(negedge i_clk)
    begin
        if(executingBranch && !w_out_ALUZero && !w_control_pcSrc)
            executingBranch <= 1'b0;
    end
    
    
endmodule
