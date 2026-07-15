`timescale 1ns / 1ps

module raizsita_datapath #(parameter N = 16)(
    input  wire clk,
    input  wire rst,
    
    input  wire [N-1:0] data_in, // Entrada
    output wire [((N+1)>>1)-1:0] Q_out,   // Raíz cuadrada
    output wire [N-1:0] A_out,   // Residuo
    
    // Señales de control
    input  wire LOAD_D,
    input  wire CLEAR_A,
    input  wire CLEAR_Q,
    input  wire CLEAR_RF,
    input  wire LOAD_n,
    input  wire SHIFT_AD,
    input  wire CALC_RF,
    input  wire SUB_A,
    input  wire INC_Q,
    input  wire SHIFT_Q,
    input  wire DEC_n,
    
    // Señales de estado
    output wire n_ZERO,
    output wire A_GE_RF
);

    localparam Q_W = (N + 1) >> 1;  // N/2

    // Registros
    reg [N-1:0]    D;
    reg [N-1:0]    A;       // Registro A (Acumulador/Residuo)
    reg [Q_W-1:0]  Q;       // Registro Q (Raíz)
    reg [N-1:0]    RF;
    reg [Q_W-1:0]  n;
    
    // --- Cables para módulos combinacionales ---
    
    // Restador: A - RF
    wire [N-1:0] A_sub_RF;
    restadorsito #(.N(N)) U_SUB_A (.a(A), .b(RF), .diff(A_sub_RF));
    
    // Sumador para RF_next = (Q << 2) + 1
    wire [N-1:0] Q_shifted_2;
    wire [N-1:0] RF_next;
    assign Q_shifted_2 = { {(N - Q_W - 2){1'b0}}, Q, 2'b0 };
    sumadorsito #(.N(N)) U_SUM_RF (.a(Q_shifted_2), .b({{(N-1){1'b0}}, 1'b1}), .sum(RF_next));
    
    // Sumador para Q_inc = (Q << 1) + 1
    wire [Q_W-1:0] Q_shifted_1;
    wire [Q_W-1:0] Q_inc;
    assign Q_shifted_1 = {Q[Q_W-2:0], 1'b0};
    sumadorsito #(.N(Q_W)) U_SUM_Q (.a(Q_shifted_1), .b({{(Q_W-1){1'b0}}, 1'b1}), .sum(Q_inc));
    
    // Decrementador: n - 1
    wire [Q_W-1:0] n_dec;
    decrementadorsito #(.N(Q_W)) U_DEC (.n(n), .dec(n_dec));
    
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            D <= 0; A <= 0; Q <= 0; RF <= 0; n <= 0;
        end else begin
            if (LOAD_D)
                D <= data_in;
                
            if (CLEAR_A)
                A <= 0;
            else if (SHIFT_AD)
                A <= (A << 2) | (D >> (N-2)); // A:D se desplaza 2 izquierda
            else if (SUB_A)
                A <= A_sub_RF;
                
            if (SHIFT_AD)
                D <= D << 2;
                
            if (CLEAR_RF)
                RF <= 0;
            else if (CALC_RF)
                RF <= RF_next;
                
            if (CLEAR_Q)
                Q <= 0;
            else if (INC_Q)
                Q <= Q_inc;
            else if (SHIFT_Q)
                Q <= Q << 1;       // Q = Q << 1
                
            if (LOAD_n)
                n <= Q_W;            // N/2 iteraciones para N bits
            else if (DEC_n)
                n <= n_dec;
        end
    end
    
    // Salidas de estado (Combinacional)
    assign n_ZERO  = (n == 0);
    assign A_GE_RF = (A >= RF);
    
    // Salidas finales
    assign Q_out = Q;
    assign A_out = A;

endmodule