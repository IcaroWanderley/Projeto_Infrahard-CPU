module mux_regdestino (   
    input wire [1:0] seletor,
    input wire [4:0] data_0, data_1,
    output wire [4:0] dataout
);
    assign dataout = (seletor == 2'b00) ? data_0 :
                     (seletor == 2'b01) ? data_1 :
                     (seletor == 2'b10) ? 5'd29 :
                     (seletor == 2'b11) ? 5'd31 :
                     4'bx;
    
endmodule