`timescale 1ns / 1ps

module tb_Semi_dual_port;

    // Inputs to the UUT
    reg clkA;
    reg clkB;
    reg oce;
    reg ceA;
    reg ceB;
    reg rstA;
    reg rstB;
    reg [9:0] addrA;
    reg [9:0] addrB;
    reg [15:0] dat_in;

    // Outputs from the UUT
    wire [15:0] dat_out;

    // Instantiate the Unit Under Test (UUT)
    Semi_dual_port uut (
        .clkA(clkA),
        .clkB(clkB),
        .oce(oce),
        .ceA(ceA),
        .ceB(ceB),
        .rstA(rstA),
        .rstB(rstB),
        .addrA(addrA),
        .addrB(addrB),
        .dat_in(dat_in),
        .dat_out(dat_out)
    );

    // Clock generation: 100MHz clocks (10ns period) matching the waveform
    always #5 clkA = ~clkA;
    always #5 clkB = ~clkB;

    initial begin
        // --- Step 1: Initialize Inputs ---
        clkA  = 0;
        clkB  = 0;
        oce   = 0;
        ceA   = 0;
        ceB   = 0;
        rstA  = 1; // Start with reset active as seen early in waveforms
        rstB  = 1;
        addrA = 10'h000;
        addrB = 10'h000;
        dat_in = 16'h0000;

        // Hold reset for a couple of cycles
        #15;
        
        // --- Step 2: Release Reset & Enable Chip ---
        rstA = 0;
        rstB = 0;
        ceA  = 1;
        ceB  = 1;
        oce  = 1;
        #5;

        // --- Step 3: Write and Read Sequences ---
        // We write to AddrA and read from AddrB with a 1-cycle offset 
        // to mimic your wave pipeline structure.

        // Cycle 1
        addrA = 10'h001; dat_in = 16'h00FF;
        addrB = 10'h000;
        #10;

        // Cycle 2
        addrA = 10'h002; dat_in = 16'h00FA;
        addrB = 10'h001; 
        #10;

        // Cycle 3
        addrA = 10'h003; dat_in = 16'h00AB;
        addrB = 10'h002;
        #10;

        // Cycle 4
        addrA = 10'h004; dat_in = 16'h0015;
        addrB = 10'h003;
        #10;

        // Cycle 5
        addrA = 10'h005; dat_in = 16'h00F1;
        addrB = 10'h004;
        #10;

        // Cycle 6
        addrA = 10'h006; dat_in = 16'h00FF;
        addrB = 10'h005;
        #10;

        // Cycle 7
        addrA = 10'h007; dat_in = 16'h00FA;
        addrB = 10'h006;
        #10;

        // Cycle 8
        addrA = 10'h008; dat_in = 16'h00AB;
        addrB = 10'h007;
        #10;

        // Cycle 9
        addrA = 10'h009; dat_in = 16'h0015;
        addrB = 10'h008;
        #10;

        // Cycle 10
        addrA = 10'h00A; dat_in = 16'h00F1;
        addrB = 10'h009;
        #10;

        // Let simulation run a bit longer to witness final outputs propagate
        #50;
        
        $finish;
    end

    // Optional: Monitor results in the console window
    initial begin
        $monitor("Time=%0dt ns | addrA=%h dat_in=%h | addrB=%h dat_out=%h", 
                 $time, addrA, dat_in, addrB, dat_out);
    end
initial begin
    $dumpfile("waveform.vcd"); // Names the waveform dump file
    $dumpvars(0, tb_Semi_dual_port); // Dumps all variables in the testbench
end
endmodule