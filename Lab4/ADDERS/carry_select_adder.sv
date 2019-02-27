module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

		logic[2:0] carr;
		
		four_bit_CSA CSA0(.A(A[3:0]), .B(B[3:0]), .c_in(0), .Sum(Sum[3:0]), .CO(carr[0]));
		four_bit_CSA CSA1(.A(A[7:4]), .B(B[7:4]), .c_in(carr[0]), .Sum(Sum[7:4]), .CO(carr[1]));
		four_bit_CSA CSA2(.A(A[11:8]), .B(B[11:8]), .c_in(carr[1]), .Sum(Sum[11:8]), .CO(carr[2]));
		four_bit_CSA CSA3(.A(A[15:12]), .B(B[15:12]), .c_in(carr[2]), .Sum(Sum[15:12]), .CO(CO));
		
endmodule
