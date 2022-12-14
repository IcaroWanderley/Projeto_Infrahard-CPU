module mux_pcsrc (   
    input wire [2:0] seletor,
    input wire [31:0] data_0, data_1, data_2, data_3, data_4,
    output wire [31:0] dataout
);
    assign dataout = (seletor == 3'b000) ? data_0 :
                     (seletor == 3'b001) ? data_1 :
                     (seletor == 3'b010) ? data_2 :
                     (seletor == 3'b011) ? data_3 :
                     (seletor == 3'b100) ? data_4 :
                     3'bx;
    
endmodule