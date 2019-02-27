module four_bit_CLA (input [3:0] A, B,
						input c_in,
						output logic [3:0] Sum,
						output logic P,
						output logic G);
						
		logic c0, c1, c2, c3;
		logic [3:0] g;
		logic [3:0] p;
		
		assign g= A&B;
		assign p= A|B;
		
		always_comb
		begin
					c0 = c_in;
					c1 = (c_in & p[0]) | g[0];
					c2 = (c_in & p[0] & p[1]) | (g[0] & p[1]) | g[1];
					c3 = (c_in & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | g[2];
					P = (p[0] & p[1] & p[2] & p[3]);
					G = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);
					
		end
		
		full_adder FA0(.x(A[0]), .y(B[0]), .z(c0),.s(Sum[0]));
		full_adder FA1(.x(A[1]), .y(B[1]), .z(c1),.s(Sum[1]));
		full_adder FA2(.x(A[2]), .y(B[2]), .z(c2),.s(Sum[2]));
		full_adder FA3(.x(A[3]), .y(B[3]), .z(c3),.s(Sum[3]));

		
endmodule
					