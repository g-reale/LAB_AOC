`include "constants.v"

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

    wire [0:5]opcode = instruction[`OPCODE];
    
    always @* begin
        if(`IS_I_OPCODE(opcode)) begin
            
            optype = `I;
            shamft = 5'd0;
            
            // ARITHIMETIC I INSTRUCTIONS
            if(opcode <= `ALUSLT) begin
                deference       = `DEF_OPA;
                aluop           =  opcode;
                pcconfig        = `PC_NORMAL;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = `REGSRC_ALU;
            
            //BRANCH I INSTRUCTIONS
            end else if (`OPBEQ <= opcode && opcode <= `OPBNQNEG) begin
                deference       = `DEF_DEST | `DEF_OPA;
                aluop           = opcode - `OPBEQ + `ALUSEQ;
                pcconfig        = `PCSET_STEP;
                ramconfig       = 0;
                regbankconfig   = 0;
                regsource       = `REGSRC_ALU;
            
            //LOAD INSTRUCTION
            end else if (opcode == `OPLOAD) begin
                deference       = `DEF_OPA;
                aluop           = `ALUADD;
                pcconfig        = `PC_NORMAL;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = `REGSRC_LOAD;

            //STORE INSTRUCTION
            end else if (opcode == `OPSTORE) begin
                deference       = `DEF_OPA;
                aluop           = `ALUADD;
                pcconfig        = `PC_NORMAL;
                ramconfig       = 1;
                regbankconfig   = 0;
                regsource       = `REGSRC_ALU;
            end

        end else if(`IS_J_OPCODE(opcode)) begin

            optype = `J;
            shamft = 5'd0;

            //JUMP INSTRUCTION
            if(instruction[`OPCODE] == `OPJ) begin
                deference       = 3'b000;
                aluop           = `ALUADD;
                pcconfig        = `PCSET_REF;
                ramconfig       = 0;
                regbankconfig   = 0;
                regsource       = `REGSRC_ALU;

            //JUMP AND LINK INSTRUCTION
            end if(instruction[`OPCODE] == `OPJAL) begin
                deference       = 3'b000;
                aluop           = `ALUADD;
                pcconfig        = `PCSET_REF;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = `REGSRC_PC;
            end
        
        end else if(`IS_R_OPCODE(opcode)) begin
            
            optype = `R;
            shamft = instruction[`SHAMFT];

            //ARITHMETIC R INSTRUCTIONS
            if(instruction[`FUNC] <= `ALUSLT) begin
                deference       = `DEF_OPA | `DEF_OPB;
                aluop           = instruction[`FUNC];
                pcconfig        = `PC_NORMAL;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = `REGSRC_ALU;

            //JUMP REGISTER INSTRUCTION
            end else if(instruction[`FUNC] == `FUNCJR) begin
                deference       = `DEF_OPA;
                aluop           = `ALUADD;
                pcconfig        = `PCSET_REF;
                ramconfig       = 0;
                regbankconfig   = 0;
                regsource       = `REGSRC_ALU;

            //JUMP AND LINK REGISTER INSTRUCTION
            end else if(instruction[`FUNC] == `FUNCJALR) begin
                deference       = `DEF_OPA;
                aluop           = `ALUADD;
                pcconfig        = `PCSET_REF;
                ramconfig       = 0;
                regbankconfig   = 1;
                regsource       = `REGSRC_PC;
            end
        end
    end
endmodule