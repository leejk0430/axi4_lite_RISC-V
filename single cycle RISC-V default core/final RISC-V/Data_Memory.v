
module Data_Memory #
(
    parameter col = 32,                 //4byte
    parameter row = 1024
)
(

    input            clk, mem_reset_n,
    input  [31:0]    mem_access_addr,               //byte address
    
    input  [31:0]    mem_write_data,
    input            mem_write_en,
    input  [2:0]     STORE_type,

    input            mem_read_en,

    output [31:0]    w_mem_read_data
);

    reg [7:0]  mem_data [0:row*4-1];

    wire [31:0] mem_read_data;

    wire [11:0] read_word_masking = 12'b111111111100;
    wire [11:0] read_word_addr = mem_access_addr[11:0] & read_word_masking; //mem_access_addr [11:2] is for start of word address (meaning 4 byte is a word)
    
    wire write_mem_addr = mem_access_addr;

    wire [7:0] data_0, data_1, data_2, data_3;


    always @(posedge clk or negedge mem_reset_n) begin
        if(!mem_reset_n) begin : reset
            integer j;
            for (j=0; j<=row*4; j=j+1) begin
                mem_data[j] <= 0;
            end
        end
        else if(mem_write_en) begin : mem_write
                if(STORE_type == 2'b00)
                    mem_data[write_mem_addr] <= mem_write_data[7:0];
                else if(STORE_type ==  2'b01)
                    mem_data[write_mem_addr] <= mem_write_data[15:0];
                else
                    mem_data[write_mem_addr] <= mem_write_data;
        end
    end


    assign data_0 = mem_data[read_word_addr + 2'b00];
    assign data_1 = mem_data[read_word_addr + 2'b01];
    assign data_2 = mem_data[read_word_addr + 2'b10];
    assign data_3 = mem_data[read_word_addr + 2'b11];

    assign mem_read_data = {data_3, data_2, data_1, data_0};


    assign w_mem_read_data = (mem_read_en == 1'b1) ? mem_read_data : 32'b0;

endmodule





