`timescale 1ns/1ps
// BCD to Excess-3 code converter (gate-level, from K-map minimisation)
// Inputs 1010-1111 are don't-cares.
module bcd_to_xs3 (
    input  wire [3:0] bcd,
    output wire [3:0] xs3
);
    assign xs3[3] = bcd[3] | (bcd[2] & (bcd[1] | bcd[0]));
    assign xs3[2] = bcd[2] ^ (bcd[1] | bcd[0]);
    assign xs3[1] = ~(bcd[1] ^ bcd[0]);
    assign xs3[0] = ~bcd[0];
endmodule
