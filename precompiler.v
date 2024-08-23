
`include "constants.v"

`ifndef PRECOMPILER
`define PRECOMPILER

// R INSTRUCTIONS
`define ADD(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUADD})
`define SUB(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUSUB})
`define MUL(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUMUL})
`define DIV(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUDIV})
`define AND(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUAND})
`define OR(dest,opa,opb,shamft) ({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUOR})
`define NOR(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUNOR})
`define XOR(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUXOR})
`define SFL(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUSFL})
`define SFR(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUSFR})
`define SLT(dest,opa,opb,shamft)({6'd63, 5'd dest, 5'd opa, 5'd opb, 5'd shamft, 2'd0, `ALUSLT})
`define JR(opa) ({6'd63, 5'd 0, 5'd opa, 5'd 0, 5'd 0, `FUNCJR})
`define JALR(dest,opa)({6'd63,5'd dest, 5'd opa, 5'd 0, 5'd 0, `FUNCJALR})

// I INSTRUCTIONS
`define ADDI(dest,opa,opb)({2'd0, `ALUADD, 5'd dest, 5'd opa, 16'd opb})
`define SUBI(dest,opa,opb)({2'd0, `ALUSUB, 5'd dest, 5'd opa, 16'd opb})
`define MULI(dest,opa,opb)({2'd0, `ALUMUL, 5'd dest, 5'd opa, 16'd opb})
`define DIVI(dest,opa,opb)({2'd0, `ALUDIV, 5'd dest, 5'd opa, 16'd opb})
`define ANDI(dest,opa,opb)({2'd0, `ALUAND, 5'd dest, 5'd opa, 16'd opb})
`define ORI(dest,opa,opb)( {2'd0, `ALUOR,  5'd dest, 5'd opa, 16'd opb})
`define NORI(dest,opa,opb)({2'd0, `ALUNOR, 5'd dest, 5'd opa, 16'd opb})
`define XORI(dest,opa,opb)({2'd0, `ALUXOR, 5'd dest, 5'd opa, 16'd opb})
`define SFLI(dest,opa,opb)({2'd0, `ALUSFL, 5'd dest, 5'd opa, 16'd opb})
`define SFRI(dest,opa,opb)({2'd0, `ALUSFR, 5'd dest, 5'd opa, 16'd opb})
`define SLTI(dest,opa,opb)({2'd0, `ALUSLT, 5'd dest, 5'd opa, 16'd opb})
`define BEQ(dest,opa,opb)( {`OPBEQ, 5'd dest, 5'd opa, 16'd opb})
`define BEQNEG(dest,opa,opb)( {`OPBEQNEG, 5'd dest, 5'd opa, 16'd opb})
`define BNQ(dest,opa,opb)( {`OPBNQ, 5'd dest, 5'd opa, 16'd opb})
`define BNQNEG(dest,opa,opb)( {`OPBNQNEG, 5'd dest, 5'd opa, 16'd opb})
`define LOAD(dest,opa,opb)({`OPLOAD, 5'd dest, 5'd opa, 16'd opb})
`define STORE(dest,opa,opb)({`OPSTORE,5'd dest, 5'd opa, 16'd opb})

// J INSTRUCTIONS
`define JMP(dest)({`OPJ, 26'd dest})
`define JAL(dest)({`OPJAL, 26'd dest})

`endif