/** ************************************************************************************
*   Module: RC4
*   Author: Hoang Phuc Nguyen
*   Date:   Mar 22th, 2018
*   
*   Function:   This code implements RC4 algorithm using 3-port SBox.
*               It takes 2 clocks for RSA and PRGA to generate 1 byte.
*               
** ************************************************************************************/
module rc4
#(parameter NUMS_OF_BYTES = 4)
(
    input           clk,
    input           rst_n,
    input           start,
    input [NUMS_OF_BYTES * 8 - 1:0]    key,
    input [7:0]     key_length,

    output [7:0]    ckey,
    output reg      done

    // output    [7:0]   raddr_1, waddr_2, addr_3,
    // output    [7:0]   rdata_1, rdata_3,
    // output reg	    [7:0]   wdata_2, wdata_3,

    // output reg             wen,
    // output reg 	[2:0]   state,
    // output reg             PRGA, KSA,

    // output reg     [7:0]   i, j, k,
    // output reg     [7:0]   temp_addr
    // output reg             first_iter,
    // output reg	    [7:0]	Si
);
	
	reg     [7:0]   key_reg [NUMS_OF_BYTES - 1:0];
    
    wire    [7:0]   raddr_1, waddr_2, addr_3;
    wire    [7:0]   rdata_1, rdata_3;
    reg	    [7:0]   wdata_2, wdata_3;

    reg             wen;
    reg 	[2:0]   state;
    reg             PRGA, KSA;

    reg     [7:0]   i, j, k;
    reg     [7:0]   temp_addr;
   
    reg             first_iter;
    reg	    [7:0]	Si;
    
    integer iter;

    // state
    parameter STEP_1 = 1;
    parameter STEP_2 = 2;
    parameter IDLE = 0;

    always@(posedge clk) begin
        if (~rst_n) begin
            state       <= 3'd0;
            i           <= 8'd0;
            j           <= 8'd0;
            k           <= 8'd0;
            Si          <= 8'd0;
            KSA         <= 1'b1;
            PRGA        <= 1'b0;
            temp_addr   <= 8'd0;
            first_iter  <= 1'b1;
			done	    <= 1'b0;
            wen         <= 1'b0;
        end
        else begin
            case (state)
            IDLE:
            begin
                if (start && ~done)
                    state <= STEP_1;
                else 
                    state <= IDLE;
            end
            STEP_1:
            begin
                if (first_iter) begin
                    if (KSA)
                        i <= 8'd0;              // i = 0 if KSA and = 1 if PRGA
                    else if (PRGA) begin
                        i <= 8'd1;
                        wen <= 1'b1;
                        if (i != j) begin
                            wdata_2 <= rdata_3; // i <- S[j]
                            wdata_3 <= rdata_1; // j <- S[i]
                            temp_addr <= i;
                        end 
                    end
                    first_iter <= 1'b0;
                end
                else begin
                    wen <= 1'b1;
                    if (i != j) begin
                        wdata_2 <= rdata_3; // i <- S[j]
                        if (PRGA) begin
                            wdata_3 <= Si;
                        end
                        else begin
                            wdata_3 <= rdata_1; // j <- S[i]
                        end
                    end 

                    if (PRGA && i >= 1) begin
                        k <= Si + rdata_3; // calculate k by Si + Sj    // Cal k Block
                    end
                    temp_addr <= i;
                    i <= i + 1'b1;      // increase i for next iteration
                end
                state <= STEP_2;
            end // end STEP 1
            STEP_2:
            begin
                wen <= 1'b0;
                if (KSA)
                    if (j == temp_addr + 1)
                        j <= j + wdata_3 + key_reg[(i % key_length)];   // Cal J Block
                    else
                        j <= j + rdata_1 + key_reg[(i % key_length)];   // Cal J Block
                else if (PRGA) begin
                    if (i == 1)
                        j <= 8'd0 + rdata_1;                            // Cal J Block                            
                    else
                        j <= j + rdata_1;                               // Cal J Block
                    Si <= rdata_1;
                end
                
                if (i == (key_length + 2) && PRGA) begin                // Finish
                    done <= 1'b1;
                    i <= 8'd0;
                    state <= IDLE;
                end
                else
                    state <= STEP_1;
            end // end STEP 2 
        endcase
        end
        
        if (KSA == 1 && i == 255) begin
            PRGA <= 1'b1;
            KSA  <= 1'b0;
            first_iter <= 1'b1;
        end
    end

    
    // address for every step 
    assign raddr_1 = (PRGA && state == STEP_1 && i >= 2 && i < 255) ? k : i;
    assign waddr_2 = temp_addr;
    assign addr_3  = j;

    // output of cipher key 
    assign ckey = PRGA ? ((~wen && state == STEP_1 && i > 1 && i < 255) ? rdata_1 : ckey) : 8'd0;
	 
	 // value of cipher key
    always@(*) begin
        for (iter = 0; iter < NUMS_OF_BYTES; iter = iter + 1) begin
            key_reg[iter] <= key[iter * 8 +: 8]; 
        end
     end

    ram SBox(
        .rst_n      (rst_n),
        .clk        (clk),
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