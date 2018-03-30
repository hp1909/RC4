module rc4_inst(
						input CLOCK_50,
						input [1:0] SW,
//						input [31:0] key_in,
//						input [7:0] keyLength,
						
						output [7:0] ckey,
						output [0:0] LEDG
);
	reg [31:0] key_in;
	reg [7:0] key_length;
	
	always@(posedge CLOCK_50) begin
		if (~SW[0]) begin
			key_length <= 8'd4;
			key_in <= 32'h40302010;
		end
	end
	
	rc4 inst(
					.clk		(CLOCK_50),
					.start		(SW[1]),
					.rst_n		(SW[0]),
					.key		(key_in),
					.key_length	(key_length),
					
					.ckey		(ckey),
					.done		(LEDG)
	);
	
endmodule
