

module risc_v_32bit_Single_Cycle
(
    input clk, reset_n, mem_reset_n, run_pc_in, i_num_cycle
    input instruction_write, 
    input [31:0]instruction_data, 
    input [7:0] instruction_addr
);


/* 

localparameter  S_IDLE = 2'b00;
localparameter  S_RUN  = 2'b01;
localparameter  S_DONE = 2'b10;

reg [1:0]   c_state;
reg [1:0]   n_state; 

always @(posedge clk) begin
    if(!reset_n) begin
        c_state <= S_IDLE;
    end
    else begin
        c_state <= n_state;
    end
end


always @(*) begin
    case(c_state)
    S_IDLE: if(i_run)
        n_state = S_RUN;
    S_RUN: if(is_done)
        n_state = S_DONE;
    S_DONE: n_state = S_IDLE;
    default: n_state = c_state;
    endcase
end










*/
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