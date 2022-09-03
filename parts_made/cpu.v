module cpu( 
    input clk, reset
);  
//controles
    wire regpc_write;
    wire [2:0] muxpc_src;
    wire [1:0] muxiord;
    wire [1:0] muxExcpCtrl;
    wire [1:0] muxRegDst;
    wire [3:0] muxDataSrc;
    wire [1:0] muxAluSrcA;
    wire [1:0] muxAluSrcB;
    wire regmem_read;
    wire regir_write;
    wire [2:0] Alu_control;
    wire regregwrite;
    wire regaluoutctrl;
    wire regepcCtrl;
    wire regMdr;
    wire regwriteA;
    wire regwriteB;

//saídas
    //pc
    wire [31:0] pc_out;
    wire [31:0] pc_srcout;
    //except
    wire [31:0] ExcpCtrlOut;
    wire [31:0] IorDout;
    //memory
    wire [31:0] Memoryout;
    //instructions
    wire [5:0] Irout31to26;
    wire [4:0] Irout25to21;
    wire [4:0] Irout20to16;
    wire [15:0] Irout15to0;
    //regDst
    wire [4:0] regdstout;
    //DataSrc
    wire [31:0] datasrcout;
    //extesors
    wire [31:0] SE16to32out;
    wire [31:0] SE8to32out;
    //registers bench
    wire [31:0] Data1out;
    wire [31:0] Data2out;
    wire [31:0] regAout;
    wire [31:0] regBout;
    //mux Alusrc A/B
    wire [31:0] alusrcAout;
    wire [31:0] alusrcBout;
    //Alucontrol
    wire [31:0] Alucontrolout;
    wire [31:0] Aluoutcontrolout;
    //Epccontrol
    wire [31:0] Epccontrolout;
    //mdr
    wire [31:0] mdrout;
    //shift left 2
    wire [31:0] shiftleftout;
    //overflow
    wire overflow;

    Registador PC(
        clk,
        reset,
        regpc_write,
        pc_srcout,
        pc_out
    );

    Registador MDR(
        clk,
        reset,
        regMdr,
        Memoryout,
        mdrout
    );

    Registador A(
        clk,
        reset,
        regwriteA,
        Data1out,
        regAout
    );

    Registador B(
        clk,
        reset,
        regwriteB,
        Data2out,
        regBout
    );

    Registador AluOutCtrl(
        clk,
        reset,
        regaluoutctrl,
        Alucontrolout,
        mdrout
    );

    Registador Epcctrl(
        clk,
        reset,
        regepcCtrl,
        Alucontrolout,
        Epccontrolout
    );

    Memoria memory(
        IorDout,
        clk,
        regmem_read,
        32'd0,
        Memoryout
    );

    Instr_Reg instruc(
        clk,
        reset,
        regir_write,
        Memoryout,
        Irout31to26,
        Irout25to21,
        Irout20to16,
        Irout15to0
    );

    Banco_reg regbench(
        clk, 
        reset,
        regregwrite,
        Irout25to21,
        Irout20to16,
        regdstout,
        darasrcout,
        Data1out,
        Data2out
    );

    sl2 shift_left(
        SE16to32out,
        shiftleftout
    );

    mux_ex_cause excpctrl(
        muxExcpCtrl,
        ExcpCtrlOut
    );

    muxiord iord(
        muxiord,
        pc_out,
        32'd0,
        32'd0,
        ExcpCtrlOut
    );

    mux_regdestino dst(
        muxRegDst,
        Irout20to16,
        Irout15to0 [15:11],
        5'd29,
        5'd31,
        regdstout
    );

    mux_datasrc src(
        muxDataSrc,
        Aluoutcontrolout,
        32'd0,
        32'd0,
        32'd0,
        32'd0,
        SE16to32out,
        32'd0,
        32'd0,
        32'd227,
        datasrcout
    );

    mux_a A(
        muxAluSrcA,
        pc_out,
        regAout,
        SE8to32out,
        32'd0,
        alusrcAout
    );

    mux_b B(
        muxAluSrcB,
        regBout,
        32'd4,
        SE16to32out,
        shiftleftout,
        alusrcBout
    );

    mux_pcsrc pcsource(
        muxpc_src,
        Alucontrolout,
        Aluoutcontrolout,
        32'd0,
        SE8to32out,
        Epccontrolout,
        pc_srcout
    );

    ula32 ULA(
        regAout,
        regBout,
        Alu_control,
        Alucontrolout,
        overflow,
        32'd0,
        32'd0,
        32'd0,
        32'd0,
        32'd0,
    );

    control controle(
        clk,
        reset,
        overflow,
        Irout31to26,
        Irout15to0 [5:0],
        //saida
        regpc_write,
        regMdr,
        regwriteA,
        regwriteB,
        regaluoutctrl,
        regepcCtrl,
        regmem_read,
        regir_write,
        regregwrite,
        muxExcpCtrl,
        muxiord,
        muxRegDst,
        muxDataSrc,
        muxAluSrcA,
        muxAluSrcB,
        muxpc_src,
        Alu_control
    );
endmodule