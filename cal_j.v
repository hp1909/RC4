// This module is for testing
module cal_j(
                input clk,
                input en,
                input rst_n,
                input [7:0] key,
                input [7:0] Si,
                input [7:0] prev_j,

                output reg [7:0] j
);

    always@(posedge clk)
    begin
        if (~rst_n)
            j <= 8'd0;
        else if (en)
            j <= key + Si + prev_j;
    end 

endmodule