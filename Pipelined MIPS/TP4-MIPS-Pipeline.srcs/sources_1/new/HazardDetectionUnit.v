`timescale 1ns / 1ps

module HazardDetectionUnit
#(
    parameter               N_BUS   	    = 5
)
(
    input   [N_BUS-1:0]     i_ifId_rsReg,
    input   [N_BUS-1:0]     i_ifId_rtReg,
    input   [N_BUS-1:0]     i_idEx_rtReg,
    input                   i_idEx_memRead,
    input                   i_exMem_branchNop,
    output  reg             o_hd_pcWrite,
    output  reg             o_hd_ifIdWrite,
    output  reg             o_hd_muxStall
);
    
    always@(*)
    begin
        if(i_exMem_branchNop)
        begin
            o_hd_muxStall   <= 1'b0;
        end
        else if(i_idEx_memRead && 
            ((i_idEx_rtReg == i_ifId_rsReg) || 
            (i_idEx_rtReg == i_ifId_rtReg)))
            begin
                o_hd_pcWrite    <= 1'b0;
                o_hd_ifIdWrite  <= 1'b0;
                o_hd_muxStall   <= 1'b0;
            end
        else
            begin
                o_hd_pcWrite    <= 1'b1;
                o_hd_ifIdWrite  <= 1'b1;
                o_hd_muxStall   <= 1'b1;
            end
    end
endmodule

