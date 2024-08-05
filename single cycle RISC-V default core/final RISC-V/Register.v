module Register #
(
    parameter col = 32,
    parameter row_r = 32
)
(
    input             clk, reset_n,
    
    input             reg_write_en,
    input   [4:0]     reg_write_dest,
    input   [31:0]    reg_write_data,

    input   [4:0]     reg_read_addr_1,
    input   [4:0]     reg_read_addr_2,
    output  [31:0]    reg_read_data_1,
    output  [31:0]    reg_read_data_2
);

    reg [col-1:0] reg_array [0:row_r-1];

    assign reg_read_data_1 = reg_array[reg_read_addr_1];        
    assign reg_read_data_2 = reg_array[reg_read_addr_2];        

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin : reg_reset
            integer i;
            for(i=0; i <= 31; i=i+1) begin
                reg_array[i] <= 32'b0;
            end
        end
        else if(reg_write_en) begin
            reg_array[reg_write_dest] <= reg_write_data;
        end
    end

endmodule
