// async control signal generation unit based on opcode
// input: 6 bits opcode
// output: all 1 bit except aluop which is 2-bits wide
module control (opcode, reg_dest, jump, branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
	input [5:0] opcode;
	output reg_dest, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite;
	output [1:0] aluop;

	assign reg_dest=(~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]);//000000
	assign jump=(~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(~opcode[0]);//000010
	assign branch=(~opcode[5])&(~opcode[4])&(~opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]);//000100
	assign memread=(opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]);//100011
	assign memtoreg=(opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]);//100011
	assign memwrite=(opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]);//101011
	assign alusrc=((~opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0])) | ((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0])) | ((opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0])) | (((opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]))); //001000,001100,100011,101011
	assign regwrite=(~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]) | ((~opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0])) | ((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0])) | ((opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]));//000000,001000,001100,100011
	assign aluop[1]=((~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]))|((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]));//000000, 001100(andi)
	assign aluop[0]= ((~opcode[5])&(~opcode[4])&(~opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]))|((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]));//000100,001100(andi)
endmodule
