module mux_ex_cause (   
    input wire [1:0] seletor,
    output wire [31:0] dataout
);
    assign dataout = (seletor == 2'b00) ? 32'd253 :
                     (seletor == 2'b01) ? 32'd254 :
                     (seletor == 2'b10) ? 32'd255 :
                     32'bxx;
    
endmodule