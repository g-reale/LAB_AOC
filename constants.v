`ifndef CONSTANTS
`define CONSTANTS

//MACROS FOR INSTRUCTION TYPES
`define I 2'd0
`define J 2'd1
`define R 2'd2

`define IS_I_OPCODE(opcode)(6'd0 <= opcode && opcode <= 6'd18)
`define IS_J_OPCODE(opcode)(6'd60 <= opcode && opcode <= 6'd61) 
`define IS_R_OPCODE(opcode)(opcode == 6'd63)

//MACROS FOR INSRUCTION SLICING
`define OPCODE      0:5
`define REGS        6:10
`define REGT        11:15
`define REGD        16:20
`define SHAMFT      21:25
`define FUNC        26:31
`define IMMI        16:31
`define IMMJ        6:31

//MACROS FOR ALU OPERATIONS
`define ALUADD      4'd0  
`define ALUSUB      4'd1
`define ALUMUL      4'd2 
`define ALUDIV      4'd3
`define ALUAND      4'd4
`define ALUOR       4'd5
`define ALUNOR      4'd6
`define ALUXOR      4'd7
`define ALUSFL      4'd8    //shift left
`define ALUSFR      4'd9    //shift right
`define ALUSLT      4'd10   //set less then
`define ALUSEQ      4'd11   //set equal
`define ALUSNQ      4'd12   //set not equal
`define ALUSEQNEG   4'd13   //set equal negated
`define ALUSNQNEG   4'd14   //set not equal negated

//MACROS FOR THE J AND I TYPE OPCODES
`define OPBEQ       6'd13
`define OPBNQ       6'd14
`define OPBEQNEG    6'd15
`define OPBNQNEG    6'd16
`define OPLOAD      6'd17
`define OPSTORE     6'd18
`define OPJ         6'd60
`define OPJAL       6'd61

//MACROS FOR THE R TYPE FUNCS 
`define FUNCJR      6'd62
`define FUNCJALR    6'd63

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

//MACROS FOR RAM AND MAGICAL ADRESSES
`define RAM_SIZE (32'd4096)
`define IS_NOT_MAGICAL(adr)(adr < (`RAM_SIZE - 1))
`define MGC_DISP_ADR (`RAM_SIZE - 1)
`define MGC_SWCH_ADR (`RAM_SIZE - 1)
`endif
