module Music (
    input clk,en,
    input [2:0] scale,//音阶数 0-6
    input [10:0] playTime,//持续ms数<2048
    output finish,
    output beep
);
    parameter BaseFreq = 1_000_000;
    // 各音阶周期，最大为3831
    parameter [0:32*7-1] ClkM = {BaseFreq/261,BaseFreq/294,BaseFreq/330,BaseFreq/349,BaseFreq/392,BaseFreq/440,BaseFreq/494};
    wire [6:0] clks;//各音符时钟
    generate 
        genvar genI;
        for (genI = 0; genI<7; genI=genI+1) begin:clkBlock
            DivideClk#(ClkM[genI*32+:32],ClkM[genI*32+:32]/2) u_DivideClk(clk,en,clks[genI]);
        end
    endgenerate
    assign beep = en&clks[scale];
    
    DivideClk#(BaseFreq/1000,BaseFreq/1000) u0(clk,en,clk1K);
    reg [10:0] cntT;
    always @(posedge clk1K or negedge en) begin
        if(!en)cntT<=0;
        else cntT <= cntT+1;
    end
    assign finish = cntT>playTime;
endmodule