module mux_base (input logic [1:0] d0, d1,
				  input logic s,
				  output logic y);
				  
always_comb
begin
	if (s)
		y = d1;
	else 
		y = d0;
end
endmodule 