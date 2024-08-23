
`include "constants.v"

//MODULE DECLARATION IF TESTING
`ifdef UNIT_TESTING
module processor;
  reg clock = 0;
  wire [0:6] displays[0:7];
  wire [0:17] switches;

//MODULE DECLARATION IF SINTHESIZING
`else

module processor(
  input reg clock50MHZ,
  input wire [0:17] switches,
  output wire [0:6] displays[0:7]
);

  wire clock;

  clock_divider clk_div(
    .clock50MHZ,
    .clock
  );

`endif

  wire [0:31] counter;
  wire [0:31] instruction;

  program_memory pm(
    .adr(counter),
    .instruction
  );

  //DECODING ARGUMENTS
  wire [0:31] desti;
  wire [0:31] opAi;
  wire [0:31] opBi;

  decoder_i deci(
    .instruction,
    .dest(desti),
    .opA(opAi),
    .opB(opBi)
  );

  wire [0:31] destj;
  wire [0:31] opAj;
  wire [0:31] opBj;

  decoder_j decj(
    .instruction,
    .dest(destj),
    .opA(opAj),
    .opB(opBj)
  );

  wire [0:31] destr;
  wire [0:31] opAr;
  wire [0:31] opBr;

  decoder_r decr(
    .instruction,
    .dest(destr),
    .opA(opAr),
    .opB(opBr)
  );

  //first micro instruction: choose decoder output
  wire [0:1] optype;
  wire [0:31]vdest = optype == `I ? desti : optype == `J ? destj : destr;
  wire [0:31]vopA = optype == `I ? opAi : optype == `J ? opAj : opAr; 
  wire [0:31]vopB = optype == `I ? opBi : optype == `J ? opBj : opBr;

  wire [0:31] pdest;
  wire [0:31] popA;
  wire [0:31] popB;

  register_bank registers(
    //operation decode
    .radrA(vdest[27:31]),
    .radrB(vopA[27:31]),
    .radrC(vopB[27:31]),
    .rvalueA(pdest),
    .rvalueB(popA),
    .rvalueC(popB),

    //routing to ram (store)
    .radrD(dest[27:31]),
    .rvalueD(store),

    //routing from alu, ram or pc
    .wadr(dest[27:31]),
    .wvalue(save),
    .wenable(regbankconfig),
    .clock
  );
  
  //second micro instruction: choose argument deference
  wire [0:2] deference;
  wire [0:31] dest = deference[0] ? pdest : vdest;
  wire [0:31] opA = deference [1] ? popA : vopA;
  wire [0:31] opB = deference [2] ? popB : vopB;
  
  //third micro instruction: choose aluop
  wire [0:3] aluop;
  
  //fourth micro instruction: choose shift amount
  wire [0:5] shamft;
  wire [0:31] result;

  arithmetic_logic_unit alu(
    .operation(aluop),
    .opA,
    .opB,
    .opC(dest),
    .shamft,
    .result
  );

  //fifith micro instruction: pc config (reference and step)
  wire [0:1] pcconfig;
  wire [0:31] reference = pcconfig[1] ? result : counter;
  wire [0:31] step = pcconfig[0] ? result : 
                     pcconfig[1] ? 32'd0 :
                     32'd1;
  
  program_counter pc(
    .reference,
    .step,
    .counter,
    .clock
  );

  //sixth micro instruction: ram config (is writing enabled or not?)
  wire ramconfig;
  wire [0:31] store;

  random_acess_memory ram(
    //writing on ram (store)
    .wadr(result),
    .wvalue(store),
    .wenable(ramconfig),

    //conections to peripherals
    .displays,
    .switches,

    //reading from ram (load)
    .radr(result),
    .rvalue(load),
    .clock
  );
  
  //seventh micro instruction: regbank config (is writing enabled or not?)
  wire regbankconfig;
  
  //eighth micro instruction: register bank source (will the loaded value be from the alu, ram or pc?) 
  wire [0:1] regsource;
  wire [0:31] load;
  wire [0:31] save = regsource == `REGSRC_ALU ? result : regsource == `REGSRC_LOAD ? load : counter;


  control_unit cu(
    .instruction,
    .optype,          // processes the operation type (I - J - R)
    .deference,       // chosses witch instruction arguments should be dereferenced on the register bank
    .aluop,           // chooses the aluoperation for the specific instruction
    .shamft,          // chooses the shiftamount for the specific instruction
    .pcconfig,        // chooses the pc mode (normal - change reference - change step)
    .ramconfig,       // enables/disables writing on the ram
    .regbankconfig,   // enables/disables writing on the regbank
    .regsource        // chooses the source of what shall be writen on the register bank (alu - ram - pc)
  );

  `ifdef UNIT_TESTING
    //TESTTING ROUTINE 
    initial begin
      $monitor("%d",result);

      //RUN 10 CLOCK CICLES
      for(integer i = 0; i < 10; i++) begin
        #1  
        clock = 1;
        clock = 0;
      end

      $finish;
    end     
  `endif

endmodule