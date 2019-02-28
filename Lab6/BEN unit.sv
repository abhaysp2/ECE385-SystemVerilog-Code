module BEN_Reg (input  logic Clk, N, Z, P, LD_BEN,
					 input  logic [2:0] In,
					 output logic BEN);
					 
always_ff @ (posedge Clk)
	begin							
		if(LD_BEN)				
			BEN <= (In[2] & N) + (In[1] & Z) + (In[0] & P); //BEN equal to 1 if restriction met
	end
				
endmodule 