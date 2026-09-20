//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.03 Education
//Part Number: GW1NSR-LV4CQN48PC6/I5
//Device: GW1NSR-4C
//Created Time: Sun May  3 17:50:14 2026

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Gowin_EMPU_Top your_instance_name(
		.sys_clk(sys_clk), //input sys_clk
		.gpio(gpio), //inout [15:0] gpio
		.uart0_rxd(uart0_rxd), //input uart0_rxd
		.uart0_txd(uart0_txd), //output uart0_txd
		.mosi(mosi), //output mosi
		.miso(miso), //input miso
		.sclk(sclk), //output sclk
		.nss(nss), //output nss
		.master_pclk(master_pclk), //output master_pclk
		.master_prst(master_prst), //output master_prst
		.master_penable(master_penable), //output master_penable
		.master_paddr(master_paddr), //output [7:0] master_paddr
		.master_pwrite(master_pwrite), //output master_pwrite
		.master_pwdata(master_pwdata), //output [31:0] master_pwdata
		.master_pstrb(master_pstrb), //output [3:0] master_pstrb
		.master_pprot(master_pprot), //output [2:0] master_pprot
		.master_psel1(master_psel1), //output master_psel1
		.master_prdata1(master_prdata1), //input [31:0] master_prdata1
		.master_pready1(master_pready1), //input master_pready1
		.master_pslverr1(master_pslverr1), //input master_pslverr1
		.master_psel2(master_psel2), //output master_psel2
		.master_prdata2(master_prdata2), //input [31:0] master_prdata2
		.master_pready2(master_pready2), //input master_pready2
		.master_pslverr2(master_pslverr2), //input master_pslverr2
		.master_psel3(master_psel3), //output master_psel3
		.master_prdata3(master_prdata3), //input [31:0] master_prdata3
		.master_pready3(master_pready3), //input master_pready3
		.master_pslverr3(master_pslverr3), //input master_pslverr3
		.reset_n(reset_n) //input reset_n
	);

//--------Copy end-------------------
