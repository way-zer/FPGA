module Week5 (
	input clkI,
	input [3:0] keyI,swI,
	output [7:0] ledO,
	output [0:7] segO1,segO2,
	output [1:0] segDig,
	output [5:0] rgbO
);
	assign rgbO = 6'b111111;
	assign segDig=0;
	reg [3:0] a,b;
	Num (a,segO1),(b,segO2);
	always @(negedge keyI[0]) a = a+1;
	always @(negedge keyI[1]) b = b+1;

	wire [3:0] s;
	wire cc;
	assign ledO = ~{cc,3'b000,s};

	Adder(a,b,0,s,cc);
endmodule