/** ************************************************************************************
*   Module: ram_new_design.v
*   Author: Hoang Phuc
*   Date: Mar 22th, 2018
*   
*   Function:   This module is the memory has 4 ports
*               +   1 read-only port for read data from address i
*               +   1 write-only port for write data to address j
*               +   1 read-write port
*               +   1 read-only port for read data from address k
*   
** ************************************************************************************/
module ram_new_design
#(parameter NUMS_OF_BYTES = 4)
(
            input rst_n,
            input clk,
            // input wen_2,
            // input wen_3,
            input wen,

            input [7:0] raddr_1,
            input [7:0] waddr_2,
            input [7:0] addr_3,

            input [7:0] wdata_2,
            input [7:0] wdata_3,

            input [NUMS_OF_BYTES * 8 - 1:0] k_addr,
            output reg [NUMS_OF_BYTES * 8 - 1:0] k_data,

            output [7:0] rdata_1,
            output [7:0] rdata_3
);
    integer i;

    reg [7:0] mem [255:0];

    assign rdata_1 = mem[raddr_1];
    assign rdata_3 = mem[addr_3];

    always@(posedge clk)
    begin
        if (~rst_n)
        begin
            for (i = 0; i < 256; i = i + 1) begin
                mem[i] <= i;
            end
        end
        else if (wen)
        begin
            mem[waddr_2]    <= wdata_2;
            mem[addr_3]     <= wdata_3;
        end 
    end

    always@(*)
    begin
        if (rst_n) begin
            for (i = 0; i < NUMS_OF_BYTES; i = i + 1) begin
                k_data[i * 8 +: 8] = mem[k_addr[i * 8 +: 8]];
            end
        end
    end

endmodule