module reg_8 (input  logic Clk, Reset, Shift_En, Load, Shift_In,
              input  logic [7:0]  S,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

				  
always_ff @ (posedge Clk)
		begin
			if (Reset)				// in reset, register output is cleared
				Data_Out <= 8'h0;
			else if (Load)
				Data_Out <= S;			// in load, register parallel loads
			else if (Shift_En)	// in shift mode, shifts right one bit
			begin
				Data_Out <= {Shift_In, Data_Out[7:1]};
			end
		end

		assign Shift_Out = Data_Out[0];

endmodule
