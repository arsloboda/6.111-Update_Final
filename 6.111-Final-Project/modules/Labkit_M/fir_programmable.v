`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:05:07 11/20/2015 
// Design Name: 
// Module Name:    fir_programmable 
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

module fir_programmable( // DEFINITELY need 27 MHz clock to handle 48 kHz, and be able to handle each new sample in our own project
  input wire clock,reset,ready,
  input wire signed [9:0] coeff,
  input wire signed [17:0] x,
  output wire signed [17:0] y,
  output reg [7:0] index
);

	reg signed [17:0] audio_out;
	assign y = audio_out;
	reg signed [27:0] accumulator; 
	reg signed [17:0] sample [255:0];  // 32 element array each 8 bits wide
	reg [7:0] offset = 0; // increment offset with each sample to always point to the newest sample
	//reg [4:0] index = 0;
	// carefully chose sample width, offset, & index to be powers of 2 to handle circular counting
//	wire signed [9:0] coeff;
//	coeffs31 coeffs(.index(index),.coeff(coeff));
	
	always @(posedge clock) begin
		//audio_out <= x; // MAKE SURE THIS STILL WORKS AS IS
		if (reset == 1) begin
			accumulator <= 0;
			index <= 0;
			offset <= 0;
		end
		else if (ready == 1) begin //essentially, reset accumulator to begin calculations
			accumulator <= 0;
			offset <= offset +1; 
			index <= 0;
			//audio_out <= x;
			sample[(offset+1) & 5'b1111_1] <= x;
			// need to rotate through pointer in sample reg to pick appropriate sample to add
		end
//		
		else if (index<255) begin // perform filter multiplication and addition over 32 cycles
			accumulator <= accumulator + coeff*sample[(offset-index)& 5'b1111_1]; // delay 1
			index <= index + 1;
			//audio_out <= x;
		end
		else begin
			//audio_out <= x;
			audio_out <= accumulator[27:10];
		end
		
	end
endmodule


//
//module fir_programmable(
//  input wire clock,reset,ready,
//  input wire signed [9:0] coeff,
//  input wire signed [17:0] x,
//  output wire signed [17:0] y,
//  output reg [4:0] index
//    );
//
//
//	reg signed [17:0] audio_out;
//	assign y = audio_out;
//	reg signed [27:0] accumulator; 
//	reg signed [17:0] sample [255:0];  // 255 element array each 18 bits wide
//	reg [7:0] offset = 0; // 255 samples
//
//	
//	always @(posedge clock) begin
//		//if (ready) y <= x; // test audio in, audio out
//		if (reset == 1) begin
//			accumulator <= 0;
//			index <= 0;
//			audio_out <= 0;
//			offset <= 0;
//		end
//		else if (ready == 1) begin //essentially, reset accumulator to begin calculations
//			//audio_out <= x;
//			accumulator <= 0;
//			offset <= offset +1; 
//			index <= 0;
//			sample[offset+1] <= x;
//			// need to rotate through pointer in sample reg to pick appropriate sample to add
//		end
////		
//		else if (index<31) begin // perform filter multiplication and addition over 32 cycles
//			accumulator <= accumulator + coeff*sample[offset-index]; // delay 1
//			index <= index + 1;
//			//audio_out <= x;
//		end
//		else begin
//				audio_out <= accumulator[17:0];
//				//audio_out <= x;
//		end
//		
//	end
//endmodule
//	


module coeffs_replay(
  input wire [7:0] index,
  output reg signed [9:0] coeff
);
  // tools will turn this into a 41x10 ROM
  always @(index)
    case (index)
	 
		8'd0:  coeff = 10'sd511; 
		8'd1:  coeff = 10'sd0; 
		8'd2:  coeff = 10'sd0; 
		8'd3:  coeff = 10'sd0; 
		8'd4:  coeff = 10'sd0; 
		8'd5:  coeff = 10'sd0; 
		8'd6:  coeff = 10'sd0; 
		8'd7:  coeff = 10'sd0; 
		8'd8:  coeff = 10'sd0; 
		8'd9:  coeff = 10'sd0; 
		8'd10:  coeff = 10'sd0; 
		8'd11:  coeff = 10'sd0; 
		8'd12:  coeff = 10'sd0; 
		8'd13:  coeff = 10'sd0; 
		8'd14:  coeff = 10'sd0; 
		8'd15:  coeff = 10'sd0; 
		8'd16:  coeff = 10'sd0; 
		8'd17:  coeff = 10'sd0; 
		8'd18:  coeff = 10'sd0; 
		8'd19:  coeff = 10'sd0; 
		8'd20:  coeff = 10'sd0; 
		8'd21:  coeff = 10'sd0; 
		8'd22:  coeff = 10'sd0; 
		8'd23:  coeff = 10'sd0; 
		8'd24:  coeff = 10'sd0; 
		8'd25:  coeff = 10'sd0; 
		8'd26:  coeff = 10'sd0; 
		8'd27:  coeff = 10'sd0; 
		8'd28:  coeff = 10'sd0; 
		8'd29:  coeff = 10'sd0; 
		8'd30:  coeff = 10'sd0; 
		8'd31:  coeff = 10'sd0; 
		8'd32:  coeff = 10'sd0; 
		8'd33:  coeff = 10'sd0; 
		8'd34:  coeff = 10'sd0; 
		8'd35:  coeff = 10'sd0; 
		8'd36:  coeff = 10'sd0; 
		8'd37:  coeff = 10'sd0; 
		8'd38:  coeff = 10'sd0; 
		8'd39:  coeff = 10'sd0; 
		8'd40:  coeff = 10'sd0; 
		8'd41:  coeff = 10'sd0; 
		8'd42:  coeff = 10'sd0; 
		8'd43:  coeff = 10'sd0; 
		8'd44:  coeff = 10'sd0; 
		8'd45:  coeff = 10'sd0; 
		8'd46:  coeff = 10'sd0; 
		8'd47:  coeff = 10'sd0; 
		8'd48:  coeff = 10'sd0; 
		8'd49:  coeff = 10'sd0; 
		8'd50:  coeff = 10'sd0; 
		8'd51:  coeff = 10'sd0; 
		8'd52:  coeff = 10'sd0; 
		8'd53:  coeff = 10'sd0; 
		8'd54:  coeff = 10'sd0; 
		8'd55:  coeff = 10'sd0; 
		8'd56:  coeff = 10'sd0; 
		8'd57:  coeff = 10'sd0; 
		8'd58:  coeff = 10'sd0; 
		8'd59:  coeff = 10'sd0; 
		8'd60:  coeff = 10'sd0; 
		8'd61:  coeff = 10'sd0; 
		8'd62:  coeff = 10'sd0; 
		8'd63:  coeff = 10'sd0; 
		8'd64:  coeff = 10'sd0; 
		8'd65:  coeff = 10'sd0; 
		8'd66:  coeff = 10'sd0; 
		8'd67:  coeff = 10'sd0; 
		8'd68:  coeff = 10'sd0; 
		8'd69:  coeff = 10'sd0; 
		8'd70:  coeff = 10'sd0; 
		8'd71:  coeff = 10'sd0; 
		8'd72:  coeff = 10'sd0; 
		8'd73:  coeff = 10'sd0; 
		8'd74:  coeff = 10'sd0; 
		8'd75:  coeff = 10'sd0; 
		8'd76:  coeff = 10'sd0; 
		8'd77:  coeff = 10'sd0; 
		8'd78:  coeff = 10'sd0; 
		8'd79:  coeff = 10'sd0; 
		8'd80:  coeff = 10'sd0; 
		8'd81:  coeff = 10'sd0; 
		8'd82:  coeff = 10'sd0; 
		8'd83:  coeff = 10'sd0; 
		8'd84:  coeff = 10'sd0; 
		8'd85:  coeff = 10'sd0; 
		8'd86:  coeff = 10'sd0; 
		8'd87:  coeff = 10'sd0; 
		8'd88:  coeff = 10'sd0; 
		8'd89:  coeff = 10'sd0; 
		8'd90:  coeff = 10'sd0; 
		8'd91:  coeff = 10'sd0; 
		8'd92:  coeff = 10'sd0; 
		8'd93:  coeff = 10'sd0; 
		8'd94:  coeff = 10'sd0; 
		8'd95:  coeff = 10'sd0; 
		8'd96:  coeff = 10'sd0; 
		8'd97:  coeff = 10'sd0; 
		8'd98:  coeff = 10'sd0; 
		8'd99:  coeff = 10'sd0; 
		8'd100:  coeff = 10'sd0; 
		8'd101:  coeff = 10'sd0; 
		8'd102:  coeff = 10'sd0; 
		8'd103:  coeff = 10'sd0; 
		8'd104:  coeff = 10'sd0; 
		8'd105:  coeff = 10'sd0; 
		8'd106:  coeff = 10'sd0; 
		8'd107:  coeff = 10'sd0; 
		8'd108:  coeff = 10'sd0; 
		8'd109:  coeff = 10'sd0; 
		8'd110:  coeff = 10'sd0; 
		8'd111:  coeff = 10'sd0; 
		8'd112:  coeff = 10'sd0; 
		8'd113:  coeff = 10'sd0; 
		8'd114:  coeff = 10'sd0; 
		8'd115:  coeff = 10'sd0; 
		8'd116:  coeff = 10'sd0; 
		8'd117:  coeff = 10'sd0; 
		8'd118:  coeff = 10'sd0; 
		8'd119:  coeff = 10'sd0; 
		8'd120:  coeff = 10'sd0; 
		8'd121:  coeff = 10'sd0; 
		8'd122:  coeff = 10'sd0; 
		8'd123:  coeff = 10'sd0; 
		8'd124:  coeff = 10'sd0; 
		8'd125:  coeff = 10'sd0; 
		8'd126:  coeff = 10'sd0; 
		8'd127:  coeff = 10'sd0; 
		8'd128:  coeff = 10'sd0; 
		8'd129:  coeff = 10'sd0; 
		8'd130:  coeff = 10'sd0; 
		8'd131:  coeff = 10'sd0; 
		8'd132:  coeff = 10'sd0; 
		8'd133:  coeff = 10'sd0; 
		8'd134:  coeff = 10'sd0; 
		8'd135:  coeff = 10'sd0; 
		8'd136:  coeff = 10'sd0; 
		8'd137:  coeff = 10'sd0; 
		8'd138:  coeff = 10'sd0; 
		8'd139:  coeff = 10'sd0; 
		8'd140:  coeff = 10'sd0; 
		8'd141:  coeff = 10'sd0; 
		8'd142:  coeff = 10'sd0; 
		8'd143:  coeff = 10'sd0; 
		8'd144:  coeff = 10'sd0; 
		8'd145:  coeff = 10'sd0; 
		8'd146:  coeff = 10'sd0; 
		8'd147:  coeff = 10'sd0; 
		8'd148:  coeff = 10'sd0; 
		8'd149:  coeff = 10'sd0; 
		8'd150:  coeff = 10'sd0; 
		8'd151:  coeff = 10'sd0; 
		8'd152:  coeff = 10'sd0; 
		8'd153:  coeff = 10'sd0; 
		8'd154:  coeff = 10'sd0; 
		8'd155:  coeff = 10'sd0; 
		8'd156:  coeff = 10'sd0; 
		8'd157:  coeff = 10'sd0; 
		8'd158:  coeff = 10'sd0; 
		8'd159:  coeff = 10'sd0; 
		8'd160:  coeff = 10'sd0; 
		8'd161:  coeff = 10'sd0; 
		8'd162:  coeff = 10'sd0; 
		8'd163:  coeff = 10'sd0; 
		8'd164:  coeff = 10'sd0; 
		8'd165:  coeff = 10'sd0; 
		8'd166:  coeff = 10'sd0; 
		8'd167:  coeff = 10'sd0; 
		8'd168:  coeff = 10'sd0; 
		8'd169:  coeff = 10'sd0; 
		8'd170:  coeff = 10'sd0; 
		8'd171:  coeff = 10'sd0; 
		8'd172:  coeff = 10'sd0; 
		8'd173:  coeff = 10'sd0; 
		8'd174:  coeff = 10'sd0; 
		8'd175:  coeff = 10'sd0; 
		8'd176:  coeff = 10'sd0; 
		8'd177:  coeff = 10'sd0; 
		8'd178:  coeff = 10'sd0; 
		8'd179:  coeff = 10'sd0; 
		8'd180:  coeff = 10'sd0; 
		8'd181:  coeff = 10'sd0; 
		8'd182:  coeff = 10'sd0; 
		8'd183:  coeff = 10'sd0; 
		8'd184:  coeff = 10'sd0; 
		8'd185:  coeff = 10'sd0; 
		8'd186:  coeff = 10'sd0; 
		8'd187:  coeff = 10'sd0; 
		8'd188:  coeff = 10'sd0; 
		8'd189:  coeff = 10'sd0; 
		8'd190:  coeff = 10'sd0; 
		8'd191:  coeff = 10'sd0; 
		8'd192:  coeff = 10'sd0; 
		8'd193:  coeff = 10'sd0; 
		8'd194:  coeff = 10'sd0; 
		8'd195:  coeff = 10'sd0; 
		8'd196:  coeff = 10'sd0; 
		8'd197:  coeff = 10'sd0; 
		8'd198:  coeff = 10'sd0; 
		8'd199:  coeff = 10'sd0; 
		8'd200:  coeff = 10'sd0; 
		8'd201:  coeff = 10'sd0; 
		8'd202:  coeff = 10'sd0; 
		8'd203:  coeff = 10'sd0; 
		8'd204:  coeff = 10'sd0; 
		8'd205:  coeff = 10'sd0; 
		8'd206:  coeff = 10'sd0; 
		8'd207:  coeff = 10'sd0; 
		8'd208:  coeff = 10'sd0; 
		8'd209:  coeff = 10'sd0; 
		8'd210:  coeff = 10'sd0; 
		8'd211:  coeff = 10'sd0; 
		8'd212:  coeff = 10'sd0; 
		8'd213:  coeff = 10'sd0; 
		8'd214:  coeff = 10'sd0; 
		8'd215:  coeff = 10'sd0; 
		8'd216:  coeff = 10'sd0; 
		8'd217:  coeff = 10'sd0; 
		8'd218:  coeff = 10'sd0; 
		8'd219:  coeff = 10'sd0; 
		8'd220:  coeff = 10'sd0; 
		8'd221:  coeff = 10'sd0; 
		8'd222:  coeff = 10'sd0; 
		8'd223:  coeff = 10'sd0; 
		8'd224:  coeff = 10'sd0; 
		8'd225:  coeff = 10'sd0; 
		8'd226:  coeff = 10'sd0; 
		8'd227:  coeff = 10'sd0; 
		8'd228:  coeff = 10'sd0; 
		8'd229:  coeff = 10'sd0; 
		8'd230:  coeff = 10'sd0; 
		8'd231:  coeff = 10'sd0; 
		8'd232:  coeff = 10'sd0; 
		8'd233:  coeff = 10'sd0; 
		8'd234:  coeff = 10'sd0; 
		8'd235:  coeff = 10'sd0; 
		8'd236:  coeff = 10'sd0; 
		8'd237:  coeff = 10'sd0; 
		8'd238:  coeff = 10'sd0; 
		8'd239:  coeff = 10'sd0; 
		8'd240:  coeff = 10'sd0; 
		8'd241:  coeff = 10'sd0; 
		8'd242:  coeff = 10'sd0; 
		8'd243:  coeff = 10'sd0; 
		8'd244:  coeff = 10'sd0; 
		8'd245:  coeff = 10'sd0; 
		8'd246:  coeff = 10'sd0; 
		8'd247:  coeff = 10'sd0; 
		8'd248:  coeff = 10'sd0; 
		8'd249:  coeff = 10'sd0; 
		8'd250:  coeff = 10'sd0; 
		8'd251:  coeff = 10'sd0; 
		8'd252:  coeff = 10'sd0; 
		8'd253:  coeff = 10'sd0; 
		8'd254:  coeff = 10'sd0; 
      default: coeff = 10'hXXX;
    endcase
endmodule


module coeffs255tap_below180( // gonna be a problem cuz can only do up to 511 absolute value with 10 bits
  input wire [5:0] index,
  output reg signed [9:0] coeff
);

  // tools will turn this into a 41x10 ROM
  always @(index)
    case (index)

		8'd0:  coeff = 10'sd0; 
		8'd1:  coeff = 10'sd0; 
		8'd2:  coeff = 10'sd0; 
		8'd3:  coeff = 10'sd0; 
		8'd4:  coeff = 10'sd0; 
		8'd5:  coeff = 10'sd0; 
		8'd6:  coeff = 10'sd0; 
		8'd7:  coeff = 10'sd0; 
		8'd8:  coeff = 10'sd0; 
		8'd9:  coeff = 10'sd0; 
		8'd10:  coeff = 10'sd0; 
		8'd11:  coeff = 10'sd0; 
		8'd12:  coeff = 10'sd0; 
		8'd13:  coeff = 10'sd0; 
		8'd14:  coeff = 10'sd0; 
		8'd15:  coeff = 10'sd0; 
		8'd16:  coeff = 10'sd0; 
		8'd17:  coeff = 10'sd0; 
		8'd18:  coeff = 10'sd0; 
		8'd19:  coeff = 10'sd0; 
		8'd20:  coeff = 10'sd0; 
		8'd21:  coeff = 10'sd0; 
		8'd22:  coeff = 10'sd0; 
		8'd23:  coeff = 10'sd0; 
		8'd24:  coeff = 10'sd0; 
		8'd25:  coeff = 10'sd0; 
		8'd26:  coeff = 10'sd0; 
		8'd27:  coeff = 10'sd0; 
		8'd28:  coeff = 10'sd0; 
		8'd29:  coeff = 10'sd0; 
		8'd30:  coeff = 10'sd0; 
		8'd31:  coeff = 10'sd0; 
		8'd32:  coeff = 10'sd0; 
		8'd33:  coeff = 10'sd0; 
		8'd34:  coeff = 10'sd0; 
		8'd35:  coeff = 10'sd0; 
		8'd36:  coeff = 10'sd0; 
		8'd37:  coeff = 10'sd0; 
		8'd38:  coeff = 10'sd0; 
		8'd39:  coeff = 10'sd0; 
		8'd40:  coeff = 10'sd0; 
		8'd41:  coeff = 10'sd0; 
		8'd42:  coeff = 10'sd0; 
		8'd43:  coeff = 10'sd0; 
		8'd44:  coeff = 10'sd0; 
		8'd45:  coeff = 10'sd0; 
		8'd46:  coeff = 10'sd1; 
		8'd47:  coeff = 10'sd1; 
		8'd48:  coeff = 10'sd1; 
		8'd49:  coeff = 10'sd1; 
		8'd50:  coeff = 10'sd1; 
		8'd51:  coeff = 10'sd1; 
		8'd52:  coeff = 10'sd1; 
		8'd53:  coeff = 10'sd1; 
		8'd54:  coeff = 10'sd1; 
		8'd55:  coeff = 10'sd1; 
		8'd56:  coeff = 10'sd1; 
		8'd57:  coeff = 10'sd1; 
		8'd58:  coeff = 10'sd1; 
		8'd59:  coeff = 10'sd1; 
		8'd60:  coeff = 10'sd2; 
		8'd61:  coeff = 10'sd2; 
		8'd62:  coeff = 10'sd2; 
		8'd63:  coeff = 10'sd2; 
		8'd64:  coeff = 10'sd2; 
		8'd65:  coeff = 10'sd2; 
		8'd66:  coeff = 10'sd2; 
		8'd67:  coeff = 10'sd2; 
		8'd68:  coeff = 10'sd3; 
		8'd69:  coeff = 10'sd3; 
		8'd70:  coeff = 10'sd3; 
		8'd71:  coeff = 10'sd3; 
		8'd72:  coeff = 10'sd3; 
		8'd73:  coeff = 10'sd3; 
		8'd74:  coeff = 10'sd4; 
		8'd75:  coeff = 10'sd4; 
		8'd76:  coeff = 10'sd4; 
		8'd77:  coeff = 10'sd4; 
		8'd78:  coeff = 10'sd4; 
		8'd79:  coeff = 10'sd4; 
		8'd80:  coeff = 10'sd5; 
		8'd81:  coeff = 10'sd5; 
		8'd82:  coeff = 10'sd5; 
		8'd83:  coeff = 10'sd5; 
		8'd84:  coeff = 10'sd5; 
		8'd85:  coeff = 10'sd6; 
		8'd86:  coeff = 10'sd6; 
		8'd87:  coeff = 10'sd6; 
		8'd88:  coeff = 10'sd6; 
		8'd89:  coeff = 10'sd7; 
		8'd90:  coeff = 10'sd7; 
		8'd91:  coeff = 10'sd7; 
		8'd92:  coeff = 10'sd7; 
		8'd93:  coeff = 10'sd7; 
		8'd94:  coeff = 10'sd8; 
		8'd95:  coeff = 10'sd8; 
		8'd96:  coeff = 10'sd8; 
		8'd97:  coeff = 10'sd8; 
		8'd98:  coeff = 10'sd9; 
		8'd99:  coeff = 10'sd9; 
		8'd100:  coeff = 10'sd9; 
		8'd101:  coeff = 10'sd9; 
		8'd102:  coeff = 10'sd9; 
		8'd103:  coeff = 10'sd10; 
		8'd104:  coeff = 10'sd10; 
		8'd105:  coeff = 10'sd10; 
		8'd106:  coeff = 10'sd10; 
		8'd107:  coeff = 10'sd10; 
		8'd108:  coeff = 10'sd10; 
		8'd109:  coeff = 10'sd11; 
		8'd110:  coeff = 10'sd11; 
		8'd111:  coeff = 10'sd11; 
		8'd112:  coeff = 10'sd11; 
		8'd113:  coeff = 10'sd11; 
		8'd114:  coeff = 10'sd11; 
		8'd115:  coeff = 10'sd12; 
		8'd116:  coeff = 10'sd12; 
		8'd117:  coeff = 10'sd12; 
		8'd118:  coeff = 10'sd12; 
		8'd119:  coeff = 10'sd12; 
		8'd120:  coeff = 10'sd12; 
		8'd121:  coeff = 10'sd12; 
		8'd122:  coeff = 10'sd12; 
		8'd123:  coeff = 10'sd12; 
		8'd124:  coeff = 10'sd12; 
		8'd125:  coeff = 10'sd12; 
		8'd126:  coeff = 10'sd12; 
		8'd127:  coeff = 10'sd12; 
		8'd128:  coeff = 10'sd12; 
		8'd129:  coeff = 10'sd12; 
		8'd130:  coeff = 10'sd12; 
		8'd131:  coeff = 10'sd12; 
		8'd132:  coeff = 10'sd12; 
		8'd133:  coeff = 10'sd12; 
		8'd134:  coeff = 10'sd12; 
		8'd135:  coeff = 10'sd12; 
		8'd136:  coeff = 10'sd12; 
		8'd137:  coeff = 10'sd12; 
		8'd138:  coeff = 10'sd12; 
		8'd139:  coeff = 10'sd12; 
		8'd140:  coeff = 10'sd11; 
		8'd141:  coeff = 10'sd11; 
		8'd142:  coeff = 10'sd11; 
		8'd143:  coeff = 10'sd11; 
		8'd144:  coeff = 10'sd11; 
		8'd145:  coeff = 10'sd11; 
		8'd146:  coeff = 10'sd10; 
		8'd147:  coeff = 10'sd10; 
		8'd148:  coeff = 10'sd10; 
		8'd149:  coeff = 10'sd10; 
		8'd150:  coeff = 10'sd10; 
		8'd151:  coeff = 10'sd10; 
		8'd152:  coeff = 10'sd9; 
		8'd153:  coeff = 10'sd9; 
		8'd154:  coeff = 10'sd9; 
		8'd155:  coeff = 10'sd9; 
		8'd156:  coeff = 10'sd9; 
		8'd157:  coeff = 10'sd8; 
		8'd158:  coeff = 10'sd8; 
		8'd159:  coeff = 10'sd8; 
		8'd160:  coeff = 10'sd8; 
		8'd161:  coeff = 10'sd7; 
		8'd162:  coeff = 10'sd7; 
		8'd163:  coeff = 10'sd7; 
		8'd164:  coeff = 10'sd7; 
		8'd165:  coeff = 10'sd7; 
		8'd166:  coeff = 10'sd6; 
		8'd167:  coeff = 10'sd6; 
		8'd168:  coeff = 10'sd6; 
		8'd169:  coeff = 10'sd6; 
		8'd170:  coeff = 10'sd5; 
		8'd171:  coeff = 10'sd5; 
		8'd172:  coeff = 10'sd5; 
		8'd173:  coeff = 10'sd5; 
		8'd174:  coeff = 10'sd5; 
		8'd175:  coeff = 10'sd4; 
		8'd176:  coeff = 10'sd4; 
		8'd177:  coeff = 10'sd4; 
		8'd178:  coeff = 10'sd4; 
		8'd179:  coeff = 10'sd4; 
		8'd180:  coeff = 10'sd4; 
		8'd181:  coeff = 10'sd3; 
		8'd182:  coeff = 10'sd3; 
		8'd183:  coeff = 10'sd3; 
		8'd184:  coeff = 10'sd3; 
		8'd185:  coeff = 10'sd3; 
		8'd186:  coeff = 10'sd3; 
		8'd187:  coeff = 10'sd2; 
		8'd188:  coeff = 10'sd2; 
		8'd189:  coeff = 10'sd2; 
		8'd190:  coeff = 10'sd2; 
		8'd191:  coeff = 10'sd2; 
		8'd192:  coeff = 10'sd2; 
		8'd193:  coeff = 10'sd2; 
		8'd194:  coeff = 10'sd2; 
		8'd195:  coeff = 10'sd1; 
		8'd196:  coeff = 10'sd1; 
		8'd197:  coeff = 10'sd1; 
		8'd198:  coeff = 10'sd1; 
		8'd199:  coeff = 10'sd1; 
		8'd200:  coeff = 10'sd1; 
		8'd201:  coeff = 10'sd1; 
		8'd202:  coeff = 10'sd1; 
		8'd203:  coeff = 10'sd1; 
		8'd204:  coeff = 10'sd1; 
		8'd205:  coeff = 10'sd1; 
		8'd206:  coeff = 10'sd1; 
		8'd207:  coeff = 10'sd1; 
		8'd208:  coeff = 10'sd1; 
		8'd209:  coeff = 10'sd0; 
		8'd210:  coeff = 10'sd0; 
		8'd211:  coeff = 10'sd0; 
		8'd212:  coeff = 10'sd0; 
		8'd213:  coeff = 10'sd0; 
		8'd214:  coeff = 10'sd0; 
		8'd215:  coeff = 10'sd0; 
		8'd216:  coeff = 10'sd0; 
		8'd217:  coeff = 10'sd0; 
		8'd218:  coeff = 10'sd0; 
		8'd219:  coeff = 10'sd0; 
		8'd220:  coeff = 10'sd0; 
		8'd221:  coeff = 10'sd0; 
		8'd222:  coeff = 10'sd0; 
		8'd223:  coeff = 10'sd0; 
		8'd224:  coeff = 10'sd0; 
		8'd225:  coeff = 10'sd0; 
		8'd226:  coeff = 10'sd0; 
		8'd227:  coeff = 10'sd0; 
		8'd228:  coeff = 10'sd0; 
		8'd229:  coeff = 10'sd0; 
		8'd230:  coeff = 10'sd0; 
		8'd231:  coeff = 10'sd0; 
		8'd232:  coeff = 10'sd0; 
		8'd233:  coeff = 10'sd0; 
		8'd234:  coeff = 10'sd0; 
		8'd235:  coeff = 10'sd0; 
		8'd236:  coeff = 10'sd0; 
		8'd237:  coeff = 10'sd0; 
		8'd238:  coeff = 10'sd0; 
		8'd239:  coeff = 10'sd0; 
		8'd240:  coeff = 10'sd0; 
		8'd241:  coeff = 10'sd0; 
		8'd242:  coeff = 10'sd0; 
		8'd243:  coeff = 10'sd0; 
		8'd244:  coeff = 10'sd0; 
		8'd245:  coeff = 10'sd0; 
		8'd246:  coeff = 10'sd0; 
		8'd247:  coeff = 10'sd0; 
		8'd248:  coeff = 10'sd0; 
		8'd249:  coeff = 10'sd0; 
		8'd250:  coeff = 10'sd0; 
		8'd251:  coeff = 10'sd0; 
		8'd252:  coeff = 10'sd0; 
		8'd253:  coeff = 10'sd0; 
		8'd254:  coeff = 10'sd0; 

      default: coeff = 10'hXXX;
    endcase
endmodule

module coeffs255tap_allpass( // gonna be a problem cuz can only do up to 511 absolute value with 10 bits
  input wire [5:0] index,
  output reg signed [9:0] coeff
);
  // tools will turn this into a 41x10 ROM
  always @(index)
    case (index)
	 
		9'd0:  coeff = 10'sd0; 
		9'd1:  coeff = 10'sd0; 
		9'd2:  coeff = 10'sd0; 
		9'd3:  coeff = 10'sd0; 
		9'd4:  coeff = 10'sd0; 
		9'd5:  coeff = 10'sd0; 
		9'd6:  coeff = 10'sd0; 
		9'd7:  coeff = 10'sd0; 
		9'd8:  coeff = 10'sd0; 
		9'd9:  coeff = 10'sd0; 
		9'd10:  coeff = 10'sd0; 
		9'd11:  coeff = 10'sd0; 
		9'd12:  coeff = 10'sd0; 
		9'd13:  coeff = 10'sd0; 
		9'd14:  coeff = 10'sd0; 
		9'd15:  coeff = 10'sd0; 
		9'd16:  coeff = 10'sd0; 
		9'd17:  coeff = 10'sd0; 
		9'd18:  coeff = 10'sd0; 
		9'd19:  coeff = 10'sd0; 
		9'd20:  coeff = 10'sd0; 
		9'd21:  coeff = 10'sd0; 
		9'd22:  coeff = 10'sd0; 
		9'd23:  coeff = 10'sd0; 
		9'd24:  coeff = 10'sd0; 
		9'd25:  coeff = 10'sd0; 
		9'd26:  coeff = 10'sd0; 
		9'd27:  coeff = 10'sd0; 
		9'd28:  coeff = 10'sd0; 
		9'd29:  coeff = 10'sd0; 
		9'd30:  coeff = 10'sd0; 
		9'd31:  coeff = 10'sd0; 
		9'd32:  coeff = 10'sd0; 
		9'd33:  coeff = 10'sd0; 
		9'd34:  coeff = 10'sd0; 
		9'd35:  coeff = 10'sd0; 
		9'd36:  coeff = 10'sd0; 
		9'd37:  coeff = 10'sd0; 
		9'd38:  coeff = 10'sd0; 
		9'd39:  coeff = 10'sd0; 
		9'd40:  coeff = 10'sd0; 
		9'd41:  coeff = 10'sd0; 
		9'd42:  coeff = 10'sd0; 
		9'd43:  coeff = 10'sd0; 
		9'd44:  coeff = 10'sd0; 
		9'd45:  coeff = 10'sd0; 
		9'd46:  coeff = 10'sd0; 
		9'd47:  coeff = 10'sd0; 
		9'd48:  coeff = 10'sd0; 
		9'd49:  coeff = 10'sd0; 
		9'd50:  coeff = 10'sd0; 
		9'd51:  coeff = 10'sd0; 
		9'd52:  coeff = 10'sd0; 
		9'd53:  coeff = 10'sd0; 
		9'd54:  coeff = -10'sd1; 
		9'd55:  coeff = 10'sd1; 
		9'd56:  coeff = -10'sd1; 
		9'd57:  coeff = 10'sd1; 
		9'd58:  coeff = -10'sd1; 
		9'd59:  coeff = 10'sd1; 
		9'd60:  coeff = -10'sd1; 
		9'd61:  coeff = 10'sd1; 
		9'd62:  coeff = -10'sd1; 
		9'd63:  coeff = 10'sd1; 
		9'd64:  coeff = -10'sd1; 
		9'd65:  coeff = 10'sd0; 
		9'd66:  coeff = 10'sd0; 
		9'd67:  coeff = 10'sd0; 
		9'd68:  coeff = 10'sd0; 
		9'd69:  coeff = -10'sd1; 
		9'd70:  coeff = 10'sd1; 
		9'd71:  coeff = -10'sd1; 
		9'd72:  coeff = 10'sd1; 
		9'd73:  coeff = -10'sd2; 
		9'd74:  coeff = 10'sd2; 
		9'd75:  coeff = -10'sd2; 
		9'd76:  coeff = 10'sd3; 
		9'd77:  coeff = -10'sd3; 
		9'd78:  coeff = 10'sd3; 
		9'd79:  coeff = -10'sd3; 
		9'd80:  coeff = 10'sd3; 
		9'd81:  coeff = -10'sd3; 
		9'd82:  coeff = 10'sd3; 
		9'd83:  coeff = -10'sd2; 
		9'd84:  coeff = 10'sd2; 
		9'd85:  coeff = -10'sd1; 
		9'd86:  coeff = 10'sd1; 
		9'd87:  coeff = 10'sd0; 
		9'd88:  coeff = -10'sd1; 
		9'd89:  coeff = 10'sd2; 
		9'd90:  coeff = -10'sd3; 
		9'd91:  coeff = 10'sd3; 
		9'd92:  coeff = -10'sd4; 
		9'd93:  coeff = 10'sd5; 
		9'd94:  coeff = -10'sd6; 
		9'd95:  coeff = 10'sd7; 
		9'd96:  coeff = -10'sd8; 
		9'd97:  coeff = 10'sd8; 
		9'd98:  coeff = -10'sd8; 
		9'd99:  coeff = 10'sd9; 
		9'd100:  coeff = -10'sd8; 
		9'd101:  coeff = 10'sd8; 
		9'd102:  coeff = -10'sd7; 
		9'd103:  coeff = 10'sd7; 
		9'd104:  coeff = -10'sd5; 
		9'd105:  coeff = 10'sd4; 
		9'd106:  coeff = -10'sd2; 
		9'd107:  coeff = 10'sd0; 
		9'd108:  coeff = 10'sd2; 
		9'd109:  coeff = -10'sd5; 
		9'd110:  coeff = 10'sd8; 
		9'd111:  coeff = -10'sd11; 
		9'd112:  coeff = 10'sd14; 
		9'd113:  coeff = -10'sd18; 
		9'd114:  coeff = 10'sd21; 
		9'd115:  coeff = -10'sd25; 
		9'd116:  coeff = 10'sd28; 
		9'd117:  coeff = -10'sd32; 
		9'd118:  coeff = 10'sd35; 
		9'd119:  coeff = -10'sd38; 
		9'd120:  coeff = 10'sd41; 
		9'd121:  coeff = -10'sd43; 
		9'd122:  coeff = 10'sd46; 
		9'd123:  coeff = -10'sd48; 
		9'd124:  coeff = 10'sd49; 
		9'd125:  coeff = -10'sd50; 
		9'd126:  coeff = 10'sd51; 
		9'd127:  coeff = 10'sd973; 
		9'd128:  coeff = 10'sd51; 
		9'd129:  coeff = -10'sd50; 
		9'd130:  coeff = 10'sd49; 
		9'd131:  coeff = -10'sd48; 
		9'd132:  coeff = 10'sd46; 
		9'd133:  coeff = -10'sd43; 
		9'd134:  coeff = 10'sd41; 
		9'd135:  coeff = -10'sd38; 
		9'd136:  coeff = 10'sd35; 
		9'd137:  coeff = -10'sd32; 
		9'd138:  coeff = 10'sd28; 
		9'd139:  coeff = -10'sd25; 
		9'd140:  coeff = 10'sd21; 
		9'd141:  coeff = -10'sd18; 
		9'd142:  coeff = 10'sd14; 
		9'd143:  coeff = -10'sd11; 
		9'd144:  coeff = 10'sd8; 
		9'd145:  coeff = -10'sd5; 
		9'd146:  coeff = 10'sd2; 
		9'd147:  coeff = 10'sd0; 
		9'd148:  coeff = -10'sd2; 
		9'd149:  coeff = 10'sd4; 
		9'd150:  coeff = -10'sd5; 
		9'd151:  coeff = 10'sd7; 
		9'd152:  coeff = -10'sd7; 
		9'd153:  coeff = 10'sd8; 
		9'd154:  coeff = -10'sd8; 
		9'd155:  coeff = 10'sd9; 
		9'd156:  coeff = -10'sd8; 
		9'd157:  coeff = 10'sd8; 
		9'd158:  coeff = -10'sd8; 
		9'd159:  coeff = 10'sd7; 
		9'd160:  coeff = -10'sd6; 
		9'd161:  coeff = 10'sd5; 
		9'd162:  coeff = -10'sd4; 
		9'd163:  coeff = 10'sd3; 
		9'd164:  coeff = -10'sd3; 
		9'd165:  coeff = 10'sd2; 
		9'd166:  coeff = -10'sd1; 
		9'd167:  coeff = 10'sd0; 
		9'd168:  coeff = 10'sd1; 
		9'd169:  coeff = -10'sd1; 
		9'd170:  coeff = 10'sd2; 
		9'd171:  coeff = -10'sd2; 
		9'd172:  coeff = 10'sd3; 
		9'd173:  coeff = -10'sd3; 
		9'd174:  coeff = 10'sd3; 
		9'd175:  coeff = -10'sd3; 
		9'd176:  coeff = 10'sd3; 
		9'd177:  coeff = -10'sd3; 
		9'd178:  coeff = 10'sd3; 
		9'd179:  coeff = -10'sd2; 
		9'd180:  coeff = 10'sd2; 
		9'd181:  coeff = -10'sd2; 
		9'd182:  coeff = 10'sd1; 
		9'd183:  coeff = -10'sd1; 
		9'd184:  coeff = 10'sd1; 
		9'd185:  coeff = -10'sd1; 
		9'd186:  coeff = 10'sd0; 
		9'd187:  coeff = 10'sd0; 
		9'd188:  coeff = 10'sd0; 
		9'd189:  coeff = 10'sd0; 
		9'd190:  coeff = -10'sd1; 
		9'd191:  coeff = 10'sd1; 
		9'd192:  coeff = -10'sd1; 
		9'd193:  coeff = 10'sd1; 
		9'd194:  coeff = -10'sd1; 
		9'd195:  coeff = 10'sd1; 
		9'd196:  coeff = -10'sd1; 
		9'd197:  coeff = 10'sd1; 
		9'd198:  coeff = -10'sd1; 
		9'd199:  coeff = 10'sd1; 
		9'd200:  coeff = -10'sd1; 
		9'd201:  coeff = 10'sd0; 
		9'd202:  coeff = 10'sd0; 
		9'd203:  coeff = 10'sd0; 
		9'd204:  coeff = 10'sd0; 
		9'd205:  coeff = 10'sd0; 
		9'd206:  coeff = 10'sd0; 
		9'd207:  coeff = 10'sd0; 
		9'd208:  coeff = 10'sd0; 
		9'd209:  coeff = 10'sd0; 
		9'd210:  coeff = 10'sd0; 
		9'd211:  coeff = 10'sd0; 
		9'd212:  coeff = 10'sd0; 
		9'd213:  coeff = 10'sd0; 
		9'd214:  coeff = 10'sd0; 
		9'd215:  coeff = 10'sd0; 
		9'd216:  coeff = 10'sd0; 
		9'd217:  coeff = 10'sd0; 
		9'd218:  coeff = 10'sd0; 
		9'd219:  coeff = 10'sd0; 
		9'd220:  coeff = 10'sd0; 
		9'd221:  coeff = 10'sd0; 
		9'd222:  coeff = 10'sd0; 
		9'd223:  coeff = 10'sd0; 
		9'd224:  coeff = 10'sd0; 
		9'd225:  coeff = 10'sd0; 
		9'd226:  coeff = 10'sd0; 
		9'd227:  coeff = 10'sd0; 
		9'd228:  coeff = 10'sd0; 
		9'd229:  coeff = 10'sd0; 
		9'd230:  coeff = 10'sd0; 
		9'd231:  coeff = 10'sd0; 
		9'd232:  coeff = 10'sd0; 
		9'd233:  coeff = 10'sd0; 
		9'd234:  coeff = 10'sd0; 
		9'd235:  coeff = 10'sd0; 
		9'd236:  coeff = 10'sd0; 
		9'd237:  coeff = 10'sd0; 
		9'd238:  coeff = 10'sd0; 
		9'd239:  coeff = 10'sd0; 
		9'd240:  coeff = 10'sd0; 
		9'd241:  coeff = 10'sd0; 
		9'd242:  coeff = 10'sd0; 
		9'd243:  coeff = 10'sd0; 
		9'd244:  coeff = 10'sd0; 
		9'd245:  coeff = 10'sd0; 
		9'd246:  coeff = 10'sd0; 
		9'd247:  coeff = 10'sd0; 
		9'd248:  coeff = 10'sd0; 
		9'd249:  coeff = 10'sd0; 
		9'd250:  coeff = 10'sd0; 
		9'd251:  coeff = 10'sd0; 
		9'd252:  coeff = 10'sd0; 
		9'd253:  coeff = 10'sd0; 
		9'd254:  coeff = 10'sd0;
	 
      default: coeff = 10'hXXX;
    endcase
endmodule
