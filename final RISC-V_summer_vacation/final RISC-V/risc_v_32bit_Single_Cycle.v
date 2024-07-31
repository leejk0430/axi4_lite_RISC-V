

module risc_v_32bit_Single_Cycle
(
    input clk, reset_n, mem_reset_n, run_pc, 
    input instruction_write, 
    input [31:0]instruction_data, 
    input [7:0] instruction_addr
);









    wire [6:0] opcode;
    wire [1:0] ALUOp, ImmSel;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;


    Datapath_Unit Unit_DP(  .clk(clk),  .reset_n(reset_n),  .mem_reset_n(mem_reset_n),  .run_pc(run_pc),
    .instruction_write(instruction_write),  .instruction_data(instruction_data),    .instruction_addr(instruction_addr),
    .ALUOp(ALUOp),  .ImmSel(ImmSel),    .Branch(Branch),    .MemRead(MemRead),   .MemtoReg(MemtoReg),   .MemWrite(MemWrite), 
    .ALUSrc(ALUSrc),    .RegWrite(RegWrite),    .opcode(opcode));


    Control_Unit Unit_Ctrl(    .opcode(opcode),   .ALUOp(ALUOp),     .ImmSel(ImmSel),   .Branch(Branch),    .MemRead(MemRead),
    .MemtoReg(MemtoReg),    .MemWrite(MemWrite),    .ALUSrc(ALUSrc),    .RegWrite(RegWrite));

endmodule