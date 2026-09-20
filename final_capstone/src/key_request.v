module key_request (
    input  wire clk,
    input  wire rst_n,
    input  wire key_in,     // raw button (active LOW)
    input  wire key_ack,    // from FSM (1-cycle or level)

    output wire  key_req     
);

localparam [19:0] CNT_MAX = 21'd540000; //20 ms debounce

reg k0, k1,tmp;
always @(posedge clk) begin
    k0 <= key_in;
    k1 <= k0;
end

wire key_active = ~k1;

reg [19:0] cnt;
reg key_stable;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        key_stable <= 0;
    end else begin
        if (key_active == key_stable) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
            if (cnt >= CNT_MAX) begin
                key_stable <= key_active;
                cnt <= 0;
            end
        end
    end
end


reg key_stable_d;
reg [25:0] cnt1=26'd0;
wire press_event;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        key_stable_d <= 0;
    else
        key_stable_d <= key_stable;
end

assign press_event = key_stable & ~key_stable_d;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        tmp <= 1'b0;
    else begin
        if(press_event)
            tmp<=~tmp;
        /*if (press_event)begin
            tmp <= 1'b1;     // latch request
            cnt1 <=cnt1+1'b1;
        end
        else if (key_ack||cnt1==26'd27000000)begin
            tmp <= 1'b0;     // clear when done
            cnt1<=1'b0;
        end*/
    end
end
assign key_req=tmp;
endmodule