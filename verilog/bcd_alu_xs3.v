`timescale 1ns/1ps
// Top module: BCD arithmetic unit with Excess-3 output
module bcd_alu_xs3 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       m,          // 0 = add, 1 = subtract
    output wire [3:0] tens_bcd,
    output wire [3:0] units_bcd,
    output wire       sign,
    output wire [3:0] tens_xs3,
    output wire [3:0] units_xs3,
    output wire       err         // high when either input is not a valid BCD digit
);
    wire       tens, sign_r;
    wire [3:0] units_r, tens_r, tens_x, units_x;

    bcd_addsub u_arith (.a(a), .b(b), .m(m), .units(units_r), .tens(tens), .sign(sign_r));

    assign tens_r = {3'b000, tens};

    bcd_to_xs3 u_xs3_t (.bcd(tens_r),  .xs3(tens_x));
    bcd_to_xs3 u_xs3_u (.bcd(units_r), .xs3(units_x));

    // Input validity: 1010-1111 are not BCD digits
    assign err = (a[3] & (a[2] | a[1])) | (b[3] & (b[2] | b[1]));

    // Output mask: every data output is forced to 0 for an invalid input
    wire ok = ~err;
    assign tens_bcd  = tens_r  & {4{ok}};
    assign units_bcd = units_r & {4{ok}};
    assign sign      = sign_r  & ok;
    assign tens_xs3  = tens_x  & {4{ok}};
    assign units_xs3 = units_x & {4{ok}};
endmodule
