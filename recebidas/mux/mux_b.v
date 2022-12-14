module mux_b (   
    input wire [1:0] seletor,
    input wire [31:0] data_0, data_1, data_2,
   output wire [31:0] dataout
);
    assign dataout = (seletor == 2'b00) ? data_0 :
                     (seletor == 2'b01) ? 32'd4  :
                     (seletor == 2'b10) ? data_1 :
                     (seletor == 2'b11) ? data_2 :
                     32'bxx;
endmodule