module controller(input logic CLK, RESET, AES_START, 
						output logic [1:0] SELECT, IMC_select,
						output logic [4:0] count,
						output logic Check_First,
						output logic AES_DONE]);
						
						
	enum logic [4:0] {WAIT, DONE, KeyExpansion, ARK1} State, Next_state;
	
	
	logic [3:0] round, in_round;
	
	assign Check_First = 1'b0;
	
	logic [2:0] count4;
	logic [3:0] count9;
	logic [4:0] countkey;
	logic countEnable4, countEnable9, countEnablekey;
	
	counter4(.CLK(CLK), .CountEnable(countEnable4), .Count(count4));
	counter9(.CLK(CLK), .CountEnable(countEnable9), .Count(count9));
	counterkey(.CLK(CLK), .CountEnable(countEnablekey), .Count(countkey));

	always_ff @ (posedge CLK)
	begin
		count <= count9;
		if (Reset)
		begin
			State <= WAIT;
			//round <= 4'b0000;
		end
		else
			State <= Next_state;
			//round <= in_round;
	
	always_comb
	begin
		Next_state = State;
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
				Next_state = IMC_LOOP;
			IMC_LOOP0:
					Next_state = IMC_LOOP1;
			IMC_LOOP1:
					Next_state = IMC_LOOP2;
			IMC_LOOP2:
					Next_state = IMC_LOOP3;
			IMC_LOOP3:
				if(count9 == 4'b1001)
					Next_state = ISR;
				else
					Next_state = ISR_LOOP;
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
				end
			KeyExpansion:
				begin
					countEnablekey = 1'b1;
				end
			ARK1:
				begin 
					Check_First = 1'b1;
					SELECT = 2'b10;
				end
			ISR_LOOP:
				begin
					SELECT = 2'b00;
				end
			ISB_LOOP:
				begin
					SELECT = 2'b01;
				end
			ARK_LOOP:
				begin
					SELECT = 2'b10;
				end
			IMC_LOOP0:
				begin
					IMC_select = 2'b00;
				end
			IMC_LOOP1:
				begin
					IMC_select = 2'b01;
				end
			IMC_LOOP2:
				begin
					IMC_select = 2'b10;
				end
			IMC_LOOP3:
				begin
					IMC_select = 2'b11;
					countEnable9 = 1'b1;
					SELECT = 2'b11;
				end
			ISR:
				begin
					SELECT = 2'b00;
				end
			ISB:
				begin
					SELECT = 2'b01;
				end
			ARK2:
				begin
					SELECT = 2'b10;
				end
				
		
	end