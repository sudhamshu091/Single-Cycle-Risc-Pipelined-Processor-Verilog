// this module flushes if/id, id/ex and ex/mem if branch or jump is determined viable at mem stage
//		we previously assumed branch NOT-taken, so 3 next instructions need to be flushed
//		we are pushing jump to mem stage because there might be a jump instruction right below our branch_not_taken assumption
//		so we need to wait for branch result to come out before executing jump
//		and of cou_rse because of the wait, all jump need to flush the next 3 instructions
// all connections are asynchronous; no clock signal is provided
module branch_and_jump_hazard_control (mem_pcsrc, if_flush, id_flush_branch, ex_flush);
	input mem_pcsrc; // the pcsrc generated in mem stage will be 1 if branch is taken or a jump instruction is detected at mem stage
	output if_flush, id_flush_branch, ex_flush;
	reg if_flush, id_flush_branch, ex_flush;
	always @(mem_pcsrc)
	begin
		if(mem_pcsrc)
		begin if_flush<=1; id_flush_branch<=1; ex_flush<=1; end
		else 
		begin if_flush<=0; id_flush_branch<=0; ex_flush<=0; end
	end
endmodule
