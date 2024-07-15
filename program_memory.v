`include "precompiler.v"

module program_memory(
  input wire [0:31] adr,
  output wire [0:31] instruction
);
  parameter memsize = ((1<<16) - 1); 
  reg [0:31] memory [0:memsize];
  
  initial begin
//--program--//
memory[0] = `ADDI(20,20,852); 
memory[1] = `ADDI(31,31,0); 
memory[2] = `JAL(1); 
//--program--//
  end

  assign instruction = memory[adr];
endmodule