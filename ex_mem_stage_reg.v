// ex/mem stage register
// update content & output updated content at rising edge
module ex_mem_stage_reg (ex_flush, regwrite_in, memtoreg_in, regwrite_out, memtoreg_out, branch_in, memread_in, memwrite_in, jump_in, branch_out, memrea_d_out, memwrite_out, jump_out, jump_addr_in, branch_addr_in, jump_addr_out, branch_addr_out, alu_zero_in, alu_zero_out, alu_result_in, reg_read_data_2_in, alu_result_out, reg_read_data_2_out, id_ex_registerrd_in, ex_mem_register_r_d_out, clk, reset);
	// 1. hazard control signal (sync rising edge)
	// if ex_flush equals 1,
	// then clear all wb, mem control signal to 0 on rising edge
	// do not need to clear addr or data content
	input ex_flush;
	// 2. wb control signal
	input regwrite_in, memtoreg_in;
	output regwrite_out, memtoreg_out;
	// 3. mem control signal
	input branch_in, memread_in, memwrite_in, jump_in;
	output branch_out, memrea_d_out, memwrite_out, jump_out;
	// 4. addr content
	input [31:0] jump_addr_in, branch_addr_in;
	output [31:0] jump_addr_out, branch_addr_out;
	// 5. data content
	input alu_zero_in;
	output alu_zero_out;
	input [31:0] alu_result_in, reg_read_data_2_in;
	output [31:0] alu_result_out, reg_read_data_2_out;
	input [4:0] id_ex_registerrd_in;
	output [4:0] ex_mem_register_r_d_out;
	// general signal
	// reset: async; set all register content to 0
	input clk, reset;

	reg regwrite_out, memtoreg_out;
	reg branch_out, memrea_d_out, memwrite_out, jump_out;
	reg [31:0] jump_addr_out, branch_addr_out;
	reg alu_zero_out;
	reg [31:0] alu_result_out, reg_read_data_2_out;
	reg [4:0] ex_mem_register_r_d_out;

	always @(posedge clk or posedge reset)
	begin
		if (reset == 1'b1)
		begin
		  regwrite_out <= 1'b0;
		  memtoreg_out <= 1'b0;
		  branch_out <= 1'b0;
		  memrea_d_out <= 1'b0;
		  memwrite_out <= 1'b0;
		  jump_out <= 1'b0;
		  jump_addr_out <= 32'b0;
		  branch_addr_out <= 32'b0;
		  alu_zero_out <= 1'b0;
		  alu_result_out <= 32'b0;
		  reg_read_data_2_out <= 32'b0;
		  ex_mem_register_r_d_out <= 5'b0; 
		end
		else if (ex_flush == 1'b1)
	    begin
		  regwrite_out <= 1'b0;
		  memtoreg_out <= 1'b0;
		  branch_out <= 1'b0;
		  memrea_d_out <= 1'b0;
		  memwrite_out <= 1'b0;
		  jump_out <= 1'b0;
		end
		else begin
		  regwrite_out <= regwrite_in;
		  memtoreg_out <= memtoreg_in;
		  branch_out <= branch_in;
		  memrea_d_out <= memread_in;
		  memwrite_out <= memwrite_in;
		  jump_out <= jump_in;
		  jump_addr_out <= jump_addr_in;
		  branch_addr_out <= branch_addr_in;
		  alu_zero_out <= alu_zero_in;
		  alu_result_out <= alu_result_in;
		  reg_read_data_2_out <= reg_read_data_2_in;
		  ex_mem_register_r_d_out <= id_ex_registerrd_in;
		end

	end

endmodule
