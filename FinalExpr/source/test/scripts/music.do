set Module Music
do pre.do

#调整变量显示方式
radix signal /$Module/i u
radix signal /$Module/t u

#修改分频器时长,降低仿真时间
change /$Module/BaseFreq 32'd10000

force /$Module/clk 0 0,1 50ns -r 100ns
force /$Module/en 0 0,1 5000ns
force /$Module/i 0
force /$Module/t 1000

run 1ms

#调整初始显示范围
wave zoomrange 0ns 50000ns