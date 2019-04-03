module mux128
	(input logic [127:0] d0, d1, d2, d3,
	 input logic [1:0] s,
	 output logic [127:0] y);

always_comb 
	begin
		case(s)
			2'b00 : y = d0;
			2'b01 : y = d1;
			2'b10 : y = d2;
			2'b11 : y = d3;
		endcase
	end
endmodule

module mux32
	#(parameter width = 32)
	(input logic [width-1:0] d0, d1, d2, d3,
	 input logic [1:0] s,
	 output logic [width-1:0] y);

always_comb 
	begin
		case(s)
			2'b00 : y = d0;
			2'b01 : y = d1;
			2'b10 : y = d2;
			2'b11 : y = d3;
		endcase
	end
endmodule

