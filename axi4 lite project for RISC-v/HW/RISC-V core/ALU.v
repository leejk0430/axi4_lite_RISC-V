//alu_control depend on funct7 field(31:25) and funct3 field(14:12)
module ALU
(
    input [31:0] a,
    input [31:0] b,
    input [4:0] alu_control,

    output zero,
    output reg [31:0] alu_result
);

    reg [31:0] signed_a;
    reg [31:0] signed_b; 

    always @(*) begin
        case(alu_control)

        5'b00000 : alu_result = a + b;
        5'b00001 : alu_result = a - b;
        5'b00010 : alu_result = a ^ b;
        5'b00011 : alu_result = a | b;
        5'b00100 : alu_result = a & b;

        5'b00101 : alu_result = a << b;
        5'b00110 : alu_result = a >> b;
        5'b00111 : alu_result = a >>> b;
        5'b01000 : begin 
            signed_a = $signed(a);
            signed_b = $signed(b);
            alu_result = (signed_a < signed_b) ? 1 : 0;
        end 
        5'b01001 : alu_result = (a < b) ? 1 : 0;
        5'b01010 : alu_result = a << b[4:0];
        5'b01011 : alu_result = a >> b[4:0];
        5'b01100 : alu_result = a >>> b[4:0];

        5'b01101 : alu_result = (a == b) ? 1 : 0;
        5'b01110 : alu_result = (a != b) ? 1 : 0;
        5'b01111 : begin
            signed_a = $signed(a);
            signed_b = $signed(b);
            alu_result = (signed_a >= signed_b) ? 1 : 0;
        end
        5'b10000 : alu_result = (a >= b) ? 1 : 0;
        default : alu_result = 0;
        endcase
    end
    
    assign zero = (alu_result == 1);

endmodule

