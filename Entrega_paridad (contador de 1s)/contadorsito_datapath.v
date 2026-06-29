`timescale 1ns / 1ps

module contadorsito_datapath #(parameter N = 8)(
    input  wire clk,
    input  wire rst,
    
    input  wire [N-1:0] data_in,
    output wire [N-1:0] Q_out,
    output wire [N-1:0] A_out,
    
    input  wire LOAD_Q,
    input  wire CLEAR_A,
    input  wire LOAD_n,
    input  wire INC_A,
    input  wire SHIFT_Q,
    input  wire DEC_n,
    
    output wire Q_0,
    output wire n_ZERO
);

    localparam N_W = $clog2(N + 1);
    
    reg [N-1:0] Q;
    reg [N-1:0] A;
    reg [N_W-1:0] n;
    

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
            A <= 0;
            n <= 0;
        end else begin
            if (LOAD_Q)
                Q <= data_in;
            else if (SHIFT_Q)
                Q <= Q >> 1;
            
            if (CLEAR_A)
                A <= 0;
            else if (INC_A)
                A <= A + 1; // A = A + 1
                

            if (LOAD_n)
                n <= N;
            else if (DEC_n)
                n <= n - 1;
        end
    end
    
    assign Q_0 = Q[0];          // CHECK Q_0
    assign n_ZERO = (n == 0);   // n == 0?
    
    // Salidas
    assign Q_out = Q;
    assign A_out = A;

endmodule