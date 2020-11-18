module DFilp (
    input clk,rst_n,
    input d,
    output reg q,
    output nq
);
    always @(posedge clk) begin
        if(!rst_n)//低电平 同步复位
            q=0;
        else
            q=d;
    end
    assign nq = ~q;
endmodule

module Counter ( clk,rst_n,data );
    parameter Size = 4;//计数位数 默认4,可计数0-15
    input clk,rst_n;
    output reg [Size-1:0] data;

    always @(posedge clk or negedge rst_n) begin
       if(!rst_n)data = 0;
       else data=data+1; 
    end
endmodule

module Week9 (
    input clk,rst_n,
    input keyI,
    output [7:0]segO1
);
    wire keyD;//消抖按键
    wire [3:0] data;//计数器输出
    Debounce u_Debounce(clk,keyI,keyD);//消抖模块
    Counter u_Counter(keyD,rst_n,data);
    Num u_Num(data,segO1);//数码译码器
endmodule