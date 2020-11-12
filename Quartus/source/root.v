module Root(
	input clkI,
	input [3:0] keyI,swI,
	inout [35:0] gpio,
	output [7:0] ledO,
	output [0:7] segO1,segO2,
	output [1:0] segDig,
	output [5:0] rgbO
);
	//WEEK4 密码箱
	// PwdBox(clkI,swI,keyI,segO1,segO2,segDig,ledO,rgbO);

	//WEEK5 4位全加器
	//Week5(clkI,keyI,swI,ledO,segO1,segO2,segDig,rgbO);

	//Week7 两种译码器
	Week7(clkI,keyI,swI,ledO,segO1,segO2,segDig,rgbO);

	ExtendBroad_Test(clkI,gpio);
endmodule

