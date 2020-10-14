`timescale 1ns/1ps
module Root(
	input clkI,
	input [3:0] keyI,swI,
	output [7:0] ledO,
	output [0:7] segO1,segO2,
	output [1:0] segDig,
	output [5:0] rgbO
);
	PwdBox(clkI,swI,keyI,segO1,segO2,segDig,ledO,rgbO);
endmodule

