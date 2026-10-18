`timescale 1ns/1ps
// Single-digit BCD adder/subtractor
//   m = 0 : A + B  -> {tens, units} (0..18), sign = 0
//   m = 1 : A - B  -> sign-magnitude result, magnitude in units (0..9)
module bcd_addsub (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       m,        // 0 = add, 1 = subtract
    output wire [3:0] units,
    output wire       tens,     // decimal carry (tens digit, 0 or 1)
    output wire       sign      // 1 = negative difference
);
    // Stage 1: binary adder/subtractor (two's complement when m = 1)
    wire [3:0] b_x = b ^ {4{m}};
    wire [3:0] s1;
    wire       c1;
    rca4 stage1 (.a(a), .b(b_x), .cin(m), .s(s1), .cout(c1));

    // Decimal correction condition for addition: sum > 9
    wire k   = c1 | (s1[3] & s1[2]) | (s1[3] & s1[1]);
    wire add_fix = ~m & k;
    // Negative difference: no end-around carry out of stage 1
    wire neg = m & ~c1;

    // Stage 2: +0110 correction (add) or two's-complement recovery (negative sub)
    wire [3:0] x2 = s1 ^ {4{neg}};
    wire [3:0] y2 = {1'b0, add_fix, add_fix, 1'b0};
    wire       c2_unused;
    rca4 stage2 (.a(x2), .b(y2), .cin(neg), .s(units), .cout(c2_unused));

    assign tens = add_fix;
    assign sign = neg;
endmodule
