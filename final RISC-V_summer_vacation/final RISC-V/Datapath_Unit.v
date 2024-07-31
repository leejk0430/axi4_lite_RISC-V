

module Datapath_Unit
(   
    input       clk, reset_n,mem_reset_n, run_pc,
    
    input       instruction_write,
    input       [31:0]instruction_data,
    input       [3:0] instruction_addr,    
    
    
    input [1:0] ALUOp, 
    input [2:0] ImmSel,
    input       Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,

    output [6:0] opcode
);

    reg  [31:0] pc_current;
    wire  [31:0] pc_next;

    wire [31:0] pc4;
    wire [31:0] pc_branch;

    wire [31:0] write_reg_data;

    wire [31:0] w_rd1;
    wire [31:0] w_rd2;
    wire [31:0] imm_gen_op;

    wire        Zero;
    wire [31:0] alu_result;

    wire [31:0] instruction;

    wire [4:0] read_reg_1;
    wire [4:0] read_reg_2;
    wire [4:0] write_reg;
    wire [31:0] imm_gen_in;
    wire [6:0] funct7;
    wire [2:0] funct3;


    wire [31:0] alu_in_1;
    wire [31:0] alu_in_2;

    wire [4:0] alu_ctrl_op;

    wire [31:0] mem_read_data;

    wire [31:0] w_mem_read_data;



    wire LOAD_sign;

    wire [31:0] LOAD_data;
    wire [15:0] LOAD_halfword;
    wire [7:0]  LOAD_byte;

    wire [31:0] STORE_data;
    wire [31:0] STORE_addr;


    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            pc_current <= 31'b0;
        end
        else if (run_pc) begin
            pc_current <= pc_next;
        end
    end


    assign pc4 = pc_current + 32'd4;
    assign pc_branch = pc_current + imm_gen_op;

    assign pc_next = (Branch & Zero) ? pc_branch :                      //(Branch & Zero) is for B-type
                    (Branch & RegWrite & ALUSrc) ? alu_result :         //(Branch & RegWrite & ALUSrc) is for jalr
                    (Branch & RegWrite) ? pc_branch : pc4;              //(Branch & RegWrite) is for jal


    Instruction_Memory unit_im(  .clk(clk),  .reset_n(reset_n),  .instruction_write(instruction_write), .instruction_data(instruction_data),
    .instruction_addr(instruction_addr),  .PC(pc_current),    .instruction(instruction));


    assign opcode       = instruction [6:0];
    assign read_reg_1   = instruction [19:15];              //rs1
    assign read_reg_2   = instruction [24:20];              //rs2
    assign write_reg    = instruction [11:7];               //rd
    assign imm_gen_in   = instruction;
    assign funct7       = instruction [31:25];
    assign funct3       = instruction [14:12];



    Register unit_reg(  .clk(clk),   .reset_n(reset_n),  .reg_write_en(RegWrite),   .reg_read_addr_1(read_reg_1),   .reg_read_addr_2(read_reg_2),
    .reg_write_dest(write_reg),     .reg_write_data(write_reg_data),     .reg_read_data_1(w_rd1),      .reg_read_data_2(w_rd2));


    Imm_Gen unit_imm_gen(   .ImmSel(ImmSel),    .instruction(imm_gen_in),    .imm_gen_op(imm_gen_op));

    
    assign alu_in_1 = w_rd1;
    assign alu_in_2 = ALUSrc ? imm_gen_op : w_rd2;

    
    ALU_control unit_alu_cnt(   .ALUOp(ALUOp),  .funct7(funct7),    .funct3(funct3),     .alu_ctrl_op(alu_ctrl_op));

    
    ALU unit_alu(   .a(alu_in_1),   .b(alu_in_2),   .alu_control(alu_ctrl_op),  .zero(Zero),    .alu_result(alu_result));

    

    assign write_reg_data = MemtoReg ? mem_read_data :
                            Branch ? pc4 :
                            (ImmSel == 101) ? imm_gen_op : 
                            (ImmSel == 110) ? pc_current + imm_gen_op : alu_result;
    
    assign w_mem_access_addr = MemRead ? alu_result :
                               MemWrite ? STORE_addr : 32'b0;                       //mem_access_addr depending on read or write in mem
    
//////////////////////////////////////////////////////code for lb,lh, lw, lbu, lhu/////////////////////////////////////////// 


    wire mem_byteAccess     = instruction[13:12] == 2'b00;          //instruction[13:12] is first 2 bits of funct3
    wire mem_halfwordAccess = instruction[13:12] == 2'b01;


    assign LOAD_sign = !instruction[14] & (mem_byteAccess ? LOAD_byte[7] : LOAD_halfword[15]);     //instruction[14] distinguish signed and unsigned extends

    assign LOAD_data = mem_byteAccess ? {{24{LOAD_sign}}, LOAD_byte} :
                        mem_halfwordAccess ? {{16{LOAD_sign}}, LOAD_halfword} : w_mem_read_data ;
    
    assign LOAD_halfword = alu_result[1] ? w_mem_read_data[31:16] : w_mem_read_data[15:0];
    assign LOAD_byte     = alu_result[0] ? LOAD_halfword [15:8] : LOAD_halfword [7:0];              //memory alignment after reading from memory


    assign mem_read_data = LOAD_data;
    
/////////////////////////////////////////////////////code for sb, sh, sw////////////////////////////////////////////////////

    assign STORE_data = mem_byteAccess ? w_rd2[7:0] :
                        mem_halfwordAccess ? w_rd2[15:0] : w_rd2[31:0];
        

    assign STORE_addr = mem_byteAccess ? alu_result :
                        mem_halfwordAccess ? alu_result & 2'b10 : alu_result & 3'b100;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        



    Data_Memory unit_data_mem(  .clk(clk),  .mem_reset_n(mem_reset_n),  .mem_access_addr(w_mem_access_addr),   .mem_write_data(STORE_data), 
    .mem_write_en(MemWrite),    .STORE_type(instruction[13:12]), .mem_read_en(MemRead),     .w_mem_read_data(w_mem_read_data));









endmodule


