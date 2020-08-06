`timescale 1ns / 1ps

module IF_ID
#( 
  // Parametros
  parameter	                    N_BUS_IN 	= 32
)
(
  input                         i_global_enable, i_clk, i_reset, i_branchNop,  
  input       [N_BUS_IN-1:0]    i_im_IF,
  input       [N_BUS_IN-1:0]    i_pcAdd_IF,
  input                         i_hd_ifIdWrite,
  output      [N_BUS_IN-1:0]    o_im_ID,
  output      [N_BUS_IN-1:0]    o_pcAdd_ID
);

  reg         [N_BUS_IN-1:0]    reg_im_ID;
  reg         [N_BUS_IN-1:0]    reg_pcAdd_ID;
  
  always @(negedge i_clk) 
    begin
      if (i_reset)
        begin
          reg_im_ID     <= 32'b0;
          reg_pcAdd_ID  <= 32'b0;
        end
      else if (i_global_enable)
        begin      
          if (i_branchNop)
            begin
                reg_im_ID     <= {6'b111111, 26'd0};
                reg_pcAdd_ID  <= i_pcAdd_IF;
            end
          else if (!i_hd_ifIdWrite)
            begin
              reg_im_ID     <= o_im_ID;
              reg_pcAdd_ID  <= o_pcAdd_ID;  
            end
          else
            begin
              reg_im_ID     <= i_im_IF;
              reg_pcAdd_ID  <= i_pcAdd_IF;
            end
        end
      else
        begin
              reg_im_ID     <= reg_im_ID;
              reg_pcAdd_ID  <= reg_pcAdd_ID;
        end
    end

  assign o_im_ID = reg_im_ID;
  assign o_pcAdd_ID = reg_pcAdd_ID;

endmodule