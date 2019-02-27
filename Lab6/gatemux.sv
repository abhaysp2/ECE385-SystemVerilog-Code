module unique_mux (input logic [3:0] S,
						 input logic [15:0] PC, Adder, ALU, MDR,
						 output logic [15:0] outputs);
							
							
							// 0001 = GatePC
							// 0010 = GateMDR
							// 0100 = GateALU
							// 1000 = GateMARMUX
always_comb
	begin
		case (S)
			4'b0001 : outputs = PC;
			4'b0010 : outputs = MDR;
			4'b0100 : outputs = ALU;
			4'b1000 : outputs = Adder;
			default : outputs = 16'h0; 
		endcase
	end
endmodule 