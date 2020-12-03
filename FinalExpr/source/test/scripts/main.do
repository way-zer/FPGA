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
change /$Module/u_DivideClk/M 32'd10 
change /$Module/u_DivideClk/N 32'd5
change /$Module/u2_DivideClk/M 32'd10
change /$Module/u_GameMatrixDisplay/u_DivideClk/M 32'd5

force /$Module/clk 0 0,1 50ns -r 100ns
force /$Module/rst_n 0 0,1 500ns
force /$Module/btnMain 0 0,1 1000ns,0 3000ns
#模拟一次正确点击
force /$Module/key 0 0,16'h0020 2500ns,0 2700ns

run 1ms

#调整初始显示范围
wave zoomrange 0ns 5000ns