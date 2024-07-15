


//MACROS FOR INSTRUCTION TYPES








//MACROS FOR INSRUCTION SLICING









//MACROS FOR ALU OPERATIONS
















//MACROS FOR THE J AND I TYPE OPCODES









//MACROS FOR THE R TYPE FUNCS 



//MACROS FOR THE CONTROL UNIT OPERATIONS











module arithmetic_logic_unit(
        input wire [0:3]operation,
        input wire [0:31]opA,
        input wire [0:31]opB,
        input wire [0:31]opC,
        input wire [0:5]shamft,
        output wire [0:31]result   
    );

    assign result = (operation == 4'd0)    ? (opA + opB) << shamft :
                    (operation == 4'd1)    ? (opA - opB) << shamft :
                    (operation == 4'd2)    ? (opA * opB) << shamft :
                    (operation == 4'd3)    ? (opA / opB) << shamft :
                    (operation == 4'd4)    ? (opA & opB) << shamft :
                    (operation == 4'd5)     ? (opA | opB) << shamft :
                    (operation == 4'd6)    ? (~(opA | opB)) << shamft :
                    (operation == 4'd7)    ? (opA ^ opB) << shamft :
                    (operation == 4'd8)    ? (opA << opB) << shamft :
                    (operation == 4'd9)    ? (opA >> opB) << shamft :
                    (operation == 4'd10)    ? (opA < opB) << shamft:
                    (operation == 4'd11)    ? (opC == opA) ? opB : 32'd1 :
                    (operation == 4'd12)    ? (opC != opA) ? opB : 32'd1 :
                    (operation == 4'd13) ? (opC == opA) ? -opB : 32'd1 :
                    (operation == 4'd14) ? (opC != opA) ? -opB : 32'd1 :
                    0;

endmodule
































































































































module control_unit(
    input wire [0:31] instruction,
    output reg [0:1] optype,
    output reg [0:2] deference,
    output reg [0:3] aluop,
    output reg [0:5] shamft,
    output reg [0:1] pcconfig,
    output reg ramconfig,
    output reg regbankconfig,
    output reg [0:1] regsource
);

    wire [0:5]opcode = instruction[0:5];
    
    always @* begin
        if((6'd0 <= opcode && opcode <= 6'd18)) begin
            
            optype = 2'd0;
            shamft = 5'd0;
            
            // ARITHIMETIC I INSTRUCTIONS
            if(opcode <= 4'd10) begin
                deference       = 3'b010;
                aluop           =  opcode;
                pcconfig        = 2'b00;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = 2'd0;
            
            //BRANCH I INSTRUCTIONS
            end else if (6'd13 <= opcode && opcode <= 6'd16) begin
                deference       = 3'b100 | 3'b010;
                aluop           = opcode - 6'd13 + 4'd11;
                pcconfig        = 2'b10;
                ramconfig       = 0;
                regbankconfig   = 0;
                regsource       = 2'd0;
            
            //LOAD INSTRUCTION
            end else if (opcode == 6'd17) begin
                deference       = 3'b010;
                aluop           = 4'd0;
                pcconfig        = 2'b00;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = 2'd1;

            //STORE INSTRUCTION
            end else if (opcode == 6'd18) begin
                deference       = 3'b010;
                aluop           = 4'd0;
                pcconfig        = 2'b00;
                ramconfig       = 1;
                regbankconfig   = 0;
                regsource       = 2'd0;
            end

        end else if((6'd60 <= opcode && opcode <= 6'd61)) begin

            optype = 2'd1;
            shamft = 5'd0;

            //JUMP INSTRUCTION
            if(instruction[0:5] == 6'd60) begin
                deference       = 3'b000;
                aluop           = 4'd0;
                pcconfig        = 2'b01;
                ramconfig       = 0;
                regbankconfig   = 0;
                regsource       = 2'd0;

            //JUMP AND LINK INSTRUCTION
            end if(instruction[0:5] == 6'd61) begin
                deference       = 3'b000;
                aluop           = 4'd0;
                pcconfig        = 2'b01;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = 2'd2;
            end
        
        end else if((opcode == 6'd63)) begin
            
            optype = 2'd2;
            shamft = instruction[21:25];

            //ARITHMETIC R INSTRUCTIONS
            if(instruction[26:31] <= 4'd10) begin
                deference       = 3'b010 | 3'b001;
                aluop           = instruction[26:31];
                pcconfig        = 2'b00;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = 2'd0;

            //JUMP REGISTER INSTRUCTION
            end else if(instruction[26:31] == 6'd62) begin
                deference       = 3'b010;
                aluop           = 4'd0;
                pcconfig        = 2'b01;
                ramconfig       = 0;
                regbankconfig   = 0;
                regsource       = 2'd0;

            //JUMP AND LINK REGISTER INSTRUCTION
            end else if(instruction[26:31] == 6'd63) begin
                deference       = 3'b010;
                aluop           = 4'd0;
                pcconfig        = 2'b01;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = 2'd2;
            end
        end
    end
endmodule
































































module decoder_i(input wire [0:31]instruction,
                 output wire [0:31]dest,
                 output wire [0:31]opA,
                 output wire [0:31]opB);

    assign dest = instruction[6:10];
    assign opA = instruction[11:15];
    assign opB = instruction[16:31];

endmodule 

module decoder_r(input wire [0:31]instruction,
                 output wire [0:31]dest,
                 output wire [0:31]opA,
                 output wire [0:31]opB);

    assign dest = instruction[6:10];
    assign opA = instruction[11:15];
    assign opB = instruction[16:20];

endmodule

module decoder_j(input wire [0:31]instruction,
                 output wire [0:31]dest,
                 output wire [0:31]opA,
                 output wire [0:31]opB);

    assign dest = 32'd31;
    assign opA = 32'd0;
    assign opB = instruction[6:31];

endmodule



































































// R INSTRUCTIONS














// I INSTRUCTIONS


















// J INSTRUCTIONS



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










































































































module program_memory(
  input wire [0:31] adr,
  output wire [0:31] instruction
);
  parameter memsize = ((1<<16) - 1); 
  reg [0:31] memory [0:memsize];
  
  initial begin
//--program--//
memory[0] = ({2'd0, 4'd0, 5'd 30, 5'd 30, 16'd 1296}); 
memory[1] = ({2'd0, 4'd0, 5'd 31, 5'd 31, 16'd 0}); 
memory[2] = ({6'd61, 26'd 1}); 
//--program--//
  end

  assign instruction = memory[adr];
endmodulemodule random_acess_memory(
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
endmodulemodule register_bank(
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
    if(wenable) begin
      registers[wadr] = wvalue;
    end
  end
  
  //combinational part
  assign rvalueA = registers[radrA];
  assign rvalueB = registers[radrB];
  assign rvalueC = registers[radrC];
  assign rvalueD = registers[radrD];
  
endmodule
































































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
  wire [0:31]vdest = optype == 2'd0 ? desti : optype == 2'd1 ? destj : destr;
  wire [0:31]vopA = optype == 2'd0 ? opAi : optype == 2'd1 ? opAj : opAr; 
  wire [0:31]vopB = optype == 2'd0 ? opBi : optype == 2'd1 ? opBj : opBr;

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
  wire [0:31] save = regsource == 2'd0 ? result : regsource == 2'd1 ? load : counter;


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