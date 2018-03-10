module rc4
(
    input clk,
    input rst_n,
    input key_setup_en,
    input cipher_req,
    input [7:0] key [255:0],

    output cipher_valid
);

    reg [7:0] i, j, k, n;
    reg [7:0] ckey [255:0];
    
    reg 	[2:0]   state;
    reg			    wen_2, wen_3;
    reg	    [7:0]	Si, Sj, Sk;
    reg     [7:0]   wdata_2, wdata_3;
    wire    [7:0]   raddr_1, waddr_2, addr_3;
    wire    [7:0]   rdata_1, rdata_3;

    parameter KSA = 0;
    parameter PRGA = 0;

    always@(posedge clk)
    begin
        if (~rst_n)
        begin
            state   <= 3'd0;
            i       <= 8'd0;
            j       <= 8'd0;
            k       <= 8'd0;
            Si      <= 8'd0;
            Sj      <= 8'd0;
            Sk      <= 8'd0;

        end
        else if (PRGA_start)
        begin
            i <= 1;
        end
        PRGA_start = key_setup_en && (i == 255);
    end

    always@(posedge clk)
    begin
        if (key_setup_en && ~PRGA_start)
        begin
            raddr_1 <= i;
            Si <= rdata_1;
            j <= j + Si + key[i];
        end
    end

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
	
endmodule 