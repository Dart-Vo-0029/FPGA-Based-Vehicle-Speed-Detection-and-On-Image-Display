module Semi_dual_port(
input clkA,
input clkB,
input oce,
input ceA,
input ceB,
input rstA,
input rstB,
input [9:0]addrA,
input [9:0]addrB,
input [15:0]dat_in,
output [15:0]dat_out
);
endmodule
/*
    input clkA, clkB, rst,
    input oce, ceA, ceB,
    input [9:0] adA, adB,
    input weA, weB,
    input [15:0] Din,
    output [15:0] DoutA, DoutB
);

reg [15:0] mem [0:653];

// pipeline registers
reg [15:0] DoA_pipe, DoB_pipe;
reg [15:0] DoA, DoB;


//PortA
always @(negedge clkA) begin
    if (rst) begin
        DoA_pipe <= 16'd0;
    end else if (ceA) begin
        if (weA) begin
            mem[adA] <= Din;
            DoA_pipe <= Din;        // write-through
        end else begin
            DoA_pipe <= mem[adA];   // read
        end

    end
end
always @(posedge clkA) begin //output delay 1 cycle
            if (oce)
            DoA <= DoA_pipe;
end
//PortB

always @(negedge clkB) begin //also with PB
    if (rst) begin
        DoB_pipe <= 16'd0;
    end else if (ceB) begin
        if (weB) begin
            mem[adB] <= Din;
            DoB_pipe <= Din;
        end else begin
            DoB_pipe <= mem[adB];
        end


    end
end
always @(posedge clkB) begin
        if (oce)
            DoB <= DoB_pipe;
end

assign DoutA = DoA;
assign DoutB = DoB;

endmodule*/