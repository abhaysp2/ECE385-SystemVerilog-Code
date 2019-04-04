module controller(input logic CLK, RESET, AES_START, 
						output logic [1:0] IMC_select,
						output logic [1:0] SELECT,
						output logic [2:0] IMC_count,
						output logic [3:0] count9,
						output logic AES_DONE,
						output logic Load_Reg, checkFirst, Load_IMC);
						
						
	enum logic [4:0] {WAIT, DONE, KeyExpansion, ARK1, ARK2, ARK_LOOP, ISR_LOOP, ISB_LOOP,
							IMC_LOOP0, IMC_LOOP1, IMC_LOOP2, IMC_LOOP3, ISR, ISB, PAUSE, PAUSE_LOOP} State, Next_state;
	
	
	//logic [3:0] round, in_round;
	
	//assign Check_First = 1'b0;
	
	logic [2:0] count4;
	//logic [3:0] count9;
	logic [4:0] countkey;
	logic countEnable4, countEnable9, countEnablekey;
	
	counter4 c4(.CLK(CLK), .CountEnable(countEnable4), .RESET(RESET), .Count(count4));
	counter9 c9(.CLK(CLK), .CountEnable(countEnable9), .RESET(RESET), .Count(count9));
	counterkey ck(.CLK(CLK), .CountEnable(countEnablekey), .RESET(RESET), .Count(countkey));

	always_ff @ (posedge CLK)
	begin
		if (RESET)
		begin
			State <= WAIT;	
		end
		else
		begin
			State <= Next_state;
		end
	end
	
	always_comb
	begin
		Next_state = State;
		
		//default
		AES_DONE = 1'b0;
		countEnablekey = 1'b0;
		IMC_select = 2'b00;
		SELECT = 2'b00;
		countEnable9 = 1'b0;
		checkFirst = 1'b0; 
		Load_Reg = 1'b0;
		Load_IMC = 1'b0;
		IMC_count = 2'b00;
		
		unique case (State)
			WAIT: 
				if(AES_START)
					Next_state = KeyExpansion;
				else
					Next_state = WAIT;
			DONE:
				if(~AES_START)
					Next_state = WAIT;
				else
					Next_state = DONE;
			KeyExpansion:
				if(countkey == 5'b11000)
					Next_state = ARK1;
				else
					Next_state = KeyExpansion;
			ARK1:
				Next_state = ISR_LOOP;
			ISR_LOOP:
				Next_state = ISB_LOOP;
			ISB_LOOP:
				Next_state = ARK_LOOP;
			ARK_LOOP:
				Next_state = IMC_LOOP0;
			IMC_LOOP0:
					Next_state = IMC_LOOP1;
			IMC_LOOP1:
					Next_state = IMC_LOOP2;
			IMC_LOOP2:
					Next_state = IMC_LOOP3;
			IMC_LOOP3:
				if(count9 == 4'b1001)
					Next_state = PAUSE;
				else
					Next_state = PAUSE_LOOP;
			PAUSE_LOOP:
				Next_state = ISR_LOOP;
			PAUSE:
				Next_state = ISR;
			ISR:
				Next_state = ISB;
			ISB:
				Next_state = ARK2;
			ARK2:
				Next_state = DONE; 
					
				
			default : ;
		endcase
		
		case (State)
			WAIT:
				begin
					AES_DONE = 1'b0;
				end
			DONE:
				begin
					AES_DONE = 1'b1;
					countEnable9 = 1'b1;
				end
			KeyExpansion:
				begin
					countEnablekey = 1'b1;
					checkFirst = 1'b1; 
				end
			ARK1:
				begin 
					countEnable9 = 1'b1;
					SELECT = 2'b10;
					Load_Reg = 1'b1;
				end
			ISR_LOOP:
				begin
					SELECT = 2'b00;
					Load_Reg = 1'b1;
				end
			ISB_LOOP:
				begin
					SELECT = 2'b01;
					Load_Reg = 1'b1;
				end
			ARK_LOOP:
				begin
					SELECT = 2'b10;
					Load_Reg = 1'b1;
				end
			IMC_LOOP0:
				begin
					IMC_select = 2'b00;
					Load_IMC = 1'b1;
					SELECT = 2'b11;
				end
			IMC_LOOP1:
				begin
					IMC_select = 2'b01;
					Load_IMC = 1'b1;
					SELECT = 2'b11;
					IMC_count = 2'b01;
				end
			IMC_LOOP2:
				begin
					IMC_select = 2'b10;
					Load_IMC = 1'b1;
					SELECT = 2'b11;
					IMC_count = 2'b10;
				end
			IMC_LOOP3:
				begin
					IMC_select = 2'b11;
					SELECT = 2'b11;
					countEnable9 = 1'b1;
					Load_IMC = 1'b1;
					IMC_count = 2'b11;
				end
			PAUSE_LOOP:
				begin
					Load_Reg = 1'b1;
					SELECT = 2'b11;
				end
			PAUSE:
				begin
					Load_Reg = 1'b1;
					SELECT = 2'b11;
				end
			ISR:
				begin
					SELECT = 2'b00;
	//				countEnable9 = 1'b1;
					Load_Reg = 1'b1;
				end
			ISB:
				begin
					SELECT = 2'b01;
					Load_Reg = 1'b1;
				end
			ARK2:
				begin
					SELECT = 2'b10;
					Load_Reg = 1'b1;
				end
			default: ;
			endcase
	end
endmodule
