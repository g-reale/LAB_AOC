
module random_acess_memory(
  input wire [0:31] radr,
  input wire [0:31] wadr,

  output wire [0:31] rvalue,
  input wire [0:31] wvalue,

  //peripherals
  output wire [0:6] displays[0:7],
  input wire [0:17] switches,

  input wire wenable,
  input wire clock
);

  reg [0:31] memory [0:`RAM_SIZE];

  `ifdef UNIT_TESTING
    initial begin
      for(integer i = 0; i < `RAM_SIZE; i++)
        memory[i] = 0;
    end
  `endif

  reg [0:31] to_display = 0;
  seven_segment_decoder ss_dec(
    .number(to_display),
    .displays
  );
  
  //sequential part
  always @(negedge clock)begin
    
    if(wenable) begin
      if(`IS_NOT_MAGICAL(wadr))  //write to main memory
        memory[wadr] = wvalue;
      else if(wadr == `MGC_DISP_ADR) //write to display
        to_display = wvalue;
    end
  end

  //combinational part
  assign rvalue = `IS_NOT_MAGICAL(wadr) ? memory[radr] : //read from main memory
                  wadr == `MGC_SWCH_ADR ? switches :     //read from switches
                  32'd0; 

endmodule