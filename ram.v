///////////////////////////////////////////////
// NAME; 3-ports RAM Block
// Author: Hoang Phuc
// Date: 
// Description; This is RAM block has 3 ports;
// Port 1: Read-only (rdadrr, rddata,..)
// port 2: Write only
// Port 3: Read-Write

module ram
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

            output [7:0] rdata_1,
            output [7:0] rdata_3
);

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
            mem[waddr_2] <= wdata_2;
        // end
        // else if (wen_3)
        // begin
            mem[addr_3] <= wdata_3;
        end 
    end

endmodule