module Num(
	input [3:0] numI,
	output reg [0:7] segO
);
	always@(numI) case(numI)
		0: segO <= 8'b1111_1100;
		1: segO <= 8'b0110_0000;
		2: segO <= 8'b1101_1010;
		3: segO <= 8'b1111_0010;
		4: segO <= 8'b0110_0110;
		5: segO <= 8'b1011_0110;
		6: segO <= 8'b1011_1110;
		7: segO <= 8'b1110_0000;
		8: segO <= 8'b1111_1110;
		9: segO <= 8'b1111_0110;
		default: segO= 0;
	endcase
endmodule