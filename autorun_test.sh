#Author: Hoang Phuc
#Use this script for running automated simulation on Matlab and modelsim

#Run matlab code to generate output.

matlab -r "try, run ('.\\test_matlab\\rc4.m'); end; quit" ;

#Run modelsim
sleep 13
vsim -c -do run_sim.tcl

#end simulation
