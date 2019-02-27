module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

		logic c1, c2, c3;
		logic p0, p4, p8, p12;
		logic g0, g4, g8, g12;
		logic c0 = 1'b0; 
		
		
		four_bit_CLA CLA0(.A(A[3:0]), .B(B[3:0]), .c_in(c0), .Sum(Sum[3:0]), .P(p0), .G(g0));
		four_bit_CLA CLA1(.A(A[7:4]), .B(B[7:4]), .c_in(c1), .Sum(Sum[7:4]), .P(p4), .G(g4));
		four_bit_CLA CLA2(.A(A[11:8]), .B(B[11:8]), .c_in(c2), .Sum(Sum[11:8]), .P(p8), .G(g8));
		four_bit_CLA CLA3(.A(A[15:12]), .B(B[15:12]), .c_in(c3), .Sum(Sum[15:12]), .P(p12), .G(g12));
		
		always_comb
		begin
				
				c1 = g0 | (c0 & p0);
				c2 = g4 | (g0 & p4)| (c0 & p0 & p4);
				c3 = g8 | (g4 & p8) | (g0 & p4 & p8) | (c0 & p0 & p4 & p8);
				CO = g12 | (g8 & p12) | (g4 & p8 & p12) | (g0 & p4 & p8 & p12) | (c0 & p0 & p4 & p8 & p12);
		end

endmodule
