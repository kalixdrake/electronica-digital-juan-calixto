`timescale 1ns / 1ps

module divisorsito_datapath #(parameter N = 8)(
    input  wire clk,
    input  wire rst,
    
    input  wire [N-1:0] dividend_in,
    input  wire [N-1:0] divisor_in,
    output wire [N-1:0] Q_out,
    output wire [N-1:0] A_out,
    
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

    localparam N_W = $clog2(N + 1);
    

    reg signed [N:0]   M;
    reg        [N-1:0] Q;
    reg signed [N:0]   A;
    reg        [N_W-1:0]   n;
    

    // Cables para la ALU modular: sumador + restador + multiplexor
    wire signed [N:0] sum_out;
    wire signed [N:0] sub_out;
    wire signed [N:0] ALU_out;

    sumadorsito #(.N(N+1)) U_SUM (
        .a(A),
        .b(M),
        .sum(sum_out)
    );

    restadorsito #(.N(N+1)) U_SUB (
        .a(A),
        .b(M),
        .diff(sub_out)
    );

    // ADD_SUB=0 → suma (in1=sum_out), ADD_SUB=1 → resta (in1=sub_out)
    muxsito #(.N(N+1)) U_MUX_ALU (
        .in0(sub_out),
        .in1(sum_out),
        .sel(ADD_SUB),
        .out(ALU_out)
    );

    // Cables para el shifter
    wire signed [N:0] A_shifted;
    wire [N-1:0] Q_shifted;
    assign A_shifted = {A[N-1:0], Q[N-1]}; // A se desplaza, mete 1
    assign Q_shifted = {Q[N-2:0], 1'b0};   // Q se desplaza, mete 0
    

    // Cable para el decrementador
    wire [N_W-1:0] n_dec;
    decrementadorsito #(.N(N_W)) U_DEC (
        .n(n),
        .dec(n_dec)
    );

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
                n <= n_dec;
        end
    end
    
    assign Q_out = Q;
    assign A_out = A[N-1:0];

endmodule