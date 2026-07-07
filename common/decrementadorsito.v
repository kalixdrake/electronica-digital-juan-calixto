// Decrementador combinacional de N bits: dec = n - 1
module decrementadorsito #(parameter N = 4) (
    input  [N-1:0] n,
    output [N-1:0] dec
);
    assign dec = n - 1;
endmodule
