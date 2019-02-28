module sign_extension6 (input logic [5:0] sign,
							  output logic [15:0] sext6);
							  
							  					  
always_comb //sign extension of IR[5:0]
	begin 
		if(sign[5])
			sext6[15:6] = 10'b1111111111;
		else
			begin
			sext6[15:6] = 10'b0000000000;
			end
		sext6[5:0] = sign;
	end 	
endmodule 


module sign_extension9 (input logic [8:0] sign,
							  output logic [15:0] sext9);
							  						  					  
always_comb //sign extension of IR[8:0]
	begin 
		if(sign[8])
			sext9[15:9] = 7'b1111111;
		else
			begin
			sext9[15:9] = 7'b0000000;
			end
		sext9[8:0] = sign;
	end 	
endmodule 


module sign_extension11 (input logic [10:0] sign,
							  output logic [15:0] sext11);
							    					  
always_comb  //sign extension of IR[10:0] 
	begin 
		if(sign[10])
			sext11[15:11] = 5'b11111;
		else
			begin
			sext11[15:11] = 5'b00000;
			end
		sext11[10:0] = sign;
	end 	
endmodule 


module sign_extension5 (input logic [4:0] sign,
							  output logic [15:0] sext5);
							  							  					  
always_comb //sign extension of IR[4:0]
	begin 
		if(sign[4])
			sext5[15:5] = 11'b11111111111;
		else
			begin
			sext5[15:5] = 11'b00000000000;
			end
		sext5[4:0] = sign;
	end 	
endmodule 