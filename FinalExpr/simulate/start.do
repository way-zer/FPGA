transcript off
vlib -dirpath work
proc external_editor {filename linenumber} { exec "C:\\Program Files\\Microsoft VS Code\\Code.exe" -g $filename:$linenumber}
set PrefSource(altEditor) external_editor

vlog ./Root.vt
vlog ../*.v
vlog ../module/*.v

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L work -voptargs="+acc"  Root_T

add wave *
view structure

run 1000ps