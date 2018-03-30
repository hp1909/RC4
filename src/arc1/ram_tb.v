/*
*   Author: Hoang Phuc - intern
*   Module: ram testbench - run in modelsim
*/
`timescale 1 ns / 100ps

module ram_tb();
    reg rst_n;
    reg clk;
    reg wen_2;
    reg wen_3;

    reg [7:0] raddr_1;
    reg [7:0] waddr_2;
    reg [7:0] addr_3;
    
    reg [7:0] wdata_2;
    reg [7:0] wdata_3;

    wire [7:0] rdata_1;
    wire [7:0] rdata_3;

    ram SBox(
        .rst_n      (rst_n),
        .clk        (clk),
        .wen_2      (wen_2),
        .wen_3      (wen_3),
        .raddr_1    (raddr_1),
        .waddr_2    (waddr_2),
        .addr_3     (addr_3),
        .wdata_2    (wdata_2),
        .wdata_3    (wdata_3),
        .rdata_1    (rdata_1),
        .rdata_3    (rdata_3)
    );

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
    end

    always 
        #5 clk = !clk;

    initial begin
        #5 
        wdata_2 = 8'd4;
        waddr_2 = 8'd10;

        #10 rst_n = 1'b1;

        #10 wen_2 = 1'b1;

        #20 wen_2 = 1'b0;

        #10 raddr_1 = 8'd5;
    end


endmodule