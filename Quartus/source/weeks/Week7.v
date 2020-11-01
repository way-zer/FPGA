module AdderBy38(
	input a,b,c1,
	output s,c2
);
	wire [7:0] seg;
	D3to8({a,b,c1},seg);
	assign s = ~&{seg[1],seg[2],seg[4],seg[7]};
	assign c2 = ~&{seg[3],seg[5],seg[6],seg[7]};
endmodule

module Week7 (
	input clkI,
	input [3:0] keyI,swI,
	output [7:0] ledO,
	output [0:7] segO1,segO2,
	output [1:0] segDig,
	output [5:0] rgbO
);
	assign rgbO = 6'b111111;
	assign segDig = 0;
	
	wire [3:0] data=swI;

    //38译码器实现全加器,并使用LED输出
    wire a,b,c1;//IN
    wire s,c2;//OUT
    AdderBy38(a,b,c1,s,c2);
    assign ledO = {~c2,~s,~c1,~b,~a,3'b111};
    assign {c1,b,a} = data[2:0];

    //数码译码器,输出到数码管
	// reg [3:0] data=0;
 	Num(data,segO1);
endmodule