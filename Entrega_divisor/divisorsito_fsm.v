`timescale 1ns / 1ps

module divisorsito_fsm (
    input  wire clk,
    input  wire rst,
    input  wire start,
    
    // Señales de estado
    input  wire SIGN_A,
    input  wire n_ZERO,
    
    // Señales de control
    output reg ready,
    output reg LOAD_M,
    output reg LOAD_Q,
    output reg CLEAR_A,
    output reg LOAD_n,
    output reg SHIFT_AQ,
    output reg ADD_SUB,
    output reg WRITE_A,
    output reg SET_Q0_EN,
    output reg SET_Q0_VAL,
    output reg DEC_n
);


    localparam [2:0] 
        IDLE     = 3'd0,
        INIT     = 3'd1,
        SHIFT    = 3'd2,
        SUB      = 3'd3, // A = A - M
        RESTORE  = 3'd4, // RESTORE A = A + M, SET Q_0=0
        SET_Q    = 3'd5, // SET Q_0=1
        CHECK    = 3'd6,
        END_ST   = 3'd7;

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
                next_state = SHIFT;
            end
            SHIFT: begin
                next_state = SUB;
            end
            SUB: begin
                if (SIGN_A) next_state = RESTORE; 
                else        next_state = SET_Q;
            end
            RESTORE: begin
                next_state = CHECK;
            end
            SET_Q: begin
                next_state = CHECK;
            end
            CHECK: begin
                if (n_ZERO) next_state = END_ST;
                else        next_state = SHIFT;
            end
            END_ST: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin

        LOAD_M=0; LOAD_Q=0; CLEAR_A=0; LOAD_n=0;
        SHIFT_AQ=0; ADD_SUB=0; WRITE_A=0;
        SET_Q0_EN=0; SET_Q0_VAL=0; DEC_n=0;
        ready=0;

        case (state)
            IDLE: begin end
            INIT: begin
                LOAD_M  = 1; 
                LOAD_Q  = 1; 
                CLEAR_A = 1; 
                LOAD_n  = 1; 
            end
            SHIFT: begin
                SHIFT_AQ = 1;
            end
            SUB: begin
                ADD_SUB = 1;
                WRITE_A = 1;
            end
            RESTORE: begin
                ADD_SUB    = 0;
                WRITE_A    = 1;
                SET_Q0_EN  = 1;
                SET_Q0_VAL = 0;
                DEC_n      = 1;
            end
            SET_Q: begin
                SET_Q0_EN  = 1;
                SET_Q0_VAL = 1;
                DEC_n      = 1;
            end
            CHECK: begin end
            END_ST: begin
                ready = 1;
            end
        endcase
    end

endmodule