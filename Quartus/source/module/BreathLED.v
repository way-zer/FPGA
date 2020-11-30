//呼吸灯模块
module BreathLED(
	input clkI,
	output ledO
);
	parameter init=0;//0~2047范围,控制初始状态
	reg [10:0] cnt1,cnt2= (init<1024?init:1024-init);
	always @(posedge clkI) cnt1=cnt1+1;
	
	reg increase= (init>=1024);
	wire clk2;
	DivideClk #(.M(12_000_000/2048)) (clkI,1,clk2);
	always @(posedge clk2) begin
		if(&cnt2)increase=0;
		else if(!cnt2)increase=1;
		if(increase)cnt2=cnt2+1;
		else cnt2=cnt2-1;
	end
	assign ledO = cnt1>cnt2;
endmodule