`timescale 1ns / 1ps

`ifdef BENCH
module divisorsito_TB;

    reg clk;
    reg rst;
    reg start;
    reg [7:0] dividend_in;
    reg [7:0] divisor_in;

    wire ready;
    wire [7:0] quotient_out;
    wire [7:0] remainder_out;

    // Instanciar DUT
    divisorsito uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .dividend_in(dividend_in),
        .divisor_in(divisor_in),
        .ready(ready),
        .quotient_out(quotient_out),
        .remainder_out(remainder_out)
    );

    // Reloj
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        dividend_in = 0;
        divisor_in = 0;
        
        `ifdef SIM
        $dumpfile("divisorsito_TB.vcd");
        $dumpvars(0, divisorsito_TB);
        `endif

        // Reset
        #10 rst = 0;
        
        // Test 1: 25 / 4 = 6 (Resto 1)
        #10;
        dividend_in = 8'd25;
        divisor_in  = 8'd4;
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 1 -> 25 / 4: Cociente = %d, Resto = %d", quotient_out, remainder_out);
        
        // Test 2: 100 / 10 = 10 (Resto 0)
        #10;
        dividend_in = 8'd100;
        divisor_in  = 8'd10;
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 2 -> 100 / 10: Cociente = %d, Resto = %d", quotient_out, remainder_out);

        #20 $finish;
    end

endmodule
`endif