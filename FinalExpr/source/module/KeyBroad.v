module KeyBroad (
    input clk,rst_n,//时钟与重置
    input [3:0] KB_Row,//键盘行列
    output [3:0] KB_Col, 
    output reg [15:0] key //转换后的正常按键状态,低电平有效
);
    reg [1:0] col=0;//键盘行计数器

    always @(posedge clk) col = col+1;//时钟上升沿更新行
    D2to4 u_D2to4(col,KB_Col);

    always @(negedge clk,negedge rst_n) begin //时钟下降沿读取输入
        if(!rst_n) key = {16{1'b1}};
        else begin
            key[col] = KB_Row[3];
            key[4+col] = KB_Row[2];
            key[8+col] = KB_Row[1];
            key[12+col] = KB_Row[0];
        end
    end
endmodule

module D2to4 (
    input [1:0] data,
    output reg [3:0] O//输出,低电平有效
);
    always @(data) begin
        case (data)
            3'h0: O=4'b1110; 
            3'h1: O=4'b1101; 
            3'h2: O=4'b1011; 
            3'h3: O=4'b0111; 
            default: O=4'b1111;
        endcase
    end
endmodule