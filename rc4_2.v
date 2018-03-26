// This module is for testing
module rc4_2
(
    input clk,
    input rst_n,
    input start,
    input [31:0] key,
    input [7:0] key_length,

    output [7:0] ckey,
    output reg done
);
	
	wire [7:0] key_reg [3:0];
    wire [7:0]   raddr_1, waddr_2, addr_3;
    wire [7:0]   rdata_1, rdata_3;

    wire [7:0]  key_value, Si, Sj, prev_j;
    wire [7:0]  j_value, j_out, k_out;
    wire en_j, en_k;
    reg	 [7:0]   wdata_2, wdata_3;

    reg wen;
    reg 	[2:0]   state;
    reg PRGA, KSA;

    reg     [7:0]   i, j, k;
    reg     [7:0]   temp_addr;
    reg             first_iter;
    reg	    [7:0]	Sk;

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
            Sk      <= 8'd0;
            KSA     <= 1'b1;
            PRGA    <= 1'b0;
            temp_addr <= 8'd0;
            first_iter <= 1'b1;
			done	<= 1'b0;
        end
        else 
        begin
            case (state)
            IDLE:
            begin
                if (start && ~done)
                    state <= STEP_1;
                else 
                    state <= IDLE;
                    wen <= 1'b0;
                // wen_2 <= 1'b0;
                // wen_3 <= 1'b0;
                // Sj <= rdata_3;
            end
            STEP_1:
            begin
                if (first_iter)
                begin
                    if (KSA)
                        i <= 8'd0;      // i = 0 if KSA and = 1 if PRGA
                    else if (PRGA)
                    begin
                        i <= 8'd1;
                        wen <= 1'b1;
                        if (i != j)
                        begin
                            wdata_2 <= rdata_3; // i <- S[j]
                            wdata_3 <= rdata_1; // j <- S[i]
                            temp_addr <= i;
                        end 
                    end
                    first_iter <= 1'b0;
                end
                else
                begin
                    // wen_2 <= 1'b1;      // enable write for swap
                    // wen_3 <= 1'b1;
                    wen <= 1'b1;
                    if (i != j)
                    begin
                        wdata_2 <= rdata_3; // i <- S[j]
                        wdata_3 <= rdata_1; // j <- S[i]
                    end 
                    // if (PRGA && i >= 1)
                    // begin
                    //     k <= Sk + rdata_3; // calculate k by Si + Sj    // Cal k Block
                    // end

                    if (PRGA && i >= 1)
                    begin
                        k <= k_out;
                    end
                    temp_addr <= i;
                    i <= i + 1'b1;      // increase i for next iteration
                end
                state <= STEP_2;
            end // end STEP 1
            STEP_2:
            begin
                // if (KSA)
                //     if (j == temp_addr + 1)
                //         j <= j + wdata_3 + key_reg[(i % key_length)];   // Cal J Block
                //     else
                //         j <= j + rdata_1 + key_reg[(i % key_length)];   // Cal J Block
                // else if (PRGA)
                // begin
                //     if (i == 1)
                //         j <= 8'd0 + rdata_1;                            // Cal J Block                            
                //     else
                //         j <= j + rdata_1;                               // Cal J Block
                //     Sk <= rdata_1;
                // end
                j <= j_out;

                if (PRGA)
                    Sk <= rdata_1;
                wen <= 1'b0;
                
                if (i == (key_length + 2) && PRGA)
                begin
                    done <= 1'b1;
                    i <= 8'd0;
                    state <= IDLE;
                end
                else
                    state <= STEP_1;
            end // end STEP 2 
        endcase
        end
        
        if (KSA == 1 && i == 255)
        begin
            PRGA <= 1'b1;
            KSA  <= 1'b0;
            first_iter <= 1'b1;
        end
    end

    assign en_j = (state == STEP_2 && start) ? 1'b1 : 1'b0;
    assign en_k = (~first_iter && PRGA && i >= 8'd1 && start && state == STEP_1) ? 1'b1 : 1'b0;

    assign key_value = (state == STEP_2 && KSA) ? key_reg[(i % key_length)] : 1'b0;
    assign Si = (start && state == STEP_2) ? ((j == (temp_addr + 1) && KSA) ? wdata_3 : rdata_1) : 8'd0;
    assign prev_j = (state == STEP_2 && PRGA && i == 1) ? 8'd0 : j;
    assign Sj = (state == STEP_1 && PRGA && i >= 1) ? rdata_3 : 8'd0;

    cal_j cal_j_inst(
                        .clk        (clk),
                        .rst_n      (rst_n),
                        .en         (en_j),
                        .key        (key_value),
                        .Si         (Si),
                        .prev_j     (prev_j),

                        .j          (j_out)
    );

    cal_k cal_k_inst(
                        .clk        (clk),
                        .rst_n      (rst_n),
                        .en         (en_k),
                        .Si         (Sk),
                        .Sj         (Sj),
                        
                        .k          (k_out)
    );
    
    // address for every step 
    assign raddr_1 = (PRGA && state == STEP_1 && i >= 2 && i < 255) ? k : i;
    assign waddr_2 = temp_addr;
    assign addr_3 = j;

    // output of cipher key 
    assign ckey = PRGA ? ((~wen && state == STEP_1 && i > 1 && i < 255) ? rdata_1 : ckey) : 8'd0;
	 
	 // value of cipher key
    assign key_reg[0] = key[7:0];
    assign key_reg[1] = key[15:8];
    assign key_reg[2] = key[23:16];
    assign key_reg[3] = key[31:24];

    ram SBox(
        .rst_n      (rst_n),
        .clk        (clk),
        // .wen_2      (wen_2),
        // .wen_3      (wen_3),
        .wen        (wen),
        .raddr_1    (raddr_1),
        .waddr_2    (waddr_2),
        .addr_3     (addr_3),
        .wdata_2    (wdata_2),
        .wdata_3    (wdata_3),
        .rdata_1    (rdata_1),
        .rdata_3    (rdata_3)
    );
	
endmodule 