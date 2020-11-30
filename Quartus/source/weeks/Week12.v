module C_CarLED (
    input clk,
    input swL,swR,
    output ledL,ledR
);
    wire clk1Hz;
    DivideClk u_DivideClk(clk,1'b1,clk1Hz);
    assign ledL = swL&clk1Hz;
    assign ledR = swR&clk1Hz;
endmodule

module CarLED (
    input clk,
    input [3:0] swI,
    output [5:0] rgbO,
    output [7:0] ledO
);
    wire ledL,ledR,ledErr;
    C_CarLED u1(clk,swI[3],swI[0],ledL,ledR);
    assign ledErr = ledL&ledR;

    wire ledL_n,ledR_n,ledErr_n;
    assign {ledL_n,ledR_n,ledErr_n} = ~{ledL,ledR,ledErr};
    assign rgbO = {ledL_n,2'b11,ledR_n,2'b11};
    assign ledO = {ledL_n|ledErr,2'b11,ledErr_n,ledErr_n,2'b11,ledR_n|ledErr};//通过单色LED模拟显示仪表盘
endmodule

module Breath (
    input clk,
    input btn,
    output [5:0] rgbO
);
    reg led2Enable_n=0;
    always @(negedge btn) led2Enable_n = ~led2Enable_n;

    wire ledR,ledG,ledB;
    //3色各相差1/3周期
    BreathLED#(0) uR(clk,ledR);
    BreathLED#(682) uG(clk,ledG);
    BreathLED#(1365) uB(clk,ledB);
    assign rgbO = {ledR,ledG,ledB,ledR|led2Enable_n,ledG|led2Enable_n,ledB|led2Enable_n};
endmodule

module Week12 (
    input clk,
    input [3:0] swI,
    input [7:0] keyI,
    output [5:0] rgbO,
    output [7:0] ledO
);
    wire swLED = swI[1];
    
    wire [5:0] rgbOCar;
    wire [7:0] ledOCar;
    CarLED u1(clk,swI,rgbOCar,ledOCar);

    wire [5:0] rgbOBreath;
    Breath u2(clk,keyI[0],rgbOBreath);

    assign rgbO = swLED?rgbOBreath:rgbOCar;
    assign ledO = swLED?8'hff:ledOCar;
endmodule