/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

	logic [1407:0] keySchedule;
	logic [127:0] State_New,
					  ISR_Out,
					  ISB_Out,
					  ARK_Out,
					  IMC_Total_Out,
					  ARK_INPUT;
	logic [31:0] IMC_input; IMC_to_add
	
	logic [1:0] SELECT, IMC_select;
					  
	always_comb
		begin
			if(Check_First == 1'b1)
				ARK_INPUT = AES_MSG_ENC;
			else
				ARK_INPUT = State_New;
		end
		
	always_ff @ (posedge clk)
	begin
		if(IMC_select == 2'b00)
		begin
			IMC_total_out[31:0] <= IMC_to_add;
		end
		else if(IMC_select == 2'b01)
		begin
			IMC_total_out[63:32] <= IMC_to_add;
		end
		else if(IMC_select == 2'b10)
		begin
			IMC_total_out[95:64] <= IMC_to_add;
		end
		else if(IMC_select == 2'b11)
		begin
			IMC_total_out[127:96] <= IMC_to_add;
		end
	end

	KeyExpansion keyExpansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(keySchedule));
	
	InvShiftRows(.data_in(State_New), .data_out(ISR_Out));
	
	InvSubBytes		invsubBytes_0	(clk, State_New[7:0], invsub_out[7:0]);
	InvSubBytes		invsubBytes_1	(clk, State_New[15:8], invsub_out[15:8]);
	InvSubBytes		invsubBytes_2	(clk, State_New[23:16], invsub_out[23:16]);
	InvSubBytes		invsubBytes_3	(clk, State_New[31:24], invsub_out[31:24]);
	InvSubBytes		invsubBytes_4	(clk, State_New[39:32], invsub_out[39:32]);
	InvSubBytes		invsubBytes_5	(clk, State_New[47:40], invsub_out[47:40]);
	InvSubBytes		invsubBytes_6	(clk, State_New[55:48], invsub_out[55:48]);
	InvSubBytes		invsubBytes_7	(clk, State_New[63:56], invsub_out[63:56]);
	InvSubBytes		invsubBytes_8	(clk, State_New[71:64], invsub_out[71:64]);
	InvSubBytes		invsubBytes_9	(clk, State_New[79:72], invsub_out[79:72]);
	InvSubBytes		invsubBytes_10	(clk, State_New[87:80], invsub_out[87:80]);
	InvSubBytes		invsubBytes_11 (clk, State_New[96:88], invsub_out[96:88]);
	InvSubBytes		invsubBytes_12	(clk, State_New[103:96], invsub_out[103:96]);
	InvSubBytes		invsubBytes_13	(clk, State_New[111:104], invsub_out[111:104]);
	InvSubBytes		invsubBytes_14	(clk, State_New[119:112], invsub_out[119:112]);
	InvSubBytes		invsubBytes_15	(clk, State_New[127:120], invsub_out[127:120]);
	
	InvMixColumns  mixcolumns(.in(IMC_input), .out(IMC_to_add));
	
	InvAddRoundKey ARK(.*);

		
	controller aes_control(.*);
	
	assign ISB_Out = invsub_out;
	
	mux128 program_mux(.d0(ISR_Out), .d1(ISB_Out), .d2(ARK_Out), .d3(IMC_Total_Out), .s(SELECT), .y(State_New));
	
	mux32  IMCmux(.d0(State_New[31:0]), .d1(State_New[63:32]), .d2(State_New[95:64]), .d3(State_New[127:96]), .s(IMC_select), .y(IMC_input));
	
	
	

endmodule
