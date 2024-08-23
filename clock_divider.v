
`ifndef UNIT_TESTING
module clock_divider(
    input wire clock50MHZ,
    output wire clock
);
    reg [25:0] divider;
    reg spike;

    // sequential part
    always@(posedge clock50MHZ) begin
        if(divider == 26'd50000000) begin
            spike <= 1;
            divider <= 0;
        end else begin
            spike <= 0;
            divider <= divider + 26'd1;
        end
    end

    //combinational part
    assign clock = spike;

endmodule
`endif