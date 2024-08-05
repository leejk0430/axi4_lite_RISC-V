module Instruction_Memory #
(
    parameter col = 32,
    parameter row_i = 256
)
(
    input           clk, reset_n,
    input           instruction_write,
    input   [31:0]  instruction_data,
    input   [7:0]   instruction_addr,        //address for writing instruction
    
    input   [31:0]  PC,
    output  [31:0]  instruction
);
    wire    [7:0]   rom_addr = PC[9:2];

    reg [col-1:0] instruction_mem [0:row_i-1];

    assign instruction = instruction_mem[rom_addr];

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin : reset
            integer j;
            for (j=0 ; j <= row_i; j = j+1) begin
                instruction_mem[j] <= 32'b0; 
            end
        end
        else if (instruction_write) begin
            instruction_mem[instruction_addr] <= instruction_data;
        end
    end

endmodule