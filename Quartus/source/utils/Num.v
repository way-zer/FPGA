module Num(
	input [3:0] numI,
	output reg [0:7] segO
);
	always@(numI) case(numI)
		4'h0: segO <= 8'b1111_1100;
		4'h1: segO <= 8'b0110_0000;
		4'h2: segO <= 8'b1101_1010;
		4'h3: segO <= 8'b1111_0010;
		4'h4: segO <= 8'b0110_0110;
		4'h5: segO <= 8'b1011_0110;
		4'h6: segO <= 8'b1011_1110;
		4'h7: segO <= 8'b1110_0000;
		4'h8: segO <= 8'b1111_1110;
		4'h9: segO <= 8'b1111_0110;
		4'ha: segO <= 8'b1110_1110;
		4'hb: segO <= 8'b0011_1110;
		4'hc: segO <= 8'b1001_1100;
		4'hd: segO <= 8'b0111_1010;
		4'he: segO <= 8'b1001_1110;
		4'hf: segO <= 8'b1000_1110;
		default: segO= 0;
	endcase
endmodule