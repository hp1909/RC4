// This module is for testing
module cal_k(
                input clk,
                input rst_n,
                input en,
                input [7:0] Sj,
                input [7:0] Si,

                output reg [7:0] k
);

    always@(posedge clk)
    begin
        if (~rst_n)
            k <= 8'd0;
        else if (en)
            k <= Sj + Si;
    end 

endmodule