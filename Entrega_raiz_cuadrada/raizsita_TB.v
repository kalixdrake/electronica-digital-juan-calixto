`timescale 1ns / 1ps

`ifdef BENCH
module raizsita_TB;

    localparam N = 8;

    reg clk;
    reg rst;
    reg start;
    reg [N-1:0] data_in;

    wire ready;
    wire [((N+1)>>1)-1:0] Q_out;
    wire [N-1:0] A_out;

    raizsita #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .ready(ready),
        .Q_out(Q_out),
        .A_out(A_out)
    );

    // Reloj
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        data_in = 0;
        
        `ifdef SIM
        $dumpfile("raizsita_TB.vcd");
        $dumpvars(0, raizsita_TB);
        `endif

        // Reset
        #10 rst = 0;
        
        //25 -> Raiz = 5, Residuo = 0
        #10;
        data_in = 8'd25;
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 1 -> Dato: %d, Raiz = %d, Residuo = %d", data_in, Q_out, A_out);
        
        //200 -> Raiz = 14, Residuo = 4 (196 + 4)
        #10;
        data_in = 8'd200;
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 2 -> Dato: %d, Raiz = %d, Residuo = %d", data_in, Q_out, A_out);

        //64 -> Raiz = 8, Residuo = 0
        #10;
        data_in = 8'd64;
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 3 -> Dato: %d, Raiz = %d, Residuo = %d", data_in, Q_out, A_out);

        #20 $finish;
    end

endmodule
`endif