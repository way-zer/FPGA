set Module Main
do pre.do

#聚合整理点阵显示
delete wave /$Module/matrixData
virtual signal /$Module/matrixData[0+:15] row0
virtual signal /$Module/matrixData[16+:15] row1
virtual signal /$Module/matrixData[32+:15] row2
virtual signal /$Module/matrixData[48+:15] row3
virtual signal /$Module/matrixData[64+:15] row4
virtual signal /$Module/matrixData[80+:15] row5
virtual signal /$Module/matrixData[96+:15] row6
virtual signal /$Module/matrixData[112+:15] row7
add wave -group -out Matrix /$Module/row*
#调整变量显示方式
radix signal /$Module/gameTime u
radix signal /$Module/score u
radix signal /$Module/pos u

#修改分频器时长,降低仿真时间
change /$Module/u_DivideClk/M 10#100
change /$Module/u_DivideClk/N 10#50
force /$Module/M 10#100
change /$Module/u_GameMatrixDisplay/u_DivideClk/M 10#50

force /$Module/clk 0 0,1 500ns -r 1us
force /$Module/clk1k 0 0,1 500ns -r 1us
force /$Module/rst_n 0 0,1 500ns
force /$Module/btnMain 0 0,1 3us,0 10us
#模拟一次正确点击
force /$Module/key 0 0
when {gameTime == 10#57} {
    force key [examine correctKey] 2us,0 20us
}

run 0.6ms

#调整初始显示范围
wave zoomfull