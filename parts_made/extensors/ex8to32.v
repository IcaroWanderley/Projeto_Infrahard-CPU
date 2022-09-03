module ex16to32(
    input wire [8:0] datain,
    output wire [31:0] dataout
);
assign dataout= (datain[8]) ? {{9{1'b1}}, datain} : {{9{1'b0}}, datain}; 

endmodule