module random_acess_memory(
  input wire [0:31] radr,
  input wire [0:31] wadr,

  output wire [0:31] rvalue,
  input wire [0:31] wvalue,

  input wire wenable,
  input wire clock
);

  reg [0:31] memory [0:(1<<32)-1];

  //sequential part
  always @(negedge clock)begin
    if(wenable)
      memory[wadr] = wvalue;
  end

  //combinational part
  assign rvalue = memory[radr]; 
  
endmodule