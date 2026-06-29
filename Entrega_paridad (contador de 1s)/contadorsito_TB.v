`timescale 1ns / 1ps

`ifdef BENCH
module contadorsito_TB;

    localparam N = 8;

    reg clk;
    reg rst;
    reg start;
    reg [N-1:0] data_in;

    wire ready;
    wire [N-1:0] Q_out;
    wire [N-1:0] A_out;

    contadorsito #(.N(N)) uut (
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
        $dumpfile("contadorsito_TB.vcd");
        $dumpvars(0, contadorsito_TB);
        `endif

        // Reset
        #10 rst = 0;
        
        //213 (11010101) -> 5 unos.
        #10;
        data_in = 8'd213; // 11010101
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 1 -> Dato: %b, Cantidad de 1's = %d", data_in, A_out);
        
        //0 (00000000) -> 0 unos
        #10;
        data_in = 8'd0;
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 2 -> Dato: %b, Cantidad de 1's = %d", data_in, A_out);

        //255 (11111111) -> 8 unos
        #10;
        data_in = 8'd255;
        start = 1;
        
        #10 start = 0;
        wait(ready == 1'b1);
        #10;
        $display("Test 3 -> Dato: %b, Cantidad de 1's = %d", data_in, A_out);

        #20 $finish;
    end

endmodule
`endif