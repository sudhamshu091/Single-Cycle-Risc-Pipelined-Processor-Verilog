// forwarding unit
// all connections are asynchronous; no clock signal is provided
module forwarding_control (ex_mem_register_rd, mem_wb_register_rd, id_ex_register_rs, id_ex_registerrt, ex_mem_regwrite, mem_wb_regwrite,if_id_register_rs,if_id_registerrt, forward_a, forward_b, forward_c, forward_d);
	input [4:0] ex_mem_register_rd, mem_wb_register_rd, id_ex_register_rs, id_ex_registerrt,if_id_register_rs,if_id_registerrt;
	input ex_mem_regwrite, mem_wb_regwrite;
	output forward_c,forward_d;
	output [1:0] forward_a, forward_b;
	reg [1:0] forward_a, forward_b;
	reg forward_c,forward_d;
	wire equal_exmem__rs,equal_exmem_rt,equal_memwb__rs,equal_memwb_rt;
	wire nonzero_exmem_rd,nonzero_memwb_rd;
	assign nonzero_exmem_rd=(ex_mem_register_rd==0)?0:1;
	assign nonzero_memwb_rd=(mem_wb_register_rd==0)?0:1;
	assign equal_exmem__rs=(ex_mem_register_rd==id_ex_register_rs)?1:0;
	assign equal_exmem_rt=(ex_mem_register_rd==id_ex_registerrt)?1:0;
	assign equal_memwb__rs=(mem_wb_register_rd==id_ex_register_rs)?1:0;
	assign equal_memwb_rt=(mem_wb_register_rd==id_ex_registerrt)?1:0;
	assign equal_wb_id__rs=(mem_wb_register_rd==if_id_register_rs)?1:0;
	assign equal_wb_id_rt=(mem_wb_register_rd==if_id_registerrt)?1:0;
	always@ (ex_mem_regwrite or mem_wb_regwrite or nonzero_exmem_rd or nonzero_memwb_rd or equal_exmem__rs
	or equal_exmem_rt or equal_memwb__rs or equal_memwb_rt or equal_wb_id__rs or equal_wb_id_rt)
	begin
		if(ex_mem_regwrite & nonzero_exmem_rd & equal_exmem__rs)
			forward_a<=2'b10;
		else if (mem_wb_regwrite & nonzero_memwb_rd & equal_memwb__rs)
			forward_a<=2'b01;
		else 
			forward_a<=2'b00;
			
		if(ex_mem_regwrite & nonzero_exmem_rd & equal_exmem_rt)
			forward_b<=2'b10;
		else if (mem_wb_regwrite & nonzero_memwb_rd & equal_memwb_rt)
			forward_b<=2'b01;
		else 
			forward_b<=2'b00;
			
		if(mem_wb_regwrite & nonzero_memwb_rd & equal_wb_id__rs)
			forward_c<=1;
		else
			forward_c<=0;
			
      if(mem_wb_regwrite & nonzero_memwb_rd & equal_wb_id_rt)
			forward_d<=1;
		else
			forward_d<=0;
		
	end
endmodule
