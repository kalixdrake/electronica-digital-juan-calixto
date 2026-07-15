// Multiplexor 2:1 de N bits
// Si sel = 1, out = in0; si sel = 0, out = in1
module muxsito #(parameter N = 16) (
    input  [N-1:0] in0,
    input  [N-1:0] in1,
    input          sel,
    output [N-1:0] out
);
    assign out = sel ? in0 : in1;
endmodule
