module register_unit (input  logic Clk, Reset, ClearA_LoadB, 
                            Shift_En,
                      input  logic [7:0]  S, 
                      output logic A_out, B_out, 
                      output logic [7:0]  A,
                      output logic [7:0]  B);
	 
	 

    reg_8  reg_A (.*, .Shift_In(A_In), .Load(Ld_A),
	               .Shift_Out(A_out), .Data_Out(A));
    reg_8  reg_B (.*, .Shift_In(B_In), .Load(ClearA_LoadB),
	               .Shift_Out(B_out), .Data_Out(B));

endmodule
