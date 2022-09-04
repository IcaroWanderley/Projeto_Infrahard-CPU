module mux_datasrc (   
    input wire [3:0] seletor,
    input wire [31:0] data_0, data_1, data_2, data_3, data_4, data_5, data_6, data_7,
    output wire [31:0] dataout
);
    assign dataout = (seletor == 4'b0000) ? data_0 :
                     (seletor == 4'b0001) ? data_1 :
                     (seletor == 4'b0010) ? data_2 :
                     (seletor == 4'b0011) ? data_3 :
                     (seletor == 4'b0100) ? data_4 :
                     (seletor == 4'b0101) ? data_5 :
                     (seletor == 4'b0110) ? data_6 :
                     (seletor == 4'b0111) ? data_7 :
                     (seletor == 4'b1000) ? 32'd227:
                     32'bx;
    
endmodule