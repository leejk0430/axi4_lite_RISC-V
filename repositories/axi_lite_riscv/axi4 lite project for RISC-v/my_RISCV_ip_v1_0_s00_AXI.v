`timescale 1ns / 1ps

    module my_RISCV_ip_v1_0_s00_AXI #
    (
        parameter integer C_S00_AXI_DATA_WIDTH = 32;
        parameter integer C_S00_AXI_ADDR_WIDTH = 5;  //because we use 7 (0~6) register and each register is 4byte 7*4 = 28 (we use 28 byte) -> 5bits to represet each byte
    )
    (
        ///////user adds ports start///////////

        input wire                                  w_i_idle,                   //slv_reg0
        input wire                                  w_i_running,                //slv_reg0
        input wire                                  w_i_done,                   //slv_reg0

        output wire [31 : 0]                        w_o_num_cycle,              //slv_reg1
        output wire                                 w_o_run,                    //slv_reg2
        output wire                                 w_mem_reset_n,              //slv_reg3



        output wire                                 w_instruction_write,        //slv_reg4
        output wire [31 : 0]                        w_slv_reg5,                 //slv_reg5
        output wire [31 : 0]                        w_slv_reg6,                 //slv_reg6




        ///////user add ports ends/////////////




        input wire                                   S_AXI_ACLK,
        input wire                                   S_AXI_ARESETN,

        
        
        
        input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]      S_AXI_AWADDR,
        input wire [2 : 0]                           S_AXI_AWPROT,
        input wire                                   S_AXI_AWVALID,
        output wire                                  S_AXI_AWREADY,

        input wire [C_S00_AXI_DATA_WIDTH-1 : 0]      S_AXI_WDATA,
        input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0]  S_AXI_WSTRB,
        input wire                                   S_AXI_WVALID,
        output wire                                  S_AXI_WREADY,
        
        output wire [1 : 0]                          S_AXI_BRESP,
        output wire                                  S_AXI_BVALID,
        input wire                                   S_AXI_BREADY,



        
        
        input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]      S_AXI_ARADDR,
        input wire [2 : 0]                           S_AXI_ARPROT,
        input wire                                   S_AXI_ARVALID,
        output wire                                  S_AXI_ARREADY,

        output wire [C_S00_AXI_DATA_WIDTH-1 : 0]     S_AXI_RDATA,
        output wire                                  S_AXI_RVALID,
        input wire                                   S_AXI_RREADY,
        output wire [1 : 0]                          S_AXI_RRESP,
    )
    
    localparam integer  ADDR_LSB = (C_S00_AXI_DATA_WIDTH/32) + 1;
    localparam integer  OPT_MEM_ADDR_BITS = 1;

    integer             byte_index;

    reg [C_S00_AXI_DATA_WIDTH-1 : 0] slv_reg0;
    reg [C_S00_AXI_DATA_WIDTH-1 : 0] slv_reg1;
    reg [C_S00_AXI_DATA_WIDTH-1 : 0] slv_reg2;
    reg [C_S00_AXI_DATA_WIDTH-1 : 0] slv_reg3;



    reg [C_S00_AXI_DATA_WIDTH-1 : 0]            reg_data_out;

    

    wire slv_reg_wren;
    wire slv_reg_rden;

    reg                                         axi_awready;
    reg                                         aw_en;
    reg [C_S00_AXI_ADDR_WIDTH-1 : 0]            axi_awaddr;
    
    reg                                         axi_wready;

    reg                                         axi_bvalid;
    reg                      [1 : 0]            axi_bresp;

    reg [C_S00_AXI_DATA_WIDTH-1 : 0]            axi_araddr;
    reg                                         axi_arready;         

    reg [C_S00_AXI_DATA_WIDTH-1 : 0]            axi_rdata;                                      
    reg                                         axi_rvalid;
    reg                      [1 : 0]            axi_rresp;



    reg [C_S00_AXI_DATA_WIDTH-1 : 0]            reg_data_out;



    assign S_AXI_AWREADY    = axi_awready;
    
    assign S_AXI_WREADY     = axi_wready;

    assign S_AXI_BRESP      = axi_bresp;
    assign S_AXI_BVALID     = axi_bvalid;

    assign S_AXI_ARREADY    = axi_arready;

    assign S_AXI_RDATA      = axi_rdata;
    assign S_AXI_RVALID     = axi_rvalid;
    assign S_AXI_RRESP      = axi_rresp;








/////making signals for axi_awready when AWVALID and WVALID come in

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_awready <= 1'b0;
            aw_en <= 1'b1;
        end
        else begin
            if (~axi_awready && aw_en && S_AXI_AWVALID && S_AXI_WVALID) begin
                axi_awready <= 1'b1;
                aw_en <= 1'b0;
            end
            else if (S_AXI_BREADY && axi_bvalid) begin
                axi_awready <= 1'b0;
                aw_en <= 1'b1;
            end
            else begin
                axi_awready <= 1'b0;
            end
        end
    end

/////putting in axi_awaddr signal when needed
    
    
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_awaddr <= 0;
        end
        else begin
            if (~axi_awready && aw_en && S_AXI_AWVALID && S_AXI_WVALID) begin
                axi_awaddr <= S_AXI_AWADDR;
            end
        end
    end








    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_wready <= 1'b0;
        end
        else begin
            if (~axi_wready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
                axi_wready <= 1'b1;
            end
            else begin
                axi_wready <= 1'b0;
            end
        end
    end



/////////when aw handshake and w handshake both occured
    assign slv_reg_wren = S_AXI_AWVALID && axi_awready && S_AXI_WVALID && axi_wready; 


    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            slv_reg0 <= 0;
            slv_reg1 <= 0;
            slv_reg2 <= 0;
            slv_reg3 <= 0;
            slv_reg4 <= 0;
            slv_reg5 <= 0;
            slv_reg6 <= 0;
        end
        else begin
            if (slv_reg_wren) begin
                case (axi_awaddr[ADDR_LSB + OPT_MEM_ADDR_BITS : ADDR_LSB])     //[3:2] axi address memory is currently usig 4 (if using 16 you [5:2])
                    2'h0:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1) begin
                        if(S_AXI_WSTRB[byte_index]) begin
                            slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                    2'h1:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1) begin
                        if(S_AXI_WSTRB[byte_index]) begin
                            slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                    2'h2:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1) begin
                        if(S_AXI_WSTRB[byte_index]) begin
                            slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                    2'h3:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1) begin
                        if(S_AXI_WSTRB[byte_index]) begin
                            slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                    2'h4:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1) begin
                        if(S_AXI_WSTRB[byte_index]) begin
                            slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                    2'h5:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1) begin
                        if(S_AXI_WSTRB[byte_index]) begin
                            slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                    2'h6:
                    for (byte_index = 0; byte_index <= (C_S00_AXI_DATA_WIDTH/8)-1; byte_index = byte_index + 1) begin
                        if(S_AXI_WSTRB[byte_index]) begin
                            slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                default : begin
                    slv_reg0 <= slv_reg0;
                    slv_reg1 <= slv_reg1;
                    slv_reg2 <= slv_reg2;
                    slv_reg3 <= slv_reg3;
                    slv_reg4 <= slv_reg4;
                    slv_reg5 <= slv_reg5;
                    slv_reg6 <= slv_reg6;
                end
                endcase
            end
        end
    end


    always @(posedge S_AXI_ACLK) begin
        if(!S_AXI_ARESETN) begin
            axi_bvalid <= 1'b0;
            axi_bresp <= 2'b0;
        end
        else begin
            if (axi_awready && S_AXI_AWVALID && axi_wready && S_AXI_WVALID && ~axi_bvalid) begin
                axi_bvalid <= 1'b1;
                axi_bresp <= 2'b0;
            end
            else begin
                if (S_AXI_BREADY && axi_bvalid) begin
                    axi_bvalid <= 1'b0;
                end
            end
        end
    end












    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_arready <= 1'b0;
            axi_araddr <= 0;
        end
        else begin 
            if (~axi_arready && S_AXI_ARVALID) begin
                axi_arready <= 1'b1;
                axi_araddr <= S_AXI_ARADDR;
                end
            else begin
                axi_arready <= 1'b0;
            end
        end
    end


    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_rvalid <= 1'b0;
            axi_rresp <= 2'b0;
        end
        else begin
            if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
                axi_rvalid <= 1'b1;
                axi_rresp <= 2'b0;
            end
            else if (axi_rvalid && S_AXI_RREADY) begin
                axi_rvalid <= 1'b0;
            end
        end
    end



    assign slv_reg_rden = axi_arready && S_AXI_ARVALID && ~axi_rvalid;

    always @(*)
    begin
        case (axi_araddr[OPT_MEM_ADDR_BITS + ADDR_LSB : ADDR_LSB])
            2'h0 : reg_data_out <= slv_reg0;
            2'h1 : reg_data_out <= slv_reg1;
            2'h2 : reg_data_out <= slv_reg2;
            2'h3 : reg_data_out <= slv_reg3;
            2'h4 : reg_data_out <= slv_reg4;
            2'h5 : reg_data_out <= slv_reg5;
            2'h6 : reg_data_out <= slv_reg6;
            default : reg_data_out <= 0;
        endcase
    end


    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_rdata <= 0;
        end
        else begin
            if(slv_reg_rden) begin
                axi_rdata <= reg_data_out;
            end
        end
    end


    ////////////////////////add user logic////////////////////////


	reg r_done; // to keep done status, w_i_done is a 1 tick.
	
	always @(posedge S_AXI_ACLK) begin
    	if(!S_AXI_ARESETN) begin  // sync reset_n
    	    r_done <= 1'b0;  
    	end else if (w_i_done) begin
    	    r_done <= 1'b1;
		end else if (w_o_run) begin
			r_done <= 1'b0;
		end  
	// else. keep status
	end



    // generating tick signal for w_i_run
    reg r_run;

    always @(posedge S_AXI_ACLK) begin
        if(!S_AXI_ARESETN) begin
            r_run <= 0;
        end
        else begin
            r_run <= slv_reg2[0];
        end
    end


    //generating tick signal for w_instruction_write
    reg r_instruction_write;

    always @(posedge S_AXI_ACLK) begin
        if(!S_AXI_ARESETN) begin
            r_instruction_write <= 0;
        end
        else begin
            r_instruction_write <= slv_reg4[0];
        end
    end





    assign slv_reg0[0]                = w_i_idle;                                                     //for reading
    assign slv_reg0[1]                = w_i_running;                                                  //for reading
    assign slv_reg0[2]                = r_done;                                                       //for reading (because w_i_done is a tick signal we need to keep the status)


    assign w_o_num_cycle              = slv_reg1;                                                     //for writing
    assign w_o_run                    = ((r_run == 1'b0) && (slv_reg2[0] == 1'b1));                   //for writing (because w_o_run should be tick signal)
    assign w_mem_reset_n              = slv_reg3[0];                                                  //for writing


    
    assign w_instruction_write        = ((r_instruction_write == 1'b0) && (slv_reg4[0] == 1'b1);       //for writing (use tick)
    assign w_slv_reg5                 = slv_reg5;                                                      //for writing
    assign w_slv_reg6                 = slv_reg6;                                                      //for writing


    
    /////////////////////// end user logic////////////////////////

    endmodule


