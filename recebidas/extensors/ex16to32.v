module ex16to32(
    input wire [15:0] datain,
    output wire [31:0] dataout
);
assign dataout= (datain[15]) ? {{16{1'b1}}, datain} : {{16{1'b0}}, datain}; 

endmodule