`timescale 1ns/1ps
module testpattern
(
    input               I_pxl_clk,   // pixel clock
    input               I_rst_n,     // low active
    input       [31:0]  Measured_val,
    input              in_key,
    input  wire        pclk,
    input  wire        preset_n,
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [7:0]  paddr,
    input  wire [31:0] pwdata,

    output reg  [31:0] prdata,
    output reg         pready,
    input       [9:0]   PIXDATA,
    input               PIXCLK,
    input               I_hs_pol,    // HS polarity
    input               I_vs_pol,    // VS polarity
    output      [11:0]  E_hcnt,
    output      [11:0]  E_vcnt,

    output              o_CLK565,
    //output reg          O_hs,
    output               V_pos,
    output reg          O_vs,
    output      [15:0]  O_data,      // rgb565 combined from out_color
    input               VSYNC,       // from camera
    input               HREF,         // from camera (acts as DE)
    input       [15:0]  word_o,
    output      [8:0]   word_addr
);


localparam N = 5; // pipeline length

localparam WHITE   = {8'd255, 8'd255, 8'd255}; 
localparam YELLOW  = {8'd255  , 8'd255, 8'd0};
localparam CYAN    = {8'd0, 8'd255, 8'd255  };
localparam GREEN   = {8'd0  , 8'd255, 8'd0  };
localparam MAGENTA = {8'd127, 8'd0  , 8'd127};
localparam RED     = {8'd127  , 8'd0  , 8'd0};
localparam BLUE    = {8'd0   , 8'd0  , 8'd255 };
localparam BLACK   = {8'd0  , 8'd0  , 8'd0  };

//-------------------------------------------------------------
// Internal signals
//-------------------------------------------------------------
reg  [11:0] h_cnt;
reg  [11:0] v_cnt;
  

wire [23:0] temp_cam24;  
assign temp_cam24 = { {PIXDAT565[15:11],3'b000},        
                      {PIXDAT565[10:5], 2'b00},         
                      {PIXDAT565[4:0], 3'b000} };       

//-------------------------------------------------------------

always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n)
        h_cnt <= 12'd0;
    else if (!HREF)
        h_cnt <= 12'd0;
    else
        h_cnt <= h_cnt + 12'd1;
end

reg href_d1;
always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n)
        href_d1 <= 1'b0;
    else
        href_d1 <= HREF;
end
wire href_fall = href_d1 & ~HREF;

always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n)
        v_cnt <= 12'd0;
    else if (VSYNC)
        v_cnt <= 12'd0;
    else if (href_fall)
        v_cnt <= v_cnt + 12'd1;
end


reg [N-1:0] Pout_de_dn;
reg [N-1:0] Pout_hs_dn;
reg [N-1:0] Pout_vs_dn;

wire Pout_de_w = HREF;   
wire Pout_hs_w = HREF;   
wire Pout_vs_w = VSYNC;  

always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n) begin
        Pout_de_dn <= {N{1'b0}};
        Pout_hs_dn <= {N{1'b1}};
        Pout_vs_dn <= {N{1'b1}};
    end else begin
        Pout_de_dn <= {Pout_de_dn[N-2:0], Pout_de_w};
        Pout_hs_dn <= {Pout_hs_dn[N-2:0], Pout_hs_w};
        Pout_vs_dn <= {Pout_vs_dn[N-2:0], Pout_vs_w};
    end
end

assign O_de = Pout_de_dn[4]; // tap chosen to align with pipeline (5 for index 4)
always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n) begin
        //O_hs <= ~I_hs_pol;
        O_vs <= ~I_vs_pol;
    end else begin
        // map camera signals to HS/VS outputs with polarity selection
        //O_hs <= I_hs_pol ? ~Pout_hs_dn[3] : Pout_hs_dn[3];
        O_vs <= I_vs_pol ? ~Pout_vs_dn[3] : Pout_vs_dn[3];
    end
end


wire De_pos = ~Pout_de_dn[1] &  Pout_de_dn[0]; // DE rising 
wire De_neg =  Pout_de_dn[1] & ~Pout_de_dn[0]; // DE falling 
wire Vs_pos = ~Pout_vs_dn[1] &  Pout_vs_dn[0]; // VS rising 

assign V_pos= Vs_pos;
reg [11:0] De_hcnt;
reg [11:0] De_vcnt;

always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n)
        De_hcnt <= 12'd0;
    else if (De_pos)
        De_hcnt <= 12'd0;
    else if (Pout_de_dn[1])
        De_hcnt <= De_hcnt + 12'd1;
    else
        De_hcnt <= De_hcnt;
end

always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n)
        De_vcnt <= 12'd0;
    else if (Vs_pos)
        De_vcnt <= 12'd0;
    else if (De_neg)
        De_vcnt <= De_vcnt + 12'd1;
    else
        De_vcnt <= De_vcnt;
end
assign E_hcnt =De_hcnt;
assign E_vcnt =De_vcnt;
//-----------------------------------------------------------//
reg [9:0]  pixdata_d1; 
reg        PIXCLK565;
reg [15:0] PIXDAT565;
always @(posedge PIXCLK or negedge I_rst_n) //I_clk
begin
    if(!I_rst_n) begin
        pixdata_d1 <= 10'd0;
        PIXCLK565 <= 0;
    end else begin
        pixdata_d1 <= PIXDATA;
        if(~HREF) PIXCLK565 <= 0;
        else begin
            PIXCLK565 <= ~PIXCLK565;    // 1/2
            if(PIXCLK565) PIXDAT565[7:0] <= PIXDATA[9:2];
            else          PIXDAT565[15:8] <= PIXDATA[9:2];
        end
    end
end
assign o_CLK565=PIXCLK565;
//------------------------------------------------------------//
localparam dot_hor = 12'd1000;
localparam dot_ver = 12'd320;
localparam num_hor = 12'd900;
localparam num_ver = 12'd500;
localparam gps_hor = 12'd100;
localparam gps_ver = 12'd700;

localparam size = 25;
localparam size_num = 75;
localparam addr = 9'd0;//72



reg [23:0] cam_dot;
reg [11:0] dx, dy;

//wire [15:0] word_o;
//wire [8:0]  word_addr;
reg  [12:0] addr_base;

reg [15:0] logo_pixel_r;
reg odd_flag;
reg [9:0] digits [0:45];
reg [7:0] digit_sel=8'd0;
reg  [7:0] gps_buf [0:35];
reg [3:0] wr_idx;
reg gps_ready;
integer i;
wire [1:0] wordaddr;
assign wordaddr = paddr[3:2];


wire [23:0] mix_color = (temp_cam24 >>1)+ (WHITE>>2);
wire [23:0] blurry =(temp_cam24 )+ (WHITE>>1);
assign word_addr = addr_base;
/*
    Gowin_SP BSRAM_blk(
        .dout(word_o), //output [15:0] dout
        .clk(I_pxl_clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(1'b0), //input reset
        .wre(1'b0), //input wre
        .ad(word_addr), //input [8:0] ad
        .din(16'h0000) //input [15:0] din
    );*/
always @(posedge pclk or negedge preset_n) begin
        if (!preset_n) begin
            pready    <= 1'b0;
            prdata    <= 32'd0;
            wr_idx    <= 0;
            gps_ready <= 0;

            for (i = 0; i < 33; i = i + 1)
                gps_buf[i] <= 8'd0;

        end else begin
            pready <= 1'b0;
            gps_ready <= 0;

            if (psel && !penable) begin
                pready <= 1'b1;

                /* ===== WRITE ===== */
                if (pwrite) begin
                    case (wordaddr)

                        /* 0x00 → GPS DATA STREAM */
                        2'b00: begin
                            gps_buf[wr_idx*4 + 0] <= pwdata[7:0];
                            gps_buf[wr_idx*4 + 1] <= pwdata[15:8];
                            gps_buf[wr_idx*4 + 2] <= pwdata[23:16];
                            gps_buf[wr_idx*4 + 3] <= pwdata[31:24];

                            if (wr_idx == 4'd8) begin
                                wr_idx <= 0;
                                gps_ready <= 1'b1; // FULL FRAME DONE
                            end else begin
                                wr_idx <= wr_idx + 1;
                            end
                        end

                        /* 0x04 → CONTROL (optional reset) */
                        2'b01: begin
                            if (pwdata[0])
                                wr_idx <= 0;
                        end

                    endcase
                end

                /* ===== READ (debug) ===== */
                else begin
                    case (wordaddr)
                        2'b00: prdata <= {28'd0, wr_idx};
                        2'b01: prdata <= {31'd0, gps_ready};
                        default: prdata <= 32'd0;
                    endcase
                end
            end
        end
    end


always @(posedge I_pxl_clk) begin //stay still addr
    digits[0] <= Measured_val[31:24]+9'd64;
    digits[1] <= Measured_val[23:16]+9'd64;
    digits[2] <= 9'd56;
    digits[3] <= Measured_val[15:8]+9'd64;
    digits[4] <= Measured_val[7:0]+9'd64;
    digits[5] <= 9'd0;
    digits[6] <= 9'd172;
    digits[7] <= 9'd308;
    digits[8] <= 9'd60;
    digits[9] <= 9'd288;
    digits[5] <= 9'd0;
    digits[6] <= 9'd172;
    digits[7] <= 9'd308;
    digits[8] <= 9'd60;
    digits[9] <= 9'd288;
    if (gps_ready) begin
       for (i = 10; i < 45; i = i + 1)
           digits[i] <= gps_buf[i-10]*4 - 9'd128;//3'd4+9'd64;
    end
end
always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n) begin
        cam_dot <= 0;
        dx <= 0; dy <= 0;
        addr_base <= 0;
        odd_flag <= 0;
        logo_pixel_r <= 0;
    end else begin
        logo_pixel_r <= word_o;

        if (De_hcnt >= dot_hor - size && De_hcnt < dot_hor + size &&
            De_vcnt >= dot_ver  && De_vcnt < dot_ver + size) begin

                cam_dot <= mix_color;

        end
        else if (De_hcnt >= num_hor && De_hcnt < num_hor+321 &&
                 De_vcnt >= num_ver && De_vcnt < num_ver+32) begin

            digit_sel <= (De_hcnt - num_hor) >> 5;
            //addr = digits[digit_sel];
            //num_hor_shift = num_hor + (digit_sel << 3);

            dx <= (De_hcnt - (num_hor + (digit_sel << 5)))>>2;
            dy <= (De_vcnt - num_ver)>>2;
        
            addr_base <= digits[digit_sel]+(dy>>1);//((De_vcnt - num_ver) >> 1);
            odd_flag <= dy & 1;//(De_vcnt - num_ver) & 1;

            if (dx < 8 && dy < 8) begin
                if (odd_flag)
                    cam_dot <= logo_pixel_r[7 - dx] ? mix_color: temp_cam24;
                else
                    cam_dot <= logo_pixel_r[15 - dx] ? mix_color : temp_cam24;
            end 
        end
        else if (De_hcnt >= gps_hor && De_hcnt < gps_hor+/*1665*/ 1153 &&
                 De_vcnt >= gps_ver && De_vcnt < gps_ver+32) begin
                    //cam_dot<= BLUE;
            digit_sel <= (De_hcnt - gps_hor) >> 5;
            dx <= (De_hcnt - (gps_hor + (digit_sel << 5)))>>2;
            dy <= (De_vcnt - gps_ver)>>2;
        
            addr_base <= digits[digit_sel+10]+(dy>>1);
            odd_flag <= dy & 1;

            if (dx < 8 && dy < 8) begin
                if (odd_flag)
                    cam_dot <= logo_pixel_r[7 - dx] ? mix_color: temp_cam24;
                else
                    cam_dot <= logo_pixel_r[15 - dx] ? mix_color : temp_cam24;
            end
        end
        else begin
                cam_dot <= temp_cam24;
            end
    end
end


//==============//
assign O_data ={ cam_dot[23:19], cam_dot[15:10], cam_dot[7:3] };
endmodule