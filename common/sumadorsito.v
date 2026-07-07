// Sumador combinacional de N bits: sum = a + b
module sumadorsito #(parameter N = 4) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] sum
);
    assign sum = a + b;
endmodule
