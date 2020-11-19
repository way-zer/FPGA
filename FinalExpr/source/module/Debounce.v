//消抖模块(20ms)
module Debounce(clk,I,O);
	parameter Size = 1;
	parameter ClkSpeed = 10_000_000;//传入时钟速度

	input clk;
	input [Size-1:0] I;
	output reg [Size-1:0] O;
	
	reg [Size-1:0] pre,now;
	always @ (posedge clk) begin
		pre <=now;
		now <= I;
	end
	wire clkEnable = ~|(pre^now);
	wire clkO;
	DivideClk #(.M(ClkSpeed/50),.N(ClkSpeed/52)) u_DivideClk(clk,clkEnable,clkO);//20ms延时器
	initial O=I;
	always @(posedge clkO) O=pre;
endmodule