`timescale 1ns / 1ps
module TimeMod(
    input signed [17:0] l_audio_in,
	 input signed [17:0] r_audio_in,
    input ready,
    input clock,
    input reset,
    input [9:0] controls,
    output signed [17:0] l_audio_out,
	 output signed [17:0] r_audio_out
    );
    //Echo variables
	wire e_d;
	wire e_u;
	reg old_e_d =0;
	reg old_e_u =0;
	//Output of BRAM 
	wire signed [17:0] l_echo_out;
	wire signed [17:0] r_echo_out;
	//Echo signal being applied to input
	reg signed [22:0] l_echo_effect=0;
	reg signed [22:0] r_echo_effect=0;
	//Contains either echo signal or all zeros, is added to input
	wire signed [17:0] l_effect;
	wire signed [17:0] r_effect;
	//Signal being added to output of BRAM, for 'reverse' echo
	wire signed [17:0] l_forward;
	wire signed [17:0] r_forward;
	//Final signal input into BRAM
	reg signed [17:0] l_echo_in=0;
	reg signed [17:0] r_echo_in=0;
	//Echo attenuation factor
	reg [4:0] echo_factor=5'd14;
	//Counters to implement delay
	reg [13:0] e_count=0;
	reg [13:0] old_e_count=0;
	//Write enable for BRAM
	reg wenable=0;
	//Control echo attenuation with L+R buttons
	assign e_d = controls[9];
	assign e_u = controls[8];
	echo echo75ms(.clka(clock),.clkb(clock),.dina({l_echo_in,r_echo_in}),
						.doutb({l_echo_out,r_echo_out}),.addra(old_e_count),
						.wea(wenable),.addrb(e_count));
	always@(posedge clock) begin
		if(reset) begin
			l_echo_in<=0;
			r_echo_in<=0;
			e_count<=0;
			wenable<=0;
			old_e_u<=0;
			old_e_d<=0;
			echo_factor<=5'd14;
		end
		else if(ready) begin
			e_count<=e_count+1;
			old_e_count<=e_count;
			l_echo_in<=(l_audio_in>>>1)+l_effect;
			r_echo_in<=(r_audio_in>>>1)+r_effect;
			wenable<=1;
			l_echo_effect <= (l_echo_out*echo_factor);
			r_echo_effect <= (r_echo_out*echo_factor);
		end
		else begin
			if (e_u & ~old_e_u & echo_factor != 5'd22) echo_factor <= echo_factor+1;       
			if (e_d & ~old_e_d & echo_factor != 5'd0) echo_factor <= echo_factor-1;       
			old_e_u <= e_u;
			old_e_d <= e_d;
			wenable<=0;
		end
	end
	assign l_effect = controls[0]? (l_echo_effect[22:5]):(18'b00_0000_0000_0000_0000);
	assign r_effect = controls[0]? (r_echo_effect[22:5]):(18'b00_0000_0000_0000_0000);
	assign l_forward = controls[1]? (l_echo_in>>>1):(18'b00_0000_0000_0000_0000);
	assign r_forward = controls[1]? (r_echo_in>>>1):(18'b00_0000_0000_0000_0000);
	assign l_audio_out=l_echo_out+l_forward;
	assign r_audio_out=r_echo_out+r_forward;
endmodule
