
`timescale 1ns / 1ps

module my_RISCV_ip_v1_0 #
(
    parameter C_S00_AXI_DATA_WIDTH = 32,
    parameter C_S00_AXI_ADDR_WIDTH = 5
)
(


    ///////////////user ports///////////////////


    input  wire                                      w_i_idle,
    input  wire                                      w_i_running,
    input  wire                                      w_i_done,                                 

    output wire [31:0]                               w_o_num_cycle,
    output wire                                      w_o_run,
    output wire                                      w_mem_reset_n,


    output wire                                      w_instruction_write,       
    output wire [31:0]                               w_slv_reg5,                //instruction data
    output wire [31:0]                               w_slv_reg6,                //instruction addr





    ///////////////user ports//////////////////



    input wire                                   s00_axi_aclk,
    input wire                                   s00_axi_aresetn,


    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]      s00_axi_awaddr,
    input wire [2 : 0]                           s00_axi_awprot,
    input wire                                   s00_axi_awvalid,
    output wire                                  s00_axi_awready,


    input wire [C_S00_AXI_DATA_WIDTH-1 : 0]      s00_axi_wdata,
    input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0]  s00_axi_wstrb,
    input wire                                   s00_axi_wvalid,
    output wire                                  s00_axi_wready,

    output wire [1 : 0]                          s00_axi_bresp,
    output wire                                  s00_axi_bvalid,
    input wire                                   s00_axi_bready,




    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]      s00_axi_araddr,
    input wire [2 : 0]                           s00_axi_arprot,
    input wire                                   s00_axi_arvalid,
    output wire                                  s00_axi_arready,

    output wire [C_S00_AXI_DATA_WIDTH-1 : 0]     s00_axi_rdata,
    output wire                                  s00_axi_rvalid,
    input wire                                   s00_axi_rready,
    output wire [1 : 0]                          s00_axi_rresp

);



my_RISCV_ip_v1_0_s00_AXI #
(
    .C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
    .C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
)
my_RISCV_ip_v1_0_s00_AXI_inst (

    ///////////user ports///////////////
   

    .w_i_idle(w_i_idle),
    .w_i_running(w_i_running),
    .w_i_done(w_i_done),

    .w_o_num_cycle(w_o_num_cycle),
    .w_o_run(w_o_run),
    .w_mem_reset_n(w_mem_reset_n),


    .w_instruction_write(w_instruction_write),
    .w_slv_reg5(w_slv_reg5),
    .w_slv_reg6(w_slv_reg6),





    //////////user port ends////////////

    .S_AXI_ACLK(s00_axi_aclk),
    .S_AXI_ARESETN(s00_axi_aresetn),



    .S_AXI_AWADDR(s00_axi_awaddr),
    .S_AXI_AWPROT(s00_axi_awprot),
    .S_AXI_AWVALID(s00_axi_awvalid),
    .S_AXI_AWREADY(s00_axi_awready),

    .S_AXI_WDATA(s00_axi_wdata),
    .S_AXI_WSTRB(s00_axi_wstrb),
    .S_AXI_WVALID(s00_axi_wvalid),
    .S_AXI_WREADY(s00_axi_wready),

    .S_AXI_BRESP(s00_axi_bresp),
    .S_AXI_BVALID(s00_axi_bvalid),
    .S_AXI_BREADY(s00_axi_bresp),


    
    .S_AXI_ARADDR(s00_axi_araddr),
    .S_AXI_ARPROT(s00_axi_arprot),
    .S_AXI_ARVALID(s00_axi_arvalid),
    .S_AXI_ARREADY(s00_axi_arready),

    .S_AXI_RDATA(s00_axi_rdata),
    .S_AXI_RVALID(s00_axi_rvalid),
    .S_AXI_RREADY(s00_axi_rready),
    .S_AXI_RRESP(s00_axi_rresp)
);

//////////user logic start///////////////




/////////////user logic ends////////////

endmodule


