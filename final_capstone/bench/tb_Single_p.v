`timescale 1ns / 1ps

module tb_Single_p;

    // Inputs to the UUT
    reg clk;
    reg rst;
    reg oce;
    reg ce;
    reg [9:0] ad;
    reg we;
    reg [15:0] Din;

    // Outputs from the UUT
    wire [15:0] Dout;

    // Instantiate the Unit Under Test (UUT)
    Single_p uut (
        .clk(clk),
        .rst(rst),
        .oce(oce),
        .ce(ce),
        .ad(ad),
        .we(we),
        .Din(Din),
        .Dout(Dout)
    );

    // Clock generation: 100MHz (10ns period)
    always #5 clk = ~clk;

    initial begin
        // --- Setup for Icarus Verilog Waveform Viewing ---
        $dumpfile("single_p_wave.vcd");
        $dumpvars(0, tb_Single_p);

        // --- Step 1: Initialize Signals ---
        clk  = 0;
        rst  = 1; // Active high reset
        oce  = 0;
        ce   = 0;
        we   = 0;
        ad   = 10'h000;
        Din  = 16'h0000;

        // Hold reset for 2 clock cycles
        #20;
        
        // Release reset and enable memory + output stage
        rst = 0;
        ce  = 1;
        oce = 1;
        #5;

        // --- Step 2: Read Test ---
        // Let's read from the first few addresses populated by your .mem file
        // Remember: operations trigger on falling edge (negedge clk), 
        // and Dout updates on the following rising edge (posedge clk).

        ad = 10'h000; #10; // Read address 0
        ad = 10'h001; #10; // Read address 1
        ad = 10'h002; #10; // Read address 2
        ad = 10'h003; #10; // Read address 3

        // --- Step 3: Write-Through Test ---
        // Let's write fresh values into memory. 
        // Because of 'write-through', Din should reflect onto Do_pipe instantly on negedge.
        
        we = 1; 
        ad = 10'h010; Din = 16'hAAAA; #10; 
        ad = 10'h011; Din = 16'hBBBB; #10;
        ad = 10'h012; Din = 16'hCCCC; #10;

        // --- Step 4: Verify the Writes via Reads ---
        we = 0;
        ad = 10'h010; #10;
        ad = 10'h011; #10;
        ad = 10'h012; #10;

        // Finish simulation
        #20;
        $finish;
    end

    // Monitor outputs in the terminal text console
    initial begin
        $monitor("Time=%0dt ns | rst=%b ce=%b we=%b | ad=%h Din=%h | Dout=%h", 
                 $time, rst, ce, we, ad, Din, Dout);
    end

endmodule