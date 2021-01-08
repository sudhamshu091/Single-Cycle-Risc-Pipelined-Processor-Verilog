// id/ex stage register
// update content & output updated content at rising edge
module id_ex_stage_reg (id_flush_lwstall, id_flush_branch, regwrite_in, memtoreg_in, regwrite_out, memtoreg_out, branch_in, memread_in, memwrite_in, jump_in, branch_out, memrea_d_out, memwrite_out, jump_out, reg_dest_in, alusrc_in, reg_dest_out, aluSr_c_out, aluop_in, aluop_out, jump_addr_in, pc_plus4_in, jump_addr_out, pc_plus4_out, reg_read_data_1_in, reg_read_data_2_in, immi_sign_extended_in, reg_read_data_1_out, reg_read_data_2_out, immi_sign_extende_d_out, if_id_register_rs_in, if_id_registerrt_in, if_id_registerrd_in, if_id_register_rs_out, if_id_registerrt_out, if_id_registerr_d_out,if_id_funct_in, if_id_funct_out,clk, reset);
	// 1. hazard control signal (sync rising edge)
	// if either id_flush_lwstall or id_flush_branch equals 1,
	// then clear all wb, mem and ex control signal to 0 on rising edge
	// do not need to clear addr, data or reg content
	input id_flush_lwstall, id_flush_branch;
	// 2. wb control signal
	input regwrite_in, memtoreg_in;
	output regwrite_out, memtoreg_out;
	// 3. mem control signal
	input branch_in, memread_in, memwrite_in, jump_in;
	output branch_out, memrea_d_out, memwrite_out, jump_out;
	// 4. ex control signal
	input reg_dest_in, alusrc_in;
	input [1:0] aluop_in;
	output reg_dest_out, aluSr_c_out;
	output [1:0] aluop_out;
	// 5. addr content
	input [31:0] jump_addr_in, pc_plus4_in;
	output [31:0] jump_addr_out, pc_plus4_out;
	// 6. data content
	input [31:0] reg_read_data_1_in, reg_read_data_2_in, immi_sign_extended_in;
	output [31:0] reg_read_data_1_out, reg_read_data_2_out, immi_sign_extende_d_out;
	// 7. reg content
	input [4:0] if_id_register_rs_in, if_id_registerrt_in, if_id_registerrd_in;
	output [4:0] if_id_register_rs_out, if_id_registerrt_out, if_id_registerr_d_out;
	input [5:0] if_id_funct_in;
	output [5:0] if_id_funct_out;
	// general signal
	// reset: async; set all register content to 0
	input clk, reset;
	
	reg regwrite_out, memtoreg_out;
	reg branch_out, memrea_d_out, memwrite_out, jump_out;
	reg reg_dest_out, aluSr_c_out;
	reg [1:0] aluop_out;
	reg [31:0] jump_addr_out, pc_plus4_out;
	reg [31:0] reg_read_data_1_out, reg_read_data_2_out, immi_sign_extende_d_out;
	reg [4:0] if_id_register_rs_out, if_id_registerrt_out, if_id_registerr_d_out;
	reg [5:0] if_id_funct_out;
	
	always @(posedge clk or posedge reset)
	begin
		if (reset == 1'b1)
		begin
			regwrite_out = 1'b0;
			memtoreg_out = 1'b0;
			branch_out = 1'b0;
			memrea_d_out = 1'b0;
			memwrite_out = 1'b0;
			jump_out = 1'b0;
			reg_dest_out = 1'b0;
			aluSr_c_out = 1'b0;
			aluop_out = 2'b0;
			jump_addr_out = 32'b0;
			pc_plus4_out = 32'b0;
			reg_read_data_1_out = 32'b0;
			reg_read_data_2_out = 32'b0;
			immi_sign_extende_d_out = 32'b0;
			if_id_register_rs_out = 5'b0;
			if_id_registerrt_out = 5'b0;
			if_id_registerr_d_out = 5'b0;
			if_id_funct_out = 6'b0;			
		end
		else if (id_flush_lwstall == 1'b1)
		begin
			regwrite_out = 1'b0;
			memtoreg_out = 1'b0;
			branch_out = 1'b0;
			memrea_d_out = 1'b0;
			memwrite_out = 1'b0;
			jump_out = 1'b0;
			reg_dest_out = 1'b0;
			aluSr_c_out = 1'b0;
			aluop_out = 2'b0;
		end
		else if (id_flush_branch == 1'b1)
		begin
			regwrite_out = 1'b0;
			memtoreg_out = 1'b0;
			branch_out = 1'b0;
			memrea_d_out = 1'b0;
			memwrite_out = 1'b0;
			jump_out = 1'b0;
			reg_dest_out = 1'b0;
			aluSr_c_out = 1'b0;
			aluop_out = 2'b0;
		end
		else begin
			regwrite_out = regwrite_in;
			memtoreg_out = memtoreg_in;
			branch_out = branch_in;
			memrea_d_out = memread_in;
			memwrite_out = memwrite_in;
			jump_out = jump_in;
			reg_dest_out = reg_dest_in;
			aluSr_c_out = alusrc_in;
			aluop_out = aluop_in;
			jump_addr_out = jump_addr_in;
			pc_plus4_out = pc_plus4_in;
			reg_read_data_1_out = reg_read_data_1_in;
			reg_read_data_2_out = reg_read_data_2_in;
			immi_sign_extende_d_out = immi_sign_extended_in;
			if_id_register_rs_out = if_id_register_rs_in;
			if_id_registerrt_out = if_id_registerrt_in;
			if_id_registerr_d_out = if_id_registerrd_in;
			if_id_funct_out = if_id_funct_in;
		end	
		
	end	
	
endmodule
