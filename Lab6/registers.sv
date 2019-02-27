module reg_base (input  logic Clk, Reset, Load,
					  input  logic [15:0]  D,
					  output logic Shift_Out,
                 output logic [15:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 16'h0000;
		 else if (Load)
			  Data_Out <= D;
		 
    end

endmodule
