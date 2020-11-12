module Matrix (
    input clk,rst_n,//时钟,重置,建议1kHz
    input [127:0] data,//数据输入 8行 每行中8列 均按大端序排列 每格用2位表示R和G两种颜色 高电平有效
    output [7:0] rowO,colR,colG//输出接口
);
    reg [2:0] row=0;//当前显示行
    always @(posedge clk or negedge rst_n) begin//行计数器
        if(!rst_n) row = 0;
        else row = row+1;
    end
    D3to8 u_D3to8(row,rowO);
    generate
        genvar i;
        for(i=0;i<8;i=i+1) begin:col
            assign colR[i] = data[(7-row)*16+2*i];             
            assign colG[i] = data[(7-row)*16+2*i+1];             
        end
    endgenerate
endmodule

module D3to8 (
    input [2:0] data,
    output reg [7:0] O//输出,低电平有效
);
    always @(data) begin
        case (data)
            3'h0: O=8'b1111_1110; 
            3'h1: O=8'b1111_1101; 
            3'h2: O=8'b1111_1011; 
            3'h3: O=8'b1111_0111; 
            3'h4: O=8'b1110_1111; 
            3'h5: O=8'b1101_1111; 
            3'h6: O=8'b1011_1111; 
            3'h7: O=8'b0111_1111; 
            default: O=8'b1111_1111;
        endcase
    end
endmodule