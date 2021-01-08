module pipeline_single_cycle (fastclk, reset, swith_select, switch_run, cathode, an, ledindicator, reg_read_data_1);
	input fastclk, reset;		                        // fastclk (5m Hz) feeds clock divider
	input switch_run;			                // decide run(1) or check reg file(0)
	input [4:0] swith_select;	                        // select $0 to $31 for output
	output [6:0] cathode;		                        // ssd
	output [3:0] an;
	output ledindicator;		                        // output clknormal for user reference
	output [31:0] reg_read_data_1;
	
	// wires in if stage
	wire [31:0] pc_in_origin_al;
	wire [6:0] p_c_out_short;
	wire [31:0] p_c_out_unsign_extended, pc_plus4;
	wire [31:0] instruction;
	wire [31:0] branch_jump_addr;
	// wires in id stage
	wire [31:0] if_id_pc_plus4, if_id_instruction;
	wire [4:0] mem_wb_register_rd;
	wire [31:0] reg_read_data_2;

	wire [31:0] immi_sign_extended;
	// jump within id stage
	wire [31:0] jump_addr;
	wire [27:0] jump_base28;
	// control signal generation within id stage
	wire reg_dest, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite;
	wire [1:0] aluop;
	// wires in ex stage
	wire id_ex_reg_dest, id_ex_jump, id_ex_branch, id_ex_memread, id_ex_memtoreg, id_ex_memwrite, id_ex_alusrc, id_ex_regwrite;
	wire [1:0] id_ex_aluop;
	wire [31:0] id_ex_jump_addr;
	wire [31:0] id_ex_pc_plus4, id_ex_reg_read_data_1, id_ex_reg_read_data_2;
	wire [31:0] id_ex_immi_sign_extended;
	wire [4:0] id_ex_register_rs, id_ex_registerrt, id_ex_registerrd;// Ou modifies: [31:0]
	wire [4:0] ex_registerrd;
	wire [5:0] id_ex_funct;
	wire [3:0] out_to_alu;
	wire [31:0] mux_a_out, mux_b_out;
	wire [31:0] after_alusrc;
	wire [31:0] alu_result;
	wire alu_zero;
	wire [31:0] after_shift, branch_addr;
	// wires in mem stage
	wire [4:0] ex_mem_register_rd;
	wire ex_mem_regwrite, ex_mem_mem_to_reg, ex_mem_branch, ex_mem_memread, ex_mem_memwrite, ex_mem_jump;
	wire [31:0] ex_mem_jump_addr, ex_mem_branch_addr;
	wire ex_mem_alu_zero;
	wire [31:0] ex_mem_alu_result, ex_mem_reg_read_data_2;
	wire [31:0] d_mem_data;
	wire branch_taken;
	// wires in wb stage
	wire [31:0] reg_write_data;
	wire mem_wb_regwrite, mem_wb_memtoreg;
	wire [31:0] mem_wb_d_mem_read_data, mem_wb_d_mem_read_addr;
	// wires for forwarding
	wire [1:0] forward_a, forward_b;
	// wires for lw hazard stall
	wire pcwrite;					        // pc stops writing if pcwrite == 0
	wire if_id_write;				        // if/id reg stops writing if if_id_write == 0
	wire id_flush_lwstall;
	// wires for jump/branch control hazard
	wire pcsrc;
	wire if_flush, id_flush_branch, ex_flush;

	// ssd display & clock slow-down
	wire clkssd, clknormal, clkrf, clk;
		                                                // fastclk: 5m Hz
								// clkssd: 500 Hz for ring counter
								// clknormal: 1 Hz
    	wire  [3:0] tho;					// Binary-Coded-Decimal 0-15
	wire  [3:0] hun;
	wire  [3:0] ten;
	wire  [3:0] one;
    	wire  [6:0] thossd;
	wire  [6:0] hunssd;
	wire  [6:0] tenssd;
	wire  [6:0] onessd;	
	// multi-purpose I-mem read_addr_1
	wire [4:0] multi_purpose_read_addr;
	wire multi_purpose_regwrite;

	// reg to resolve always block technicalities
	reg clkrf_reg, clk_reg, multi_purpose_regwrite_reg;
	reg [4:0] multi_purpose_read_addr_reg;
	reg [3:0] tho_reg, hun_reg, ten_reg, one_reg;		

   	//new forward, change id_ex stage register
	wire forward_c,forward_d;
	wire [31:0] mux_c_out,mux_d_out;
	mux_N_bit #(32) mux_N_bit4 (.in0(reg_read_data_1),.in1(reg_write_data),.mux_out(mux_c_out),.control(forward_c));
	mux_N_bit #(32) mux_N_bit5 (.in0(reg_read_data_2),.in1(reg_write_data),.mux_out(mux_d_out),.control(forward_d));


	// output processor clock (1 Hz or freeze) to a LED
	assign ledindicator = clk;
	// if stage
	Program_Counter program_counter1 (.clk(clk), .reset(reset), .pc_in(pc_in_origin_al[6:0]), .p_c_out(p_c_out_short), .pcwrite(pcwrite));
	Instruction_memory instruction_memory1 (.read_addr(p_c_out_short), .instruction(instruction), .reset(reset));
	assign p_c_out_unsign_extended = {26'b0000_0000_0000_0000_0000_0000_0, p_c_out_short}; // from 7 bits to 32 bits
	alu_add_only alu_add_only1 (.in_a(p_c_out_unsign_extended), .in_b(32'b0100), .ad_d_out(pc_plus4)); // pc + 4
	mux_N_bit #(32) mux_N_bit1 (.in0(pc_plus4), .in1(branch_jump_addr), .mux_out(pc_in_origin_al), .control(pcsrc));
	if_id_stage_reg if_id_stage_reg1(.pc_plus4_in(pc_plus4), .pc_plus4_out(if_id_pc_plus4), .instruction_in(instruction), .instruction_out(if_id_instruction), .if_id_write(if_id_write), .if_flush(if_flush), .clk(clk), .reset(reset));
	// id stage
	register_file register_file1 (.read_addr_1(multi_purpose_read_addr), .read_addr_2(if_id_instruction[20:16]), .write_addr(mem_wb_register_rd), .read_data_1(reg_read_data_1), .read_data_2(reg_read_data_2), .write_data(reg_write_data), .regwrite(multi_purpose_regwrite), .clk(clkrf), .reset(reset));
	sign_extension sign_extension1 (.sign_in(if_id_instruction[15:0]), .sign_out(immi_sign_extended));
		// jump within id stage
	jump_shiftleft2 jump_shift (.shift_in(if_id_instruction[25:0]), .shift_out(jump_base28));
	assign jump_addr = {if_id_pc_plus4[31:28], jump_base28}; // jump_addr = (pc+4)[31:28] joined with jump_base28[27:0]
	control control1 (.opcode(if_id_instruction[31:26]), .reg_dest(reg_dest), .jump(jump), .branch(branch), .memread(memread), .memtoreg(memtoreg), .aluop(aluop), .memwrite(memwrite), .alusrc(alusrc), .regwrite(regwrite));
	id_ex_stage_reg id_ex_stage_reg1 (.id_flush_lwstall(id_flush_lwstall), .id_flush_branch(id_flush_branch), .regwrite_in(regwrite), .memtoreg_in(memtoreg), .regwrite_out(id_ex_regwrite), .memtoreg_out(id_ex_memtoreg), .branch_in(branch), .memread_in(memread), .memwrite_in(memwrite), .jump_in(jump), .branch_out(id_ex_branch), .memrea_d_out(id_ex_memread), 
	.memwrite_out(id_ex_memwrite), .jump_out(id_ex_jump), .reg_dest_in(reg_dest), .alusrc_in(alusrc), .reg_dest_out(id_ex_reg_dest), .aluSr_c_out(id_ex_alusrc), .aluop_in(aluop), .aluop_out(id_ex_aluop), .jump_addr_in(jump_addr), .pc_plus4_in(if_id_pc_plus4), .jump_addr_out(id_ex_jump_addr), .pc_plus4_out(id_ex_pc_plus4),
	.reg_read_data_1_in(mux_c_out), .reg_read_data_2_in(mux_d_out), .immi_sign_extended_in(immi_sign_extended), .reg_read_data_1_out(id_ex_reg_read_data_1), .reg_read_data_2_out(id_ex_reg_read_data_2), .immi_sign_extende_d_out(id_ex_immi_sign_extended), .if_id_register_rs_in(if_id_instruction[25:21]), 
	.if_id_registerrt_in(if_id_instruction[20:16]), .if_id_registerrd_in(if_id_instruction[15:11]), .if_id_register_rs_out(id_ex_register_rs), .if_id_registerrt_out(id_ex_registerrt), .if_id_registerr_d_out(id_ex_registerrd), .if_id_funct_in(if_id_instruction[5:0]),.if_id_funct_out(id_ex_funct),.clk(clk), .reset(reset));//Ou adds  if_id_funct_in and out
	// ex stage
	mux_N_bit #(5) mux_N_bit_6 (.in0(id_ex_registerrt), .in1(id_ex_registerrd), .mux_out(ex_registerrd), .control(id_ex_reg_dest));
	alucontrol alucontrol1 (.aluop(id_ex_aluop), .funct(id_ex_funct), .out_to_alu(out_to_alu));// Ou modifies: funct should not be if_id_instruction. Rather, it should be id_ex_funct(a new wire)
	mux_32bit_3to1 mux_a1 (.in00(id_ex_reg_read_data_1), .in01(reg_write_data), .in10(ex_mem_alu_result), .mux_out(mux_a_out), .control(forward_a));
	mux_32bit_3to1 mux_b1 (.in00(id_ex_reg_read_data_2), .in01(reg_write_data), .in10(ex_mem_alu_result), .mux_out(mux_b_out), .control(forward_b));//Ou modifies: keep the structure paralleled with muxA
	mux_N_bit #(32) mux_N_bit2 (.in0(mux_b_out), .in1(id_ex_immi_sign_extended), .mux_out(after_alusrc), .control(id_ex_alusrc));
	alu alu1 (.in_a(mux_a_out), .in_b(after_alusrc), .alu_out(alu_result), .zero(alu_zero), .control(out_to_alu));
	branch_shiftleft2 branch_shift1 (.shift_in(id_ex_immi_sign_extended), .shift_out(after_shift));
	alu_add_only alu_add_only2 (.in_a(id_ex_pc_plus4), .in_b(after_shift), .ad_d_out(branch_addr)); // (pc+4) + branch_addition*4Z
	// in ex/mem stage reg, note mux_b_out is used in the place of reg_read_data_2 as a result of forwarding;ygb 
	ex_mem_stage_reg ex_mem_stage_reg1 (.ex_flush(ex_flush), .regwrite_in(id_ex_regwrite), .memtoreg_in(id_ex_memtoreg), .regwrite_out(ex_mem_regwrite), .memtoreg_out(ex_mem_mem_to_reg),
	.branch_in(id_ex_branch), .memread_in(id_ex_memread), .memwrite_in(id_ex_memwrite),
	.jump_in(id_ex_jump), .branch_out(ex_mem_branch), .memrea_d_out(ex_mem_memread),
	.memwrite_out(ex_mem_memwrite), .jump_out(ex_mem_jump), .jump_addr_in(id_ex_jump_addr), 
	.branch_addr_in(branch_addr), .jump_addr_out(ex_mem_jump_addr), 
	.branch_addr_out(ex_mem_branch_addr), .alu_zero_in(alu_zero),
	.alu_zero_out(ex_mem_alu_zero), .alu_result_in(alu_result), .reg_read_data_2_in(mux_b_out), 
	.alu_result_out(ex_mem_alu_result), .reg_read_data_2_out(ex_mem_reg_read_data_2), 
	.id_ex_registerrd_in(ex_registerrd), .ex_mem_register_r_d_out(ex_mem_register_rd), .clk(clk), .reset(reset));
	// mem stage
	data_memory data_memory1 (.addr(ex_mem_alu_result[7:0]), .write_data(ex_mem_reg_read_data_2), .read_data(d_mem_data), .clk(clk), .reset(reset), .memread(ex_mem_memread), .memwrite(ex_mem_memwrite));
	and (branch_taken, ex_mem_branch, ex_mem_alu_zero);
	jump_or_branch jump_or_branch1 (.jump(ex_mem_jump), .branch_taken(branch_taken), .branch_addr(ex_mem_branch_addr), .jump_addr(ex_mem_jump_addr), .pcsrc(pcsrc), .addr_out(branch_jump_addr));
	//wb stage
	mem_wb_stage_reg mem_wb_stage_reg1 (.regwrite_in(ex_mem_regwrite), .memtoreg_in(ex_mem_mem_to_reg), .regwrite_out(mem_wb_regwrite), .memtoreg_out(mem_wb_memtoreg), .d_mem_read_data_in(d_mem_data), .d_mem_read_addr_in(ex_mem_alu_result), .d_mem_read_dat_a_out(mem_wb_d_mem_read_data), 
	.d_mem_read_addr_out(mem_wb_d_mem_read_addr), .ex_mem_register_rd_in(ex_mem_register_rd), .mem_wb_register_r_d_out(mem_wb_register_rd), .clk(clk), .reset(reset));
	mux_N_bit #(32) Mux_N_bit3 (.in0(mem_wb_d_mem_read_addr), .in1(mem_wb_d_mem_read_data), .mux_out(reg_write_data), .control(mem_wb_memtoreg));
	forwarding_control Utni23 (.ex_mem_register_rd(ex_mem_register_rd), .mem_wb_register_rd(mem_wb_register_rd), .id_ex_register_rs(id_ex_register_rs), .id_ex_registerrt(id_ex_registerrt), .ex_mem_regwrite(ex_mem_regwrite), .mem_wb_regwrite(mem_wb_regwrite), .if_id_register_rs(if_id_instruction[25:21]),.if_id_registerrt(if_id_instruction[20:16]),.forward_a(forward_a), .forward_b(forward_b),.forward_c(forward_c), .forward_d(forward_d));
	stall_for_lw_control stall_for_lw_control1 (.id_ex_registerrt(id_ex_registerrt), .if_id_register_rs(if_id_instruction[25:21]), .if_id_registerrt(if_id_instruction[20:16]), .id_ex_memread(id_ex_memread), .pcwrite(pcwrite), .if_id_write(if_id_write), .id_flush_lwstall(id_flush_lwstall));
	branch_and_jump_hazard_control branch_and_jump_hazard_control1 (.mem_pcsrc(pcsrc), .if_flush(if_flush), .id_flush_branch(id_flush_branch), .ex_flush(ex_flush));
	// ssd Display
	divide_by_100k clock500HZ (.clock(fastclk), .reset(reset), .clock_out(clkssd));
	divide_by_500  clock1HZ (.clock(clkssd), .reset(reset), .clock_out(clknormal));
	Ring_4_counter Ring_Counter (.clock(clkssd), .reset(reset), .q(an));
	ssd_driver	ssdtho (.in_bcd(tho), .out_ssd(thossd));
	ssd_driver	ssdhun (.in_bcd(hun), .out_ssd(hunssd));
	ssd_driver	ssdten (.in_bcd(ten), .out_ssd(tenssd));
	ssd_driver	ssdone (.in_bcd(one), .out_ssd(onessd));
	choose_cathode choose_cathode1 (.tho(thossd), .hun(hunssd), .ten(tenssd), .one(onessd), .an(an), .ca(cathode));

	assign clkrf = clkrf_reg;
	assign clk = clk_reg;
	assign multi_purpose_read_addr = multi_purpose_read_addr_reg;
	assign multi_purpose_regwrite = multi_purpose_regwrite_reg;
	assign tho = tho_reg;
	assign hun = hun_reg;
	assign ten = ten_reg;
	assign one = one_reg;

	always @(switch_run or clkssd) begin
		if (switch_run) begin
			// sys status 1: run pipeline_single_cycle processor
			clkrf_reg <= clknormal;		// 1 Hz
			clk_reg <= clknormal;		// 1 Hz
			multi_purpose_read_addr_reg <= if_id_instruction[25:21]; // reg-file-port1 reads from instruction
			// reg-file protection measure; explained in "else"
			multi_purpose_regwrite_reg <= mem_wb_regwrite;
			// output pc to ssd, but since pc only has 6 bits
			tho_reg <= p_c_out_unsign_extended[15:12];	// always 0
			hun_reg <= p_c_out_unsign_extended[11:8];	// always 0
			ten_reg <= p_c_out_unsign_extended[7:4];
			one_reg <= p_c_out_unsign_extended[3:0];
		end
		else begin
			// sys status 2: pause processor; inspect reg file content
			clkrf_reg <= clkssd;	// 500 Hz
			clk_reg <= 1'b0;		// freeze at 0
			multi_purpose_read_addr_reg <= swith_select; // reg-file-port1 reads from swith_select
			// reg-file is not freezed in time, this protects against RF-data-overwrite
			multi_purpose_regwrite_reg <= 1'b0;
			// output reg file content to ssd, but only the lower 16 bits (we only have 4 ssd)
			tho_reg <= reg_read_data_1[15:12];
			hun_reg <= reg_read_data_1[11:8];
			ten_reg <= reg_read_data_1[7:4];
			one_reg <= reg_read_data_1[3:0];
		end
	end

endmodule
