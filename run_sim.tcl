#------------------------------------------------------------------------
#Design name : run_sim.tcl
# Use for autorun in modelsim commandline

cd test/modelsim
vlib mywork
vmap work mywork
vlog ../../src/arc1/rc4_tb.v ../../src/arc2/rc4_new_design.v ../../src/arc1/ram.v ../../src/arc1/rc4.v ../../src/arc2/ram_new_design.v ../../src/arc1/ram_tb.v


vsim work.rc4_tb

add wave *

run 10us


