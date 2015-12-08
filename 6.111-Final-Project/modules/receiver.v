module receiver(
    input clock_in,
	 input reset,
    input [11:0] l_audio_in,
    input [11:0] r_audio_in,
    output [17:0] l_audio_out,
    output [17:0] r_audio_out
    );
        //Buffer audio variables
	 reg [17:0] l_audio_out_n=0;
	 reg [17:0] r_audio_out_n=0;
	//At the negedge of the transmitter ready signal, take data input
	always@(negedge clock_in) begin
		if(reset) begin
			l_audio_out_n<=0;
			r_audio_out_n<=0;
		//Place audio in buffer, replacing bottom 6 bits with top sign bit
		//to reduce noise
		end else begin
			l_audio_out_n<={l_audio_in,{6{l_audio_in[11]}}};
			r_audio_out_n<={r_audio_in,{6{r_audio_in[11]}}};
		end
	end
	//Continously assign buffered audio to output variables
	assign l_audio_out=l_audio_out_n;
	assign r_audio_out=r_audio_out_n;
	
endmodule
