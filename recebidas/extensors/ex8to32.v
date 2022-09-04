module ex8to32(
    input wire [7:0] datain,
    output wire [31:0] dataout
);
    assign dataout = {{24{1'b0}}, datain};

endmodule