//游戏点阵控制器
module GameMatrixDisplay (
    input clk,en,
    input [3:0] pos,
    input [1:0] color,
    input showBoom,//显示爆炸动画
    output finishBoom,//爆炸动画完成
    output reg [127:0] matrixData
);
    reg [1:0] boomState;//0为准备态,1为第一动画,2为第二动画,3为动画完成态
    assign finishBoom = &boomState/**==3*/;

    wire clk2Hz;//分频时钟,2Hz脉冲,0.5s
    DivideClk#(.M(5_000_000)) u_DivideClk(clk,showBoom,clk2Hz);//分频器

    always @(negedge showBoom or posedge clk2Hz) begin
        if(!showBoom)boomState <=2'd0;
        else boomState <= boomState+2'd1;
    end

    wire [1:0] row,col;
    assign row = pos[3:2];
    assign col = pos[1:0];
    wire [6:0] base = {row,1'h0,col,2'h0};
    always @(*) begin
        matrixData = 128'h0;//清屏
        if(en) begin
            if (~boomState[1]) begin// 0|1状态时,显示中间4点
                //         base 配上偏移值
                matrixData[base+0]=color[1];
                matrixData[base+1]=color[0];
                matrixData[base+2]=color[1];
                matrixData[base+3]=color[0];
                matrixData[base+16]=color[1];
                matrixData[base+16+1]=color[0];
                matrixData[base+16+2]=color[1];
                matrixData[base+16+3]=color[0];
            end
            if(^boomState)begin//  1|2 状态时,显示周围8点
                if(|row)begin//防止上溢出
                    matrixData[base-16+0]=color[1];
                    matrixData[base-16+1]=color[0];
                    matrixData[base-16+2]=color[1];
                    matrixData[base-16+3]=color[0];
                end
                if(|col)begin//防止左溢出
                    matrixData[base-2]=color[1];
                    matrixData[base-1]=color[0];
                    matrixData[base+16-2]=color[1];
                    matrixData[base+16-1]=color[0];
                end
                if (~&col) begin//防止右溢出
                    matrixData[base+4]=color[1];
                    matrixData[base+5]=color[0];
                    matrixData[base+16+4]=color[1];
                    matrixData[base+16+5]=color[0];
                end
                if (~&row) begin//防止下溢出 
                    matrixData[base+32+0]=color[1];
                    matrixData[base+32+1]=color[0];
                    matrixData[base+32+2]=color[1];
                    matrixData[base+32+3]=color[0];
                end
            end
        end
    end
endmodule