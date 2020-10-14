module D3to8(
	input [2:0] I,
	output reg [0:7] O
);
	always@(I) case(I)
		3'b000: O <= 8'b0111_1111;
		3'b001: O <= 8'b1011_1111;
		3'b010: O <= 8'b1101_1111;
		3'b011: O <= 8'b1110_1111;
		3'b100: O <= 8'b1111_0111;
		3'b101: O <= 8'b1111_1011;
		3'b110: O <= 8'b1111_1101;
		3'b111: O <= 8'b1111_1110;
		default: O <= 8'hff;
	endcase
endmodule