module rc4_inst(
						input CLOCK_50,
						input start,
						input rst_n,
						input [31:0] key,
						input [7:0] keyLength,
						
						output [7:0] ckey,
						output done
);
	rc4 inst(
					.clk		(CLOCK_50),
					.start		(start),
					.rst_n		(rst_n),
					.key		(key),
					.key_length	(keyLength),
					
					.ckey		(ckey),
					.done		(done)
	);
	
endmodule
