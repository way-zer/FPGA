set Module Exam
do pre.do

force /$Module/clk 0 0,1 500ns -r 1000ns
force /$Module/sw 0 0,1 5000ns
#修改分频器时长,降低仿真时间
change /$Module/u_DivideClk/M 32'd100
change /$Module/u_DivideClk/N 32'd50

run 1ms
wave zoomfull