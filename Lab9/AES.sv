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
					  IMC_Total_Out,
					  ARK_Out,
					  Hold;
	logic [31:0] IMC_input, IMC_to_add;
	logic [127:0] invsub_out;
	logic [2:0] IMC_count;
	logic [1:0] IMC_select;
	logic [1:0] SELECT;
	logic [3:0] count9;
	logic checkFirst, Load_Reg, Load_IMC;
	
	assign AES_MSG_DEC = Hold;
	
	
	reg_128 state_reg(.Clk(CLK), .Reset(RESET), .Load(Load_Reg), .checkFirst(checkFirst), .D(State_New), .D2(AES_MSG_ENC), .Data_Out(Hold));
	
	reg_IMC IMC_reg(.Clk(CLK), .Reset(RESET), .Load(Load_IMC), .d0(IMC_to_add), .IMC_count(IMC_count), .Data_Out(IMC_Total_Out));
	
	KeyExpansion keyExpansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(keySchedule));
	
	InvAddRoundKey ARK(.ARK_INPUT(Hold), .keySchedule(keySchedule), .ARK_Out(ARK_Out), .count(count9));
	
	InvShiftRows ISR(.data_in(Hold), .data_out(ISR_Out));
	
	InvSubBytes		invsubBytes_0	(.clk(CLK), .in(Hold[7:0]), .out(invsub_out[7:0]));
	InvSubBytes		invsubBytes_1	(.clk(CLK), .in(Hold[15:8]), .out(invsub_out[15:8]));
	InvSubBytes		invsubBytes_2	(.clk(CLK), .in(Hold[23:16]), .out(invsub_out[23:16]));
	InvSubBytes		invsubBytes_3	(.clk(CLK), .in(Hold[31:24]), .out(invsub_out[31:24]));
	InvSubBytes		invsubBytes_4	(.clk(CLK), .in(Hold[39:32]), .out(invsub_out[39:32]));
	InvSubBytes		invsubBytes_5	(.clk(CLK), .in(Hold[47:40]), .out(invsub_out[47:40]));
	InvSubBytes		invsubBytes_6	(.clk(CLK), .in(Hold[55:48]), .out(invsub_out[55:48]));
	InvSubBytes		invsubBytes_7	(.clk(CLK), .in(Hold[63:56]), .out(invsub_out[63:56]));
	InvSubBytes		invsubBytes_8	(.clk(CLK), .in(Hold[71:64]), .out(invsub_out[71:64]));
	InvSubBytes		invsubBytes_9	(.clk(CLK), .in(Hold[79:72]), .out(invsub_out[79:72]));
	InvSubBytes		invsubBytes_10	(.clk(CLK), .in(Hold[87:80]), .out(invsub_out[87:80]));
	InvSubBytes		invsubBytes_11 (.clk(CLK), .in(Hold[96:88]), .out(invsub_out[96:88]));
	InvSubBytes		invsubBytes_12	(.clk(CLK), .in(Hold[103:96]), .out(invsub_out[103:96]));
	InvSubBytes		invsubBytes_13	(.clk(CLK), .in(Hold[111:104]), .out(invsub_out[111:104]));
	InvSubBytes		invsubBytes_14	(.clk(CLK), .in(Hold[119:112]), .out(invsub_out[119:112]));
	InvSubBytes		invsubBytes_15	(.clk(CLK), .in(Hold[127:120]), .out(invsub_out[127:120]));
	
	InvMixColumns  mixcolumns(.in(IMC_input), .out(IMC_to_add));
	


	controller aes_control(.*, .count9(count9), .checkFirst(checkFirst));
	
	assign ISB_Out = invsub_out;
	
	mux128 program_mux(.d0(ISR_Out), .d1(ISB_Out), .d2(ARK_Out), .d3(IMC_Total_Out), .s(SELECT), .y(State_New));
	
	mux32  IMCmux(.d0(Hold[31:0]), .d1(Hold[63:32]), .d2(Hold[95:64]), .d3(Hold[127:96]), .s(IMC_select), .y(IMC_input));

endmodule
