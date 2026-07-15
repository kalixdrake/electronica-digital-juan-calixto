module multiplicadorsito #(parameter N = 16)(
    input clock,
    input reset,
    input start,
    input [N-1:0] M_in,
    input [N-1:0] Q_in,
    
    output done,
    output [2*N-1:0] result
);

    wire load_M, load_Q, clear_A, load_n, write_A, shift_AQ, dec_n;

    wire Q_0, n_ZERO;

    multiplicadorsito_fsm fsm (
        .clock(clock),
        .reset(reset),
        .start(start),
        .Q_0(Q_0),
        .n_ZERO(n_ZERO),
        .load_M(load_M),
        .load_Q(load_Q),
        .clear_A(clear_A),
        .load_n(load_n),
        .write_A(write_A),
        .shift_AQ(shift_AQ),
        .dec_n(dec_n),
        .done(done)
    );


    multiplicadorsito_datapath #(.N(N)) datapath (
        .clock(clock),
        .reset(reset),
        .M_in(M_in),
        .Q_in(Q_in),
        .load_M(load_M),
        .load_Q(load_Q),
        .clear_A(clear_A),
        .load_n(load_n),
        .write_A(write_A),
        .shift_AQ(shift_AQ),
        .dec_n(dec_n),
        .Q_0(Q_0),
        .n_ZERO(n_ZERO),
        .result(result),
        .A_debug(),
        .Q_debug(),
        .M_debug(),
        .n_debug()
    );

endmodule