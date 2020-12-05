module Music (
    input clk,en,
    input [4:0] scale,//音阶数 1-21,0为空音
    input [10:0] playTime,//持续ms数<2048
    output finish,
    output beep
);
    parameter BaseFreq = 1_000_000;
    // 各音阶周期，最大为3831
    parameter [0:32*7*3-1] ClkM = {
        BaseFreq/261,BaseFreq/294,BaseFreq/330,BaseFreq/349,BaseFreq/392,BaseFreq/440,BaseFreq/494,//低音
        BaseFreq/523,BaseFreq/587,BaseFreq/659,BaseFreq/698,BaseFreq/784,BaseFreq/880,BaseFreq/988,//中音
        BaseFreq/1047,BaseFreq/1175,BaseFreq/1319,BaseFreq/1397,BaseFreq/1568,BaseFreq/1760,BaseFreq/1096//高音
    };
    wire [11:0] M=ClkM[(scale-1)*32+:32];
    wire clkO;
    DivideClkMN#(12) u_DivideClkMN(clk,en,M,M>>1,clkO);
    assign beep = |scale?(en&clkO):1'b0;
    
    DivideClk#(BaseFreq/1000,BaseFreq/1000) u0(clk,en,clk1K);
    reg [10:0] cntT=0;
    always @(posedge clk1K or negedge en) begin
        if(!en)cntT<=0;
        else if(finish) cntT<=0;
        else cntT <= cntT+1;
    end
    assign finish = cntT>=playTime;
endmodule