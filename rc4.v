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
    reg PRGA_ready, PRGA, KSA;
    reg 	[2:0]   state;
    reg             first_iter;
    reg			    wen_2, wen_3;
    reg	    [7:0]	Si, Sj, Sk;
    wire     [7:0]   wdata_2, wdata_3;
    wire    [7:0]   raddr_1, waddr_2, addr_3;
    wire    [7:0]   rdata_1, rdata_3;

    // state
    parameter STEP_1 = 1;
    parameter STEP_2 = 2;
    parameter IDLE = 0;

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
            KSA     <= 1'b1;
            PRGA    <= 1'b0;
            wen_2   <= 1'b0;
            wen_3   <= 1'b0;
            first_iter <= 1'b0;
        end
        else if (PRGA_start)
        begin
            i <= 1;
        end
        
        if (KSA == 1 && i == 255)
        begin
            PRGA <= 1'b1;
            KSA  <= 1'b0;
        end
    end




    always@(posedge clk)
    begin
        if (KSA)
        begin
            case (state)
                IDLE:
                begin
                    state <= STEP_1;
                end
                STEP_1:
                begin
                    if (first_iter)
                    begin
                        state <= STEP_2;
                    end
                    else 
                    begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // address for every step 
    assign raddr_1 = STEP_1 ? i : STEP_2 ? k;
    assign waddr_2 = i;
    assign addr_3 = j;
    assign 

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