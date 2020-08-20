@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Wed Aug 19 19:53:06 -0300 2020
REM SW Build 2708876 on Wed Nov  6 21:40:23 MST 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim T_DatapathControl_tb_behav -key {Behavioral:sim_1:Functional:T_DatapathControl_tb} -tclbatch T_DatapathControl_tb.tcl -view C:/Users/Nico/Desktop/TP Final - Arqui/MIPS-architecture-processor/Pipelined MIPS/T_DatapathControl_tb_behav_pipelineRegisters.wcfg -log simulate.log"
call xsim  T_DatapathControl_tb_behav -key {Behavioral:sim_1:Functional:T_DatapathControl_tb} -tclbatch T_DatapathControl_tb.tcl -view C:/Users/Nico/Desktop/TP Final - Arqui/MIPS-architecture-processor/Pipelined MIPS/T_DatapathControl_tb_behav_pipelineRegisters.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
