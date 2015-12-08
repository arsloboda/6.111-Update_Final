`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:44 12/04/2015 
// Design Name: 
// Module Name:    mixer_buffer 
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
module mixer_buffer(
    input clock, // 27 MHz clock
    input ready, // asserted with frequency of 48 kHz, receive new 18-bit audio on ready pulse
    input reset,
    input [17:0] audio_in_left1,
	 input [17:0] audio_in_left2,
    input [17:0] audio_in_right1,
	 input [17:0] audio_in_right2,
	 input [55:0] freq_data,
    output [17:0] audio_out_left,
    output [17:0] audio_out_right,
    input [9:0] controls,
    output [4:0] weight1,
    output [4:0] weight2,
	 output fup,
	 output fdown
    );
	 // 8 bits of frequency data from audio 1 input, used to control volume of audio 2 when selected
	 wire [7:0] freq1;
	 wire [7:0] freq2;
	 wire [7:0] freq3;
	 wire [7:0] freq4;
	 wire [7:0] freq5;
	 wire [7:0] freq6;
	 
	 wire [4:0] weight1_l;
	 wire [4:0] weight1_r;
	 wire [4:0] weight2_l;
	 wire [4:0] weight2_r;
	 
	 wire fupl;
	 wire fupr;
	 wire fdownl;
	 wire fdownr;
	 
	 assign freq1 = freq_data[7:0];
	 assign freq2 = freq_data[7:0];
	 assign freq3 = freq_data[7:0];
	 assign freq4 = freq_data[7:0];
	 assign freq5 = freq_data[7:0];
	 assign freq6 = freq_data[7:0];
	  
	 // left and right buttons used to control weights of mixed audio signals, uniform to both left and right audio
	 assign fup = fupl;
	 assign fdown = fdownl;
	 // weights of the mixed audio signals, uniform to both left and right audio
	 assign weight1 = weight1_l;
	 assign weight2 = weight2_l;
	 
	 // Instantiate mixer modules for both left and right stereo audio data.
	 mixer mix_left(.audio_in1(audio_in_left1),.audio_in2(audio_in_left2),
					.ready(ready),.clock(clock),.reset(reset),
					.freq1(freq1),.freq2(freq2),.freq3(freq3),.freq4(freq4),
					.freq5(freq5),.freq6(freq6),
					.controls(controls),.audio_out(audio_out_left),
					.weight1(weight1_l),.weight2(weight2_l),
					.fup(fupl),.fdown(fdownl));

	 mixer mix_right(.audio_in1(audio_in_right1),.audio_in2(audio_in_right2),
					.ready(ready),.clock(clock),.reset(reset),
					.freq1(freq1),.freq2(freq2),.freq3(freq3),.freq4(freq4),
					.freq5(freq5),.freq6(freq6),
					.controls(controls),.audio_out(audio_out_right),
					.weight1(weight1_r),.weight2(weight2_r),
					.fup(fupr),.fdown(fdownr));

endmodule
