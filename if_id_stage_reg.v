// if/id stage register
// update content & output updated content at rising edge
module if_id_stage_reg (pc_plus4_in, pc_plus4_out, instruction_in, instruction_out, if_id_write, if_flush, clk, reset);
	// 1. data content
	input [31:0] pc_plus4_in, instruction_in;
	output [31:0] pc_plus4_out, instruction_out;
	// 2. hazard control
	// if_id_write: sync; if (if_id_write==1'b0), do not update content at this rising edge
	// if_flush: sync; if (if_flush==1), clear ALL content, NOT ONLY control signals
	input if_id_write, if_flush;
	// 3. general contorl
	// reset: async; set all register content to 0
	input clk, reset;

	reg [31:0] pc_plus4_out, instruction_out;

	always @(posedge clk or posedge reset)
	begin
		if (reset==1'b1)
		begin
			pc_plus4_out <= 32'b0;
			instruction_out <= 32'b0;
		end
		else if (if_flush==1'b1)
		begin
			pc_plus4_out <= 32'b0;
			instruction_out <= 32'b0;
		end
		else if (if_id_write==1'b1)
		begin
			pc_plus4_out <= pc_plus4_in;
			instruction_out <= instruction_in;
		end

	end
	
endmodule
