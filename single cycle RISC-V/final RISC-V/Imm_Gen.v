module Imm_Gen
(
    
    input  [2:0]  ImmSel,
    input  [31:0] instruction,        
    output [31:0] imm_gen_op
);
    reg  [20:0] offset; 
    
    wire   [31:0]     imm_ext_1;
    wire   [31:0]     imm_ext_2;
    wire   [31:0]     imm_ext_3;
    wire   [31:0]     imm_ext_4;

    assign imm_gen_op = (ImmSel == (3'b101 | 3'b110)) ? imm_ext_4 :
    (ImmSel == 3'b100) ? imm_ext_3 :
    (ImmSel == 3'b011) ? imm_ext_2 : imm_ext_1;

    assign imm_ext_1 = {{20{offset[11]}}, offset[11:0]};
    assign imm_ext_2 = {{19{offset[12]}}, offset[12:1], 1'b0};          //only for B-type
    assign imm_ext_3 = {{11{offset[20]}}, offset[20:1], 1'b0};          //only for j-type
    assign imm_ext_4 = {offset, 12'b0};                                 //only for U-type

    always @(*) begin
        case(ImmSel)
        3'b000 : offset = instruction[31:20];    //R-type (actually doesnt matter because R-type lets out ALUSrc to 0)
        3'b001 : offset = instruction[31:20];    //load, I-type, addi(I-type) 
        3'b010 : offset = {instruction[31:25], instruction[11:7]};     //store, S-type
        3'b011 : offset = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};  //beq, SB-type(B), shift 1bit left (imm[12:1],1'b0)
        3'b100 : offset = {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};     //j-type (imm[20:1], 1'b0)
        3'b101 : offset = instruction[31:12];
        3'b110 : offset = instruction[31:12];
        default : offset = instruction[31:20];
        endcase
    end
endmodule
