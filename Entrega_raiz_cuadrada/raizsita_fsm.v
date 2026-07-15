`timescale 1ns / 1ps

module raizsita_fsm (
    input  wire clk,
    input  wire rst,
    input  wire start,
    output reg  ready,
    
    // Señales de estado
    input  wire n_ZERO,    // ¿n == 0?
    input  wire A_GE_RF,   // ¿A >= RF?
    
    // Señales de control
    output reg LOAD_D,
    output reg CLEAR_A,
    output reg CLEAR_Q,
    output reg CLEAR_RF,
    output reg LOAD_n,
    output reg SHIFT_AD,   // SHIFT SHIFT A:D
    output reg CALC_RF,    // RF = (Q << 2) + 1
    output reg SUB_A,      // A = A - RF
    output reg INC_Q,      // Q = (Q << 1) + 1
    output reg SHIFT_Q,    // Q = Q << 1
    output reg DEC_n       // n = n - 1
);


    localparam [3:0] 
        IDLE    = 4'd0,
        INIT    = 4'd1,
        CHK_N   = 4'd2, // ¿n==0?
        SHIFT   = 4'd3, // SHIFT A:D
        CALC    = 4'd4, // RF = (Q<<2)+1
        COMP    = 4'd5, // ¿A>=RF?
        SUB     = 4'd6, // A=A-RF, Q=(Q<<1)+1, DEC n
        SHQ     = 4'd7, // Q=Q<<1, DEC n
        END_ST  = 4'd8;

    reg [3:0] state, next_state;

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
                next_state = CHK_N;
            end
            CHK_N: begin
                if (n_ZERO) next_state = END_ST;
                else        next_state = SHIFT;
            end
            SHIFT: begin
                next_state = CALC;
            end
            CALC: begin
                next_state = COMP;
            end
            COMP: begin
                if (A_GE_RF) next_state = SUB;
                else         next_state = SHQ;
            end
            SUB: begin
                next_state = CHK_N;
            end
            SHQ: begin
                next_state = CHK_N;
            end
            END_ST: begin
                        if (start) next_state = INIT;
                        else next_state = END_ST;
                    end
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        LOAD_D=0; CLEAR_A=0; CLEAR_Q=0; CLEAR_RF=0; LOAD_n=0;
        SHIFT_AD=0; CALC_RF=0; SUB_A=0; INC_Q=0; SHIFT_Q=0; DEC_n=0;
        ready=0;

        case (state)
            IDLE: begin end
            INIT: begin
                LOAD_D   = 1; // LOAD D
                CLEAR_A  = 1; // LOAD A (0)
                CLEAR_Q  = 1; // LOAD Q (0)
                CLEAR_RF = 1; // LOAD RF (0)
                LOAD_n   = 1; // LOAD n (4)
            end
            CHK_N: begin end
            SHIFT: begin
                SHIFT_AD = 1; // SHIFT SHIFT A:D
            end
            CALC: begin
                CALC_RF  = 1; // RF = (Q << 2) + 1
            end
            COMP: begin end
            SUB: begin
                SUB_A   = 1;  // A = A - RF
                INC_Q   = 1;  // Q = (Q << 1) + 1
                DEC_n   = 1;  // DEC n
            end
            SHQ: begin
                SHIFT_Q = 1;  // Q = Q << 1
                DEC_n   = 1;  // DEC n
            end
            END_ST: begin
                ready = 1;
            end
        endcase
    end

endmodule