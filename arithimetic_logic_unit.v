
`include "constants.v"

module arithmetic_logic_unit(
        input wire [0:3]operation,
        input wire [0:31]opA,
        input wire [0:31]opB,
        input wire [0:31]opC,
        input wire [0:5]shamft,
        output wire [0:31]result   
    );

    assign result = (operation == `ALUADD)    ? (opA + opB) << shamft :
                    (operation == `ALUSUB)    ? (opA - opB) << shamft :
                    (operation == `ALUMUL)    ? (opA * opB) << shamft :
                    (operation == `ALUDIV)    ? (opA / opB) << shamft :
                    (operation == `ALUAND)    ? (opA & opB) << shamft :
                    (operation == `ALUOR)     ? (opA | opB) << shamft :
                    (operation == `ALUNOR)    ? (~(opA | opB)) << shamft :
                    (operation == `ALUXOR)    ? (opA ^ opB) << shamft :
                    (operation == `ALUSFL)    ? (opA << opB) << shamft :
                    (operation == `ALUSFR)    ? (opA >> opB) << shamft :
                    (operation == `ALUSLT)    ? (opA < opB) << shamft:
                    (operation == `ALUSEQ)    ? (opC == opA) ? opB : 32'd1 :
                    (operation == `ALUSNQ)    ? (opC != opA) ? opB : 32'd1 :
                    (operation == `ALUSEQNEG) ? (opC == opA) ? -opB : 32'd1 :
                    (operation == `ALUSNQNEG) ? (opC != opA) ? -opB : 32'd1 :
                    0;

endmodule