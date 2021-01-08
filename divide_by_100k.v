module divide_by_100k (clock, reset, clock_out); // modified to divide-by-4 for simulation
	parameter N = 17;
	input	clock, reset;
	wire	load, asyclock_out;
	wire 	[N-1:0] dat;
	output 	clock_out;
	reg 	[N-1:0] q;
	assign	dat = 0;
	assign	load = q[1] & q[0]; // modified to load = 3 (DEC) for simulation
	always @ (posedge reset or posedge clock)
	begin
		if (reset == 1'b1) q <= 0;
		else if (load == 1'b1) q <= dat;
		else q <= q + 1;
	end
	assign	asyclock_out = load;
	dff_asy dff (.q(clock_out), .d(asyclock_out), .clk(clock), ._rst(reset));
endmodule
