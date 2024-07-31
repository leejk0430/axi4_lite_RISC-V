module lab_RISCV #(


)
(
	input wire  s00_axi_aclk,
	input wire  s00_axi_aresetn,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
	input wire [2 : 0] s00_axi_awprot,
	input wire  s00_axi_awvalid,
	output wire  s00_axi_awready,
	input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
	input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
	input wire  s00_axi_wvalid,
	output wire  s00_axi_wready,
	output wire [1 : 0] s00_axi_bresp,
	output wire  s00_axi_bvalid,
	input wire  s00_axi_bready,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
	input wire [2 : 0] s00_axi_arprot,
	input wire  s00_axi_arvalid,
	output wire  s00_axi_arready,
	output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
	output wire [1 : 0] s00_axi_rresp,
	output wire  s00_axi_rvalid,
	input wire  s00_axi_rready
);




wire  w_mem_reset_n;
wire  w_run_pc_in;
wire [31:0] w_slave_reg1;
wire [31:0] w_slave_reg2;
wire [31:0] w_slave_reg3;




my_RISCV_ip_v1_0 #(

)
my_RISCV_ip_v1_0_inst(

    .w_mem_reset_n(w_mem_reset_n),
    .w_run_pc_in(w_run_pc_in),
    .w_slv_reg1(w_slv_reg1),
    .w_slv_reg2(w_slv_reg2),
    .w_slv_reg3(w_slv_reg3),



    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_areset(s00_axi_aresetn),



    .s00_axi_awaddr(s00_axi_awaddr),
    .s00_axi_awprot(s00_axi_awprot),
    .s00_axi_awvalid(s00_axi_awvalid),
    .s00_axi_awready(s00_axi_awready),

    .s00_axi_wdata(s00_axi_wdata),
    .s00_axi_wstrb(s00_axi_wstrb),
    .s00_axi_wvalid(s00_axi_wvalid),
    .s00_axi_wready(s00_axi_wready),

    .s00_axi_bresp(s00_axi_bresp),
    .s00_axi_bvalid(s00_axi_bvalid),
    .s00_axi_bready(s00_axi_bready),



    .s00_axi_araddr(s00_axi_araddr),
    .s00_axi_arprot(s00_axi_arprot),
    .s00_axi_arvalid(s00_axi_arvalid),
    .s00_axi_arready(s00_axi_arready),

    .s00_axi_rdata(s00_axi_rdata),
    .s00_axi_rvalid(s00_axi_rvalid),
    .s00_axi_rready(s00_axi_rready),
    .s00_axi_rresp(s00_axi_rresp),
);





risc_v_32bit_Single_Cycle #(

)
risc_v_32bit_Single_Cycle_inst (



    .clk (s00_axi_aclk),
    .reset_n(s00_axi_aresetn),
    
    .mem_reset_n(w_mem_reset_n),
    .run_pc_in(w_run_pc_in),


    .instruction_write(w_slave_reg1),
    .instruction_data(w_slave_reg2),
    .instruction_addr(w_slave_reg3),

);

// my first git diff
// my first git branch
// my first push test to github