
`include "precompiler.v"

module program_memory(
  input wire [0:31] adr,
  output wire [0:31] instruction
);
  parameter memsize = ((1<<16) - 1); 
  reg [0:31] memory [0:memsize];
  
//--program--//
assign memory[0] = `SUB(0,0,0,0); 
assign memory[1] = `ADDI(0,0,4095); 
assign memory[2] = `STORE(0,0,0); 
assign memory[3] = `JMP(2); 
//--program--//

  assign instruction = memory[adr];
endmodule