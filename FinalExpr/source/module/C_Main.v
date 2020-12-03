module Main (
    input clk,rst_n,
    
    input btnMain,btnSwitch,
    input [15:0] key,//键盘按键
    output [127:0] matrixData,
    output [31:0] numbersData
);
    localparam Perpare = 2'h1;
    localparam Gaming = 2'h2;
    localparam EndTimeOut = 2'h0;
    localparam EndWin = 2'h3;
    reg [1:0] gameState=Perpare;

    reg [7:0] gameTime,score;
    wire clk1Hz;//分频时钟,1Hz 50%
    DivideClk u_DivideClk(clk,1'b1,clk1Hz);//分频器

    //游戏状态机时钟,分频降低速度,避免冒险
    wire clk1k;//分频时钟,1k Hz 50%
    DivideClk#(.M(10_000),.N(5_000)) u2_DivideClk(clk,1'b1,clk1k);
    //主游戏状态机
    always @(posedge clk1k) begin
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

    //数码管显示控制区
    wire [7:0] gameTimeBCD,scoreBCD;//BCD表示数
    D8421toBCD d1(gameTime,gameTimeBCD),d2(score,scoreBCD);
    wire [7:0] gameTimeShow = (gameState==EndTimeOut & clk1Hz)?8'hff:gameTimeBCD;
    wire [7:0] scoreShow = (gameState==EndWin & clk1Hz)?8'hff:scoreBCD;
    assign numbersData = {gameTimeShow,16'hffff,scoreShow};
    //游戏时间计数器
    always @(negedge clk1Hz)begin
        case (gameState)
            Perpare: gameTime<=8'd59;
            Gaming: gameTime<=gameTime-1'd1;
            EndTimeOut: gameTime<=1'd0;
            EndWin: gameTime<=gameTime;
        endcase
    end
    //M序列发生器产生随机数
    reg [7:0] random=8'b1;
    always @(posedge clk) begin
        if(!rst_n)random=8'b1;
        else random = {random[6:0],random[7]^random[0]};
    end

    //游戏主体逻辑处理
    reg [3:0] pos;
    reg [1:0] color;//颜色RG,同时代表分数
    reg waitBoom;//中间间隔
    wire finishBoom;

    wire timeout1s;//1s延时时钟
    DivideClk#(.N(10_000_000)) u3_DivideClk(clk,(gameState==Gaming)&&(~waitBoom),timeout1s);//1s延时器
    GameMatrixDisplay u_GameMatrixDisplay(clk,gameState==Gaming,pos,color,waitBoom,finishBoom,matrixData);//游戏点阵控制器

    //获取下一个坐标点
    wire clockNext = timeout1s | finishBoom;//解决10237问题
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

module D8421toBCD (
    input [7:0] I,
    output [7:0] O
);
    assign O[7:4] = I / 4'd10;
    assign O[3:0] = I % 4'd10;
endmodule