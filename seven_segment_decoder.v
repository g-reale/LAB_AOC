`define SEGMENT_TABLE(value)(\
    (value) == 4'd9 ? 7'b0001100: /* 9 */ \
    (value) == 4'd8 ? 7'b0000000: /* 8 */ \
    (value) == 4'd7 ? 7'b0001111: /* 7 */ \
    (value) == 4'd6 ? 7'b0100000: /* 6 */ \
    (value) == 4'd5 ? 7'b0100100: /* 5 */ \
    (value) == 4'd4 ? 7'b1001100: /* 4 */ \
    (value) == 4'd3 ? 7'b0000110: /* 3 */ \
    (value) == 4'd2 ? 7'b0010010: /* 2 */ \
    (value) == 4'd1 ? 7'b1001111: /* 1 */ \
    (value) == 4'd0 ? 7'b0000001: /* 0 */ \
    7'b1111111 /* OFF */ \
)

module seven_segment_decoder(
    input wire [0:31] number,
    output wire [0:6] displays [0:7]
);
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_displays
            wire [0:31] digit;
            assign digit = ((number / 10**i) % 10);
            assign displays[i] = `SEGMENT_TABLE(digit[0:3]);
        end
    endgenerate

endmodule
