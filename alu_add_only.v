// 32-bit alu for addition only
// data input width: 2 32-bit
// data output width: 1 32-bit, no "zero" output
// control: no control input, only addition operation implemented
module alu_add_only (in_a, in_b, ad_d_out);
	input [31:0] in_a, in_b;
	output [31:0] ad_d_out;
	assign ad_d_out=in_a+in_b;
endmodule
