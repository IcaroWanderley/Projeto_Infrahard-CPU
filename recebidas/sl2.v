module sl2 (
    input wire [31:0] datain,
    output wire [31:0] dataout
);
assign dataout = datain<<2;

endmodule