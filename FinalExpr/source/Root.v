module Root (
    input clk,rst,

    input [3:0] KB_Row,//键盘行列
    output [3:0] KB_Col, 
    output [15:0] ledO,//LED输出端口

    output [7:0] rowO,colR,colG//点阵输出接口
);
    wire rst_n = ~rst;
    Matrix u_Matrix(clk,~rst_n,{
        2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b10,
        2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
        2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
        2'b00,2'b00,2'b00,2'b00,2'b11,2'b00,2'b00,2'b00,
        2'b00,2'b00,2'b00,2'b11,2'b00,2'b00,2'b00,2'b00,
        2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
        2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
        2'b01,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00
    },rowO,colR,colG);

    wire [15:0] key,keyD;
    KeyBroad u_KeyBroad(clk,rst_n,KB_Row,KB_Col,key);
    Debounce#(.Size(16)) u_Debounce (clk,key,keyD);
    assign ledO=keyD;
endmodule