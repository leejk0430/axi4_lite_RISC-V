
`timescale 1ns / 1ps

module tb_RISC_V_32bit_Single_Cycle();



reg clk, reset_n, mem_reset_n, pc_run;
reg instruction_write;

reg [31:0] instruction_data;
reg [7:0] instruction_addr;


risc_v_32bit_Single_Cycle   unit_riscv_32(  .clk(clk),  .reset_n(reset_n),  .mem_reset_n(mem_reset_n),  .run_pc(pc_run),
    .instruction_write(instruction_write),     .instruction_data(instruction_data),     .instruction_addr(instruction_addr));

initial begin

    clk <= 1;
    reset_n <= 0;
    mem_reset_n <= 0;
    pc_run <= 0;
    instruction_write <= 0;


    #10
    reset_n <= 1;
    mem_reset_n <= 1;

    instruction_write <= 1;
    instruction_addr <= 7'b0000000;
    instruction_data <= 32'b000000000101_00111_000_00011_0010011; //machine code for addi because reg and data memory is empty(3번쨰 reg(dest(rd))에 7번째 reg(base) 값에 5(offset)를 더한값을 저장 )
   
   
    /*#10
    instruction_addr <= 7'b000001;
    instruction_data <= 32'b0000000_10011_00011_000_01100_0110011; // add    rd = rs1 + rs2      (12번째 reg(dest(rd))에  3번째 reg(rs1) 값과 19번째 reg(rs2) 를 더한값을 저장   )

    #10
    instruction_addr <= 7'b000010;
    instruction_data <= 32'b10100010101010010101010101001100010101010; blah blah blah

    00000000010100111000000110010011
    .
    .

    */

    #10
    instruction_write <= 0;
    pc_run <= 1;


    #200
    $finish;
end



always begin
    #5 clk = ~clk;
end
endmodule
