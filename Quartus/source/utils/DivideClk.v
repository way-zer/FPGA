/**
* 分时器模块
* enable控制分时器的运行
* 通过M,N调节循环周期和占空比
*/
module DivideClk(
	input clkI,
	input enable,//0时关闭计算器,且归零
	output reg clkO
);
//	parameter WIDTH = 24;
	parameter M = 12_000_000;
	parameter N = 6_000_000;
	localparam WIDTH = $clog2(M+1);
	
	reg [WIDTH-1:0] r=1;//在1->M中循环
	
	always @ (posedge clkI or negedge enable) begin
		if(!enable) begin//未启用,全部置零
			clkO <= 0;
			r <= 1;
		end else begin
			clkO <= r>=N || r==M;
			if(r==M)
				r<=1;
			else 
				r<=r+1;
		end
	end
endmodule