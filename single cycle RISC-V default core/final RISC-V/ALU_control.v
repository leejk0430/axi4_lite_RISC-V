module ALU_control
(
    input [1:0] ALUOp,      //input from control unit
    input [6:0] funct7,     //instruction[31:25]
    input [2:0] funct3,     //instruction[14:12]

    output [4:0] alu_ctrl_op
);

    wire [11:0] ALU_CONTROL_IN;
    reg   [4:0] alu_ctrl_op_reg;
    assign ALU_CONTROL_IN = {ALUOp,funct7,funct3};


    always @(*) begin
        casex(ALU_CONTROL_IN)


////////////////////////////////////////////////////////////////////R-format///////////////////////////////////////////////////////////////////////////////////////////////
        12'b10_0000000_000 : alu_ctrl_op_reg = 5'b00000;       //operation : add                                     ALU action : add
        12'b10_0100000_000 : alu_ctrl_op_reg = 5'b00001;       //operation : sub                                     ALU action : subtract
        12'b10_0000000_100 : alu_ctrl_op_reg = 5'b00010;       //operation : xor                                     ALU action : XOR
        12'b10_0000000_110 : alu_ctrl_op_reg = 5'b00011;       //operation : or                                      ALU action : OR
        12'b10_0000000_111 : alu_ctrl_op_reg = 5'b00100;       //operation : and                                     ALU action : AND
        12'b10_0000000_001 : alu_ctrl_op_reg = 5'b00101;       //operation : sll (shift_left_logic)                  ALU action : <<
        12'b10_0000000_101 : alu_ctrl_op_reg = 5'b00110;       //operation : srl (shift_right_logic)                 ALU action : >>
        12'b10_0100000_101 : alu_ctrl_op_reg = 5'b00111;       //operation : sra (arith shift_right)                 ALU action : >>>
        12'b10_0000000_010 : alu_ctrl_op_reg = 5'b01000;       //operation : slt (set_less_than(signed))             ALU action : (signed_rs1 < signed_rs2) ? 1 : 0;
        12'b10_0000000_011 : alu_ctrl_op_reg = 5'b01001;       //operation : sltu(set_less_than_unsigned)            ALU action : (rs1 < rs2) ? 1 : 0



////////////////////////////////////////////////////////////////////I-format////////////////////////////////////////////////////////////////////////////////////////////////
        12'b00_xxxxxxx_000 : alu_ctrl_op_reg = 5'b00000;       //operation : addi                                    ALU action : add
        12'b00_xxxxxxx_100 : alu_ctrl_op_reg = 5'b00010;       //operation : xori                                    ALU action : XOR
        12'b00_xxxxxxx_110 : alu_ctrl_op_reg = 5'b00011;       //operation : ori                                     ALU action : OR
        12'b00_xxxxxxx_111 : alu_ctrl_op_reg = 5'b00100;       //operation : andi                                    ALU action : AND

        12'b00_0000000_001 : alu_ctrl_op_reg = 5'b01010;       //operation : slli (shift_left_logic_imm)             ALU action : << imm[0:4]
        12'b00_0000000_101 : alu_ctrl_op_reg = 5'b01011;       //operation : srli (shift_right_logic_imm)            ALU action : >> imm[0:4]
        12'b00_0100000_101 : alu_ctrl_op_reg = 5'b01100;       //operation : srai (shift_left_arith_imm)             ALU action : >>> imm[0:4]
        12'b00_xxxxxxx_010 : alu_ctrl_op_reg = 5'b01000;       //operation : slti (set_less_than_imm_signed)         ALU action : (signed_rs1 < signed_imm) ? 1 : 0;
        12'b00_xxxxxxx_011 : alu_ctrl_op_reg = 5'b01001;       //operation : sltiu(set_less_than_imm_unsigned)       ALU action : (rs1 < imm) ? 1 : 0;

        12'b00_xxxxxxx_000 : alu_ctrl_op_reg = 5'b00000;       //operation : lb(load byte)                           ALU action : add
        12'b00_xxxxxxx_001 : alu_ctrl_op_reg = 5'b00000;       //operation : lh(load half)                           ALU action : add
        12'b00_xxxxxxx_010 : alu_ctrl_op_reg = 5'b00000;       //operation : lw(load word)                           ALU action : add
        12'b00_xxxxxxx_100 : alu_ctrl_op_reg = 5'b00000;       //operation : lbu(load byte(U))                       ALU action : add
        12'b00_xxxxxxx_101 : alu_ctrl_op_reg = 5'b00000;       //operation : lhu(load half(U))                       ALU action : add


////////////////////////////////////////////////////////////////////S-format//////////////////////////////////////////////////////////////////////////////////////////

        12'b01_xxxxxxx_000 : alu_ctrl_op_reg = 5'b00000;       //operation : sb(store byte)                             ALU_action : add
        12'b01_xxxxxxx_001 : alu_ctrl_op_reg = 5'b00000;       //operation : sh(store half)                             ALU_action : add
        12'b01_xxxxxxx_010 : alu_ctrl_op_reg = 5'b00000;       //operation : sh(store half)                             ALU_action : add

////////////////////////////////////////////////////////////////////B-format/////////////////////////////////////////////////////////////////////////////////////////

        12'b11_xxxxxxx_000 : alu_ctrl_op_reg = 5'b01101;       //operation : beq(branch if equal)                       ALU_action : (rs1 == rs2) ? 1 : 0;
        12'b11_xxxxxxx_001 : alu_ctrl_op_reg = 5'b01110;       //operation : bnq(branch if not_equal)                   ALU_action : (rs1 != rs2) ? 1 : 0;
        12'b11_xxxxxxx_100 : alu_ctrl_op_reg = 5'b01000;       //operation : blt(branch if larger_than)                 ALU_action : (signed_rs1 < signed_rs2) ? 1 : 0;
        12'b11_xxxxxxx_101 : alu_ctrl_op_reg = 5'b01111;       //operation : bge(branch if greater_or_equal)            ALU_action : (signed_rs1 >= signed_rs2) ? 1 : 0;
        12'b11_xxxxxxx_110 : alu_ctrl_op_reg = 5'b01001;       //operation : bltu(branch if larger_than_unsigned)       ALU_action : (rs1 < rs2) ? 1 : 0;
        12'b11_xxxxxxx_111 : alu_ctrl_op_reg = 5'b10000;       //operation : bgeu(branch if greater_or_equal_unsigned)  ALU_action : (rs1 >= rs2) ? 1 : 0;
    
        default : alu_ctrl_op_reg = 5'b11111;
        endcase
    end

    assign alu_ctrl_op = alu_ctrl_op_reg;
endmodule