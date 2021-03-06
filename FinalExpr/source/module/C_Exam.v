module Exam (
    input clk,sw,//sw为主开关状态
    output finish,//完成自检状态指示,高电平有效

    output beep,//蜂鸣器输出
    output [127:0] matrixData,//点阵模块数据
    output [31:0] numbersData//数码管模块数据
);
    reg [2:0] t = 0;//状态,从自检开始的秒数
    wire clk1Hz;//分频时钟,1Hz 50%
    DivideClk u_DivideClk(clk,sw,clk1Hz);//分频器
    assign finish = (t==4);//t=7时标志着自检完成

    reg [1:0] color;//矩阵颜色RG
    wire [1:0] colorO = color &{clk1Hz,clk1Hz};//通过1Hz方波掩码后的颜色
    assign matrixData = {64{colorO}};

    reg showNum=0;//是否显示数码管
    wire [3:0] num = (showNum&clk1Hz)?4'h8:4'hf;//通过方波控制显示数字为8(全亮)或f(隐藏)
    // assign numbersData[31:28] = {1'b0,t};//显示自检状态
    assign numbersData[31:0] = {8{num}};

    reg [4:0] musicI=0;
    wire musicFinish;
    Music u_Music(clk,sw&~finish,musicI,125,musicFinish,beep);
    always @(posedge musicFinish or negedge sw) begin
        if(!sw) musicI <= 1'b0;
        else if (musicI == 5'd21)//播放完最后一个音符
            musicI <= 1'b0;
        else
            musicI <= musicI+1'b1;
    end
    

    always @(posedge clk1Hz or negedge sw) begin
        if(!sw) begin 
            t<=3'b0;
            color <=2'h0;
            showNum=0;
        end
        else if(!finish) begin
            t <= t+3'h1;
            case (t)
                0:  begin
                    color <= 2'b10;//红
                    showNum <= 1'b1;//闪烁数字
                end
                1:  color <= 2'b01;//绿
                2:  color <= 2'b11;//黄
                3: begin
                    color <= 2'b00;
                    showNum <= 1'b0;
                end
                default: t<=0;//不应当出现
            endcase
        end
    end
endmodule