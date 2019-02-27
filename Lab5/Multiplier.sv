module multiplier (input logic Clk, Reset, Run, ClearA_LoadB, 
							input logic [7:0] S,
							output logic [6:0] AhexU, BhexU, AhexL, BhexL,
							output logic [7:0] Aval, Bval,
							output logic X
							);

	logic	Reset_New,				//reset input from controller
			Run_New, 				//run from button
			ClearA_LoadB_New, 	//cleara_loadb from button 
			Add_New, 				//add from controller
			Sub_New,					//sub from controller
			Clear_Ld_New, 			//clear from controller
			Shift_New; 				//shift from controller
			
	logic [8:0] Addition_Boi; //output of adder

	logic [7:0] A, B;	//output of reg a,b, switches
	logic A_out;
												
							
	reg_8		    	  A_Reg(
									.Clk(Clk),
									.Reset(Reset_New | Clear_Ld_New),
									.Load(Add_New | Sub_New),					//check
									.Shift_En(Shift_New),
									.Shift_In(X),
									.S(Addition_Boi[7:0]),
									.Shift_Out(A_out),
									.Data_Out(A)				 );
	reg_8				  B_Reg(
									.Clk(Clk),
									.Reset(Reset_New),
									.Load(ClearA_LoadB_New),
									.Shift_En(Shift_New),
									.Shift_In(A_out),
									.S(S),
									.Shift_Out(),
									.Data_Out(B)  			 );
									
	control			  controller(
									.Clk(Clk),
									.Reset(Reset_New),
									.ClearA_LoadB(ClearA_LoadB_New),
									.Run(Run_New),
									.Check(B[0]),
									.Clear_Ld(Clear_Ld_New),
									.Shift(Shift_New),
									.Add(Add_New),
									.Sub(Sub_New) 			 );
									
	flip_flop	 Extra_bit(
									.Clk(Clk),
									.Load(Add_New | Sub_New),
									.Reset(Clear_Ld_New | Reset_New),
									.D(Addition_Boi[8]),
									.Q(X)				  	   );
						
	adder_subtractor		Adder(
									.A(A),
									.B(S),
									.fn(Sub_New),
									.S(Addition_Boi)  	    );

									
	HexDriver        HexAL (
									.In0(A[3:0]),
									.Out0(AhexL) );
	HexDriver        HexBL (
									.In0(B[3:0]),
									.Out0(BhexL) );
									
	HexDriver        HexAU (
									.In0(A[7:4]),
									.Out0(AhexU) );	
	HexDriver        HexBU (
								  .In0(B[7:4]),
									.Out0(BhexU) );
									
	assign Aval = A;
	assign Bval = B;
									
									
	sync button_sync[2:0] (Clk, {~Reset, ~Run, ~ClearA_LoadB}, {Reset_New, Run_New, ClearA_LoadB_New});

endmodule
	
	