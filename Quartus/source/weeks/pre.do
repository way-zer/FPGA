# By WayZer
# cd ../../simulate/multisim
vlib work
proc external_editor {filename linenumber} { exec "C:\\Program Files\\Microsoft VS Code\\Code.exe" -g $filename:$linenumber}
set PrefSource(altEditor) external_editor

vlog ../source/module/*.v
vlog ../source/utils/*.v
vlog ../source/weeks/*.v

vsim -t 10ns -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L work -voptargs="+acc" $Module 

view structure
add wave *