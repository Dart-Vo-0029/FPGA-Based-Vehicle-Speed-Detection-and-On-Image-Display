//====================================================
// IMAGE STREAM FIFO SYSTEM
// HyperRAM -> FIFO -> APB -> ESP32
// RGB565 XVGA
//====================================================

module image_stream
(
    input               I_rst_n,

    //========================================
    // CAMERA INPUT
    //========================================
    input               PIXCLK565,
    input               VSYNC,
    input               HREF,
    input       [15:0]  alt_dat,

    //========================================
    // APB
    //========================================
    input               pclk,
    input               preset_n,

    input               psel3,
    input               penable,
    input               pwrite,

    input       [31:0]  paddr,
    input       [31:0]  pwdata,

    output reg  [31:0]  prdata3,
    output              pready3,

    //========================================
    // HYPERRAM PHY
    //========================================
    input               I_clk,

    output              O_hpram_ck,
    output              O_hpram_ck_n,
    inout               IO_hpram_rwds,
    inout       [7:0]   IO_hpram_dq,
    output              O_hpram_reset_n,
    output              O_hpram_cs_n
);

//====================================================
// FRAME BUFFER SIGNALS
//====================================================

wire            cmd;
wire            cmd_en;
wire [21:0]     addr;
wire [31:0]     wr_data;
wire [3:0]      data_mask;

wire            rd_data_valid;
wire [31:0]     rd_data;

wire            init_calib;

wire            dma_clk;
wire            pix_clk;

//====================================================
// VIDEO OUTPUT
//====================================================

wire            off0_syn_de;
wire [15:0]     off0_syn_data;
wire            syn_off0_vs;

//====================================================
// PLL
//====================================================

wire memory_clk;
wire mem_pll_lock;

GW_PLLVR GW_PLLVR_inst
(
    .clkout(memory_clk),
    .lock(mem_pll_lock),
    .clkin(I_clk)
);

//====================================================
// HYPERRAM IP
//====================================================

HyperRAM_Memory_Interface_Top HyperRAM_Memory_Interface_Top_inst
(
    .clk            (I_clk),
    .memory_clk     (memory_clk),
    .pll_lock       (mem_pll_lock),
    .rst_n          (I_rst_n),

    .O_hpram_ck     (O_hpram_ck),
    .O_hpram_ck_n   (O_hpram_ck_n),
    .IO_hpram_rwds  (IO_hpram_rwds),
    .IO_hpram_dq    (IO_hpram_dq),
    .O_hpram_reset_n(O_hpram_reset_n),
    .O_hpram_cs_n   (O_hpram_cs_n),

    .wr_data        (wr_data),
    .rd_data        (rd_data),
    .rd_data_valid  (rd_data_valid),

    .addr           (addr),
    .cmd            (cmd),
    .cmd_en         (cmd_en),

    .clk_out        (dma_clk),

    .data_mask      (data_mask),
    .init_calib     (init_calib)
);

//====================================================
// FRAME BUFFER
//====================================================

Video_Frame_Buffer_Top Video_Frame_Buffer_Top_inst
(
    .I_rst_n            (I_rst_n & init_calib),
    .I_dma_clk          (dma_clk),

    .I_wr_halt          (1'b0),
    .I_rd_halt          (1'b0),

    // CAMERA INPUT
    .I_vin0_clk         (PIXCLK565),
    .I_vin0_vs_n        (VSYNC),
    .I_vin0_de          (HREF),
    .I_vin0_data        (alt_dat),

    .O_vin0_fifo_full   (),

    // VIDEO OUTPUT
    .I_vout0_clk        (pix_clk),
    .I_vout0_vs_n       (~syn_off0_vs),
    .I_vout0_de         (off0_syn_de),

    .O_vout0_den        (off0_syn_de),
    .O_vout0_data       (off0_syn_data),

    .O_vout0_fifo_empty (),

    // HYPERRAM
    .O_cmd              (cmd),
    .O_cmd_en           (cmd_en),
    .O_addr             (addr),
    .O_wr_data          (wr_data),
    .O_data_mask        (data_mask),

    .I_rd_data_valid    (rd_data_valid),
    .I_rd_data          (rd_data),

    .I_init_calib       (init_calib)
);

//====================================================
// PACK RGB565 -> 32BIT
//====================================================

reg [15:0] pixel_hold;
reg        pixel_toggle;

reg [31:0] fifo_din_r;
reg        fifo_wr_r;

wire [31:0] fifo_din;
wire        fifo_wr;

assign fifo_din = fifo_din_r;
assign fifo_wr  = fifo_wr_r;

always @(posedge pix_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
    begin
        pixel_hold   <= 16'd0;
        pixel_toggle <= 1'b0;
        fifo_wr_r    <= 1'b0;
    end
    else
    begin
        fifo_wr_r <= 1'b0;

        if(off0_syn_de)
        begin
            if(pixel_toggle == 1'b0)
            begin
                pixel_hold   <= off0_syn_data;
                pixel_toggle <= 1'b1;
            end
            else
            begin
                fifo_din_r   <= {pixel_hold, off0_syn_data};
                fifo_wr_r    <= 1'b1;
                pixel_toggle <= 1'b0;
            end
        end
    end
end

//====================================================
// FRAME DONE
//====================================================

reg vs_d0;
reg frame_done;

always @(posedge pix_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
    begin
        vs_d0       <= 1'b0;
        frame_done  <= 1'b0;
    end
    else
    begin
        vs_d0 <= syn_off0_vs;

        // falling edge
        if(vs_d0 && !syn_off0_vs)
            frame_done <= 1'b1;

        // clear from APB
        if(psel3 && penable && pwrite)
        begin
            if(paddr[5:2] == 4'h3)
                frame_done <= 1'b0;
        end
    end
end

//====================================================
// ASYNC FIFO
//====================================================

wire [31:0] fifo_dout;

reg         fifo_rd;

wire        fifo_empty;
wire        fifo_full;

wire [11:0] fifo_level;

Gowin_FIFO_Async u_fifo
(
    .wr_clk    (pix_clk),
    .rd_clk    (pclk),

    .din       (fifo_din),
    .wr_en     (fifo_wr),

    .rd_en     (fifo_rd),
    .dout      (fifo_dout),

    .full      (fifo_full),
    .empty     (fifo_empty),

    .rd_data_count(fifo_level)
);

//====================================================
// APB
//====================================================

assign pready3 = 1'b1;

always @(posedge pclk or negedge preset_n)
begin
    if(!preset_n)
    begin
        prdata3 <= 32'd0;
        fifo_rd <= 1'b0;
    end
    else
    begin
        fifo_rd <= 1'b0;

        if(psel3 && penable && !pwrite)
        begin
            case(paddr[5:2])

            //====================================
            // 0x00 FIFO DATA
            //====================================
            4'h0:
            begin
                if(!fifo_empty)
                begin
                    prdata3 <= fifo_dout;
                    fifo_rd <= 1'b1;
                end
                else
                begin
                    prdata3 <= 32'hDEADBEEF;
                end
            end

            //====================================
            // 0x04 FIFO LEVEL
            //====================================
            4'h1:
            begin
                prdata3 <= fifo_level;
            end

            //====================================
            // 0x08 STATUS
            //====================================
            4'h2:
            begin
                prdata3 <=
                {
                    29'd0,
                    frame_done,
                    fifo_full,
                    fifo_empty
                };
            end

            default:
            begin
                prdata3 <= 32'd0;
            end

            endcase
        end
    end
end

endmodule