`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:20:32 11/09/2015 
// Design Name: 
// Module Name:    FreqMod 
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
module FreqMod(
    input signed [17:0] audio_in, // I made this signed
    input ready,
    input clock, // 27MHz clock 
    input reset,
    input [9:0] controls,
    output wire signed [17:0] audio_out, // I made this signed
    output wire [7:0] freq1,
    output wire [7:0] freq2,
    output wire [7:0] freq3,
    output wire [7:0] freq4,
    output wire [7:0] freq5,
    output wire [7:0] freq6,
    output wire [7:0] freq7,
	 output wire [4:0] weight1,
	 output wire [4:0] weight2,
	 output wire [4:0] weight3,
	 output wire [4:0] weight4,
	 output wire [4:0] weight5,
	 output wire [4:0] weight6,
	 output wire [4:0] weight7
    );
	
	wire [7:0] switches = controls[7:0];
	wire fup = controls[8];
	wire fdown = controls[9];

	wire signed [17:0] full_freq_allpass;
	wire signed [17:0] full_freq1;
	wire signed [17:0] full_freq2;
	wire signed [17:0] full_freq3;
	wire signed [17:0] full_freq4;
	wire signed [17:0] full_freq5;
	wire signed [17:0] full_freq6;
	wire signed [17:0] full_freq7;
	
	wire signed [17:0] equalizer_output;
	wire signed[17:0] weighted_freq1;
	wire signed[17:0] weighted_freq2;
	wire signed[17:0] weighted_freq3;
	wire signed[17:0] weighted_freq4;
	wire signed[17:0] weighted_freq5;
	wire signed[17:0] weighted_freq6;
	wire signed[17:0] weighted_freq_allpass;
		
	
	assign freq1 = weighted_freq1[17:10];
	assign freq2 = weighted_freq2[17:10];
	assign freq3 = weighted_freq3[17:10];
	assign freq4 = weighted_freq4[17:10];
	assign freq5 = weighted_freq5[17:10];
	assign freq6 = weighted_freq6[17:10];
	assign freq7 = weighted_freq_allpass[17:10];
	
	wire signed [9:0] coeff_allpass;
	wire signed [9:0] coeff1;
	wire signed [9:0] coeff2;
	wire signed [9:0] coeff3;
	wire signed [9:0] coeff4;
	wire signed [9:0] coeff5;
	wire signed [9:0] coeff6;
//	wire signed [9:0] coeff7;
	
	wire [7:0] index_allpass;
	wire [8:0] index1;
	wire [8:0] index2;
	wire [8:0] index3;
	wire [8:0] index4;
	wire [8:0] index5;
	wire [8:0] index6;
//	wire [8:0] index7;
	
///////////////////////////////////////////////////////////////////////
// instantiate coefficients
	
	coeffs_replay coeffs_allpass (.index(index_allpass),.coeff(coeff_allpass));
	coeffs400tap_below120Hz coeffs1 (.index(index1),.coeff(coeff1));
	coeffs400tap_120_260Hz coeffs2 (.index(index2),.coeff(coeff2));
	coeffs400tap_260_600Hz coeffs3 (.index(index3),.coeff(coeff3));
//	coeffs400tap_test coeffs3 (.index(index3),.coeff(coeff3)); // test go through all coeffs
	coeffs400tap_600_1200Hz coeffs4 (.index(index4),.coeff(coeff4)); 
	coeffs400tap_1200_4kHz coeffs5 (.index(index5),.coeff(coeff5)); 
	coeffs400tap_above_4kHz coeffs6 (.index(index6),.coeff(coeff6)); 


///////////////////////////////////////////////////////////////////////
// instantiate filters

	fir_programmable filter_allpass (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff_allpass),
					.x(audio_in),.y(full_freq_allpass),.index(index_allpass));
	
	fir400 filter1 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff1),
					.x(audio_in),.y(full_freq1),.index(index1));
	
	fir400 filter2 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff2),
					.x(audio_in),.y(full_freq2),.index(index2));

	fir400 filter3 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff3),
					.x(audio_in),.y(full_freq3),.index(index3));

	fir400 filter4 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff4),
					.x(audio_in),.y(full_freq4),.index(index4));
	
	fir400 filter5 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff5),
					.x(audio_in),.y(full_freq5),.index(index5));
	
	fir400 filter6 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff6),
					.x(audio_in),.y(full_freq6),.index(index6));
	
	
//	fir400 filter1 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff1),
//					.x(audio_in),.y(full_freq1),.index(index1));
	
//	fir31 filter2 (.clock(clock),.reset(reset),.ready(ready),.coeff(coeff2),
//					.x(audio_in),.y(full_freq2),.index(index2));
	
//	fir_test filter_test(.clock(clock),.reset(reset),.ready(ready),.x(audio_in),.y(full_freq3));

////////////////////////////////////////////////////////////////////////


//wire [4:0] weight1;
equalizer equalize(.ready(ready),.clock(clock),.reset(reset),
					.controls(controls),.audio_allpass(full_freq_allpass),
					.full_freq1(full_freq1),.full_freq2(full_freq2),.full_freq3(full_freq3),
					.full_freq4(full_freq4),.full_freq5(full_freq5),.full_freq6(full_freq6),
					.full_freq7(full_freq_allpass),.audio_out(equalizer_output),
					.weight1(weight1),.weight2(weight2),.weight3(weight3),
					.weight4(weight4),.weight5(weight5),.weight6(weight6),.weight7(weight7),
					.weighted_freq1(weighted_freq1),.weighted_freq2(weighted_freq2),
					.weighted_freq3(weighted_freq3),.weighted_freq4(weighted_freq4),
					.weighted_freq5(weighted_freq5),.weighted_freq6(weighted_freq6),
					.weighted_freq7(weighted_freq_allpass));

///////////////////////////////////////////////////////////////////////
// controls
	
	reg signed [17:0] reg_audio_out;
	assign audio_out = reg_audio_out;
	always@(*) begin
//		if(reset) begin
//			reg_audio_out=18'b00_0000_0000_0000_0000;	
//		end
		case(switches)
			8'b0000_0001: reg_audio_out = weighted_freq1; // no filter applied
//			8'd2: reg_audio_out = (full_freq1*2)+full_freq_allpass; // boost the bass?
			8'b0000_0010: reg_audio_out = weighted_freq2;
			8'b0000_0100: reg_audio_out = weighted_freq3;
			8'b0000_1000: reg_audio_out = weighted_freq4;
			8'b0001_0000: reg_audio_out = weighted_freq5;
			8'b0010_0000: reg_audio_out = weighted_freq6;
//			8'b0100_0000: reg_audio_out = full_freq_allpass;
			8'b0100_0000: reg_audio_out = weighted_freq_allpass;
			default: reg_audio_out = equalizer_output; // all pass applied
		endcase
	end

endmodule
/////////////////////////////////////////////////////////////////////
// set default of all frequency weights to zero except for the audio_allpass
// maybe want some parameters? (e.g. initial weight values??)

// currently all weights are positive, but should probably go negative as well?
module equalizer (
    input ready,
    input clock, // 27MHz clock 
    input reset,
	 input [9:0] controls,
    input wire [17:0] audio_allpass,
    input wire [17:0] full_freq1,
    input wire [17:0] full_freq2,
    input wire [17:0] full_freq3,
    input wire [17:0] full_freq4,
    input wire [17:0] full_freq5,
    input wire [17:0] full_freq6,
	 input wire [17:0] full_freq7,
	 
	 output wire signed [17:0] audio_out, // I made this signed,
	 output reg [4:0] weight1, // output to hex display for debugging
	 output reg [4:0] weight2,
	 output reg [4:0] weight3,
	 output reg [4:0] weight4,
	 output reg [4:0] weight5,
	 output reg [4:0] weight6,
	 output reg [4:0] weight7,
	 output reg signed[17:0] weighted_freq1,
	 output reg signed[17:0] weighted_freq2,
	 output reg signed[17:0] weighted_freq3,
	 output reg signed[17:0] weighted_freq4,
	 output reg signed[17:0] weighted_freq5,
	 output reg signed[17:0] weighted_freq6,
	 output reg signed[17:0] weighted_freq7
);

	reg signed [17:0] reg_audio_out;
	assign audio_out = reg_audio_out;

	wire [7:0] switches = controls[7:0];
	
	wire fup = controls[8];
	wire fdown = controls[9];
	reg old_fup=0; // used for edge detection
	reg old_fdown=0; // used for edge detection
	reg increment = 0;
	reg decrement = 0;
	
	reg [8:0] current_frequency_band;
	reg [4:0] weight_allpass;
//	reg [4:0] weight1;
//	reg [4:0] weight2;
//	reg [4:0] weight3;
//	reg [4:0] weight4;
//	reg [4:0] weight5;
//	reg [4:0] weight6;

//	reg signed[17:0] weighted_freq1;
//	reg signed[17:0] weighted_freq2;
//	reg signed[17:0] weighted_freq3;
//	reg signed[17:0] weighted_freq4;
//	reg signed[17:0] weighted_freq5;
//	reg signed[17:0] weighted_freq6;



	always @ (posedge clock) begin
		if (reset) begin
			old_fup <= 0;
			old_fdown <= 0;
			weight_allpass <= 5'd24;
			weight1 <= 5'd0;
			weight2 <= 5'd0;
			weight3 <= 5'd0;
			weight4 <= 5'd0;
			weight5 <= 5'd0;
			weight6 <= 5'd0;
			weight7 <= 5'd0;
		end

		else begin
			weighted_freq1 <= weight1*full_freq1;
			weighted_freq2 <= weight2*full_freq2;
			weighted_freq3 <= weight3*full_freq3;
			weighted_freq4 <= weight4*full_freq4;
			weighted_freq5 <= weight5*full_freq5;
			weighted_freq6 <= weight6*full_freq6;
			weighted_freq7 <= weight7*full_freq7; // all pass, don't add to reg_audio_out

			reg_audio_out <= audio_allpass+weighted_freq1+weighted_freq2+weighted_freq3
									+weighted_freq4+weighted_freq5+weighted_freq6;

			if(switches[0]) begin
				if (increment & weight1 != 5'd31) weight1 <= weight1+1;       
				if (decrement & weight1 != 5'd0) weight1 <= weight1-1;       
			end
			
			if(switches[1]) begin
				if (increment & weight2 != 5'd31) weight2 <= weight2+1;       
				if (decrement & weight2 != 5'd0) weight2 <= weight2-1;       
			end			

			if(switches[2]) begin
				if (increment & weight3 != 5'd31) weight3 <= weight3+1;       
				if (decrement & weight3 != 5'd0) weight3 <= weight3-1;       
			end		

			if(switches[3]) begin
				if (increment & weight4 != 5'd31) weight4 <= weight4+1;       
				if (decrement & weight4 != 5'd0) weight4 <= weight4-1;       
			end	

			if(switches[4]) begin
				if (increment & weight5 != 5'd31) weight5 <= weight5+1;       
				if (decrement & weight5 != 5'd0) weight5 <= weight5-1;       
			end	
			
			if(switches[5]) begin
				if (increment & weight6 != 5'd31) weight6 <= weight6+1;       
				if (decrement & weight6 != 5'd0) weight6 <= weight6-1;       
			end	

			if(switches[6]) begin
				if (increment & weight7 != 5'd31) weight7 <= weight7+1;       
				if (decrement & weight7 != 5'd0) weight7 <= weight7-1;       
			end	

		end
		increment <= 0;
		decrement <= 0;
		if (fup & ~old_fup) increment <= 1;       
		if (fdown & ~old_fdown) decrement <= 1;  
//		if (fup & ~old_fup & (weight1 != 5'd31)) weight1 <= weight1+1;       
//		if (fdown & ~old_fdown & (weight1 != 5'd0)) weight1 <= weight1-1;       
		old_fup <= fup;
		old_fdown <= fdown;
   end
	
	

endmodule

