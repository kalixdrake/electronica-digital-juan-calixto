`timescale 1ns / 1ps

module divisorsito #(parameter N = 16)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [N-1:0] dividend_in,
    input  wire [N-1:0] divisor_in,
    output wire ready,
    output wire [N-1:0] quotient_out,
    output wire [N-1:0] remainder_out
);


    wire LOAD_M, LOAD_Q, CLEAR_A, LOAD_n, SHIFT_AQ, ADD_SUB, WRITE_A;
    wire SET_Q0_EN, SET_Q0_VAL, DEC_n;
    
    wire SIGN_A, n_ZERO;

    divisorsito_fsm fsm (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .ready      (ready),
        .SIGN_A     (SIGN_A),
        .n_ZERO     (n_ZERO),
        .LOAD_M     (LOAD_M),
        .LOAD_Q     (LOAD_Q),
        .CLEAR_A    (CLEAR_A),
        .LOAD_n     (LOAD_n),
        .SHIFT_AQ   (SHIFT_AQ),
        .ADD_SUB    (ADD_SUB),
        .WRITE_A    (WRITE_A),
        .SET_Q0_EN  (SET_Q0_EN),
        .SET_Q0_VAL (SET_Q0_VAL),
        .DEC_n      (DEC_n)
    );

    divisorsito_datapath #(.N(N)) datapath (
        .clk           (clk),
        .rst           (rst),
        .dividend_in   (dividend_in),
        .divisor_in    (divisor_in),
        .Q_out         (quotient_out),
        .A_out         (remainder_out),
        .LOAD_M        (LOAD_M),
        .LOAD_Q        (LOAD_Q),
        .CLEAR_A       (CLEAR_A),
        .LOAD_n        (LOAD_n),
        .SHIFT_AQ      (SHIFT_AQ),
        .ADD_SUB       (ADD_SUB),
        .WRITE_A       (WRITE_A),
        .SET_Q0_EN     (SET_Q0_EN),
        .SET_Q0_VAL    (SET_Q0_VAL),
        .DEC_n         (DEC_n),
        .SIGN_A        (SIGN_A),
        .n_ZERO        (n_ZERO)
    );

endmodule