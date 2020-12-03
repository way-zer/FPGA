module Main (
    input clk,rst_n,
    
    input btnMain,btnSwitch,
    input [15:0] key,//键盘按键
    output [127:0] matrixData,
    output [31:0] numbersData
);
    localparam Perpare = 2'h0;
    localparam Gaming = 2'h1;
    localparam EndTimeOut = 2'h2;
    localparam EndWin = 2'h3;
    reg [1:0] gameState=Perpare;

    wire clk1Hz;//分频时钟,1Hz 50%
    DivideClk u_DivideClk(clk,1,clk1Hz);//分频器
    reg [7:0] gameTime,score;
    wire [7:0] gameTimeBCD,scoreBCD;//BCD表示数
    D8421toBCD d1(gameTime,gameTimeBCD),d2(score,scoreBCD);
    assign numbersData = {gameTimeBCD,12'hfff,2'h0,gameState,scoreBCD};

    always @(*) begin//主游戏状态机
        if(!rst_n)gameState<=Perpare;
        else begin
            gameState <= gameState;
            case (gameState)
                Perpare: if(btnMain)gameState<=Gaming;
                Gaming: begin 
                    if(gameTime==0)
                        gameState<=EndTimeOut;
                    else if(score>=19)
                        gameState<=EndWin;
                end
                EndTimeOut,EndWin: if(btnMain)gameState<=Perpare;
            endcase
        end
    end
    always @(negedge clk1Hz)begin//游戏时间计数器
        case (gameState)
            Perpare: gameTime<=59;
            Gaming: gameTime<=gameTime-1;
            EndTimeOut: gameTime<=0;
            EndWin: gameTime<=gameTime;
        endcase
    end

    reg [7:0] random=8'b1;//M序列发生器产生随机数
    always @(posedge clk) begin
        if(!rst_n)random=8'b1;
        else random = {random[6:0],random[7]^random[0]};
    end

    //游戏主体逻辑处理
    reg [3:0] pos;
    reg [1:0] color;//颜色RG,同时代表分数
    reg waitBoom;//中间间隔
    wire finishBoom;
    GameMatrixDisplay u_GameMatrixDisplay(clk,gameState==Gaming,pos,color,waitBoom,finishBoom,matrixData);
    // GameMatrixDisplay u_GameMatrixDisplay(clk,1'b1,gameTime[3:0],gameTime[5:4],waitBoom,finishBoom,matrixData);

    wire timeout1s;//分频时钟,1Hz 脉冲
    DivideClk#(.N(10_000_000)) u2_DivideClk(clk,(gameState==Gaming)&&(~waitBoom),timeout1s);//分频器

    wire clockNext = timeout1s | finishBoom;//解决10237问题
    //获取下一个坐标点
    always@(posedge clockNext)begin
        pos <= random[7:4];
        color[1] <= random[1];//取随机数
        color[0] <= ~random[1] | random[0]; //保证不均为0
    end

    //按键检测及得分控制
    wire [15:0] correctKey = (16'b1)<<pos;
    always @(posedge clk) begin
        if(gameState==Perpare)score <=0;
        if(gameState==Gaming)begin
            if(finishBoom) waitBoom = 1'b0;
            else if(!waitBoom)begin
                if((key&correctKey)&&~(key^correctKey))begin//当前仅按下正确的按键
                    waitBoom = 1'b1;
                    score <= score+color;
                end
            end
        end else waitBoom = 1'b0;
    end
endmodule

module GameMatrixDisplay (
    input clk,en,
    input [3:0] pos,
    input [1:0] color,
    input showBoom,
    output finishBoom,
    output reg [127:0] matrixData
);
    reg [1:0] boomState;//0为准备态,1为第一动画,2为第二动画,3为动画完成态
    assign finishBoom = &boomState/**==3*/;

    wire clk2Hz;//分频时钟,2Hz脉冲,0.5s
    DivideClk#(.M(5_000_000)) u_DivideClk(clk,showBoom,clk2Hz);//分频器

    always @(negedge showBoom or posedge clk2Hz) begin
        if(!showBoom)boomState <=0;
        else boomState <= boomState+1;
    end

    always @(*) begin
        matrixData = 128'h0;
        if(en) begin
            if (~boomState[1]) begin// 0|1状态时,显示中间4点
                //         pos[3:2]取行 pos[1:0]取列 后配上偏移值
                matrixData[pos[3:2]*32+pos[1:0]*4+0]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+1]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+2]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+3]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+16]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+16+1]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+16+2]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+16+3]=color[0];
            end
            if(^boomState)begin//  1|2 状态时,显示周围8点
                matrixData[pos[3:2]*32+pos[1:0]*4-16+0]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4-16+1]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4-16+2]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4-16+3]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4-2]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4-1]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+4]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+5]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+16-2]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+16-1]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+16+4]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+16+5]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+32+0]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+32+1]=color[0];
                matrixData[pos[3:2]*32+pos[1:0]*4+32+2]=color[1];
                matrixData[pos[3:2]*32+pos[1:0]*4+32+3]=color[0];
            end
        end
    end
endmodule

module D8421toBCD (
    input [7:0] I,
    output [7:0] O
);
    assign O[7:4] = I / 10;
    assign O[3:0] = I % 4'd10;
endmodule