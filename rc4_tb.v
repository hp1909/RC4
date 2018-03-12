`timescale 1 ns / 100 ps
`define DELAY 1010

module rc4_tb();
    reg clk, rst_n, start;
    reg [31:0] key;
    reg [7:0] key_length;

    wire [7:0] ckey;
    wire done;
endmodule 
