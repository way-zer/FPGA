//游戏点阵控制器
module GameMatrixDisplay (
    input clk,en,
    input [3:0] pos,
    input [1:0] color,
    input showBoom,//显示爆炸动画
    output reg finishBoom,//爆炸动画完成
    output reg [127:0] matrixData
);
    reg boomState;//0为第一动画,1为第二动画

    wire clk2Hz;//分频时钟,2Hz脉冲,0.5s
    DivideClk#(.M(500_000)) u_DivideClk(clk,showBoom,clk2Hz);//分频器

    always @(negedge showBoom or posedge clk2Hz) begin
        if(!showBoom)begin
            boomState <=1'd0;
            finishBoom <= 1'b0;
        end else begin 
            if(boomState) finishBoom <= 1'b1;
            else boomState <= 1'd1;
        end
    end

    wire [1:0] row,col;
    assign row = pos[3:2];
    assign col = pos[1:0];
    wire [6:0] base = {row,1'h0,col,2'h0};
    always @(*) begin
        matrixData = 128'h0;//清屏
        if(en) begin
            if (~boomState) begin// 0状态时,显示中间4点 showBoom为任意值，无需判断
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
            if(showBoom)begin//  0|1均时,显示周围8点 boomState为任意值，无需判断
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