// load word causes pipeline_single_cycle with ex/mem -> ex forwarding scheme to stall for one cycle
// all connections asynchronous; no clock signal is provided.
// In this module we are concerned with outputting 3 stall signals (don't care about the one cycle).
// at next rising edge, id_ex_memread will be flushed to 0, this module will automatically stop stalling.
//
// stalling condition could be found in "stall_for_lw_control code" attached in email
// how to stall the pipeline_single_cycle:
//		1. set pcwrite and if_id_write to 0
//		2. set id_flush_lwstall to 1 (modified from textbook mux solution; now we feed this signal to id/ex stage register)
// Important: if stalling condition is not met, set all 3 signals to the opposite value!
module stall_for_lw_control (id_ex_registerrt, if_id_register_rs, if_id_registerrt, id_ex_memread, pcwrite, if_id_write, id_flush_lwstall);
	input [4:0] id_ex_registerrt, if_id_register_rs, if_id_registerrt;
	input id_ex_memread;
	output pcwrite, if_id_write, id_flush_lwstall;
	wire equal_idexrt_ifid_rs,equal_idexrt_ifidrt;
	assign equal_idexrt_ifid_rs=(id_ex_registerrt==if_id_register_rs)?1:0;
	assign equal_idexrt_ifidrt=(id_ex_registerrt==if_id_registerrt)?1:0;
	reg pcwrite, if_id_write, id_flush_lwstall;
	
	always@(id_ex_memread or equal_idexrt_ifid_rs or equal_idexrt_ifidrt)
	begin
		if(id_ex_memread & (equal_idexrt_ifid_rs|equal_idexrt_ifidrt))
		begin pcwrite<=0;if_id_write<=0;id_flush_lwstall<=1; end
		else 
		begin pcwrite<=1;if_id_write<=1;id_flush_lwstall<=0; end
	end
endmodule
