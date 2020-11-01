module Adder1 (
    input a,b,c,
    output s,cc
);
    assign s = a^b^c;
    assign cc = (a&b)|(a&c)|(b&c);
endmodule

module Adder (
    input [W-1:0] a,b,c0,
    output [W-1:0] s,
    output cc
);
    parameter W = 4;
    wire [W:0] c;
    assign c[0] = c0;
    assign cc = c[W];
    generate
        genvar i;
        for ( i=0 ;i<W ;i=i+1 ) begin:gen
            Adder1(a[i],b[i],c[i],s[i],c[i+1]);
        end
    endgenerate
endmodule