`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:08 11/09/2015 
// Design Name: 
// Module Name:    HighLevelFSM 
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
module HighLevelFSM(
    input clock,
    input reset,
    input [14:0] controls,
    output reg [9:0] f_controls =0,
    output reg [9:0] t_controls =0,
	 output reg [10:0] status =0
    );
	 reg state=0;
	 reg t = 1;
	 reg f =0;
	 wire enter;
	 assign enter = controls[12];
	 reg [7:0] n_f_controls = 0;
	 reg [7:0] n_t_controls = 0;
	always@(posedge clock) begin
		if (reset) begin
			f_controls<=0;
			t_controls<=0;
			n_f_controls<=0;
			n_t_controls<=0;
			state<=0;
			status<=0;
		end else if(controls[11]) begin
			state<=f;
		end else if(controls[10]) begin
			state<=t;
		end else begin
			status[10]<=state;
			case(state)
				f:
					begin
						n_f_controls[7:0]<=controls[7:0];
						f_controls[9:8]<=controls[14:13];
						status[9:0]<=f_controls[9:0];
						if(enter) begin
							f_controls[7:0]<=n_f_controls[7:0];
						end
					end
				t:
					begin
						n_t_controls[7:0]<=controls[7:0];
						t_controls[9:8]<=controls[14:13];
						status[9:0]<=t_controls[9:0];
						if(enter) begin
							t_controls[7:0]<=n_t_controls[7:0];
						end
					end
			endcase
		end
	end	
endmodule
