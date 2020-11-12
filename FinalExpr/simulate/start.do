# By WayZer
# 运行命令 vsim do start.do <模块名>
transcript off
if {$argc==0} {
    echo no Parmater set, use "Root_T" for default
    set 1 "Root_T"
}
echo Will Simulate Module $1

vlib work
proc external_editor {filename linenumber} { exec "C:\\Program Files\\Microsoft VS Code\\Code.exe" -g $filename:$linenumber}
set PrefSource(altEditor) external_editor

vlog ../source/test/*.vt
vlog ../source/module/*.v
vlog ../source/*.v

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L work -voptargs="+acc"  $1

add wave *
view structure

run 1000ps