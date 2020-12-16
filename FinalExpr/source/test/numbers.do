set Module Numbers
do pre.do

# 显示数码管数值，便于分析
add wave -u /$Module/u_Num/numI

force /$Module/clk 0 @0,1 @500 -r 1000
force /$Module/data 16#12345678
run 10us
wave zoomfull