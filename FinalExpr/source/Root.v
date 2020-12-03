module Root (//此处定义硬件相关引脚信息,不一定全部使用
    input clk,//时钟取10Mhz
    input [7:0] sw,//上为高电平
    
    input [7:0] btn,//按键,高电平有效
    output [15:0] ledO,//LED输出端口,高电平有效

    input [3:0] KB_Row,//键盘行列,高电平有效
    output [3:0] KB_Col, //低电平有效

    output [7:0] rowO,colR,colG,//点阵输出接口
    output [7:0] segO,sig//数码管输出控制接口
);
    wire btnMain = btn[3];
    wire btnSwitch = btn[0];
    wire swMain = sw[3];
    wire rst_n = 1'b1;

    // 信号
    wire finishExam,enableMain;
    assign enableMain = sw[7]|(swMain&finishExam);
    wire [127:0] matrixData,matrixDataExam,matrixDataMain;
    assign matrixData = enableMain?matrixDataMain:matrixDataExam;
    wire [31:0] numbersData,numbersDataExam,numbersDataMain;
    assign numbersData = enableMain?numbersDataMain:numbersDataExam;

    wire [15:0] key;
    
    //控制模块
    Exam u_Exam(clk,swMain,finishExam,matrixDataExam,numbersDataExam);
    Main u_Main(clk,enableMain,btnMain,btnSwitch,key,matrixDataMain,numbersDataMain);

    //功能模块
    Matrix u_Matrix(clk,rst_n,matrixData,rowO,colR,colG);
    Numbers u_Numbers(clk,numbersData,segO,sig);
    KeyBroad u_KeyBroad(clk,rst_n,KB_Row,KB_Col,key);
    assign ledO[0]=finishExam;
    assign ledO[1]=enableMain;
    assign ledO[2]=btnMain;
    assign ledO[3]=btnSwitch;
endmodule