`ifndef CONSTANTS
`define CONSTANTS

//MACROS FOR INSTRUCTION TYPES
`define I 2'd0
`define J 2'd1
`define R 2'd2

`define IS_I_OPCODE(opcode)(6'd0 <= opcode && opcode <= 6'd15)
`define IS_J_OPCODE(opcode)(61'd0 <= opcode && opcode <= 6'd62) 
`define IS_R_OPCODE(opcode)(opcode == 6'd63)

//MACROS FOR INSRUCTION SLICING
`define OPCODE 0:5
`define REGS 6:10
`define REGT 11:15
`define REGD 16:20
`define SHAMFT 21:25
`define FUNC 26:31
`define IMMI 16:31
`define IMMJ 6:31

//MACROS FOR ALU OPERATIONS
`define ALUADD 4'd0  
`define ALUSUB 4'd1
`define ALUMUL 4'd3 
`define ALUDIV 4'd4
`define ALUAND 4'd5
`define ALUOR  4'd6
`define ALUNOR 4'd7
`define ALUXOR 4'd8
`define ALUSFL 4'd9   //shift left
`define ALUSFR 4'd10  //shift right
`define ALUSLT 4'd11  //set less then
`define ALUSEQ 4'd12  //set equal
`define ALUSNQ 4'd13  //set not equal

//MACROS FOR THE R TYPE FUNCS 
`define FUNCJR   6'd62
`define FUNCJALR 6'd63

//MACROS FOR THE J AND I TYPE OPCODES
`define OPBEQ   6'd12
`define OPBNQ   6'd13
`define OPLOAD  6'd14
`define OPSTORE 6'd15
`define OPJ     6'd61
`define OPJAL   6'd62

//MACROS FOR THE CONTROL UNIT OPERATIONS
`define DEF_DEST    3'b100
`define DEF_OPA     3'b010
`define DEF_OPB     3'b001
`define PC_NORMAL   2'b00 
`define PCSET_REF   2'b01
`define PCSET_STEP  2'b10
`define REGSRC_ALU  2'd0
`define REGSRC_LOAD 2'd1
`define REGSRC_PC   2'd2
`endif
