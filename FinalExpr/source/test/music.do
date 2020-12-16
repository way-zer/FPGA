set Module Music
do pre.do

#调整变量显示方式
radix signal /$Module/scale u
radix signal /$Module/playTime u

#修改分频器时长,降低仿真时间
change /$Module/BaseFreq 10#100000
force /$Module/clk 0 0,1 500 -r 1000
force /$Module/en 0 0,1 5000ns
force /$Module/scale 1
force /$Module/playTime 10#30

run 50ms

#调整初始显示范围
wave zoomfull