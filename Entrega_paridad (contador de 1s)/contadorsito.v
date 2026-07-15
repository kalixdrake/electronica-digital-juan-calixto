`timescale 1ns / 1ps

module contadorsito #(parameter N = 16)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [N-1:0] data_in,
    output wire ready,
    output wire [N-1:0] Q_out,
    output wire [N-1:0] A_out
);

    wire LOAD_Q, CLEAR_A, LOAD_n, INC_A, SHIFT_Q, DEC_n;
    
    wire Q_0, n_ZERO;

    // FSM
    contadorsito_fsm u_fsm (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .ready      (ready),
        .Q_0        (Q_0),
        .n_ZERO     (n_ZERO),
        .LOAD_Q     (LOAD_Q),
        .CLEAR_A    (CLEAR_A),
        .LOAD_n     (LOAD_n),
        .INC_A      (INC_A),
        .SHIFT_Q    (SHIFT_Q),
        .DEC_n      (DEC_n)
    );

    // Datapath
    contadorsito_datapath #(.N(N)) u_datapath (
        .clk        (clk),
        .rst        (rst),
        .data_in    (data_in),
        .Q_out      (Q_out),
        .A_out      (A_out),
        .LOAD_Q     (LOAD_Q),
        .CLEAR_A    (CLEAR_A),
        .LOAD_n     (LOAD_n),
        .INC_A      (INC_A),
        .SHIFT_Q    (SHIFT_Q),
        .DEC_n      (DEC_n),
        .Q_0        (Q_0),
        .n_ZERO     (n_ZERO)
    );

endmodule