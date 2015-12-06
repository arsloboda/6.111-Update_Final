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
    input clock,
    input ready,
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
	 
	 // TODO: USE FREQUENCY DATA TO CONTROL VOLUME INSIDE MIXER BUFFER, NOT MIXER ITSELF
	 // TODO: MAKE THIS SELECTABLE (E.G. DO OR DON'T BEAT VOLUME TO BASS ... 2 LOWEST FILTERS)
	 
	 assign fup = fupl;
	 assign fdown = fdownl;
	 
	 assign weight1 = weight1_l;
	 assign weight2 = weight2_l;
	 mixer mix_left(.audio_in1(audio_in_left1),.audio_in2(audio_in_left2),
					.ready(ready),.clock(clock),.reset(reset),
//					.freq1(freq1l),.freq2(freq2l),freq3(freq3l),.freq4(freq4l),
//					.freq5(freq5l),.freq6(freq6l),
					.controls(controls),.audio_out(audio_out_left),
					.weight1(weight1_l),.weight2(weight2_l),
					.fup(fupl),.fdown(fdownl));

	 mixer mix_right(.audio_in1(audio_in_right1),.audio_in2(audio_in_right2),
					.ready(ready),.clock(clock),.reset(reset),
//					.freq1(freq1r),.freq2(freq2r),freq3(freq3r),.freq4(freq4r),
//					.freq5(freq5r),.freq6(freq6r),
					.controls(controls),.audio_out(audio_out_right),
					.weight1(weight1_r),.weight2(weight2_r),
					.fup(fupr),.fdown(fdownr));

endmodule
