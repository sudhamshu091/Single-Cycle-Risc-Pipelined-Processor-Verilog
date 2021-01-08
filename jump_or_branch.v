// all connections asynchronous; no clock signal is provided.
// this module is designed to merge branch(if taken) and jump instruction
// getting an output of pcsrc and a destintion pc address
module jump_or_branch (jump, branch_taken, branch_addr, jump_addr, pcsrc, addr_out);
	input jump, branch_taken; 
	input [31:0] branch_addr, jump_addr;
	output pcsrc;
	output [31:0] addr_out;
	reg [31:0] addr_out;
	reg pcsrc;
	// only one of jump or branch_taken can be true in mem in one cycle
	// so if jump is true, assign jump_addr to addr_out, and set pcsrc to 1
	// and if branch is true, assign branch_addr to addr_out, and set pcsrc to 1
	// if none of the two are true, set pcsrc to 0. addr_out could be whatever.
	always @(jump or branch_taken or branch_addr or jump_addr)
	begin
		if(branch_taken)
		begin addr_out<=branch_addr;pcsrc<=1; end
		else if (jump)
		begin addr_out<=jump_addr;pcsrc<=1;end
		else 
		begin pcsrc<=0; addr_out<=32'b0; end
	end
	
endmodule
