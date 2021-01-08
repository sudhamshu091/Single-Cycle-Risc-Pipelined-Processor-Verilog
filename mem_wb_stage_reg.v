// mem/wb stage register
// update content & output updated content at rising edge
module mem_wb_stage_reg (regwrite_in, memtoreg_in, regwrite_out, memtoreg_out, d_mem_read_data_in, d_mem_read_addr_in, d_mem_read_dat_a_out, d_mem_read_addr_out, ex_mem_register_rd_in, mem_wb_register_r_d_out, clk, reset);
	// 1. wb control signal
	input regwrite_in, memtoreg_in;
	output regwrite_out, memtoreg_out;
	// 2. data content
	input [31:0] d_mem_read_data_in, d_mem_read_addr_in;
	output [31:0] d_mem_read_dat_a_out, d_mem_read_addr_out;
	input [4:0] ex_mem_register_rd_in;
	output [4:0] mem_wb_register_r_d_out;
	// general signal
	// reset: async; set all register content to 0
	input clk, reset;
	
	reg regwrite_out, memtoreg_out;
	reg [31:0] d_mem_read_dat_a_out, d_mem_read_addr_out;
	reg [4:0] mem_wb_register_r_d_out;
	
	always @(posedge clk or posedge reset)
	begin
		if (reset == 1'b1)
		begin
			regwrite_out <= 1'b0;
			memtoreg_out <= 1'b0;
			d_mem_read_dat_a_out <= 32'b0;
			d_mem_read_addr_out <= 32'b0;
			mem_wb_register_r_d_out <= 5'b0;
		end
		else begin
			regwrite_out <= regwrite_in;
			memtoreg_out <= memtoreg_in;
			d_mem_read_dat_a_out <= d_mem_read_data_in;
			d_mem_read_addr_out <= d_mem_read_addr_in;
			mem_wb_register_r_d_out <= ex_mem_register_rd_in;
		end
		
	end
	
endmodule
