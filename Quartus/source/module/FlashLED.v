//流水灯模块
module FlashLED(
	input clkI,
	output [7:0] ledO
);	
	wire clkW;//1s周期
	DivideClk(clkI,1,clkW);
	
	reg [2:0] i=0;//0-7循环
	always @(posedge clkW) i=i+1;
	
	D3to8(i,ledO);//显示到LED
endmodule