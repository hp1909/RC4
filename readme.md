#--------------------------------------------------------
#-------------  HOW TO USE THIS PROJECT -----------------

1. FILE STRUCTURE

RC4
│   .DS_Store
│   autorun_test.sh
│   git_update.sh
│   RC4.qpf
│   RC4.qsf
│   RC4.qsf.bak
│   RC4.qws
│   readme.md
│       
├───src
│   ├───arc1_4_bits_per_clock
│   │       ram.v
│   │       ram_tb.v
│   │       rc4.v
│   │       rc4_inst.v
│   │       rc4_tb.v
│   │       
│   ├───arc2_n_bytes_per_clk
│   │       ram_new_design.v
│   │       rc4_new_design.v
│   │       
│   └───arc3_16_bits_per_2_clk
└───test
    ├───c
    │       input.txt
    │       rc4.cpp
    │       
    ├───data
    │       input.txt
    │       output.txt
    │       
    ├───matlab
    │       rc4.asv
    │       rc4.m
    │       test_case_generater.m
    │       
    └───modelsim
            run_sim.tcl

2. /src FOLDER

    - Contains source code verilog of RC4 algorithm including:
        +   RC4 generate 4 bits / clock in both KSA sub-stage and PRGA.
        +   RC4 generate N byte / clock in PRGA stage by adding 1 read-port to SBox with N * 8 width.
        +   RC4 generate 16 bits / 2 clock using new method in both KSA and PRGA (developing).

    -   In each sub-folder in src, It contains:
        +   rc4.v: main code of the RC4 algorithm
        +   *_tb.v: testbench code for each method.
        +   rc4_inst.v: use for running on FPGA board (In this project, we use DE2-115 EP4CE115F29C7).
        +   ram.v: contains code to generate SBox of the RC4 algorithm.

3. /test FOLDER

    - Contains files for generating and evaluating the results.
        +   matlab sub-folder: contains matlab code. It gets input data (number of secret key bytes and secret key)
                               and return result to output.txt file.
        +   c sub-folder: contains c code for verify result. (for reference, you may only use matlab enough).
        +   modelsim: contains a file name run_sim.tcl to auto run modelsim with full signal and a work folder is 
                      workspace of modelsim.

    - 