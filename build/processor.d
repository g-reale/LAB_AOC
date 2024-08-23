



//MACROS FOR INSTRUCTION TYPES








//MACROS FOR INSRUCTION SLICING









//MACROS FOR ALU OPERATIONS
















//MACROS FOR THE J AND I TYPE OPCODES









//MACROS FOR THE R TYPE FUNCS 



//MACROS FOR THE CONTROL UNIT OPERATIONS










//MACROS FOR RAM AND MAGICAL ADRESSES






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
                aluop           =  opcode[0:3];
                pcconfig        = 2'b00;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = 2'd0;
            
            //BRANCH I INSTRUCTIONS
            end else if (6'd13 <= opcode && opcode <= 6'd16) begin
                deference       = 3'b100 | 3'b010;
                aluop           = (opcode - 6'd13 + 4'd11);
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











































































//MODULE DECLARATION IF TESTING

module processor;
  reg clock = 0;
  wire [0:6] displays[0:7];
  wire [0:17] switches;

//MODULE DECLARATION IF SINTHESIZING

















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
  wire [0:31] save = regsource == 2'd0 ? result : regsource == 2'd1 ? load : counter;


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
  

endmodule
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
  
//--program--//
assign memory[0] = ({2'd0, 4'd0, 5'd 28, 5'd 28, 16'd 1601}); 
assign memory[1] = ({2'd0, 4'd0, 5'd 31, 5'd 31, 16'd 0}); 
assign memory[2] = ({6'd61, 26'd 1}); 
//--program--//

  assign instruction = memory[adr];
endmodule
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

  reg [0:31] memory [0:(32'd4096)];

  
    initial begin
      for(integer i = 0; i < (32'd4096); i++)
        memory[i] = 0;
    end
  

  reg [0:31] to_display = 0;
  seven_segment_decoder ss_dec(
    .number(to_display),
    .displays
  );
  
  //sequential part
  always @(negedge clock)begin
    
    if(wenable) begin
      if((wadr < ((32'd4096) - 1)))  //write to main memory
        memory[wadr] = wvalue;
      else if(wadr == ((32'd4096) - 1)) //write to display
        to_display = wvalue;
    end
  end

  //combinational part
  assign rvalue = (wadr < ((32'd4096) - 1)) ? memory[radr] : //read from main memory
                  wadr == ((32'd4096) - 1) ? switches :     //read from switches
                  32'd0; 

endmodule
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

  input wire[0:31]wvalue,
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













module seven_segment_decoder(
    input wire [0:31] number,
    output wire [0:6] displays [0:7]
);
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_displays
            wire [0:31] digit;
            assign digit = ((number / 10**i) % 10);
            assign displays[i] = (
    (digit[0:3]) == 4'd9 ? 7'b0001100:
    (digit[0:3]) == 4'd8 ? 7'b0000000:
    (digit[0:3]) == 4'd7 ? 7'b0001111:
    (digit[0:3]) == 4'd6 ? 7'b0100000:
    (digit[0:3]) == 4'd5 ? 7'b0100100:
    (digit[0:3]) == 4'd4 ? 7'b1001100:
    (digit[0:3]) == 4'd3 ? 7'b0000110:
    (digit[0:3]) == 4'd2 ? 7'b0010010:
    (digit[0:3]) == 4'd1 ? 7'b1001111:
    (digit[0:3]) == 4'd0 ? 7'b0000001:
    7'b1111111
);
        end
    endgenerate

endmodule