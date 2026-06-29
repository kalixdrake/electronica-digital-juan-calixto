`timescale 1ns / 1ps

module contadorsito_fsm (
    input  wire clk,
    input  wire rst,
    input  wire start,
    output reg  ready,
    
    // Señales de estado 
    input  wire Q_0,
    input  wire n_ZERO,
    
    // Señales de control
    output reg LOAD_Q,
    output reg CLEAR_A,
    output reg LOAD_n,
    output reg INC_A,
    output reg SHIFT_Q,
    output reg DEC_n
);

    // Definición de estados
    localparam [2:0] 
        IDLE    = 3'd0,
        INIT    = 3'd1,
        CHECK   = 3'd2,
        INC     = 3'd3,
        SHIFT   = 3'd4,
        CHECK_N = 3'd5,
        END_ST  = 3'd6;

    reg [2:0] state, next_state;


    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end


    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start) next_state = INIT;
            end
            INIT: begin
                next_state = CHECK;
            end
            CHECK: begin
                if (Q_0) next_state = INC;
                else     next_state = SHIFT;
            end
            INC: begin
                next_state = SHIFT;
            end
            SHIFT: begin
                next_state = CHECK_N;
            end
            CHECK_N: begin
                if (n_ZERO) next_state = END_ST;
                else        next_state = CHECK;
            end
            END_ST: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin

        LOAD_Q=0; CLEAR_A=0; LOAD_n=0;
        INC_A=0; SHIFT_Q=0; DEC_n=0;
        ready=0;

        case (state)
            IDLE: begin end
            INIT: begin
                LOAD_Q  = 1; // LOAD Q
                CLEAR_A = 1; // CLEAR A
                LOAD_n  = 1; // LOAD n
            end
            CHECK: begin end
            INC: begin
                INC_A = 1;   // A = A + 1
            end
            SHIFT: begin
                SHIFT_Q = 1; // SHIFT Q
                DEC_n   = 1; // DEC n (n=n-1)
            end
            CHECK_N: begin end
            END_ST: begin
                ready = 1;   // END
            end
        endcase
    end

endmodule