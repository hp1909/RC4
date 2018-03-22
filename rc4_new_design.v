/** ************************************************************************************
*   Module: RC4 - New Design for k output
*   Author: Hoang Phuc Nguyen
*   Date:   Mar 22th, 2018
*   
*   Function:   This design is slightly different with the original one.
*               It focuses on the output of address k in 1 iteration by
*               adding 1 read-only port for SBOX. 
*               Other step and state machine is the same with the original one.
*   Input:      
*               clk         :   1 bit
*               rst_n       :   1 bit       - Reset when equal to 0.
*               start       :   1 bit       - When value is 1, it starts RC4. 
*               key         :   n * 8 bits  - Input key for generate cipher key.
*                                             n is the number of cipher key's bytes.
*               key_length  :   8 bit       - Key length has value from 1 --> 256 bytes.
*   Output:     
*               ckey        :   n * 8 bits  - n is the number of cipher key's bytes.
*               done        :   1 bit       - When finish. Done has value 1.
*               
** ************************************************************************************/

module rc4_new_design
#(parameter NUMS_OF_BYTES = 4)
(
    input clk,
    input rst_n,
    input start,
    input [31:0] key,
    input [7:0] key_length,

    output [NUMS_OF_BYTES * 8 - 1:0]  k_data,
    output reg [NUMS_OF_BYTES * 8 - 1:0] k_addr,  

    output [7:0] ckey,
    output reg done
);
	
	wire [7:0] key_reg [3:0];
    wire [7:0]  raddr_1, waddr_2, addr_3;
    wire [7:0]  rdata_1, rdata_3;  
    reg	 [7:0]  wdata_2, wdata_3;

    reg wen;
    reg 	[2:0]   state;
    reg PRGA, KSA;

    reg     [7:0]   i, j, k;
    reg     [7:0]   temp_addr;
    reg             first_iter;
    reg	    [7:0]	Si;

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
            k_addr      <= 0;
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
            end // end IDLE 
            STEP_1:
            begin
                if (first_iter) begin
                    if (KSA)
                        i <= 8'd0;      // i = 0 if KSA and = 1 if PRGA
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
                        wdata_3 <= rdata_1; // j <- S[i]
                    end 
                    if (PRGA && i >= 1) begin
                        k <= Si + rdata_3; // calculate k by Si + Sj    // Cal k Block
                        k_addr[(i - 1) * 8 +: 8] <= Si + rdata_3;
                    end
                    temp_addr <= i;
                    i <= i + 1'b1;      // increase i for next iteration
                end
                state <= STEP_2;
            end // end STEP 1
            STEP_2:
            begin
                wen <= 1'b0;
                if (KSA) begin
                    if (j == temp_addr + 1)
                        j <= j + wdata_3 + key_reg[(i % key_length)];   // Cal J Block
                    else
                        j <= j + rdata_1 + key_reg[(i % key_length)];   // Cal J Block
                end
                else if (PRGA) begin
                    if (i == 1)
                        j <= 8'd0 + rdata_1;                            // Cal J Block                            
                    else
                        j <= j + rdata_1;                               // Cal J Block
                    Si <= rdata_1;
                end
                
                if (i == (key_length + 2) && PRGA) begin                // If done, move to IDLE
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
    assign addr_3 = j;

    // output of cipher key 
    assign ckey = PRGA ? ((~wen && state == STEP_1 && i > 1 && i < 255) ? rdata_1 : ckey) : 8'd0;
	 
	 // value of cipher key
    assign key_reg[0] = key[7:0];
    assign key_reg[1] = key[15:8];
    assign key_reg[2] = key[23:16];
    assign key_reg[3] = key[31:24];

    ram_new_design #(.NUMS_OF_BYTES(NUMS_OF_BYTES)) SBox (
        .rst_n      (rst_n),
        .clk        (clk),
        .wen        (wen),
        .raddr_1    (raddr_1),
        .waddr_2    (waddr_2),
        .addr_3     (addr_3),
        .k_addr     (k_addr),
        .k_data     (k_data),
        .wdata_2    (wdata_2),
        .wdata_3    (wdata_3),
        .rdata_1    (rdata_1),
        .rdata_3    (rdata_3)
    );
	
endmodule 