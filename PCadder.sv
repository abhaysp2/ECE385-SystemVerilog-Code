module PC_adder (input logic [15:0] PC_Val,

					  output logic [15:0] PC_Val_add);
					  

assign PC_Val_add = PC_Val + 1;

endmodule 
