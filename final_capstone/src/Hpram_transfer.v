module Hpram_transfer
(
    input wire clk,
    input wire rst_n,

    input wire start,

    //--------------------------------------------------
    // HyperRAM return
    //--------------------------------------------------
    input wire        rd_valid,
    input wire [31:0] rd_data,

    //--------------------------------------------------
    // APB/FIFO acknowledge
    //--------------------------------------------------
    input wire next_word,

    //--------------------------------------------------
    // HyperRAM command outputs
    //--------------------------------------------------
    output reg        cmd,
    output reg        cmd_en,
    output reg [21:0] addr,

    //--------------------------------------------------
    // data output
    //--------------------------------------------------
    output reg [31:0] data_out,
    output reg        data_valid,

    output reg busy
);

localparam IDLE = 0;
localparam REQ  = 1;
localparam WAIT = 2;
localparam HOLD = 3;

reg [1:0] state;

always @(posedge clk or negedge rst_n)
begin

    if(!rst_n)
    begin

        state <= IDLE;

        cmd <= 1'b1;
        cmd_en <= 0;

        addr <= 0;

        data_out <= 0;
        data_valid <= 0;

        busy <= 0;

    end
    else
    begin

        cmd_en <= 0;

        case(state)

        //----------------------------------------------
        // IDLE
        //----------------------------------------------
        IDLE:
        begin

            data_valid <= 0;

            if(start)
            begin

                addr <= 0;

                busy <= 1;

                state <= REQ;

            end

        end

        //----------------------------------------------
        // issue read
        //----------------------------------------------
        REQ:
        begin

            cmd <= 1'b1;
            cmd_en <= 1'b1;

            state <= WAIT;

        end

        //----------------------------------------------
        // wait ram
        //----------------------------------------------
        WAIT:
        begin

            if(rd_valid)
            begin

                data_out <= rd_data;

                data_valid <= 1'b1;

                state <= HOLD;

            end

        end

        //----------------------------------------------
        // wait MCU consume
        //----------------------------------------------
        HOLD:
        begin

            if(next_word)
            begin

                data_valid <= 0;

                addr <= addr + 1;

                state <= REQ;

            end

        end

        endcase

    end

end

endmodule