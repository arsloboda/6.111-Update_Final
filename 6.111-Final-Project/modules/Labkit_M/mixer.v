`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:11:01 12/02/2015 
// Design Name: 
// Module Name:    mixer 
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
module mixer(
    input signed [17:0] audio_in1,
    input signed [17:0] audio_in2,
    input ready,
    input clock,
    input reset,
    input [9:0] controls,
	 input wire signed [7:0] freq1,
	 input wire signed [7:0] freq2,
	 input wire signed [7:0] freq3,
	 input wire signed [7:0] freq4,
	 input wire signed [7:0] freq5,
	 input wire signed [7:0] freq6,
    output wire signed[17:0] audio_out,
    output reg [4:0] weight1,
    output reg [4:0] weight2,
	 output fup,
	 output fdown
    );
	 
	parameter MAX_WEIGHT = 5'd31;
	wire [7:0] switches = controls[7:0];
//	wire fup = controls[8];
//	wire fdown = controls[9];	
	assign fup = controls[8];
	assign fdown = controls[9];	
	
	wire signed [17:0] mixed_audio;
	reg signed [22:0] reg_mixed_audio;
	reg signed [22:0] weighted_audio1;
	reg signed [22:0] weighted_audio2;
	reg signed [22:0] a2_by_volume_a1bass = 0;
	reg signed [22:0] volume_audio2bass = 0;
	reg signed [22:0] a2_by_volume_a1 = 5'd16;
	reg signed [22:0] a1_by_volume_a2 = 5'd16;
	reg [4:0] audio1_vcontrol = 1;
	reg [4:0] audio2_vcontrol = 1;
	reg [4:0] freq1_vcontrol = 1;
	reg [9:0] counter = 0;
	
	reg signed [17:0] reg_audio_out;
	assign audio_out = reg_audio_out;
	assign mixed_audio = reg_mixed_audio[22:5];
//	assign audio_out = audio_in1; // test pass through
	
	wire signed [17:0] wire_weighted_audio1;
	wire signed [17:0] wire_weighted_audio2;
	wire signed [17:0] wire_a2_by_volume_a1;
	wire signed [17:0] wire_a1_by_volume_a2;
	wire signed [17:0] wire_a2_by_volume_a1bass;
//	wire signed [17:0] wire_volume_audio2bass;
	
	assign wire_weighted_audio1 = weighted_audio1[22:5];
	assign wire_weighted_audio2 = weighted_audio2[22:5];
	assign wire_a2_by_volume_a1bass = a2_by_volume_a1bass[22:5];
//	assign wire_volume_audio2bass = volume_audio2bass[22:5];
	assign wire_a2_by_volume_a1 = a2_by_volume_a1[22:5];
	assign wire_a1_by_volume_a2 = a1_by_volume_a2[22:5];
	
	reg old_fup=0; // used for edge detection
	reg old_fdown=0; // used for edge detection

	always @(posedge clock) begin
		if (reset) begin
			old_fup <= 0;
			old_fdown <= 0;
//			weight1 <= 5'd1;
//			weight2 <= 5'd1;
			weight1 <= 5'd16; // centered
			weight2 <= 5'd31-weight1;
			counter <= 0;
		end
	
		else begin
			weight2 <= 5'd31-weight1;
			weighted_audio1 <= weight1*audio_in1;
			weighted_audio2 <= weight2*audio_in2;
			reg_mixed_audio <= weighted_audio1 + weighted_audio2;
			a2_by_volume_a1 <= 2*audio1_vcontrol*audio_in2;
			a1_by_volume_a2 <= 2*audio2_vcontrol*audio_in1;
			a2_by_volume_a1bass <= 2*freq1_vcontrol*audio_in2;
			
			if (ready) counter <= counter + 1;
			
			if (counter == 0) begin
				if(audio_in1[17] == 0) begin
					if (audio_in1[16:12] > 5'd8) begin
						audio1_vcontrol <= audio_in1[16:12];
					end
					else audio1_vcontrol <= 5'd8;
				end
				
				if(audio_in2[17] == 0) begin
					if (audio_in2[16:12] > 5'd8) begin
						audio2_vcontrol <= audio_in2[16:12];
					end
					else audio2_vcontrol <= 5'd8;
				end
				
				if(freq1[7] == 0) begin
					if (freq1[6:2] > 5'd8) begin
						freq1_vcontrol <= freq1[6:2];
					end
					else freq1_vcontrol <= 5'd8;
				end
			end
			
			if (fup & ~old_fup & (weight1 != 5'd31)) weight1 <= weight1+1;       
			if (fdown & ~old_fdown & (weight1 != 5'd0)) weight1 <= weight1-1;     
			old_fup <= fup;
			old_fdown <= fdown;
			
		end
		
	end
	


	always@(*) begin
		case(switches)
			8'b0000_0001: reg_audio_out = wire_weighted_audio1; 
			8'b0000_0010: reg_audio_out = wire_weighted_audio2;
			8'b0000_0100: reg_audio_out = wire_a1_by_volume_a2;
			8'b0000_1000: reg_audio_out = wire_a2_by_volume_a1;
			8'b0001_0000: reg_audio_out = wire_a2_by_volume_a1bass;
			default: reg_audio_out = mixed_audio; 
		endcase
	end

endmodule
