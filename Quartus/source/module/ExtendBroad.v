module ExtendBroad (
    inout [35:0] gpio,
    
    input [1:8] matrix_row,
    input [1:8] matrix_col,

    input serial_tx,
    output serial_rx,
    
    inout [1:12] io,
    
    input ir_send,
    output ir_rec,
    
    inout tem,

    input iic_SCL,
    inout iic_SDA,
    input bh_DVI
);
    assign gpio[17:10] = matrix_row; 
    assign gpio[35:28] = matrix_col; 

    assign gpio[2] = serial_tx;
    assign serial_rx = gpio[3];
    
    assign io = {gpio[4],gpio[5],gpio[6],gpio[7],gpio[21],gpio[20],gpio[18],gpio[19],gpio[22],gpio[23],gpio[24],gpio[25]};
    // assign {gpio[4],gpio[5],gpio[6],gpio[7],gpio[21],gpio[20],gpio[18],gpio[19],gpio[22],gpio[23],gpio[24],gpio[25]} = io;

    assign gpio[27]=ir_send;
    assign ir_rec = gpio[26];

    assign tem = gpio[8];
    // assign gpio[8] = tem;

    assign gpio[0] = iic_SCL;
    assign gpio[1] = iic_SDA;
    // assign iic_SDA = gpio[1];
    assign gpio[9] = bh_DVI;
endmodule

module Matrix(
    input [0:7] data[0:7],//数据列 1为显示
    input clkI,//时钟
    output [0:7] matrix_row,matrix_col//输出,低电平有效
);
    reg [2:0] row;//当前渲染行
    always @(posedge clkI) row=row+1;
    assign matrix_col = ~data[row];
    // assign matrix_col = 8'b0011_1100;
    // assign matrix_row = 8'b0101_1010;
    D3to8(row,matrix_row);
endmodule

module ExtendBroad_Test(input clkI,inout [35:0] gpio);
    wire [0:7] matrix_row,matrix_col;
    ExtendBroad(gpio,matrix_row,matrix_col);

    reg [0:7] data[0:7];
    initial begin
        data[0] = 8'b00000000;
        data[1] = 8'b00001100;
        data[2] = 8'b00001110;
        data[3] = 8'b11111111;
        data[4] = 8'b11111111;
        data[5] = 8'b00001110;
        data[6] = 8'b00001100;
        data[7] = 8'b10001000;
    end
    Matrix(data,clkI,matrix_row,matrix_col);
endmodule