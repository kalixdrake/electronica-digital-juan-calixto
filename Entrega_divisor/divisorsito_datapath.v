`timescale 1ns / 1ps

module divisorsito_datapath (
    input  wire clk,
    input  wire rst,
    
    input  wire [7:0] dividend_in,
    input  wire [7:0] divisor_in,
    output wire [7:0] Q_out,
    output wire [7:0] A_out,
    
    // Señales de control
    input  wire LOAD_M,
    input  wire LOAD_Q,
    input  wire CLEAR_A,
    input  wire LOAD_n,
    input  wire SHIFT_AQ,
    input  wire ADD_SUB,
    input  wire WRITE_A,
    input  wire SET_Q0_EN,
    input  wire SET_Q0_VAL,
    input  wire DEC_n,
    
    // Señales de estado
    output wire SIGN_A,
    output wire n_ZERO
);

    localparam N = 16;
    
    // Registros
    reg signed [N:0]   M;
    reg        [N-1:0] Q;
    reg signed [N:0]   A;
    reg        [3:0]   n;
    
    // Lógica de la ALU
    wire signed [N:0] ALU_out;
    assign ALU_out = (ADD_SUB == 1'b0) ? (A + M) : (A - M);
    
    // Lógica de shift
    wire signed [N:0] A_shifted;
    wire [N-1:0] Q_shifted;
    assign A_shifted = {A[N-1:0], Q[N-1]}; // A se desplaza, mete MSB de Q
    assign Q_shifted = {Q[N-2:0], 1'b0};   // Q se desplaza, mete 0
    
    // Bloque COMPARE
    assign SIGN_A = A[N]; // Si el bit más significativo es 1, A es negativo
    assign n_ZERO = (n == 0);
    
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            M <= 0; Q <= 0; A <= 0; n <= 0;
        end else begin
            // REG M
            if (LOAD_M) 
                M <= {1'b0, divisor_in};
            
            // REG Q
            if (LOAD_Q)
                Q <= dividend_in;
            else if (SHIFT_AQ)
                Q <= Q_shifted;
            else if (SET_Q0_EN)
                Q[0] <= SET_Q0_VAL;
                
            // REG A
            if (CLEAR_A)
                A <= 0;
            else if (SHIFT_AQ)
                A <= A_shifted;
            else if (WRITE_A)
                A <= ALU_out;
                
            // REG n
            if (LOAD_n)
                n <= N;
            else if (DEC_n)
                n <= n - 1;
        end
    end
    
    assign Q_out = Q;
    assign A_out = A[N-1:0];

endmodule