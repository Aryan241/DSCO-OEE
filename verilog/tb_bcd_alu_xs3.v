`timescale 1ns/1ps
// Self-checking testbench: directed cases followed by an exhaustive sweep
module tb_bcd_alu_xs3;
    reg  [3:0] a, b;
    reg        m;
    wire [3:0] tens_bcd, units_bcd, tens_xs3, units_xs3;
    wire       sign, err;

    bcd_alu_xs3 dut (.a(a), .b(b), .m(m), .tens_bcd(tens_bcd), .units_bcd(units_bcd),
                     .sign(sign), .tens_xs3(tens_xs3), .units_xs3(units_xs3), .err(err));

    integer i, j, k, r;
    integer pass, fail, n_valid, n_invalid;
    reg [3:0] e_t, e_u, e_tx, e_ux;
    reg       e_s, e_err;

    task check;
        begin
            e_err = (a > 9) || (b > 9);
            if (e_err) begin
                // invalid input: all data outputs must be zero
                e_t = 0; e_u = 0; e_s = 0; e_tx = 0; e_ux = 0;
                n_invalid = n_invalid + 1;
            end else begin
                if (m == 0) begin
                    r = a + b;  e_s = 0;
                end else begin
                    r = (a >= b) ? a - b : b - a;  e_s = (a < b);
                end
                e_t = r / 10;  e_u = r % 10;
                e_tx = e_t + 3;  e_ux = e_u + 3;
                n_valid = n_valid + 1;
            end
            // !== also fails on any X or Z output bit
            if ({err, sign, tens_bcd, units_bcd, tens_xs3, units_xs3} !==
                {e_err, e_s, e_t, e_u, e_tx, e_ux}) begin
                fail = fail + 1;
                $display("FAIL a=%0d b=%0d m=%0d -> err=%b sign=%b tens=%0d units=%0d xs3=%b_%b",
                         a, b, m, err, sign, tens_bcd, units_bcd, tens_xs3, units_xs3);
            end else
                pass = pass + 1;
        end
    endtask

    task apply(input [3:0] ta, input [3:0] tb, input tm);
        begin
            a = ta; b = tb; m = tm; #10;
            $display("%3d ns  m=%b  A=%0d B=%0d | sign=%b tens=%b units=%b | XS3=%b %b | err=%b",
                     $time, m, a, b, sign, tens_bcd, units_bcd, tens_xs3, units_xs3, err);
        end
    endtask

    initial begin
        $dumpfile("bcd_alu_xs3.vcd");
        $dumpvars(0, tb_bcd_alu_xs3);
        pass = 0; fail = 0; n_valid = 0; n_invalid = 0;

        $display("---- Directed cases ----");
        apply(4'd3, 4'd4, 1'b0);  check;   // T1  normal add, no correction
        apply(4'd7, 4'd5, 1'b0);  check;   // T2  add, sum > 9 -> +6 correction
        apply(4'd8, 4'd8, 1'b0);  check;   // T3  add, binary carry (16)
        apply(4'd9, 4'd9, 1'b0);  check;   // T4  maximum sum 18
        apply(4'd8, 4'd3, 1'b1);  check;   // T5  sub, positive
        apply(4'd2, 4'd7, 1'b1);  check;   // T6  sub, negative
        apply(4'd5, 4'd5, 1'b1);  check;   // T7  sub, zero
        apply(4'd0, 4'd0, 1'b0);  check;   // T8  all zero
        apply(4'd12, 4'd3, 1'b0); check;   // T9  invalid A -> err, outputs masked
        apply(4'd4, 4'd10, 1'b1); check;   // T10 invalid B -> err, outputs masked
        $display("Directed result: %0d passed, %0d failed", pass, fail);

        $display("---- Exhaustive sweep (16 x 16 x 2) ----");
        pass = 0; fail = 0; n_valid = 0; n_invalid = 0;
        for (k = 0; k < 2; k = k + 1)
            for (i = 0; i < 16; i = i + 1)
                for (j = 0; j < 16; j = j + 1) begin
                    a = i; b = j; m = k; #10; check;
                end
        $display("Exhaustive result: %0d passed, %0d failed (%0d valid, %0d invalid)",
                 pass, fail, n_valid, n_invalid);
        $finish;
    end
endmodule
