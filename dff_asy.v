module dff_asy (q, d, clk, _rst);
	input d, clk, _rst;
	output reg q;
	
	always @ (posedge clk or posedge _rst)
		if (_rst == 1) q <= 0;
		else q <= d;
endmodule
