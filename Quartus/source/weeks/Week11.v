module Counter8421JK (
    input clk,rst,
    output [3:0] data
);
    //              J               K
    JK u0_JK(clk,   1'b1,           1'b1,        1'b0,rst,data[0]);
    JK u1_JK(clk,   data[0]&~data[3],data[0],  1'b0,rst,data[1]);
    JK u2_JK(clk,   &data[1:0],     &data[1:0],  1'b0,rst,data[2]);
    JK u3_JK(clk,   &data[2:0],     data[0],     1'b0,rst,data[3]);
endmodule
module Counter8421JK_T;
/**
vlog ../../source/weeks/Week10.v
vlog ../../source/weeks/Week11.v
vsim Counter8421JK_T
add wave *
run
*/
        parameter PERIOD  = 10;
        reg   clk                                  = 0 ;
        reg   rst                                  = 1 ;
        wire  [3:0]  data                          ;

        always #(PERIOD/2)  clk=~clk;
        initial #(PERIOD*2) rst  =  0;
        Counter8421JK  u_Counter8421JK (
                .clk                     ( clk         ),
                .rst                     ( rst         ),
                .data                    ( data  [3:0] )
        );
        initial #(16*PERIOD) $finish;
endmodule


module Clock24s (
    input clk,rst,
    output [7:0] segO1,segO2
);
    reg [1:0] ten;
    reg [3:0] i;
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            ten <= 2'h2;
            i <= 4'h4;
        end else if(|{ten,i}) begin
            i <= (|i)?(i-4'h1):4'h9;
            ten <= (|i)?ten:(ten-2'h1);
        end//00时保持不变
    end
    Num u1_Num(ten,segO1);
    Num u2_Num(i,segO2);
endmodule
module Clock24s_T;
/**
vlog ../../source/weeks/Week11.v
vsim Clock24s_T
add wave /Clock24s_T/u_Clock24s/*
run
*/
        parameter PERIOD  = 10;
        reg   clk                                  = 0 ;
        reg   rst                                  = 1 ;

        always #(PERIOD/2)  clk=~clk;
        initial #(PERIOD*2) rst  =  0;
        Clock24s  u_Clock24s (
                .clk                     ( clk         ),
                .rst                     ( rst         )
        );
        initial #(30*PERIOD) $finish;
endmodule