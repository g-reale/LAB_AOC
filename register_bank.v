module register_bank(
  input wire [0:4]radrA,
  input wire [0:4]radrB,
  input wire [0:4]radrC,
  input wire [0:4]radrD,
  input wire [0:4]wadr,
  
  output wire[0:31]rvalueA,
  output wire[0:31]rvalueB,
  output wire[0:31]rvalueC,
  output wire[0:31]rvalueD,
  output wire[0:31]wvalue,

  input wire wenable,
  input wire clock
);

  reg [0:31] registers [0:31];
  //memory initialized to 0
  initial begin
      for(integer i = 0; i < 32; i = i + 1) begin
          registers[i] <= 32'd0;
      end
  end
  
  //sequential part
  always @(negedge clock) begin
    if(wenable) 
      registers[wadr] = wvalue;
  end
  
  //combinational part
  assign rvalueA = registers[radrA];
  assign rvalueB = registers[radrB];
  assign rvalueC = registers[radrC];
  assign rvalueD = registers[radrD];
  
endmodule