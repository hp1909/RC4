#------------------------------------------------------------------------
#Design name : run_sim.tcl4

vlib mywork
vmap work mywork
vlog rc4_tb.v rc4_new_design.v ram.v rc4.v ram_new_design.v ram_tb.v


vsim work.rc4_tb

add wave *

run 10us


