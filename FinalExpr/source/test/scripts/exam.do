set Module Exam
do pre.do

force /$Module/clk 0 0,1 50ns -r 100ns
force /$Module/sw 0 0,1 500ns
#修改分频器时长,降低仿真时间
change /$Module/u_DivideClk/M 32'd1000 
change /$Module/u_DivideClk/N 32'd500

run 1ms