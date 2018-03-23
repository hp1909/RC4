`timescale 1 ns / 100 ps
`define DELAY 10

module rc4_tb();
parameter NUMS_OF_BYTES = 4;
    reg clk, rst_n, start;
    reg [31:0] key;
    reg [7:0] key_length;
    reg [7:0] input_key [NUMS_OF_BYTES: 0];
    reg [7:0] output_cipher [NUMS_OF_BYTES - 1:0];
     

    // wire [7:0] i_out;
    // wire [7:0] j_out;
    // wire [7:0] k_out;
    // wire [7:0] raddr_1, waddr_2, addr_3;
    // wire [7:0]  rdata_1, rdata_3;
    // wire [7:0]   wdata_2, wdata_3;
    // wire PRGA, KSA;
    // wire wen;
    // wire [2:0] state;
    wire [NUMS_OF_BYTES * 8 - 1:0] k_addr;
    wire [NUMS_OF_BYTES * 8 - 1:0] ckey;
    //wire [7:0] ckey;
    wire done;
    integer i, out;

    rc4_new_design #(.NUMS_OF_BYTES(NUMS_OF_BYTES)) rc4_test(
                    //input
                    .clk        (clk),
                    .rst_n      (rst_n),
                    .start      (start),
                    .key        (key),
                    .key_length (key_length),
                    // .state      (state),
                    // .PRGA       (PRGA),
                    // .KSA        (KSA),
                    // //output
                    // .wen        (wen),
                    // .j_out      (j_out),
                    // .k_out      (k_out),
                    // .i_out      (i_out),
                    // .raddr_1    (raddr_1),
                    // .waddr_2    (waddr_2),
                    // .addr_3     (addr_3),
                    // .rdata_1    (rdata_1),
                    // .rdata_3    (rdata_3),
                    // .wdata_2    (wdata_2),
                    // .wdata_3    (wdata_3),
                    .k_addr     (k_addr),
                    //.k_data     (k_data),
                    .ckey       (ckey),
                    .done       (done)
    );

    initial begin
        out = $fopen("output.txt", "w");

        $readmemh("")
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
    end

    always
        #5 clk = !clk;
    
    initial begin
        #5 
            key = 32'h40302010;
            key_length = 8'h4;

        #10
            rst_n = 1'b1;
        
        #10
            start = 1'b1;
    end

    // Notify when done
    always@(posedge done) begin
            for (i = 0; i < NUMS_OF_BYTES; i = i + 1) begin
                $fwrite(out, "%d\n", ckey[i * 8 +: 8]);
            end
    end
endmodule 
