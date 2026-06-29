`timescale 1ns / 1ps

module raizsita #(parameter N = 8)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [N-1:0] data_in,
    output wire ready,
    output wire [((N+1)>>1)-1:0] Q_out,
    output wire [N-1:0] A_out
);

    wire LOAD_D, CLEAR_A, CLEAR_Q, CLEAR_RF, LOAD_n;
    wire SHIFT_AD, CALC_RF, SUB_A, INC_Q, SHIFT_Q, DEC_n;
    
    wire n_ZERO, A_GE_RF;

    // FSM
    raizsita_fsm u_fsm (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .ready      (ready),
        .n_ZERO     (n_ZERO),
        .A_GE_RF    (A_GE_RF),
        .LOAD_D     (LOAD_D),
        .CLEAR_A    (CLEAR_A),
        .CLEAR_Q    (CLEAR_Q),
        .CLEAR_RF   (CLEAR_RF),
        .LOAD_n     (LOAD_n),
        .SHIFT_AD   (SHIFT_AD),
        .CALC_RF    (CALC_RF),
        .SUB_A      (SUB_A),
        .INC_Q      (INC_Q),
        .SHIFT_Q    (SHIFT_Q),
        .DEC_n      (DEC_n)
    );

    // Datapath
    raizsita_datapath #(.N(N)) u_datapath (
        .clk        (clk),
        .rst        (rst),
        .data_in    (data_in),
        .Q_out      (Q_out),
        .A_out      (A_out),
        .LOAD_D     (LOAD_D),
        .CLEAR_A    (CLEAR_A),
        .CLEAR_Q    (CLEAR_Q),
        .CLEAR_RF   (CLEAR_RF),
        .LOAD_n     (LOAD_n),
        .SHIFT_AD   (SHIFT_AD),
        .CALC_RF    (CALC_RF),
        .SUB_A      (SUB_A),
        .INC_Q      (INC_Q),
        .SHIFT_Q    (SHIFT_Q),
        .DEC_n      (DEC_n),
        .n_ZERO     (n_ZERO),
        .A_GE_RF    (A_GE_RF)
    );

endmodule