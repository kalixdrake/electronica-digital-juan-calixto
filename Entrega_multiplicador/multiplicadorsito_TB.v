`timescale 1ns / 1ps

module multiplicadorsito_TB;

    localparam N = 4;
    
    reg clock;
    reg reset;
    reg start;
    reg [N-1:0] M_in;
    reg [N-1:0] Q_in;
    
    wire done;
    wire [2*N-1:0] result;
    
    multiplicadorsito #(.N(N)) DUT (
        .clock(clock),
        .reset(reset),
        .start(start),
        .M_in(M_in),
        .Q_in(Q_in),
        .done(done),
        .result(result)
    );
    
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    initial begin

        reset = 1;
        start = 0;
        M_in = 0;
        Q_in = 0;
        
        #20;
        reset = 0;
        
        //3 x 5 
        M_in = 4'd3;
        Q_in = 4'd5;
        
        #10;
        start = 1;
        
        #10;
        start = 0;
        
        #200;
        
        $display("Resultado de 3x5 = %d", result);
        $finish;
    end

    initial begin
        $dumpfile("multiplicadorsito_TB.vcd");
        $dumpvars(0, multiplicadorsito_TB);
    end

endmodule