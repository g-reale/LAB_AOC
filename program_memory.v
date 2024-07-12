`include "precompiler.v"

module program_memory(
  input wire [0:31] adr,
  output wire [0:31] instruction
);
  parameter memsize = ((1<<16) - 1); 
  reg [0:31] memory [0:memsize];
  
  initial begin
    memory[0] = `ADDI(1,1,3);
    memory[1] = `MUL(1,1,1,0);
    memory[2] = `JMP(1);
  end

  assign instruction = memory[adr];
endmodule