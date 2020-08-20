`timescale 1ns / 1ps

module T_DatapathControl_tb();
  reg                   i_clk;
  reg                   i_reset;
  reg                   i_stepEnableBtn;
  reg                   i_global_en;
  
  reg       [31:0]      reading_inst;
  reg       [31:0]      writing_mem_addr;
  reg       [3:0]       writing_mem_en;
  reg       [1:0]       program_state;

  integer               instructions_file, end_file;
  
  wire                  halt;
   
    T_DatapathControl T_DatapathControl_tb
    (
        .i_clk(i_clk), 
        .i_reset(i_reset), 
        .i_stepEnableBtn(i_stepEnableBtn),
        .i_global_en(i_global_en),
        
        .i_inst_instMem (reading_inst),
        .i_wEn_instMem (writing_mem_en),
        .i_addr_instMem (writing_mem_addr),
        
        .o_halt (halt)
    );

    localparam 
      load_mem  = 2'b00,
      init      = 2'b01,
      ejec      = 2'b10,
      stepEn    = 1'b1;     // step by step mode enable

    initial
    begin
        
    end

    initial
        begin
          instructions_file = $fopen("C:\\Users\\Nico\\Desktop\\TP Final - Arqui\\MIPS-architecture-processor\\Pipelined MIPS\\BinaryFiles\\inst-file.b", "r");
          if (!instructions_file) $stop;
          
          program_state     =   load_mem;
          writing_mem_addr  =   32'd0;
          writing_mem_en    =   4'b1111;
		  #0      i_reset = 1'b1; 
		          i_clk = 1'b1; 
		          i_stepEnableBtn = 1'b0;
		          
		  #5      i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #15     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #25     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #20     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #100    i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #5      i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #5      i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  /*#50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;
		  #50     i_stepEnableBtn = 1'b1;         #2      i_stepEnableBtn = 1'b0;*/
		  #100    i_stepEnableBtn = 1'b1; 
		  
		end
	
    /* STEP BY STEP MODE (stepEn = paso-a-paso || !stepEn = continuo)*/
    always @(posedge i_clk)
    begin
        if (stepEn)
            i_global_en <= i_stepEnableBtn;
        else
            i_global_en <= 1'b1;
    end
    
    // STATE TRANSITION - LOADING MEMORY - INITIAL STATE
    always @(negedge i_clk)
    begin
        if(program_state == load_mem)
        begin
            end_file <= $fscanf(instructions_file,"%b", reading_inst);
        end
    end
    
    always@(*)
    begin
        if(end_file != 1)
        begin
            reading_inst = 32'b0;
            writing_mem_en = 4'b0000;
            program_state = init;
        end
    end
    
    //Actualizacion de registro utilizado como direccion para cargar el programa
    always @(negedge i_clk)
    begin
        if(program_state != load_mem)
            writing_mem_addr = 32'b0;
        else
            writing_mem_addr = writing_mem_addr + 4;
    end
    
    //Una vez que pasa al estado de inicializacion, coloca reset en cero y pasa a ejecucion
    always @(negedge i_clk)
    begin
        if(program_state == init)
        begin
            i_reset = 1'b0;
            program_state = ejec;
        end
    end

    always @(posedge i_clk)
      begin
        if(halt == 1)
          $finish;
      end
  
    /* CLK SIGNAL */	
    always  
    begin
        #1  i_clk = ~i_clk;
    end
    
endmodule
