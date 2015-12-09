`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:57:15 12/01/2015 
// Design Name: 
// Module Name:    music_flash_memory 
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
module music_flash_memory(
    input clock,
    input reset,
    input ready,
//    input do_record,
//    input do_play,
    input [17:0] left_audio_in,
	 input [17:0] right_audio_in,
    input flash_sts,
    inout [15:0] flash_data,
    output [17:0] left_audio_out,
	 output [17:0] right_audio_out,
    output [23:0] flash_address,
    output flash_ce_b,
    output flash_oe_b,
    output flash_we_b,
    output flash_reset_b,
    output flash_byte_b,
	 output reg test,
	 output reg test2,
	 output reg do_record,
	 output reg do_play,
	 output reg writemode,
	 output [15:0] frdata
    );
	
//	reg do_record; // temporarily not inputs for debugging
//	reg do_play;// temporarily not inputs for debugging
	reg [18:0] test_counter; // temporarily for debugging
	reg [18:0] test_counter2;
	
	reg [22:0] memory_counter; // keep track of where I've written so that I can read it back

	//////////////////////////////////////////////////////////////////////
	/// store/read from flash data
	/// --> use code flash_manager.v provided in 6.111 tools to do so
	//////////////////////////////////////////////////////////////////////
//	reg writemode; // temporarily not input for debugging
	reg [15:0] wdata;
	reg dowrite;
	reg [22:0] raddr; // address of where we want to read from flash (playing from flash)
	//wire [15:0] frdata; // data output from flash that we want to play, need to add 2 LSBs
	reg doread; // tell flash to read from memory
	wire busy; // flash is busy, don't read/write when asserted
	wire [11:0] fsmstate; 
	
	//assign wdata = audio_in[17:2];
	//assign dowrite = do_record;
	
	reg [15:0] reg_left_audio_out;
	assign left_audio_out = {reg_left_audio_out,2'b0};
	assign right_audio_out = 18'b0; // temporary
	
	flash_manager flash(
			.clock(clock),.reset(reset),.writemode(writemode),.wdata(wdata),
			.dowrite(dowrite),.raddr(raddr),.frdata(frdata),.doread(doread),
			.busy(busy),.flash_data(flash_data), .flash_address(flash_address),
			.flash_ce_b(flash_ce_b),.flash_oe_b(flash_oe_b),.flash_we_b(flash_we_b),
			.flash_reset_b(flash_reset_b),.flash_sts(flash_sts),.flash_byte_b(flash_byte_b),
			.fsmstate(fsmstate)); 
	
	
	always @(posedge clock) begin
		if (reset) begin
			writemode <=1; // erase flash
			dowrite <= 0; // erase flash
			doread <= 0; // erase flash
			memory_counter <= 0; // erase flash
			wdata <= 0; // initial write data = 0
			raddr <= 0; // initial read address = 0
			test_counter <= 0;
			reg_left_audio_out <= 0;
		end
		else begin
			if (busy ==0) begin
				if (ready) begin
	//				dowrite <= 0; // assume not reading/writing sample, unless receive instruction otherwise
	//				doread <= 0;
	//			// debugging purposes
	//			
					if (test_counter < 19'd524000) begin
						test_counter <= test_counter +1;
						do_record <= 1;
						do_play <= 0;
						test <= 1;
						test2 <= 0;
					end
					
					else begin
						test <= 0;
						test2 <= 1;
						
						do_record <= 0;
						do_play <= 1;
					end
					
					if (do_record) begin
						//do_play <= 0;
						writemode <= 1;
						dowrite <= 1;
						doread <= 0;
						wdata <= left_audio_in[17:2];
						reg_left_audio_out <= 16'b0;
					end else if (do_play) begin 
						writemode <= 0;
						if (raddr == memory_counter) raddr <= 0;
						else raddr <= raddr + 1; 
						doread <= 1;
						dowrite <= 0;
						reg_left_audio_out <= frdata;
					end
				end
				// if not new data with read pulse
				else if (dowrite) begin
						dowrite <= 0;
						memory_counter <= memory_counter +1;
				end
				
				else if (doread) begin
//					if (busy == 0) begin
						doread <= 0;
//					end
				end
			end // end busy
		end
	end
	

endmodule
