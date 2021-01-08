// this one added a pcwrite signal. 
// Stop writing on this rising edge if pcwrite equals 0
//
// origin_al module description:
// rising-edge synchronous program counter
// output range: decimal 0 to 32 (== I-mem height)
// data I/O width: 64 = 2^6
// async reset: set program counter to 0 asynchronously
module program_counter (clk, reset, pc_in, p_c_out, pcwrite);
	input pcwrite; // new input for pipeline_single_cycle
	input clk, reset;
	input [6:0] pc_in;//at most 32 instructions
	output [6:0] p_c_out;
	reg [6:0] p_c_out;
	always @ (posedge clk or posedge reset)
	begin
		if(reset==1'b1)
			p_c_out<=0;
		else if(pcwrite)
			p_c_out<=pc_in;
	end
endmodule
