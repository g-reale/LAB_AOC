`include "constants.v"

module testbench;

  reg clock = 0;
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

  //second micro instruction: choose argument deference
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
  
  wire [0:2] deference;
  wire [0:31] dest = deference[0] ? pdest : vdest;
  wire [0:31] opA = deference [1] ? popA : vopA;
  wire [0:31] opB = deference [2] ? popB : vopB;

  // EXECUTING CALCULATIONS
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

  // ROUTING RESULT TO PROGRAM COUNTER
  //fifith micro instruction: pc config (reference and step)
  wire [0:1] pcconfig;
  wire [0:31] step = pcconfig[0] ? result : 
                     pcconfig[1] ? 32'd0 :
                     32'd1;
  wire [0:31] reference = pcconfig[1] ? result : counter;
  
  program_counter pc(
    .reference,
    .step,
    .counter,
    .clock
  );

  //ROUTING RESULT TO RAM (STORE)
  //sixth micro instruction: ram config (is writing enabled or not?)
  wire ramconfig;
  wire [0:31] store;
  random_acess_memory ram(
    //writing on ram (store)
    .wadr(result),
    .wvalue(store),
    .wenable(ramconfig),

    //reading from ram (load)
    .radr(result),
    .rvalue(load),
    .clock
  );

  //ROUTING RESULT FROM RAM TO REG BANK (LOAD)
  //ROUTING RESULT FROM ALU TO REG BANK (CALCULATION)
  //ROUTING REUSLT FROM PC TO REG BANK (JUMP AND LINK)
  //seventh micro instruction: regbank config (is writing enabled or not?)
  wire regbankconfig;
  //eighth micro instruction: register bank source (will the loaded value be from the alu, ram or pc?) 
  wire [0:1] regsource;
  wire [0:31] load;
  wire [0:31] save = regsource == `REGSRC_ALU ? result : regsource == `REGSRC_LOAD ? load : counter;


  //CONNECTING THE TORMENT NEXUS
  control_unit cu(
    .instruction,
    .optype,
    .deference,
    .aluop,
    .shamft,
    .pcconfig,
    .ramconfig,
    .regbankconfig,
    .regsource
  );

  initial begin
    $monitor("%d",result);
    // $monitor("instruction: %b, pc: %d, dest: %d, opA: %d, opB: %d, result: %d, clk: %b", instruction, counter, dest, opA, opB, result, clock);  
    // $monitor("pc: %d wadr: %d, wvalue: %d, wenable: %d, radr: %d, rvalue: %d",counter,result,store,ramconfig,result,load);
    // $monitor("inst: %b, opcode: %b, REGS: %b, REGT: %b, REGD: %b, SHAMFT: %b, FUNC: %b, IMMI: %b, IMMJ: %b",instruction,instruction[`OPCODE],instruction[`REGS],instruction[`REGT],instruction[`REGD],instruction[`SHAMFT],instruction[`FUNC],instruction[`IMMI],instruction[`IMMJ]);
    // $monitor("optype: %b, deference: %b, aluop: %b, shamft: %b, pcconfig: %b, ramconfig: %b, regbankconfig: %b, regsource: %b",optype,deference,aluop,shamft,pcconfig,ramconfig,regbankconfig,regsource);

    //RUN 10 CLOCK CICLES
    for(integer i = 0; i < 10; i++) begin
      #1  
      clock = 1;
      clock = 0;
    end

    $finish;
  end     

endmodule