module rc4
(
    input clk,
    input rst_n,
    input start,
    input [31:0] key,
    input [7:0] key_length,

    output [7:0]   raddr_1, waddr_2, addr_3,
    output [7:0]   rdata_1, rdata_3,
    output reg	    [7:0]   wdata_2, wdata_3,
    output reg wen,
    output reg 	[2:0]   state,
    output reg PRGA, KSA,
    output [7:0] i_out,
    output [7:0] j_out,
    output [7:0] k_out,
    output [7:0] ckey,
    output reg done
);
	
	 wire [7:0] key_reg [3:0];

    reg [7:0] i, j, k, n;
    reg [7:0] temp_addr;
    reg             first_iter;
    // reg			    wen_2, wen_3;
    // reg wen;
    reg	    [7:0]	Si, Sj, Sk;

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
            temp_addr <= 8'd0;
            // wen_2   <= 1'b0;
            // wen_3   <= 1'b0;
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
                    if (PRGA)
                    begin
                        k <= rdata_1 + rdata_3; // calculate k by Si + Sj
                    end
                    temp_addr <= i;
                    i <= i + 1'b1;      // increase i for next iteration
                end
                state <= STEP_2;
            end
            STEP_2:
            begin
                if (KSA)
                    if (j == temp_addr + 1)
                        j <= j + wdata_3 + key_reg[(i % key_length)];
                    else
                        j <= j + rdata_1 + key_reg[(i % key_length)];
                else if (PRGA)
                begin
                    j <= j + rdata_1;
                    Sk <= rdata_1;
                end
                wen <= 1'b0;
                
                if (i == (key_length + 1) && PRGA)
                begin
                    done <= 1'b1;
                    i <= 8'd0;
                    state <= IDLE;
                end
                else
                    state <= STEP_1;
            end
        endcase
        end
        
        if (KSA == 1 && i == 255)
        begin
            PRGA <= 1'b1;
            KSA  <= 1'b0;
        end
    end
    
    // address for every step 
    assign raddr_1 = i;
    assign waddr_2 = temp_addr;
    assign addr_3 = j;

    // output of cipher key 
    assign ckey = Sk;
	 
	 // value of cipher key
	 assign key_reg[0] = key[7:0];
	 assign key_reg[1] = key[15:8];
	 assign key_reg[2] = key[23:16];
	 assign key_reg[3] = key[31:24];
     assign i_out = i;
     assign j_out = j;
     assign k_out = k;
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