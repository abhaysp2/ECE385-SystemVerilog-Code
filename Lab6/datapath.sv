module datapath (input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC,
					  LD_REG, LD_PC, LD_LED, GatePC, GateMDR, GateALU,
					  GateMARMUX, DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
					  MIO_EN, Clk, Reset,
					  input logic [1:0] ALUK, PCMUX, ADDR2MUX,
					  input logic [15:0] MDR_In,
					  output logic BEN,
					  output logic [15:0] MAR, MDR, IR, PC,
					  output logic [11:0] LED
					 );

					 logic [15:0] 
					 PC_New_Out, 			 //PC value + 1
					 PC_Entry,				 //PC value into register from mux
					 Adder_Out,				 //Adder output
					 Path,					 //direct from datapath!!!!!!!!!!!!!!
					 MDR_Entry,				 //MDR into register
					 ALU_New,			 	 //Value from ALU
					 MAR_New,				 //MAR value from register
					 IR_New,					 //IR value from register
					 Base_R,					 //SR1, register source   !!!!! not called SR1 ______!!!!!!
					 ADDR2_Out,				 //4 to 1 mux output into adder
					 ADDR1_Out,				 //2 to 1 mux output into adder
					 SR2_Out;				 //SR2 from reg file
					 			 
					 logic [2:0]
					 DR_Out,					 //DR output
					 SR1Mux_Out,			 //SR1 mux ouput
					 SR2;						 //SR2 input into register file
					 
					 logic
					 N, Z, P, N_Out, Z_Out, P_Out; //all singular bit wires
						
					 assign SR2 = IR[2:0];		//assigning input into reg file of SR2
					 
					 //SEXT Logic
					 logic [15:0] Sext5, Sext6, Sext9, Sext11;			
	
sign_extension5		S5(.sign(IR[4:0]), .sext5(Sext5));	//SEXT [4:0]
sign_extension6		S6(.sign(IR[5:0]), .sext6(Sext6));	//SEXT [5:0]
sign_extension9		S9(.sign(IR[8:0]), .sext9(Sext9));	//SEXT [8:0]
sign_extension11		S11(.sign(IR[10:0]), .sext11(Sext11)); //SEXT [10:0]
										 
reg_base 		PC_Reg  (.Clk(Clk), .Reset(Reset), .Load(LD_PC), .D(PC_Entry), .Data_Out(PC)); //PC reg
reg_base 		MAR_Reg (.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .D(Path), .Data_Out(MAR)); //MAR reg
reg_base 		MDR_Reg (.Clk(Clk), .Reset(Reset), .Load(LD_MDR), .D(MDR_Entry), .Data_Out(MDR));	//MDR reg
reg_base 		IR_Reg  (.Clk(Clk), .Reset(Reset), .Load(LD_IR), .D(Path), .Data_Out(IR));	 //IR reg

PC_adder 		plusPC (.PC_Val(PC), .PC_Val_add(PC_New_Out));									//Increases PC value
mux3 	#(16)		Mux_PC(.d0(PC_New_Out), .d1(Path), .d2(Adder_Out), .s(PC_MUX), .y(PC_Entry));	//Mux going to PC

mux2  #(16) 	Mux_MDR(.d0(Path), .d1(MDR_In), .s(MIO_EN), .y(MDR_Entry)); //Mux going into MDR

unique_mux  	Mux_Gates(.S({GateMARMUX, GateALU, GateMDR, GatePC}), .PC(PC), .Adder(Adder_Out), 
					.MDR(MDR), .ALU(ALU_New), .outputs(Path)); //tristatebuffer representation

mux4  #(16)		ADDR2_Mux(.d0(), .d1(Sext6), .d2(Sext9), .d3(Sext11), .s(ADDR2MUX), .y(ADDR2_Out)); //adder 2 mux into adder
mux2  #(16) 	ADDR1_Mux(.d0(PC), .d1(Base_R), .s(ADDR1MUX), .y(ADDR1_Out));		         		//adder 1 mux into adder
ALU				Adder_Path(.A(ADDR2_Out), .B(ADDR1_Out), .Out(Adder_Out), .s(2'b00));		 //adder into PC and path

mux2  #(3)  	DR_Mux(.d0(IR[11:9]), .d1(3'b111), .s(DRMUX), .y(DR_Out));					//DR mux into regfile
mux2  #(3) 		SR1_Mux(.d0(IR[11:9]), .d1(IR[8:6]), .s(SR1MUX), .y(SR1Mux_Out));    		//SR1 mux into regfile
regfile    		Reg_File(.*, .Load(LD_REG), .SR1_Input(SR1Mux_Out), .SR2_Input(SR2), 	//reg file 
					.DR_Input(DR_Out), .D(Path), .Base_R(Base_R), .SR2_Out(SR2_Out));	

ALU            ALU_unit(.A(Base_R), .B(SR2_Muxed), .s(ALUK), .Out(ALU_New)); 				//ALU unit
mux2  #(16)    SR2_Mux(.d0(SR2_Out), .d1(Sext5), .s(SR2MUX), .y(SR2_Muxed));				//SR2 mux into ALU

NZP 				NZP_Reg(.*);		//NZP unit
BEN_Reg			BEN_Unit(.*, .N(N_Out), .Z(Z_Out), .P(P_Out), .In(IR[11:9]), .BEN(BEN));	//BEN unit

always_comb
begin 
	if (Path[15])
		begin 
			N = 1'b1;
			Z = 1'b0;
			P = 1'b0; 
		end
	else 
		case(Path)
			16'h0: 
				begin
					N = 1'b0;
					Z = 1'b1;
					P = 1'b0;
				end
			default:
				begin
					N = 1'b0;
					Z = 1'b0;
					P = 1'b1;
				end
		endcase
end
			
always_ff @ (posedge Clk)
	begin
		if(LD_LED)
			LED <= IR[11:0];
		else
			LED <= 12'h0;
	end
			
endmodule 