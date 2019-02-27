module NZP (input  logic Clk, N, Z, P, LD_CC,
						output logic N_Out, Z_Out, P_Out);
						
always_ff @ (posedge Clk)
begin
	if(LD_CC)	
	begin
		N_Out <= N;
		Z_Out <= Z;
		P_Out <= P;
	end
end
			
endmodule 