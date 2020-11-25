module JK (
    input clk,//时钟,下降沿触发
    input j,k,
    input async_s,async_r,//异步置位,async_s优先
    output reg q,
    output nq
);
    assign nq = ~q;
    always @(negedge clk or posedge async_s or posedge async_r) begin
        if(async_s)q<=1'b1;
        else if(async_r)q<=1'b0;
        else q <= (j&~q) | (~k&q);
    end
endmodule

module MRegister (
    input clk,rst_n,//时钟重置,上升沿触发
    input I,//串行输入
    output reg [7:0] q,//并行输出
    output O//串行输出
);
    assign O = q[7];
    always @(posedge clk) begin
        if (!rst_n) q <= {8{1'b0}};
        else begin
            q <= {q[6:0],I};
        end
    end
endmodule