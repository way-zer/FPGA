set Module Exam
do pre.do

force /$Module/clk 0 0,1 50ns -r 100ns
force /$Module/sw 0 0,1 500ns
#修改分频器时长,降低仿真时间
change /$Module/u_DivideClk/M 32'd10
change /$Module/u_DivideClk/N 32'd5

run 1ms