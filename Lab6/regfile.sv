module regfile(input logic Clk, Load, Reset,
				   input  logic [2:0]  SR1_Input, SR2_Input, DR_Input,
				   input  logic [15:0] D,
				   output logic [15:0] Base_R, SR2_Out);
			
logic [7:0][15:0] OUT;
			
always_ff @ (posedge Clk)
	begin
		if (Reset)
			begin
				OUT[0] <= 16'h0;
				OUT[1] <= 16'h0;
				OUT[2] <= 16'h0;
				OUT[3] <= 16'h0;
				OUT[4] <= 16'h0;
				OUT[5] <= 16'h0;
				OUT[6] <= 16'h0;
				OUT[7] <= 16'h0;
			end		
		else if (Load)	
			case(DR_Input)
				3'b000: OUT[0] <= D;
				3'b001: OUT[1] <= D;
				3'b010: OUT[2] <= D;
				3'b011: OUT[3] <= D;
				3'b100: OUT[4] <= D;
				3'b101: OUT[5] <= D;
				3'b110: OUT[6] <= D;
				3'b111: OUT[7] <= D;
				default: ;
			endcase
	end	
always_comb 
	begin	
		case(SR1_Input) 
			3'b000: Base_R <= OUT[0];
			3'b001: Base_R <= OUT[1];
			3'b010: Base_R <= OUT[2];
			3'b011: Base_R <= OUT[3];
			3'b100: Base_R <= OUT[4];
			3'b101: Base_R <= OUT[5];
			3'b110: Base_R <= OUT[6];
			3'b111: Base_R <= OUT[7];
			default: ;
		endcase
				
		case(SR2_Input) 
			3'b000: SR2_Out <= OUT[0];
			3'b001: SR2_Out <= OUT[1];
			3'b010: SR2_Out <= OUT[2];
			3'b011: SR2_Out <= OUT[3];
			3'b100: SR2_Out <= OUT[4];
			3'b101: SR2_Out <= OUT[5];
			3'b110: SR2_Out <= OUT[6];
			3'b111: SR2_Out <= OUT[7];
			default: ;
		endcase
	end
endmodule 