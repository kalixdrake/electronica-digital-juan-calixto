module multiplicadorsito_fsm (
    input clock,
    input reset,
    input start,
    input Q_0,
    input n_ZERO,

    output reg load_M,
    output reg load_Q,
    output reg clear_A,
    output reg load_n,
    output reg write_A,
    output reg shift_AQ,
    output reg dec_n,
    output reg done
    );
    
    localparam  INIT = 4'd0,
                LOAD_M = 4'd1,
                LOAD_Q = 4'd2,
                CLEAR_A = 4'd3,
                LOAD_N = 4'd4,
                CHECK_Q0 = 4'd5,
                ADD_AM = 4'd6,
                SHIFT_AQ = 4'd7,
                DEC_N = 4'd8,
                END_STATE = 4'd9;

    reg [3:0] state, next_state;


    always @(posedge clock or posedge reset) begin
        if (reset) state <=INIT;
        else state <=next_state;
    end

    //Cambio de estados
    always @(*) begin
        next_state = state;

        case(state)
            INIT:       if (start) next_state = LOAD_M;
            LOAD_M:     next_state = LOAD_Q;
            LOAD_Q:     next_state = CLEAR_A;
            CLEAR_A:    next_state = LOAD_N;
            LOAD_N:     next_state = CHECK_Q0;
            CHECK_Q0:   begin
                            if (Q_0 == 1'b1) next_state = ADD_AM;
                            else next_state = SHIFT_AQ;
                        end
            ADD_AM:     next_state = SHIFT_AQ;
            SHIFT_AQ:   next_state = DEC_N;
            DEC_N:      begin
                            if (n_ZERO == 1'b1) next_state = END_STATE;
                            else next_state = CHECK_Q0;
                        end
            END_STATE: begin
                            if (!start) next_state = END_STATE;
                            else next_state = INIT;
                       end
        endcase
    end

    //activacion de salidas
    //las pongo todas en 0 primero para evitar que Camargo me regañe si sale un latch por ahí
    always @(*) begin
        load_M = 0;
        load_Q = 0;
        clear_A = 0;
        load_n = 0;
        write_A = 0;
        shift_AQ = 0;
        dec_n = 0;
        done = 0;

        case(state)
            INIT:       ;
            LOAD_M:     load_M = 1'b1;
            LOAD_Q:     load_Q = 1'b1;
            CLEAR_A:    begin
                            clear_A = 1'b1;
                            write_A = 1'b1;
                        end
            LOAD_N:     load_n = 1'b1;
            CHECK_Q0:   ;
            ADD_AM:     write_A = 1'b1;
            SHIFT_AQ:   shift_AQ = 1'b1;
            DEC_N:      dec_n = 1'b1;
            END_STATE: done = 1'b1;
        endcase
    end

endmodule