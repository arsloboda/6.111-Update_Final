`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:32:40 11/09/2015 
// Design Name: 
// Module Name:    ProcessMod 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ProcessMod(
    input [17:0] l_audio_in,
	 input [17:0] r_audio_in,
    input ready,
    input clock,
    input reset,
    input [9:0] f_controls,
	 input [9:0] t_controls,
    output [17:0] l_audio_out,
	 output [17:0] r_audio_out,
    output [7:0] freq1,
    output [7:0] freq2,
    output [7:0] freq3,
    output [7:0] freq4,
    output [7:0] freq5,
    output [7:0] freq6,
    output [7:0] freq7
    );
	//Left and right audio out of frequency modules
	wire [17:0] l_audio_out_t;
	wire [17:0] r_audio_out_t;
	//Left frequency data out for all 7 bands
	wire [7:0] l_f_f1_out;
	wire [7:0] l_f_f2_out;
	wire [7:0] l_f_f3_out;
	wire [7:0] l_f_f4_out;
	wire [7:0] l_f_f5_out;
	wire [7:0] l_f_f6_out;
	wire [7:0] l_f_f7_out;
	//Right frequency data out for all 7 bands
	wire [7:0] r_f_f1_out;
	wire [7:0] r_f_f2_out;
	wire [7:0] r_f_f3_out;
	wire [7:0] r_f_f4_out;
	wire [7:0] r_f_f5_out;
	wire [7:0] r_f_f6_out;
	wire [7:0] r_f_f7_out;
	//Instantiate frequency modules for left and right channels
	FreqMod FreqL(.audio_in(l_audio_out_t),.ready(ready),.clock(clock),
						.reset(reset),.controls(f_controls),.audio_out(l_audio_out),
						.freq1(l_f_f1_out),.freq2(l_f_f2_out),.freq3(l_f_f3_out),
						.freq4(l_f_f4_out),.freq5(l_f_f5_out),.freq6(l_f_f6_out),
						.freq7(l_f_f7_out));
	FreqMod FreqR(.audio_in(r_audio_out_t),.ready(ready),.clock(clock),
						.reset(reset),.controls(f_controls),.audio_out(r_audio_out),
						.freq1(r_f_f1_out),.freq2(r_f_f2_out),.freq3(r_f_f3_out),
						.freq4(r_f_f4_out),.freq5(r_f_f5_out),.freq6(r_f_f6_out),
						.freq7(r_f_f7_out));
	//TBD outputting mixture of frequency data from left and right channels for mixer
	
	//Instantiate time modules for left and right channels
	TimeMod Time(.l_audio_in(l_audio_in),.r_audio_in(r_audio_in),.ready(ready),
					 .clock(clock),.reset(reset),.controls(t_controls),
					 .l_audio_out(l_audio_out_t),.r_audio_out(r_audio_out_t));

endmodule
