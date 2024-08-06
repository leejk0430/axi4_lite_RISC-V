module Control_Unit 
(
    input      [6:0] opcode,

    output reg [1:0] ALUOp, 
    output reg [2:0] ImmSel,
    output reg       Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite
);

    always @(*) begin
        case(opcode)
        7'b0110011 : begin                  //R-format
            ALUSrc      = 1'b0;
            MemtoReg    = 1'b0;
            RegWrite    = 1'b1;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b0;
            ALUOp       = 2'b10;
            ImmSel      = 3'b000;
        end
        7'b0010011 : begin                  //I-format    addi, xori, ori, andi, slli, srli, srai, slti, sltiu
            ALUSrc      = 1'b1;
            MemtoReg    = 1'b0;
            RegWrite    = 1'b1;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b0;
            ALUOp       = 2'b00;
            ImmSel      = 3'b001;
        end
        7'b0000011 : begin                  //I-format    lb,lh,lw, lbu, lhu
            ALUSrc      = 1'b1;
            MemtoReg    = 1'b1;
            RegWrite    = 1'b1;
            MemRead     = 1'b1;
            MemWrite    = 1'b0;
            Branch      = 1'b0;
            ALUOp       = 2'b00;
            ImmSel      = 3'b001;
        end
        7'b0100011 : begin                  //S-format   sb, sh, sw
            ALUSrc      = 1'b1;
            MemtoReg    = 1'bx;
            RegWrite    = 1'b0;
            MemRead     = 1'b0;
            MemWrite    = 1'b1;
            Branch      = 1'b0;
            ALUOp       = 2'b01;
            ImmSel      = 3'b010;
        end
        7'b1100011 : begin                  //SB-format (B-fromat)
            ALUSrc      = 1'b0; 
            MemtoReg    = 1'bx;
            RegWrite    = 1'b0;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b1;
            ALUOp       = 2'b11;
            ImmSel      = 3'b011;
        end
        7'b1101111 : begin                  //J-format (only jal)
            ALUSrc      = 1'b0;
            MemtoReg    = 1'b0;
            RegWrite    = 1'b1;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b1;
            ALUOp       = 2'bxx;
            ImmSel      = 3'b100;
        end
        7'b1100111 : begin                  //I-format (only jalr)
            ALUSrc      = 1'b1;
            MemtoReg    = 1'b0;
            RegWrite    = 1'b1;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b1;
            ALUOp       = 2'b00;
            ImmSel      = 3'b001;
        end 

        7'b0110111 : begin                  //u-format (only lui)
            ALUSrc      = 1'b0;
            MemtoReg    = 1'b0;
            RegWrite    = 1'b1;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b0;
            ALUOp       = 2'b0;
            ImmSel      = 3'b101;
        end
        7'b001011 : begin                   //u-format (only auipc)
            ALUSrc      = 1'b0;
            MemtoReg    = 1'b0;
            RegWrite    = 1'b1;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b0;
            ALUOp       = 2'b0;
            ImmSel      = 3'b110;
        end 
        default : begin
            ALUSrc      = 1'b0;
            MemtoReg    = 1'b0;
            RegWrite    = 1'b0;
            MemRead     = 1'b0;
            MemWrite    = 1'b0;
            Branch      = 1'b0;
            ALUOp       = 2'b00;
            ImmSel      = 3'b000;
        end
        endcase
    end

endmodule
        
