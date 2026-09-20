module APB_MCU_SPI(

    input  wire        pclk,
    input  wire        preset_n,

    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,

    input  wire [7:0]  paddr,

    output reg [31:0]  prdata,
    output reg         pready,

    input  wire [31:0] data_in
);

    always @(posedge pclk or negedge preset_n)
    begin
        if(!preset_n)
        begin
            prdata <= 32'd0;
            pready <= 1'b0;
        end
        else
        begin
            pready <= 1'b0;

            if(psel && !penable)
            begin
                pready <= 1'b1;

                if(!pwrite)
                begin
                    prdata <= data_in;
                end
            end
        end
    end

endmodule