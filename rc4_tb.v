`timescale 1 ns / 100 ps
`define DELAY 10

module rc4_tb();
    parameter NUMS_OF_BYTES = 16;

    reg clk, rst_n, start;
    reg [NUMS_OF_BYTES * 8 - 1:0] key;
    reg [7:0] key_length;
    reg [7:0] input_key [NUMS_OF_BYTES: 0];
    reg [7:0] output_cipher [NUMS_OF_BYTES - 1:0];
     

    wire [7:0] i_out;
    wire [7:0] j_out;
    wire [7:0] k_out;
    wire [7:0] raddr_1, waddr_2, addr_3;
    wire [7:0]  rdata_1, rdata_3;
    wire [7:0]   wdata_2, wdata_3;
    wire PRGA, KSA;
    wire wen;
    wire [7:0] temp_addr;
    //wire [7:0] temp_data;
    wire [2:0] state;
    wire [NUMS_OF_BYTES * 8 - 1:0] k_addr;
    //wire [NUMS_OF_BYTES * 8 - 1:0] ckey;
    wire [NUMS_OF_BYTES * 8 - 1:0] data_out;
    wire [7:0] ckey;
    wire done;
    integer i, out;
    reg valid;

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
                    // .j          (j_out),
                    // .k          (k_out),
                    // .i          (i_out),
                    // .raddr_1    (raddr_1),
                    // .waddr_2    (waddr_2),
                    // .addr_3     (addr_3),
                    // .rdata_1    (rdata_1),
                    // .rdata_3    (rdata_3),
                    // .wdata_2    (wdata_2),
                    // .wdata_3    (wdata_3),
                    // .temp_addr  (temp_addr),
                    //.temp_data  (temp_data),
                    //.k_addr     (k_addr),
                    //.data_out   (data_out),
                    //.k_data     (k_data),
                    .ckey       (ckey),
                    .done       (done)
    );

    initial begin

        $readmemh("test_data/input.txt", input_key);
        $readmemh("test_data/output.txt", output_cipher);

        /* If you want to run directly in Modelsim, use this path
        $readmemh("../test_data/input.txt", input_key);
        $readmemh("../test_data/output.txt", output_cipher);
        */
    end

    initial begin
        valid = 1'b1;
        clk = 1'b0;
        rst_n = 1'b0;

        key_length = input_key[0];

        for (i = 1; i <= NUMS_OF_BYTES; i = i + 1) begin
            key[(i - 1) * 8 +: 8] = input_key[i];
        end
    end

    always
        #5 clk = !clk;
    
    initial begin
        #15
            rst_n = 1'b1;
        
        #10
            start = 1'b1;
    end

    // Notify when done
    always@(posedge done) begin
            for (i = 0; i < NUMS_OF_BYTES; i = i + 1) begin
                if (ckey[i * 8 +: 8] != output_cipher[i]) begin
                    $display("error at position %d\n", i);
                    valid = 1'b0;
                end
            end

            if (valid) begin
                $display("data corect");
            end
            else begin
                $display("data fail");
            end
    end

endmodule 
