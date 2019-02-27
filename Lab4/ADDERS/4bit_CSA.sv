module four_bit_CSA ( input logic [3:0] A, B,
							input logic c_in,
							output logic[3:0] Sum, 
							output logic CO);
							
				//carry in is 1
				logic[3:0] carry1;
				logic[3:0] Sum1;
				
				//carry in is 0
				logic[3:0] carry0;
				logic[3:0] Sum0;
				
				
				//perform ripple add with carry being 0
				full_adder FA0(.x(A[0]), .y(B[0]), .z(0), .s(Sum0[0]), .c(carry0[0]));
				full_adder FA1(.x(A[1]), .y(B[1]), .z(carry0[0]), .s(Sum0[1]), .c(carry0[1]));
				full_adder FA2(.x(A[2]), .y(B[2]), .z(carry0[1]), .s(Sum0[2]), .c(carry0[2]));
				full_adder FA3(.x(A[3]), .y(B[3]), .z(carry0[2]), .s(Sum0[3]), .c(carry0[3]));
				
				//perform ripple add with carry being 1
				full_adder FA4(.x(A[0]), .y(B[0]), .z(1), .s(Sum1[0]), .c(carry1[0]));
				full_adder FA5(.x(A[1]), .y(B[1]), .z(carry1[0]), .s(Sum1[1]), .c(carry1[1]));
				full_adder FA6(.x(A[2]), .y(B[2]), .z(carry1[1]), .s(Sum1[2]), .c(carry1[2]));
				full_adder FA7(.x(A[3]), .y(B[3]), .z(carry1[2]), .s(Sum1[3]), .c(carry1[3]));
				
				always_comb
				begin
						if(c_in == 0) begin
							Sum = Sum0;
							CO = carry0[3];
						end else begin
							Sum = Sum1;
							CO = carry1[3];
						end
				end
				
endmodule
