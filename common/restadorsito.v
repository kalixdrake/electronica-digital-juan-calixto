// Restador combinacional de N bits: diff = a - b
module restadorsito #(parameter N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] diff
);
    assign diff = a - b;
endmodule
