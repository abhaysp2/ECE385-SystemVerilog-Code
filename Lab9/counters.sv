module counter4(input logic CLK,
					 input logic CountEnable,
					 input logic RESET,
					 output logic [2:0] Count);

logic [2:0] counter = 3'b000;

always_ff @ (posedge CLK)
begin
	if(CountEnable)
		Count <= counter;
end

always_comb
begin
	if(Count == 3'b011)
		counter = 3'b000;
	else
		counter = Count + 1;
		
end
endmodule



module counter9(input logic CLK,
					 input logic CountEnable,
					 input logic RESET,
					 output logic [3:0] Count);
					 
logic [3:0] counter = 4'b0000;

always_ff @ (posedge CLK)
begin
	if(RESET)
		Count <= 4'b0000;
	if(CountEnable)
		Count <= counter;
end

always_comb
begin
	if(Count == 4'b1010)
		counter = 4'b0000;
	else
		counter = Count + 1;
		
end
endmodule

module counterkey(input logic CLK,
						input logic CountEnable,
						input logic RESET,
					   output logic [4:0] Count);
logic [4:0] counter = 5'b00000;

always_ff @ (posedge CLK)
begin
	if(RESET)
		Count <= 5'b0000;
	if(CountEnable)
		Count <= counter;
end

always_comb
begin
	if(Count == 5'b11000)
		counter = 5'b00000;
	else
		counter = Count + 1;
		
end			 
endmodule
