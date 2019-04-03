//output
module InvAddRoundKey ( input	logic	[127:0] ARK_INPUT,
								input	logic	[1407:0]	keySchedule,
								input	logic [3:0] count,
								output logic	[127:0] ARK_Out);

		logic [127:0] RoundKey;
		always_comb
		begin
			case (count)
				4'b0000:
					RoundKey = keySchedule[127:0];
				4'b0001:
					RoundKey = keySchedule[255:128];
				4'b0010:
					RoundKey = keySchedule[383:256];
				4'b0011:
					RoundKey = keySchedule[511:384];
				4'b0100:
					RoundKey = keySchedule[639:512];
				4'b0101:
					RoundKey = keySchedule[767:640];
				4'b0110:
					RoundKey = keySchedule[895:768];
				4'b0111:
					RoundKey = keySchedule[1023:896];
				4'b1000:
					RoundKey = keySchedule[1151:1024];
				4'b1001:
					RoundKey = keySchedule[1279:1152];
				4'b1010:
					RoundKey = keySchedule[1407:1280];
				default:
					RoundKey = 128'b0;
			endcase
		end
		assign ARK_Out = ARK_INPUT ^ RoundKey;
endmodule