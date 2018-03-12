module rc4
(
    input clk,
    input rst_n,
    input start,
    input cipher_req,
    input [31:0] key,
    input [7:0] key_length;

    output [7:0] ckey;
    output done,
);


    reg [7:0] i, j, k, n;
    reg PRGA_ready, PRGA, KSA;
    reg 	[2:0]   state;
    reg             first_iter;
    reg			    wen_2, wen_3;
    reg	    [7:0]	Si, Sj, Sk;
    wire    [7:0]   wdata_2, wdata_3;
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
        
        if (KSA == 1 && i == 255)
        begin
            PRGA <= 1'b1;
            KSA  <= 1'b0;
        end
        else if (PRGA == 1 && i == 255)
        begin
            done => 1'b1;
            KSA => 1'b1;
            PRGA => 1'b0;
        end
    end

    always@(posedge clk)
    begin
        case (state)
            IDLE:
            begin
                if (start && ~done)
                    state <= STEP_1;
                else 
                    state <= IDLE;
                wen_2 <= 1'b0;
                wen_3 <= 1'b0;
                Sj <= rdata_3;
            end
            STEP_1:
            begin
                if (first_iter)
                begin
                    if (KSA)
                        i <= 8'd0;      // i = 0 if KSA and = 1 if PRGA
                    else if (PRGA)
                        i <= 8'd1;
                end
                else
                begin
                    wen_2 <= 1'b1;      // enable write for swap
                    wen_3 <= 1'b1;
                    if (i == j)
                    begin
                        wdata_2 <= rdata_3; // i <- S[j]
                        wdata_3 <= rdata_1; // j <- S[i]
                    end 
                    if (PRGA)
                    begin
                        k <= rdata_1 + rdata_3; // calculate k by Si + Sj
                    end
                end
                i <= i + 1'b1;      // increase i for next iteration
                state <= STEP_2;
            end
            STEP_2:
            begin
                if (KSA)
                    j <= j + rdata_1 + key[i];
                else if (PRGA)
                begin
                    j <= j + rdata_1;
                    Sk <= rdata_1;
                end
                wen_3 <= 1'b1;
                
                if (i == key_length)
                begin
                    done <= 1'b1;
                    start <= 1'b0; 
                    i <= 8'd0;
                end
            end
        endcase
    end

    // address for every step 
    assign raddr_1 = STEP_1 ? i : STEP_2 ? k : 0;
    assign waddr_2 = i;
    assign addr_3 = j;

    // output of cipher key 
    assign ckey = Sk;

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