module lab_RISCV #(
    
    parameter C_S00_AXI_DATA_WIDTH 32,
    parameter C_S00_AXI_ADDR_WIDTH 5,

    parameter NUM_CYCLE_BIT 32
)
(
	input wire                                          s00_axi_aclk,
	input wire                                          s00_axi_aresetn,
	
    
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]             s00_axi_awaddr,
	input wire [2 : 0]                                  s00_axi_awprot,
	input wire                                          s00_axi_awvalid,
	output wire                                         s00_axi_awready,
	
    input wire [C_S00_AXI_DATA_WIDTH-1 : 0]             s00_axi_wdata,
	input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0]         s00_axi_wstrb,
	input wire                                          s00_axi_wvalid,
	output wire                                         s00_axi_wready,
	
    output wire [1 : 0]                                 s00_axi_bresp,
	output wire                                         s00_axi_bvalid,
	input wire                                          s00_axi_bready,
	
    
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]             s00_axi_araddr,
	input wire [2 : 0]                                  s00_axi_arprot,
	input wire                                          s00_axi_arvalid,
	output wire                                         s00_axi_arready,

	output wire [C_S00_AXI_DATA_WIDTH-1 : 0]            s00_axi_rdata,
	output wire [1 : 0]                                 s00_axi_rresp,
	output wire                                         s00_axi_rvalid,
	input wire                                          s00_axi_rready
);




wire                    w_o_idle;
wire                    w_o_running;
wire                    w_o_done;

wire [31:0]             w_i_num_cycle;
wire                    w_i_run;
wire                    w_mem_reset_n;

wire                    w_instruction_write;
wire [31:0]             w_slv_reg5;
wire [31:0]             w_slv_reg6;



my_RISCV_ip_v1_0 #(

    .C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
    .C_S00_AXI_ADDR_WIDTH(C_S00_AXI_DATA_WIDTH)

)
my_RISCV_ip_v1_0_inst(

    

    .w_i_idle(w_o_idle),
    .w_i_running(w_o_running),
    .w_i_done(w_o_done),

    .w_o_num_cycle(w_i_num_cycle),
    .w_o_run(w_i_run),
    .w_mem_reset_n(w_mem_reset_n),



    .w_instruction_write(w_instruction_write),
    .w_slv_reg5(w_slv_reg5),
    .w_slv_reg6(w_slv_reg6),


    
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

    .NUM_CYCLE_BIT(NUM_CYCLE_BIT)

)
risc_v_32bit_Single_Cycle_inst (



    .clk (s00_axi_aclk),
    .reset_n(s00_axi_aresetn),
    
    .mem_reset_n(w_mem_reset_n),
    .w_i_running (w_o_running),
    .w_i_done(w_o_done),


    .instruction_write(w_instruction_write),
    .instruction_data(w_slv_reg5),
    .instruction_addr(w_slv_reg6),

);




cycle_counter #(

    .NUM_CYCLE_BIT(NUM_CYCLE_BIT)

)
cycle_counter(


    .clk (s00_axi_aclk),
    .reset_n(s00_axi_aresetn),


    .i_num_cycle(w_i_num_cycle),
    .i_run(w_i_run),

    .o_idle(w_o_idle),
    .o_running(w_o_running),
    .o_done(w_o_done)
)