`timescale 1 ns / 100 ps
`define DELAY 10

module rc4_tb();
    reg clk, rst_n, start;
    reg [31:0] key;
    reg [7:0] key_length;

    wire [7:0] i_out;
    wire [7:0] j_out;
    wire [7:0] k_out;
    wire [7:0] raddr_1, waddr_2, addr_3;
    wire [7:0]  rdata_1, rdata_3;
    wire [7:0]   wdata_2, wdata_3;
    wire PRGA, KSA;
    wire wen;
    wire [2:0] state;
    wire [7:0] ckey;
    wire done;

    rc4 rc4_test(
                    //input
                    .clk        (clk),
                    .rst_n      (rst_n),
                    .start      (start),
                    .key        (key),
                    .key_length (key_length),
                    .state      (state),
                    .PRGA       (PRGA),
                    .KSA        (KSA),
                    //output
                    .wen        (wen),
                    .j_out      (j_out),
                    .k_out      (k_out),
                    .i_out      (i_out),
                    .raddr_1    (raddr_1),
                    .waddr_2    (waddr_2),
                    .addr_3     (addr_3),
                    .rdata_1    (rdata_1),
                    .rdata_3    (rdata_3),
                    .wdata_2    (wdata_2),
                    .wdata_3    (wdata_3),
                    .ckey       (ckey),
                    .done       (done)
    );

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
    end

    always
        #5 clk = !clk;
    
    initial begin
        #5 
            key = 32'h64636261;
            key_length = 8'h4;

        #10
            rst_n = 1'b1;
        
        #10
            start = 1'b1;
    end
endmodule 
