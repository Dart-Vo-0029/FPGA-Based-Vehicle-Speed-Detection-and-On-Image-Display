`timescale 1ns/1ps

module tb_syn_gen;

reg         I_pxl_clk;
reg         I_rst_n;

reg [15:0]  I_h_total;
reg [15:0]  I_h_sync;
reg [15:0]  I_h_bporch;
reg [15:0]  I_h_res;

reg [15:0]  I_v_total;
reg [15:0]  I_v_sync;
reg [15:0]  I_v_bporch;
reg [15:0]  I_v_res;

reg [15:0]  I_rd_hres;
reg [15:0]  I_rd_vres;

reg         I_hs_pol;
reg         I_vs_pol;

wire        O_rden;
wire        O_de;
wire        O_hs;
wire        O_vs;

// DUT
syn_gen dut (
    .I_pxl_clk(I_pxl_clk),
    .I_rst_n(I_rst_n),

    .I_h_total(I_h_total),
    .I_h_sync(I_h_sync),
    .I_h_bporch(I_h_bporch),
    .I_h_res(I_h_res),

    .I_v_total(I_v_total),
    .I_v_sync(I_v_sync),
    .I_v_bporch(I_v_bporch),
    .I_v_res(I_v_res),

    .I_rd_hres(I_rd_hres),
    .I_rd_vres(I_rd_vres),

    .I_hs_pol(I_hs_pol),
    .I_vs_pol(I_vs_pol),

    .O_rden(O_rden),
    .O_de(O_de),
    .O_hs(O_hs),
    .O_vs(O_vs)
);

// ================= CLOCK =================
initial begin
    I_pxl_clk = 0;
    forever #10 I_pxl_clk = ~I_pxl_clk; // 50MHz pixel clock
end

// ================= RESET =================
initial begin
    I_rst_n = 0;

    I_h_total  = 16'd800;
    I_h_sync   = 16'd96;
    I_h_bporch = 16'd48;
    I_h_res    = 16'd640;

    I_v_total  = 16'd525;
    I_v_sync   = 16'd2;
    I_v_bporch = 16'd33;
    I_v_res    = 16'd480;

    I_rd_hres  = 16'd640;
    I_rd_vres  = 16'd480;

    I_hs_pol = 0;
    I_vs_pol = 0;

    #100;
    I_rst_n = 1;
end

// ================= WAVEFORM =================
initial begin
    $dumpfile("syn_gen.vcd");
    $dumpvars(0, tb_syn_gen);
end

// ================= RUN TIME =================
initial begin
    #200000;  // long enough for multiple frames
    $finish;
end

endmodule