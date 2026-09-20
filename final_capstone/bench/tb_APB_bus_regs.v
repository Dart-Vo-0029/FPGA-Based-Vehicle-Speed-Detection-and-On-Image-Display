`timescale 1ns/1ps

module tb_APB_bus_regs;

reg         pclk;
reg         preset_n;
reg         psel;
reg         penable;
reg         pwrite;
reg [7:0]   paddr;
reg [31:0]  pwdata;

wire [31:0] prdata;
wire        pready;
wire [31:0] velocity;

// DUT
APB_bus_regs dut (
    .pclk(pclk),
    .preset_n(preset_n),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready),
    .velocity(velocity)
);

// clock 100MHz
always #5 pclk = ~pclk;

initial begin
    $dumpfile("apb_tb.vcd");
    $dumpvars(0, tb_APB_bus_regs);

    // init
    pclk = 0;
    preset_n = 0;
    psel = 0;
    penable = 0;
    pwrite = 0;
    paddr = 0;
    pwdata = 0;

    // ================= RESET =================
    #20;
    preset_n = 1;

    // ================= WRITE velocity =================
    #10;

    apb_write(8'h00, 32'h000003E8); // 1000

    #20;

    // ================= READ velocity =================
    apb_read(8'h00);

    #20;

    // ================= CHANGE VALUE =================
    apb_write(8'h00, 32'h00000FA0); // 4000

    #20;

    apb_read(8'h00);

    #50;

    $finish;
end

// ================= TASK: WRITE =================
task apb_write(input [7:0] addr, input [31:0] data);
begin
    @(posedge pclk);
    paddr   <= addr;
    pwdata  <= data;
    pwrite  <= 1;
    psel    <= 1;
    penable <= 0;

    @(posedge pclk);
    penable <= 1;

    @(posedge pclk);
    psel    <= 0;
    penable <= 0;
    pwrite  <= 0;
end
endtask

// ================= TASK: READ =================
task apb_read(input [7:0] addr);
begin
    @(posedge pclk);
    paddr   <= addr;
    pwrite  <= 0;
    psel    <= 1;
    penable <= 0;

    @(posedge pclk);
    penable <= 1;

    @(posedge pclk);
    psel    <= 0;
    penable <= 0;
end
endtask

endmodule