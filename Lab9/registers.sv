module reg_128 (input  logic Clk, Reset, Load, checkFirst,
					  input  logic [127:0]  D, D2,
                 output logic [127:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 128'h0;
		 else if (Load)
			  Data_Out <= D;
		 else if (checkFirst)
		     Data_Out <= D2;
		 
    end

endmodule

module reg_IMC (input  logic Clk, Reset, Load, 
					input logic [2:0] IMC_count,
					  input  logic [31:0] d0, 
                 output logic [127:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 128'h0;
		 else if (Load)
			case(IMC_count)
				2'b00:
				Data_Out[31:0] <= d0;
				2'b01:
				Data_Out[63:32] <= d0;
				2'b10:
				Data_Out[95:64] <= d0;
				2'b11:
				Data_Out[127:96] <= d0;
				default :;
			endcase 
		 
    end

endmodule