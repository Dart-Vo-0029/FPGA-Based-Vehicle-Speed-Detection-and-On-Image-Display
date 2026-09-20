module gw_gao(
    I_clk,
    PIXCLK,
    dma_clk,
    memory_clk,
    pix_clk,
    cmd,
    cmd_en,
    rd_data_valid,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[31] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[30] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[29] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[28] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[27] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[26] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[25] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[24] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[23] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[22] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[21] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[20] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[19] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[18] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[17] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[16] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[15] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[14] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[13] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[12] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[11] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[10] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[9] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[8] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[7] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[6] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[5] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[4] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[3] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[2] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[1] ,
    \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[0] ,
    syn_off0_vs,
    off0_syn_de,
    key_flag,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input I_clk;
input PIXCLK;
input dma_clk;
input memory_clk;
input pix_clk;
input cmd;
input cmd_en;
input rd_data_valid;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[31] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[30] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[29] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[28] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[27] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[26] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[25] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[24] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[23] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[22] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[21] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[20] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[19] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[18] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[17] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[16] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[15] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[14] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[13] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[12] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[11] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[10] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[9] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[8] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[7] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[6] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[5] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[4] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[3] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[2] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[1] ;
input \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[0] ;
input syn_off0_vs;
input off0_syn_de;
input key_flag;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire I_clk;
wire PIXCLK;
wire dma_clk;
wire memory_clk;
wire pix_clk;
wire cmd;
wire cmd_en;
wire rd_data_valid;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[31] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[30] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[29] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[28] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[27] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[26] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[25] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[24] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[23] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[22] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[21] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[20] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[19] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[18] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[17] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[16] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[15] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[14] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[13] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[12] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[11] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[10] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[9] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[8] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[7] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[6] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[5] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[4] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[3] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[2] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[1] ;
wire \HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[0] ;
wire syn_off0_vs;
wire off0_syn_de;
wire key_flag;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i(key_flag),
    .data_i({I_clk,PIXCLK,dma_clk,memory_clk,pix_clk,cmd,cmd_en,rd_data_valid,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[31] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[30] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[29] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[28] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[27] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[26] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[25] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[24] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[23] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[22] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[21] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[20] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[19] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[18] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[17] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[16] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[15] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[14] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[13] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[12] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[11] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[10] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[9] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[8] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[7] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[6] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[5] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[4] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[3] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[2] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[1] ,\HyperRAM_Memory_Interface_Top_inst/u_hpram_top/rd_data_d0[0] ,syn_off0_vs,off0_syn_de}),
    .clk_i(I_clk)
);

endmodule
