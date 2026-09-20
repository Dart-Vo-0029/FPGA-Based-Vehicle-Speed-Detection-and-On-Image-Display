module APB_bus_regs(
    input  wire        pclk,
    input  wire        preset_n,
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [7:0]  paddr,
    input  wire [31:0] pwdata,

    output reg  [31:0] prdata,
    output reg         pready,

    output reg  [31:0] velocity   
);

    wire [1:0] wordaddr;
    assign wordaddr = paddr[3:2];

    always @(posedge pclk or negedge preset_n) begin
        if (!preset_n) begin
            velocity <= 32'd0;
            pready   <= 1'b0;
            prdata   <= 32'd0;
        end else begin
            pready <= 1'b0;

            if (psel && !penable) begin
                pready <= 1'b1;

                if (pwrite) begin
                    case (wordaddr)
                        2'b00: velocity <= pwdata;  // 0x40002400
                    endcase
                end else begin
                    case (wordaddr)
                        2'b00: prdata <= velocity;
                        default: prdata <= 32'd0;
                    endcase
                end
            end
        end
    end

endmodule