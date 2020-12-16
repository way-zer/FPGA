module Main (
    input clk,rst_n,
    
    input btnMain,btnSwitch,
    input [15:0] key,//键盘按键
    output beep,
    output [127:0] matrixData,
    output [31:0] numbersData
);
    localparam Perpare = 2'h1;
    localparam Gaming = 2'h2;
    localparam EndTimeOut = 2'h0;
    localparam EndWin = 2'h3;
    reg [1:0] gameState=Perpare;
    reg [1:0] difficult=0;//难度，数字越大，反应时间越少

    reg [7:0] gameTime,score;
    wire clk1Hz;//分频时钟,1Hz 50%
    DivideClk u_DivideClk(clk,1'b1,clk1Hz);//分频器

    //游戏状态机时钟,分频降低速度,避免冒险
    wire clk1k;//分频时钟,1k Hz 50%
    DivideClk#(.M(1_000),.N(500)) u2_DivideClk(clk,1'b1,clk1k);
    //主游戏状态机
    always @(posedge clk1k) begin
        if(!rst_n)gameState<=Perpare;
        else begin
            gameState <= gameState;
            case (gameState)
                Perpare: if(btnMain&&gameTime==8'd59)gameState<=Gaming;//增加时间判断,确保各项参数初始化完成,游戏状态稳定
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
    assign numbersData = {gameTimeShow,8'hff,2'h0,difficult,4'hf,scoreShow};
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
    //难度控制
    always @(posedge btnSwitch) begin
        if(gameState!=Gaming)//游戏中不能切换
            difficult = difficult+1;
    end

    //游戏主体逻辑处理
    reg [3:0] pos;
    reg [1:0] color;//颜色RG,同时代表分数
    reg waitBoom;//中间间隔
    wire finishBoom;

    localparam [0:95] Ms = {24'd2000_000,24'd1000_000,24'd500_000,24'd200_000};
    wire [23:0] M= Ms[difficult*24+:24];
    wire timeout;//延时时钟
    DivideClkMN#(24) u_DivideClkMN(clk,(gameState==Gaming)&&(~waitBoom),M,M,timeout);//延时器
    GameMatrixDisplay u_GameMatrixDisplay(clk,gameState==Gaming,pos,color,waitBoom,finishBoom,matrixData);//游戏点阵控制器

    //获取下一个坐标点
    wire clockNext = timeout | finishBoom;//解决10237问题
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
                if(key==correctKey)begin//当前仅按下正确的按键
                    waitBoom = 1'b1;
                    score <= score+color;
                end
            end
        end else waitBoom = 1'b0;
    end

    //======声音控制======
    reg [4:0] musicData;
    wire finishMusic;
    Music u_Music(clk,rst_n,timeout?(pos+1'b1):(musicData),180,finishMusic,beep);
    always @(posedge clk) begin
        if(clockNext)begin
            musicData <= pos+1'b1;//插入一个音符的提示音
        end else if (btnMain) begin
            musicData <= 5'h6;//主按键提示音
        end else if(finishMusic)begin
            case(gameState)//基于伪随机数产生简单音频
                Perpare: musicData <= {random[6]^random[3],random[3],random[0]|random[1],1'b1};
                // Perpare: musicData <= random[2:0]+5'b1;
                Gaming: musicData <= waitBoom?((color-1)*7+{random[2],random[0],1'b1}):5'b0;
                EndWin: musicData <= {random[6],random[3],random[4],random[0]^random[4]};
                EndTimeOut: musicData <= random[2:0]+random[5:3];
                default: musicData <= 0;
            endcase
        end
    end
endmodule

module D8421toBCD (
    input [7:0] I,
    output [7:0] O
);
    //使用乘法伪除法，降低资源消耗（确保60以下无误）
    assign O[7:4] = (I*13'd103)>>10;
    assign O[3:0] = I % 4'd10;
endmodule