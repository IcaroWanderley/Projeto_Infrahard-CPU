module control(
    input wire clk, reset, overflow, [5:0] Irout31to26, funct,
    output reg regpc_write,
    output reg regMdr,
    output reg regwriteA,
    output reg regwriteB,
    output reg regaluoutctrl,
    output reg regepcCtrl,
    output reg regmem_read,
    output reg regir_write,
    output reg regregwrite,
    output reg [1:0] muxExcpCtrl,
    output reg [1:0] muxiord,
    output reg [1:0] muxRegDst,
    output reg [3:0] muxDataSrc,
    output reg [1:0] muxAluSrcA,
    output reg [1:0] muxAluSrcB,
    output reg [2:0] muxpc_src,
    output reg [2:0] Alu_control
);

    reg [5:0] estado;
    reg [4:0] contador;

    parameter sreseta = 6'b000_000;
    parameter sfetch = 6'b000_001;
    parameter sdecode = 6'b000_010;
    parameter soperror = 6'b000_011;
    parameter soverflow = 6'b000_100;
    parameter sADD = 6'b000_101;
    parameter sAND = 6'b000_110;
    parameter sSUB = 6'b000_111;
    parameter sADDI = 6'b001_000;

    parameter op_r = 6'b000_000;

    parameter op_ADDI = 6'b001_000;

    parameter functadd = 6'b100_000;
    parameter functand = 6'b100_100;
    parameter functsub = 6'b100_010;

    always @(posedge clk) begin
        if(reset == 1'b1 || estado == sreseta) begin
            regpc_write = 1'b0;
            regMdr = 1'b0;
            regwriteA = 1'b0;
            regwriteB = 1'b0;
            regaluoutctrl = 1'b0;
            regepcCtrl = 1'b0;
            regmem_read = 1'b0;
            regir_write = 1'b0;
            regregwrite = 1'b0;
            muxExcpCtrl = 2'b00;
            muxiord = 2'b00;
            muxAluSrcA = 2'b00;
            muxAluSrcB = 2'b00;
            muxpc_src = 3'b000;
            Alu_control = 3'b000;

            regregwrite = 1'b1;
            muxRegDst = 2'b10;
            muxDataSrc = 4'b1000;

            contador = 5'b00000;
            estado = sfetch;
        end else begin      
            case (estado)
                sfetch: begin
                    if(contador != 5'b00011) begin
                        regpc_write = 1'b0;
                        regwriteA = 1'b0;
                        regwriteB = 1'b0;
                        regregwrite = 1'b0;
                        regaluoutctrl = 1'b0;
                        regepcCtrl = 1'b0;
                        regir_write = 1'b0;
                        regmem_read = 1'b0;
                        regMdr = 1'b0;

                        muxiord = 2'b00;
                        regmem_read = 1'b0;
                        muxAluSrcA = 2'b00;
                        muxAluSrcB = 2'b01;
                        Alu_control = 3'b001;

                        contador = contador + 5'b00001;
                    end else begin
                        regmem_read = 1'b0;
                        regir_write = 1'b1;
                        muxpc_src = 3'b000;
                        regpc_write = 1'b1;

                        contador = 5'b00000;
                        estado = sdecode;
                    end
                end
                sdecode: begin
                    if (contador == 5'b00000) begin
                        regir_write = 1'b0;
                        regpc_write = 1'b0;

                        muxAluSrcA = 2'b00;
                        muxAluSrcB = 2'b01;
                        Alu_control = 3'b001;
                        regaluoutctrl = 1'b1;

                        contador = contador + 5'b00001;
                    end else if(contador == 5'b00001) begin
                        regaluoutctrl = 1'b0;

                        regwriteA = 1'b1;
                        regwriteB = 1'b1;

                        contador = 5'b00000;

                        case(Irout31to26)
                            op_r: begin
                                case(funct)
                                    functadd: begin
                                        estado = sADD;
                                    end
                                    functand: begin
                                        estado = sAND;
                                    end
                                    functsub: begin
                                        estado = sSUB;
                                    end
                                endcase
                            end
                            op_ADDI: begin
                                estado = sADDI;
                            end
                            default:
                                estado = soperror;
                        endcase
                    end
                end
                soperror: begin
                    if(contador == 5'b00000 || contador == 5'b00001 || contador == 5'b00010) begin
                        regpc_write = 1'b0;
                        regwriteA = 1'b0;
                        regwriteB = 1'b0;
                        regaluoutctrl = 1'b0;
                        regepcCtrl = 1'b0;
                        regmem_read = 1'b0;
                        regir_write = 1'b0;

                        muxExcpCtrl = 2'b00;
                        muxiord = 2'b11;
                        regmem_read = 1'b1;
                        muxAluSrcA = 2'b00;
                        muxAluSrcB = 2'b01;
                        Alu_control = 3'b010;

                        contador = contador + 5'b00001;
                    end else if(contador == 5'b00011) begin
                        regmem_read = 1'b0;
                        regepcCtrl = 1'b1;

                        contador = contador + 5'b00001;
                    end else begin
                        regepcCtrl = 1'b0;

                        muxpc_src = 3'b011;
                        regpc_write = 1'b1;

                        contador = 5'b00000;
                        estado = sfetch;
                    end
                end
                soverflow: begin
                    if(contador == 5'b00000 || contador == 5'b00001 || contador == 5'b00010) begin
                        regpc_write = 1'b0;
                        regwriteA = 1'b0;
                        regwriteB = 1'b0;
                        regaluoutctrl = 1'b0;
                        regepcCtrl = 1'b0;
                        regmem_read = 1'b0;
                        regir_write = 1'b0;

                        muxExcpCtrl = 2'b01;
                        muxiord = 2'b11;
                        regmem_read = 1'b1;
                        muxAluSrcA = 2'b00;
                        muxAluSrcB = 2'b01;
                        Alu_control = 3'b010;

                        contador = contador + 5'b00001;
                    end else if(contador == 5'b00011) begin
                        regmem_read = 1'b0;
                        regepcCtrl = 1'b1;

                        contador = contador + 5'b00001;
                    end else begin
                        regepcCtrl = 1'b0;

                        muxpc_src = 3'b011;
                        regpc_write = 1'b1;

                        contador = 5'b00000;
                        estado = sfetch;
                    end
                end
                sADD: begin
                    if(contador == 5'b00000) begin
                        regpc_write = 1'b0;
                        regwriteA = 1'b0;
                        regwriteB = 1'b0;
                        regaluoutctrl = 1'b0;
                        regepcCtrl = 1'b0;
                        regmem_read = 1'b0;
                        regir_write = 1'b0;

                        muxAluSrcA = 2'b01;
                        muxAluSrcB = 2'b00;
                        Alu_control = 3'b001;
                        regaluoutctrl = 1'b1;

                        contador = contador + 5'b00001;
                    end else if(contador == 5'b00001) begin
                        regaluoutctrl = 1'b0;
                        if(overflow == 1'b1) begin
                            contador = 5'b00000;
                            estado = soverflow;
                        end else begin
                            muxDataSrc = 4'b0000;
                            muxRegDst = 2'b01;
                            regregwrite = 1'b1;

                            contador = 5'b00000;
                            estado = sfetch;
                        end
                    end
                end
                sAND: begin
                    if(contador == 5'b00000) begin
                        regpc_write = 1'b0;
                        regwriteA = 1'b0;
                        regwriteB = 1'b0;
                        regaluoutctrl = 1'b0;
                        regepcCtrl = 1'b0;
                        regmem_read = 1'b0;
                        regir_write = 1'b0;

                        muxAluSrcA = 2'b01;
                        muxAluSrcB = 2'b00;
                        Alu_control = 3'b011;
                        regaluoutctrl = 1'b1;

                        contador = contador + 5'b00001;
                    end else if(contador == 5'b00001) begin
                        regaluoutctrl = 1'b0;
                        
                        muxDataSrc = 4'b0000;
                        muxRegDst = 2'b01;
                        regregwrite = 1'b1;

                        contador = 5'b00000;
                        estado = sfetch;
                    end
                end
                sSUB: begin
                    if(contador == 5'b00000) begin
                        regpc_write = 1'b0;
                        regwriteA = 1'b0;
                        regwriteB = 1'b0;
                        regaluoutctrl = 1'b0;
                        regepcCtrl = 1'b0;
                        regmem_read = 1'b0;
                        regir_write = 1'b0;

                        muxAluSrcA = 2'b01;
                        muxAluSrcB = 2'b00;
                        Alu_control = 3'b010;
                        regaluoutctrl = 1'b1;

                        contador = contador + 5'b00001;
                    end else if(contador == 5'b00001) begin
                        regaluoutctrl = 1'b0;
                        if(overflow == 1'b1) begin
                            contador = 5'b00000;
                            estado = soverflow;
                        end else begin
                            muxDataSrc = 4'b0000;
                            muxRegDst = 2'b01;
                            regregwrite = 1'b1;

                            contador = 5'b00000;
                            estado = sfetch;
                        end
                    end
                end
                sADDI: begin
                    if(contador == 5'b00000) begin
                        regpc_write = 1'b0;
                        regwriteA = 1'b0;
                        regwriteB = 1'b0;
                        regaluoutctrl = 1'b0;
                        regepcCtrl = 1'b0;
                        regmem_read = 1'b0;
                        regir_write = 1'b0;

                        muxAluSrcA = 2'b01;
                        muxAluSrcB = 2'b10;
                        Alu_control = 3'b001;
                        regaluoutctrl = 1'b1;

                        contador = contador + 5'b00001;
                    end else if(contador == 5'b00001) begin
                        regaluoutctrl = 1'b0;
                        if(overflow == 1'b1) begin
                            contador = 5'b00000;
                            estado = soverflow;
                        end else begin
                            muxDataSrc = 4'b0000;
                            muxRegDst = 2'b00;
                            regregwrite = 1'b1;

                            contador = 5'b00000;
                            estado = sfetch;
                        end
                    end
                end
            endcase
        end
    end
endmodule 














