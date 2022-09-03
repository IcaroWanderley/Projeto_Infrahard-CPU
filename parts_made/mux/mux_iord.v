module mux_iord (   
    input wire [1:0] seletor,
    input wire [31:0] data_0, data_1, data_2, data_3,
    output wire [31:0] dataout
);
    assign dataout = (selector == 2'b00) ? data_0 :
                     (selector == 2'b01) ? data_1 :
                     (selector == 2'b10) ? data_2 :
                     (selector == 2'b11) ? data_3 :
                     32'bx;
    
endmodule