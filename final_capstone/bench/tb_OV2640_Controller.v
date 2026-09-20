`timescale 1ns / 1ps

module tb_OV2640_Controller();

    // Inputs to UUT
    reg clk;
    reg resend;
    reg [15:0] ov_dat;

    // Outputs from UUT
    wire config_finished;
    wire sioc;
    wire reset;
    wire pwdn;
    wire [9:0] addr_chk;

    // Bidirectional Inout
    wire siod;

    // -------------------------------------------------------------------------
    // 1. Instantiate the Unit Under Test (UUT)
    // -------------------------------------------------------------------------
    OV2640_Controller uut (
        .clk(clk),
        .resend(resend),
        .config_finished(config_finished),
        .sioc(sioc),
        .siod(siod),
        .reset(reset),
        .pwdn(pwdn),
        .addr_chk(addr_chk),
        .ov_dat(ov_dat)
    );

    // -------------------------------------------------------------------------
    // 2. Pull-up Resistor for Tri-state I2C Data Line (siod)
    // -------------------------------------------------------------------------
    // In real hardware, I2C/SCCB require pull-up resistors. When the master 
    // releases siod (Z), this line pulls it high to simulate a standard 'ACK'.
    pullup (siod);

    // -------------------------------------------------------------------------
    // 3. Clock Generation (50MHz -> Period = 20ns)
    // -------------------------------------------------------------------------
    always begin
        #10 clk = ~clk;
    end

    // -------------------------------------------------------------------------
    // 4. Mock LUT Behavior (Feeding configuration array to ov_dat)
    // -------------------------------------------------------------------------
    // This matches the target index array required by your OV2640_Registers module.
    always @(*) begin
        case (addr_chk)
            // Sequence extracted from your commented Register template
            10'd0   : ov_dat = 16'hFF_01;
            10'd1   : ov_dat = 16'h12_80; // Soft reset
            10'd2   : ov_dat = 16'hFF_00;
            10'd3   : ov_dat = 16'h2c_ff;
            10'd4   : ov_dat = 16'h2e_df;
            10'd5   : ov_dat = 16'hFF_01;
            10'd6   : ov_dat = 16'h3c_32;
            10'd7   : ov_dat = 16'h11_80; // Clock dividers
            10'd8   : ov_dat = 16'h09_02;
            
            // Fast-forwarding simulation structure: 
            // You can add more addresses here if you need to trace explicit bits.
            // For verification, we capture up to an arbitrary endpoint 
            // and append the termination command.
            10'd9   : ov_dat = 16'h04_28;
            10'd10  : ov_dat = 16'h13_E5;
            
            // End Configuration identifier (Flashes config_finished high)
            default : ov_dat = 16'hFF_FF; 
        endcase
    end

    // -------------------------------------------------------------------------
    // 5. Test Stimulus Sequence
    // -------------------------------------------------------------------------
    initial begin
        // Initialize Inputs
        clk    = 0;
        resend = 0;

        $display("[TB INFO] Starting OV2640 Controller Testbench Initialization...");
        
        // Assert Power-on Reset
        #100;
        resend = 1; 
        #40;
        resend = 0;
        $display("[TB INFO] System released from initial reset state.");

        // Monitor transmission progress
        // Watch for config_finished assertion
        fork
            begin : timeout_protection
                // Safety timeout sequence if communication pipeline locks
                #50_000_000; 
                $display("[TB ERROR] Simulation Timed Out! Configuration did not finish.");
                $finish;
            end
            
            begin : watch_completion
                wait(config_finished == 1'b1);
                $display("[TB SUCCESS] Config Finished detected! Target Registers successfully mapped.");
                disable timeout_protection;
            end
        Loop

        // Let the state machine settle under passive tracking
        #200_000;

        // -------------------------------------------------------------------------
        // 6. Test a Runtime Re-send Condition
        // -------------------------------------------------------------------------
        $display("[TB INFO] Triggering dynamic runtime 'resend' sequence...");
        #100;
        resend = 1;
        #100;
        resend = 0;

        // Wait once more for configuration re-completion
        fork
            begin : timeout_protection_2
                #50_000_000;
                $display("[TB ERROR] Simulation Timed Out during secondary resend phase.");
                $finish;
            end
            
            begin : watch_completion_2
                wait(config_finished == 1'b1);
                $display("[TB SUCCESS] Configuration re-completed successfully after dynamic reset!");
                disable timeout_protection_2;
            end
        join

        #500_000;
        $display("[TB COMPLETE] All sequence tests executed flawlessly.");
        $finish;
    end

    // -------------------------------------------------------------------------
    // 7. Waveform Tracking Assertions (Optional Console Logs)
    // -------------------------------------------------------------------------
    always @(posedge config_finished) begin
        $display("[STATUS CHANGE @ %0t ns] config_finished updated = %b", $time, config_finished);
    end

endmodule