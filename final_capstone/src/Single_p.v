module Single_p(
    input clk, rst,
    input oce, ce,
    input [9:0] ad,
    input we,
    input [15:0] Din,
    output [15:0] Dout
);

reg [15:0] mem [0:653];

reg [15:0] Do_pipe;
reg [15:0] Do;

initial begin
    $readmemh("ASCII_n_OVaddr.mem", mem);
end

always @(negedge clk) begin
    if (rst) begin
        Do_pipe <= 16'd0;
    end else if (ce) begin
        if (we) begin
            mem[ad] <= Din;
            Do_pipe <= Din;        // write-through
        end else begin
            Do_pipe <= mem[ad];   // read
        end

    end
end
always @(posedge clk) begin //output delay 1 cycle
            if (oce)
            Do <= Do_pipe;
end

assign Dout = Do;


endmodule