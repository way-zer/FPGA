set Module KeyBroad
do pre.do

force /$Module/rst_n 1
force /$Module/clk 0 @0,1 @500 -r 1000
when -repeat {KB_Col = 'b0111} {force KB_Row 'b0111}
when -repeat {KB_Col = 'b1011} {force KB_Row 'b1011}
when -repeat {KB_Col = 'b1101} {force KB_Row 'b1101}
when -repeat {KB_Col = 'b1110} {force KB_Row 'b1110}
radix signal col u

run 20us
wave zoomfull