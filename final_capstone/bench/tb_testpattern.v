`timescale 1ns/1ps

module tb_testpattern;

reg         I_pxl_clk;
reg         I_rst_n;

reg  [31:0] Measured_val;
reg         in_key;

reg         pclk;
reg         preset_n;
reg         psel;
reg         penable;
reg         pwrite;
reg  [7:0]  paddr;
reg  [31:0] pwdata;

reg  [9:0]  PIXDATA;
reg         PIXCLK;
reg         HREF;
reg         VSYNC;

wire [31:0] prdata;
wire        pready;
wire [11:0] E_hcnt;
wire [11:0] E_vcnt;
wire        o_CLK565;
wire        V_pos;
wire        O_vs;
wire [15:0] O_data;
wire [8:0]  word_addr;

// DUT
testpattern dut (
    .I_pxl_clk(I_pxl_clk),
    .I_rst_n(I_rst_n),
    .Measured_val(Measured_val),
    .in_key(in_key),

    .pclk(pclk),
    .preset_n(preset_n),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready),

    .PIXDATA(PIXDATA),
    .PIXCLK(PIXCLK),
    .HREF(HREF),
    .VSYNC(VSYNC),

    .E_hcnt(E_hcnt),
    .E_vcnt(E_vcnt),
    .o_CLK565(o_CLK565),
    .V_pos(V_pos),
    .O_vs(O_vs),
    .O_data(O_data),
    .word_o(16'hA5A5),
    .word_addr(word_addr)
);

// ================= CLOCKS =================
initial begin
    I_pxl_clk = 0;
    forever #10 I_pxl_clk = ~I_pxl_clk; // 50MHz pixel clock
end

initial begin
    PIXCLK = 0;
    forever #20 PIXCLK = ~PIXCLK; // camera clock slower
end

initial begin
    pclk = 0;
    forever #5 pclk = ~pclk; // APB clock 100MHz
end

// ================= RESET =================
initial begin
    I_rst_n = 0;
    preset_n = 0;

    HREF = 0;
    VSYNC = 1;
    PIXDATA = 0;

    Measured_val = 32'h12345678;
    in_key = 0;

    psel = 0;
    penable = 0;
    pwrite = 0;
    paddr = 0;
    pwdata = 0;

    #100;
    I_rst_n = 1;
    preset_n = 1;
end

// ================= CAMERA STIMULUS =================
reg [9:0] pixel_cnt;

always @(posedge PIXCLK) begin
    if (!I_rst_n) begin
        PIXDATA <= 0;
        HREF <= 0;
        VSYNC <= 1;
        pixel_cnt <= 0;
    end else begin

        VSYNC <= 0;
        HREF  <= 1;

        // fake grayscale ramp
        PIXDATA <= pixel_cnt;

        pixel_cnt <= pixel_cnt + 1;

        // simulate line break
        if (pixel_cnt == 300) begin
            HREF <= 0;
        end
    end
end

// ================= APB WRITE TEST =================
initial begin
    #200;

    apb_write(8'h00, 32'h11223344);
    apb_write(8'h04, 32'h00000001);

    #500;

    apb_write(8'h00, 32'hAABBCCDD);
end

task apb_write(input [7:0] addr, input [31:0] data);
begin
    @(posedge pclk);
    paddr = addr;
    pwdata = data;
    pwrite = 1;
    psel = 1;
    penable = 0;

    @(posedge pclk);
    penable = 1;

    @(posedge pclk);
    psel = 0;
    penable = 0;
    pwrite = 0;
end
endtask

// ================= WAVEFORM =================
initial begin
    $dumpfile("testpattern.vcd");
    $dumpvars(0, tb_testpattern);
end

// ================= END =================
initial begin
    #5000;
    $finish;
end

endmodule