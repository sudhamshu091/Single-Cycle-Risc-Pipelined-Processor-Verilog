`timescale 1ns / 1ps

module pipeline_single_cycle_tb;

	reg fastclk;
	reg reset;
	reg [4:0] swith_select;
	reg switch_run;
	reg clkread;
	reg [31:0] reg_read_data_2,reg_read_data_3;
	integer count;


	// Outputs
	wire [31:0]reg_read_data_1;
		
	// Instantiate the Unit Under Test (UUT)
	pipeline_single_cycle uut (
		.fastclk(fastclk), 
		.reset(reset),
		.swith_select(swith_select),
		.switch_run(switch_run),
		.reg_read_data_1(reg_read_data_1));

	initial begin
		// Initialize Inputs
		count = 0;
		fastclk = 0;
		reset = 1;
		switch_run = 0;
		swith_select = 5'd0;
		clkread = 0;
		#4 reset=0;
		#10000;
		#50 $stop;
	end

	always begin #1 fastclk=~fastclk; end
	always begin #320 clkread = ~clkread; end 
	
	always @(posedge clkread)
	begin
	
			#10	$display ("Time: %d [clk]= 1", count);
	  			swith_select = 5'd16;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd17;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd18;
	  		#10 $display ("[$s0] = %h [$s1] = %h [$s2] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);
			
	  			swith_select = 5'd19;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd20;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd21;
	  		#10 $display ("[$s3] = %h [$s4] = %h [$s5] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd22;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd23;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd8;
	  		#10 $display ("[$s6] = %h [$s7] = %h [$t0] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd9;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd10;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd11;
	  		#10 $display ("[$t1] = %h [$t2] = %h [$t3] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd12;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd13;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd14;
	  		#10 $display ("[$t4] = %h [$t5] = %h [$t6] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd15;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd24;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd25;
	  		#10 $display ("[$t7] = %h [$t8] = %h [$t9] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);
		
			
			#2 switch_run = 1;
			#32 switch_run = 0;
					
	end
	
		always @(negedge clkread)
	begin
	
			#10	$display ("Time: %d [clk]= 0", count);
	  			swith_select = 5'd16;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd17;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd18;
	  		#10 $display ("[$s0] = %h [$s1] = %h [$s2] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);
			
	  			swith_select = 5'd19;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd20;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd21;
	  		#10 $display ("[$s3] = %h [$s4] = %h [$s5] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd22;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd23;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd8;
	  		#10 $display ("[$s6] = %h [$s7] = %h [$t0] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd9;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd10;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd11;
	  		#10 $display ("[$t1] = %h [$t2] = %h [$t3] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd12;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd13;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd14;
	  		#10 $display ("[$t4] = %h [$t5] = %h [$t6] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);

	  			swith_select = 5'd15;
			#10 reg_read_data_3=reg_read_data_1;
				swith_select = 5'd24;
			#10 reg_read_data_2=reg_read_data_1;		
				swith_select = 5'd25;
	  		#10 $display ("[$t7] = %h [$t8] = %h [$t9] = %h ", reg_read_data_3, reg_read_data_2, reg_read_data_1);
		
			
			#2 switch_run = 1;
			#32 switch_run = 0;
			count = count + 1;				
	end
endmodule

