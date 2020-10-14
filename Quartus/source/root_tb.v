`timescale 1ns/100ps
module Test;
	reg clkI=0;
	always begin
		#5 clkI=0;
		#5 clkI=1;
	end
	
	reg [3:0] swI=0;

	reg [3:0] key=0;
	initial begin
		#30 key =1;
		#30 key =0;
		#30 key =1;
		#30 key =0;
		#30 key =1;
		#30 key =0;
		#30 key =1;
		#30 key =0;
	end
	
	wire out;
	PwdBox _(clkI,key,out);
endmodule
