
module program_counter(
  input wire [0:31] reference,
  input wire [0:31] step,
  output wire [0:31] counter,

  input wire clock
);

  reg [0:31] memory;
  initial memory <= 32'd0;

  //sequential part
  always @(posedge clock) begin
    memory = reference + step;
  end

  //combinational part
  assign counter = memory;
  
endmodule