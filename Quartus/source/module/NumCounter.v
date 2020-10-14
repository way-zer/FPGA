//消抖对比计数器模块, segO1不消抖,segO2消抖输出
module NumCounter(
	input clkI,key,
	output [0:7] segO1,segO2
);
	wire debounced;
	Debounce(clkI,key,debounced);
	
	reg [3:0] num1,num2;
	Num (num1,segO1),(num2,segO2);
	
	always@(negedge key) num1=(num1+1)%10;
	always@(negedge debounced) num2=(num2+1)%10;
endmodule