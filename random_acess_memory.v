module random_acess_memory(
  input wire [0:31] radr,
  input wire [0:31] wadr,

  output wire [0:31] rvalue,
  input wire [0:31] wvalue,

  input wire wenable,
  input wire clock
);

  //CHANGE RAM SIZE WHEN SYTHESIZING TO THE TARGET PLATAFORM
  //THE COMPILED PROGRAM WON'T WORK IF THE RAM IS TOO BIG
  parameter RAM_SIZE = 4096;
  reg [0:31] memory [0:RAM_SIZE];

  initial begin
    for(integer i = 0; i < RAM_SIZE; i++)
      memory[i] = 0;
  end

  //sequential part
  always @(negedge clock)begin
    if(wenable) begin
      memory[wadr] = wvalue;
    end
  end

  //combinational part
  assign rvalue = memory[radr]; 
endmodule