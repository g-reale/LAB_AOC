
`include "constants.v"

module decoder_i(input wire [0:31]instruction,
                 output wire [0:31]dest,
                 output wire [0:31]opA,
                 output wire [0:31]opB);

    assign dest = instruction[`REGS];
    assign opA = instruction[`REGT];
    assign opB = instruction[`IMMI];

endmodule 

module decoder_r(input wire [0:31]instruction,
                 output wire [0:31]dest,
                 output wire [0:31]opA,
                 output wire [0:31]opB);

    assign dest = instruction[`REGS];
    assign opA = instruction[`REGT];
    assign opB = instruction[`REGD];

endmodule

module decoder_j(input wire [0:31]instruction,
                 output wire [0:31]dest,
                 output wire [0:31]opA,
                 output wire [0:31]opB);

    assign dest = 32'd31;
    assign opA = 32'd0;
    assign opB = instruction[`IMMJ];

endmodule