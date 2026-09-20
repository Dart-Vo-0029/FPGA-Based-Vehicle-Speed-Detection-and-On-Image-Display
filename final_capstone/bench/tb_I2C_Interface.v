`timescale 1ns/1ps

module tb_I2C_Interface;

    // Testbench signals
    reg clk;
    reg send;
    reg [7:0] rega;
    reg [7:0] value;
    wire sioc;
    wire siod;
    wire taken;

    // Pull-up for SIOD (important for I2C/SCCB)
    pullup(siod);

    // Instantiate DUT
    I2C_Interface #(
        .SID(8'h42)
    ) dut (
        .clk   (clk),
        .siod  (siod),
        .sioc  (sioc),
        .taken (taken),
        .send  (send),
        .rega  (rega),
        .value (value)
    );

    // 50 MHz clock → period = 20 ns
    always #10 clk = ~clk;

    initial begin
        // Dump waveforms
        $dumpfile("i2c_tb.vcd");
        $dumpvars(0, tb_I2C_Interface);

        // Init
        clk   = 0;
        send  = 0;
        rega  = 8'h00;
        value = 8'h00;

        // Wait a bit
        #100;

        // Send first register write
        rega  = 8'h12;      // example OV7670 register
        value = 8'h80;      // example value
        send  = 1;

        // send must be asserted long enough
        #200;
        send = 0;

        // Wait until transaction finishes
        wait(taken == 1);
        #100;

        // Second write
        rega  = 8'h11;
        value = 8'h01;
        send  = 1;

        #200;
        send = 0;

        // Run long enough to see full SCCB waveform
        #20_000_000;

        $stop;
    end

endmodule


