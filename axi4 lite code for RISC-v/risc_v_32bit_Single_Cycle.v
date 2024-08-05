

module risc_v_32bit_Single_Cycle
(
    input clk, 
    input reset_n, 
    input mem_reset_n, w_i_running , w_i_done,
    
    input instruction_write, 
    input [31:0]instruction_data, 
    input [7:0] instruction_addr
);
(
    wire w_reset_n;

    assign w_reset_n = ~((!reset_n) || (w_o_done));


    wire [6:0] opcode;
    wire [1:0] ALUOp, ImmSel;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;


    Datapath_Unit Unit_DP(  .clk(clk),  .reset_n(w_reset_n),  .mem_reset_n(mem_reset_n),  .run_pc(w_o_running),
    .instruction_write(instruction_write),  .instruction_data(instruction_data),    .instruction_addr(instruction_addr),
    .ALUOp(ALUOp),  .ImmSel(ImmSel),    .Branch(Branch),    .MemRead(MemRead),   .MemtoReg(MemtoReg),   .MemWrite(MemWrite), 
    .ALUSrc(ALUSrc),    .RegWrite(RegWrite),    .opcode(opcode));


    Control_Unit Unit_Ctrl(    .opcode(opcode),   .ALUOp(ALUOp),     .ImmSel(ImmSel),   .Branch(Branch),    .MemRead(MemRead),
    .MemtoReg(MemtoReg),    .MemWrite(MemWrite),    .ALUSrc(ALUSrc),    .RegWrite(RegWrite));
)

endmodule