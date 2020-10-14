//消抖模块(20ms)
module Debounce(
	input clkI,
	input I,
	output reg O
);
	reg pre,now;
	always @ (posedge clkI) begin
		pre <=now;
		now <=I;
	end
	wire clkEnable = pre==now;
	wire clkO;
	DivideClk #(.M(240_000),.N(200_000)) _(clkI,clkEnable,clkO);//20ms延时器
	initial O=I;
	always @(posedge clkO) O=pre;
endmodule