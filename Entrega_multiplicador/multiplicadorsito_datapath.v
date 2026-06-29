module multiplicadorsito_datapath #(parameter N = 4)(
    input clock,
    input reset,
    input [N-1:0] M_in,
    input [N-1:0] Q_in,
    input load_M,
    input load_Q,
    input clear_A,
    input load_n,
    input write_A,
    input shift_AQ,
    input dec_n,
    
    output Q_0,
    output n_ZERO,
    output [2*N-1:0] result,
    
    output [N-1:0] A_debug,
    output [N-1:0] Q_debug,
    output [N-1:0] M_debug,
    output [N-1:0] n_debug
);


    reg [N-1:0] M, Q, A, n;
    wire [N-1:0] sum_out; // ALU 
    wire [N-1:0] n_dec;   // decrementador
    wire [N-1:0] A_input; // Multiplexor

    assign sum_out = A + M;
    
    assign n_dec = n - 1;
    
    // Si clear_A es 1, la entrada a A es 0. Si no, es la suma de la ALU.
    assign A_input = clear_A ? {N{1'b0}} : sum_out;

    assign Q_0 = Q[0];
    assign n_ZERO = (n == 0) ? 1'b1 : 1'b0;

    assign result = {A, Q};

    // Señales para GTKWave
    assign A_debug = A;
    assign Q_debug = Q;
    assign M_debug = M;
    assign n_debug = n;

    // Ahora si el datapath
    always @(negedge clock or posedge reset) begin
        if (reset) begin
            M <= 0;
            Q <= 0;
            A <= 0;
            n <= 0;
        end else begin
            if (load_M) M <= M_in;
            
            if (load_Q) Q <= Q_in;
            
            if (load_n)  n <= N;       
            if (dec_n)   n <= n_dec;   
            
            if (write_A) A <= A_input;
            
            if (shift_AQ) begin
                A <= {1'b0, A[N-1:1]};
                Q <= {A[0], Q[N-1:1]};
            end
        end
    end

endmodule