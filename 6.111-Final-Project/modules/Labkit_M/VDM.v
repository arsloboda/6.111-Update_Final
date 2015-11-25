`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:13 11/23/2015 
// Design Name: 
// Module Name:    VDM 
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
module VDM(
    input [47:0] f_data,
	 input [17:0] a_data,
	 input clock,
    input ready,
    input reset,
	 input controls,
    output [29:0] lights
    );
	 wire [20:0] average;
	 reg [30:0] out=0;
	 reg [5:0] audio=0;
	 reg [5:0] count=0;
	 reg [5:0] a1[31:0];
	 always@(posedge clock) begin
		if (reset) begin
			audio<=0;
			out<=31'b100_0000_0000_0000_0000_0000_0000_0000;
			count<=0;
		end else if (ready) begin
			if(count==6'b11_0000) begin
				count<=0;
				out<=31'b100_0000_0000_0000_0000_0000_0000_0000;
				audio<=average[5:0];
				if (~a_data[17]) begin
					a1[0]<=a_data[16:11];
					a1[1]<=a1[0];
					a1[2]<=a1[1];
					a1[3]<=a1[2];
					a1[4]<=a1[3];
					a1[5]<=a1[4];
					a1[6]<=a1[5];
					a1[7]<=a1[6];
					a1[8]<=a1[7];
					a1[9]<=a1[8];
					a1[10]<=a1[9];
					a1[11]<=a1[10];
					a1[12]<=a1[11];
					a1[13]<=a1[12];
					a1[14]<=a1[13];
					a1[15]<=a1[14];
					a1[16]<=a1[15];
					a1[17]<=a1[16];
					a1[18]<=a1[17];
					a1[19]<=a1[18];
					a1[20]<=a1[19];
					a1[21]<=a1[20];
					a1[22]<=a1[21];
					a1[23]<=a1[22];
					a1[24]<=a1[23];
					a1[25]<=a1[24];
					a1[26]<=a1[25];
					a1[27]<=a1[26];
					a1[28]<=a1[27];
					a1[29]<=a1[28];
					a1[30]<=a1[29];
					a1[31]<=a1[30];
					
				end
			end else begin
				count<=count+1;
			end
		end else begin
			if(audio>1) begin
				audio<=audio-1;
				out<=(out>>1)+31'b100_0000_0000_0000_0000_0000_0000_0000;
			end
		end
	 end
	 assign average = (a1[0]+a1[1]+a1[2]+a1[3]+a1[4]+a1[5]+a1[6]+
							a1[7]+a1[8]+a1[9]+a1[10]+a1[11]+a1[12]+a1[13]
							+a1[14]+a1[15]+a1[16]+a1[17]+a1[18]+a1[19]
							+a1[20]+a1[21]+a1[22]+a1[23]+a1[24]+a1[25]
							+a1[26]+a1[27]+a1[28]+a1[29]+a1[30]+a1[31])>>4;
	 assign lights=out[29:0];
endmodule
