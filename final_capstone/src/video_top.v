// ==============0ooo===================================================0ooo===========
// =  Copyright (C) 2014-2020 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// ====================================================================================
// 
//  __      __      __
//  \ \    /  \    / /   [File name   ] video_top.v
//   \ \  / /\ \  / /    [Description ] Video demo
//    \ \/ /  \ \/ /     [Timestamp   ] Friday May 26 14:00:30 2019
//     \  /    \  /      [version     ] 1.0.0
//      \/      \/
//
// ==============0ooo===================================================0ooo===========
// Code Revision History :
// ----------------------------------------------------------------------------------
// Ver:    |  Author    | Mod. Date    | Changes Made:
// ----------------------------------------------------------------------------------
// V1.0    | Caojie     | 11/22/19     | Initial version 
// ----------------------------------------------------------------------------------
// ==============0ooo===================================================0ooo===========
`define USE_1024
  
module video_top
(
    input             I_clk           , //27Mhz
    input             I_rst_n         ,
    input             key             ,
    inout       O_led           ,
    inout             SDA             ,
    inout             SCL             ,
    input             VSYNC           ,
    input             HREF            ,
    input      [9:0]  PIXDATA         ,
    input             PIXCLK          ,
    output            XCLK            ,
    //output     [2:0]  tsig,
    inout             uart0_rxd,
   //inout            uart0_txd,
    inout             M3_val,
    
    inout             mosi,
    inout             miso,
    inout             sclk,
    inout             nss,
    
    output     [0:0]  O_hpram_ck      ,
    output     [0:0]  O_hpram_ck_n    ,
    output     [0:0]  O_hpram_cs_n    ,
    output     [0:0]  O_hpram_reset_n ,
    inout      [7:0]  IO_hpram_dq     ,
    inout      [0:0]  IO_hpram_rwds   ,
    output            O_tmds_clk_p    ,
    output            O_tmds_clk_n    ,
    output     [2:0]  O_tmds_data_p   ,//{r,g,b}
    output     [2:0]  O_tmds_data_n   
);

//==================================================
reg  [31:0] run_cnt;
wire        running;

//--------------------------
wire        tp0_vs_in  ;
//wire        tp0_hs_in  ;
//wire        tp0_de_in ;
wire [ 7:0] tp0_data_r/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_g/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_b/*synthesis syn_keep=1*/;

reg         vs_r;
reg  [9:0]  cnt_vs;
wire        PIXCLK565;
//--------------------------
reg  [9:0]  pixdata_d1;
reg         hcnt;
wire [15:0] alt_dat;

//-------------------------
//frame buffer in
wire        ch0_vfb_clk_in ;
wire        ch0_vfb_vs_in  ;
wire        ch0_vfb_de_in  ;
wire [15:0] ch0_vfb_data_in;

//-------------------
//syn_code
wire        syn_off0_re;  // ofifo read enable signal
wire        syn_off0_vs;
wire        syn_off0_hs;
            
wire        off0_syn_de  ;
wire [15:0] off0_syn_data;

//-------------------------------------
//Hyperram
wire        dma_clk  ; 

wire        memory_clk;
wire        mem_pll_lock  ;

//-------------------------------------------------
//memory interface


//------------------------------------------
//rgb data
wire        rgb_vs     ;
wire        rgb_hs     ;
wire        rgb_de     ;
wire [23:0] rgb_data   ;  

//------------------------------------
//HDMI TX
wire serial_clk;
wire pll_lock;

wire hdmi_rst_n;

wire pix_clk;

wire clk_12M;

//===================================================

assign  XCLK = clk_12M;

wire  key_flag;
wire return_key;
key_request key_req_inst(
    .clk(I_clk),
    .rst_n(I_rst_n),
    .key_in(key),
    .key_ack(return_key),
    .key_req(key_flag)
);

//===========================================================================
//MCU cortex M3 and reg process
wire [14:0] io_p;
wire uart0_tx_null;
wire null_nss;

   wire        pclk;
   wire        preset_n;
   wire        penable;
   wire [7:0]  paddr;
   wire        pwrite;
   wire [31:0] pwdata;
   wire [3:0]  pstrb;
   wire [2:0]  pprot;
   wire        psel1,psel2,psel3;
   wire [31:0] prdata1,prdata2,prdata3;
   wire        pready1,pready2,pready3;
   wire [31:0] velo;

	Gowin_EMPU_Top MCU_core(
		.sys_clk(I_clk), //input sys_clk
		.gpio({io_p[14:0]/*,O_led*/,M3_val}), //inout [15:0] gpio
		.uart0_rxd(uart0_rxd), //input uart0_rxd
		.uart0_txd(uart0_tx_null), //output uart0_txd
        
        .mosi(mosi), //output mosi
		.miso(miso), //input miso
		.sclk(sclk), //output sclk
		.nss(O_led), //output nss

		.master_pclk(pclk), //output master_pclk
		.master_prst(preset_n), //output master_prst
		.master_penable(penable), //output master_penable
		.master_paddr(paddr), //output [7:0] master_paddr
		.master_pwrite(pwrite), //output master_pwrite
		.master_pwdata(pwdata), //output [31:0] master_pwdata
		.master_pstrb(pstrb), //output [3:0] master_pstrb
		.master_pprot(pprot), //output [2:0] master_pprot
		.master_psel1(psel1), //output master_psel1
		.master_prdata1(prdata1), //input [31:0] master_prdata1
		.master_pready1(pready1), //input master_pready1
		.master_pslverr1(1'b0), //input master_pslverr1
		.master_psel2(psel2), //output master_psel2
		.master_prdata2(prdata2), //input [31:0] master_prdata2
		.master_pready2(pready2), //input master_pready2
		.master_pslverr2(1'b0), //input master_pslverr2
        .master_psel3(psel3), //output master_psel3
		.master_prdata3(prdata3), //input [31:0] master_prdata3
		.master_pready3(pready3), //input master_pready3
		.master_pslverr3(1'b0), //input master_pslverr3
		.reset_n(I_rst_n) //input reset_n
);
    APB_bus_regs APB_inst(
        .pclk(pclk),
        .preset_n(preset_n),
        .paddr(paddr),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        //.pstrb(pstrb),
        //.pprot(pprot),
        .psel(psel1),
        .prdata(prdata1),
        .pready(pready1),
        .velocity(velo)
    );

//===========================================================================
//uart
/*
uart uart_inst (
.clk(I_clk),
.rst(I_rst_n),
.rx(uart0_rxd),
.tx(uart0_txd),
.I_mode(I_mode)
);
*/
wire [11:0]v_cnt,h_cnt;
wire v_pos,sc_valid;
wire [8:0]  ascii_addr;
reg [15:0] ascii_data;

//testpattern
testpattern testpattern_inst
(
    .I_pxl_clk   (PIXCLK            ),//pixel clock
    .I_rst_n     (I_rst_n            ),//low active 
    .Measured_val(velo               ),
    .in_key      (key_flag),   
    .pclk        (pclk              ),
    .preset_n    (preset_n),
    .paddr       (paddr),
    .penable     (penable),
    .pwrite      (pwrite),
    .pwdata      (pwdata),
    .psel        (psel2),
    .prdata      (prdata2),
    .pready      (pready2),

    .PIXCLK      (PIXCLK),
    .PIXDATA     (PIXDATA),
    .I_hs_pol    (1'b1               ),//HS polarity , 0:negetive ploarity，1：positive polarity
    .I_vs_pol    (1'b1               ),//VS polarity , 0:negetive ploarity，1：positive polarity
    .VSYNC       (VSYNC              ),       // from camera
    .HREF        (HREF               ),        // from camera
    .E_hcnt      (h_cnt              ),
    .E_vcnt      (v_cnt              ),
    .o_CLK565    (PIXCLK565),
    //.scaled_valid (sc_valid           ),
    .V_pos       (v_pos             ),
    //.O_de        (tp0_de_in          ),   
    //.O_hs        (tp0_hs_in          ),
    .O_vs        (tp0_vs_in          ),
    .word_addr      (ascii_addr    ),
    .word_o    (ascii_data         ),
    .O_data      (alt_dat          )
);

always@(posedge I_clk)
begin
    vs_r<=tp0_vs_in;
end

always@(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        cnt_vs<=0;
    else if(cnt_vs==10'h3ff)
        cnt_vs<=cnt_vs;
    else if(vs_r && !tp0_vs_in) //vs24 falling edge
        cnt_vs<=cnt_vs+1;
    else
        cnt_vs<=cnt_vs;
end 
//================================================================================


//==============================================================================
wire [9:0] ov_addr,access_Addr;
wire [15:0] access_Data;
wire conflag;
reg [15:0] ov_data;
reg [9:0] tmp_addr;
OV2640_Controller u_OV2640_Controller
(
    .clk             (clk_12M),         // 24Mhz clock signal
    .resend          (1'b0),            // Reset signal
    .config_finished (conflag), // Flag to indicate that the configuration is finished
    .sioc            (SCL),             // SCCB interface - clock signal
    .siod            (SDA),             // SCCB interface - data signal
    .reset           (),       // RESET signal for OV7670
    .pwdn            (),       // PWDN signal for OV7670
    .ov_dat(ov_data),
    .addr_chk(ov_addr)
);
always @(posedge pix_clk) begin
    if(!conflag) begin
        tmp_addr<=ov_addr+9'd385;
        ov_data<=access_Data;
    end
    else begin
        tmp_addr<=ascii_addr;
        ascii_data<=access_Data;
    end
end
assign access_Addr=tmp_addr;
Single_p single_out_port (
    .clk(pix_clk),
    .oce(1'b1),
    .rst(1'b0),
    .ce(1'b1),
    .we(1'b0),
    .ad(access_Addr),
    .Din(16'd0),
    .Dout(access_Data)
);

always @(posedge PIXCLK or negedge I_rst_n) //I_clk
begin
    if(!I_rst_n)
        hcnt <= 1'd0;
    else if(HREF)
        hcnt <= ~hcnt;
    else
        hcnt <= 1'd0;
end


//==============================================

// cam_data only  
    assign ch0_vfb_clk_in  = PIXCLK565; // PIXCLK;       
    assign ch0_vfb_vs_in   = VSYNC;  //negative
    assign ch0_vfb_de_in   = HREF;//hcnt;  
    assign ch0_vfb_data_in = alt_dat;


//=====================================================
//SRAM 控制模? 
wire          cmd;
wire          cmd_en;
wire [21:0]   addr;
wire [31:0]   wr_data;
wire [3:0]    data_mask;

wire          rd_data_valid;
wire [31:0]   rd_data;

wire          init_calib;

reg  [31:0] ESP_dat;
reg         valid_pack;


// APB SPI SLAVE

APB_MCU_SPI u_apb(
    .pclk       (pclk),
    .preset_n   (preset_n),

    .psel       (psel3),
    .penable    (penable),
    .pwrite     (pwrite),

    .paddr      (paddr),
   // .pwdata     (pwdata),

    .prdata     (prdata3),
    .pready     (pready3),

    .data_in    (off0_syn_data )//
    //.data_valid (valid_pack),
    //.next_word  (apb_next_word)
);

Video_Frame_Buffer_Top Video_Frame_Buffer_Top_inst
(
    .I_rst_n            (init_calib       ),
    .I_dma_clk          (dma_clk          ),

    .I_wr_halt          (key_flag         ),
    .I_rd_halt          (1'b00        ),

    .I_vin0_clk         (ch0_vfb_clk_in   ),
    .I_vin0_vs_n        (ch0_vfb_vs_in    ),
    .I_vin0_de          (ch0_vfb_de_in    ),
    .I_vin0_data        (ch0_vfb_data_in  ),

    .O_vin0_fifo_full   (                 ),

    .I_vout0_clk        (pix_clk          ),
    .I_vout0_vs_n       (~syn_off0_vs     ),
    .I_vout0_de         (syn_off0_re      ),

    .O_vout0_den        (off0_syn_de      ),
    .O_vout0_data       (off0_syn_data    ),

    .O_vout0_fifo_empty (                 ),

    .O_cmd              (cmd              ),
    .O_cmd_en           (cmd_en           ),
    .O_addr             (addr             ),
    .O_wr_data          (wr_data          ),
    .O_data_mask        (data_mask        ),

    .I_rd_data_valid    (rd_data_valid      ),
    .I_rd_data          (rd_data       ),

    .I_init_calib       (init_calib       )
);


//================================================
//HyperRAM ip
GW_PLLVR GW_PLLVR_inst
(
    .clkout(memory_clk    ), //output clkout 159MHz(53/9) -> 148.5MHz
    .lock  (mem_pll_lock  ), //output lock
    .clkin (I_clk         )  //input clkin   27MHz
);

HyperRAM_Memory_Interface_Top HyperRAM_Memory_Interface_Top_inst
(
    .clk            (I_clk          ),
    .memory_clk     (memory_clk     ),
    .pll_lock       (mem_pll_lock   ),
    .rst_n          (I_rst_n        ),  //rst_n
    .O_hpram_ck     (O_hpram_ck     ),
    .O_hpram_ck_n   (O_hpram_ck_n   ),
    .IO_hpram_rwds  (IO_hpram_rwds  ),
    .IO_hpram_dq    (IO_hpram_dq    ),
    .O_hpram_reset_n(O_hpram_reset_n),
    .O_hpram_cs_n   (O_hpram_cs_n   ),
    .wr_data        (wr_data  ),// changed until cmd_en
    .rd_data        (rd_data   ),
    .rd_data_valid  (rd_data_valid ),
    .addr           (addr  ),
    .cmd            (cmd  ),
    .cmd_en         (cmd_en),
    .clk_out        (dma_clk        ),
    .data_mask      (data_mask      ),
    .init_calib     (init_calib      )
); 

//================================================
wire out_de;
syn_gen syn_gen_inst
(
    .I_pxl_clk   (pix_clk         ),//40MHz      //65MHz      //74.25MHz    
    .I_rst_n     (hdmi_rst_n      ),//800x600    //1024x768   //1280x720       
    .I_h_total   (16'd1344        ),// 16'd1056  // 16'd1344  // 16'd1650    
    .I_h_sync    (16'd136          ),// 16'd128   // 16'd136   // 16'd40     
    .I_h_bporch  (16'd160         ),// 16'd88    // 16'd160   // 16'd220     
    .I_h_res     (16'd1024        ),// 16'd800   // 16'd1024  // 16'd1280    
    .I_v_total   (16'd806         ),// 16'd628   // 16'd806   // 16'd750      
    .I_v_sync    (16'd6           ),// 16'd4     // 16'd6     // 16'd5        
    .I_v_bporch  (16'd29          ),// 16'd23    // 16'd29    // 16'd20        
    .I_v_res     (16'd768         ),// 16'd600   // 16'd768   // 16'd720      
`ifdef USE_1024 
    .I_rd_hres   (16'd1024        ),//1024
    .I_rd_vres   (16'd768         ),
`endif
    .I_hs_pol    (1'b1            ),//HS polarity , 0:??性，1：正?性
    .I_vs_pol    (1'b1            ),//VS polarity , 0:??性，1：正?性
    .O_rden      (syn_off0_re     ),
    .O_de        (out_de          ),   
    .O_hs        (syn_off0_hs     ),
    .O_vs        (syn_off0_vs     )
);

localparam N = 5; //delay N clocks
                          
reg  [N-1:0]  Pout_hs_dn   ;
reg  [N-1:0]  Pout_vs_dn   ;
reg  [N-1:0]  Pout_de_dn   ;

always@(posedge pix_clk or negedge hdmi_rst_n)
begin
    if(!hdmi_rst_n)
        begin                          
            Pout_hs_dn  <= {N{1'b1}};
            Pout_vs_dn  <= {N{1'b1}}; 
            Pout_de_dn  <= {N{1'b0}}; 
        end
    else 
        begin                          
            Pout_hs_dn  <= {Pout_hs_dn[N-2:0],syn_off0_hs};
            Pout_vs_dn  <= {Pout_vs_dn[N-2:0],syn_off0_vs}; 
            Pout_de_dn  <= {Pout_de_dn[N-2:0],out_de}; 
        end
end

//==============================================================================
//TMDS TX
assign rgb_data    = off0_syn_de ? {off0_syn_data[15:11],3'd0,off0_syn_data[10:5],2'd0,off0_syn_data[4:0],3'd0} : 24'h000000;//{r,g,b}
assign rgb_vs      = Pout_vs_dn[4];//syn_off0_vs;
assign rgb_hs      = Pout_hs_dn[4];//syn_off0_hs;
assign rgb_de      = Pout_de_dn[4];//off0_syn_de;

//assign tsig[0] = I_clk;     // (27.00MHz)     XTAL 
//assign tsig[1] = pix_clk;   // (74.25MHz)  <- I_clkx2.75(11/4)
//assign tsig[2] = PIXCLK;    // (24.75MHz)  <- pix_clk/3
//assign tsig[3] = XCLK;      // (12.375MHz) <- PIXCLK/2
//assign tsig[4] = serial_clk;// (371.25MHz) <- pix_clkx5

TMDS_PLLVR TMDS_PLLVR_inst
(.clkin     (I_clk     )     //input clk     (27M) 
,.clkout    (serial_clk)     //output clk    (371.25MHz) 55/4
,.clkoutd   (clk_12M   )     //output clkoutd(12.375MHz)
,.lock      (pll_lock  )     //output lock
);

assign hdmi_rst_n = I_rst_n & pll_lock;

CLKDIV u_clkdiv
(.RESETN(hdmi_rst_n)
,.HCLKIN(serial_clk) //clk  x5
,.CLKOUT(pix_clk)    //clk  x1
,.CALIB (1'b1)
);
defparam u_clkdiv.DIV_MODE="5";

DVI_TX_Top DVI_TX_Top_inst
(
    .I_rst_n       (hdmi_rst_n   ),  //asynchronous reset, low active
    .I_serial_clk  (serial_clk    ),
    .I_rgb_clk     (pix_clk       ),  //pixel clock
    .I_rgb_vs      (rgb_vs        ), 
    .I_rgb_hs      (rgb_hs        ),    
    .I_rgb_de      (rgb_de        ), 
    .I_rgb_r       (rgb_data[23:16]    ),  
    .I_rgb_g       (rgb_data[15: 8]    ),  
    .I_rgb_b       (rgb_data[ 7: 0]    ),  
    .O_tmds_clk_p  (O_tmds_clk_p  ),
    .O_tmds_clk_n  (O_tmds_clk_n  ),
    .O_tmds_data_p (O_tmds_data_p ),  //{r,g,b}
    .O_tmds_data_n (O_tmds_data_n )
);

endmodule
