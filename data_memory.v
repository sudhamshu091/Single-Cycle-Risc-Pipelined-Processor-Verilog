// rising edge sync-write, async-read D-mem
// height: 64, width: 32 bits (from document "Project Two Specification (V3)")
// address input: 6 bits (64 == 2^6)
// data input/output: 32 bits
// write: on rising edge, when (memwrite == 1)
// read: asynchronous, when (memread == 1)
module data_memory (addr, write_data, read_data, clk, reset, memread, memwrite);
	input [7:0] addr;
	input [31:0] write_data;
	output [31:0] read_data;
	input clk, reset, memread, memwrite;
	reg [31:0] Dmemory [63:0];
	integer k;
	wire [5:0] shifted_addr;
	assign shifted_addr=addr[7:2];
	assign read_data = (memread) ? Dmemory[shifted_addr] : 32'bx;

	always @(posedge clk or posedge reset)// Ou modifies reset to posedge
	begin
		if (reset == 1'b1) 
			begin
				for (k=0; k<64; k=k+1) begin
					Dmemory[k] = 32'b0;
				end

			end
		else
			if (memwrite) Dmemory[shifted_addr] = write_data;
	end
endmodule
