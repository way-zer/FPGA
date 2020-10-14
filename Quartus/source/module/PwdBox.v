//密码箱模块
module PwdBox(
	input clkI,
	input [3:0] swI,keyI,
	output [7:0] segO1,segO2,
	output [1:0] segDig,
	output [7:0] ledO,
	output [5:0] rgbO
);
	reg [7:0] pwd=0;
	reg open=0,lock=0;//开锁成功/失败报警状态
	wire [7:0] ans;
	reg fail=0;

	reg [2:0] rgbO1=3'b111;
	assign rgbO = {rgbO1,!lock,!open,1'b1};
	assign ledO = 8'b11111111;

	reg inputing=0;
	wire switchK, finishInput;
	NumDisplayInput(clkI,swI,inputing,switchK,finishInput,ans,segO1,segO2,segDig);

	// assign ledO={!inputing,!switchEnable,!switchK,!finishInput,!open,!lock,pwd!=ans,1'b11};//状态指示灯

	reg switchEnable=0;
	wire key0;//消抖后的主输入按键
	Debounce(clkI,keyI[0],key0);
	assign switchK = switchEnable && !key0;//输入时,重定向按键到输入组件
	wire key1;//消抖后的上锁按键
	Debounce(clkI,keyI[3],key1);
	always@(negedge key0 or posedge finishInput)begin
		if(finishInput)begin
			switchEnable<=0;//关闭重定向
			inputing<=0;//关闭输入状态
		end else begin
			if(!lock)
				if(!inputing)
					inputing <= 1;
				else
					switchEnable<=1;//开启按键重定向
			if(!inputing && !lock)//开始输入按键
				inputing<=1;
		end  
	end
	always@(negedge key1 or posedge finishInput) 
		if(finishInput)begin//完成输入
			if (open) begin
				pwd = ans;//修改密码
				rgbO1<=3'b101;
			end else begin
				if (ans==pwd) begin
					rgbO1<=3'b101;
					open<=1;
				end else begin
					rgbO1<=3'b011;
					fail = !fail;
				end
			end
		end else if(!key1)begin//上锁按键
			rgbO1<=3'b111;
			open<=0;
		end
	//锁定后逻辑
	wire unlock;
	DivideClk #(.M(3*12_000_000),.N(3*12_000_000))(clkI,lock,unlock);//从锁定开始60秒
	always @(posedge fail or posedge unlock)
		if(unlock)
			lock = 0;
		else if(fail)
			lock=1;
endmodule

//配套数字展示输入模块
module NumDisplayInput(
	input clkI,
	input [3:0] swI,
	input enable,
	input switch,
	output reg finish=0,//是否完成输入,完成回调高
	output reg [7:0] out,
	output [7:0] segO1,segO2,
	output [1:0] segDig
);
	reg [7:0] data = 0;
	reg pos = 0;//当前高低位,0为高位
	Num(data[7:4],segO1),(data[3:0],segO2);

	always @(data) if(enable)out=data;
	
	always @ (posedge switch or negedge enable)//switch切换下一步
		if(!enable)begin
			pos=0;
			finish=0;
		end else if(!pos) pos=1;
		else finish=1;
	always @ (swI or pos or enable)//拨码开关到数码管
		if(!enable)
			data = 0;
		else if(pos==0)
			data[7:4]=swI;
		else data[3:0]=swI;
	
	//控制当前位数码管闪烁
	wire clkO;
	DivideClk #(.M(6_000_000),.N(3_000_000)) (clkI,enable,clkO); //半秒50%波
	assign segDig[0] = !enable || (!pos && clkO);//输出0时,数码管显示  
	assign segDig[1] = !enable || (pos && clkO);  
endmodule