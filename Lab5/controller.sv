module control (input  logic Clk, Reset, ClearA_LoadB, Run, Check,
                output logic Clear_Ld, Shift, Add, Sub);

    // Declare signals curr_state, next_state of type enum
    enum logic [4:0] {A, A1, B, C, D, E, F, G, H, I, K, L, M, N, O, P, Q, R, S}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk or posedge Reset)  
    begin
        if (Reset)
            curr_state <= A;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	 always_comb
    begin
        
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 

            A :    if (Run)
                       next_state = A1;
				A1:    next_state = B; //state to clear XA
            B :    next_state = C; //add
            C :    next_state = D; //shift
            D :    next_state = E; //add
            E :    next_state = F; //shift
				F : 	 next_state = G; //add
				G :	 next_state = H; //shift
				H : 	 next_state = I; //add
				I : 	 next_state = K; //shift
				K : 	 next_state = L; //add
				L : 	 next_state = M; //shift
				M : 	 next_state = N; //add
				N : 	 next_state = O; //shift
				O : 	 next_state = P; //add
				P : 	 next_state = Q; //shift
				Q : 	 next_state = R; //subtract
				R : 	 next_state = S; //shift
            S :    if (~Run) 
                       next_state = A;
							  
        endcase
	end
	
	always_comb
   begin 
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   A: 						//start state
	         begin
                Clear_Ld = ClearA_LoadB;
                Shift = 1'b0;
					 Add = 1'b0;
					 Sub = 1'b0;
		      end
				
	   	   S: 						//idle state
	         begin
                Clear_Ld = 1'b0;
                Shift = 1'b0;
					 Add = 1'b0;
					 Sub = 1'b0;
		      end				
				
	   	   A1: 						//clear state
	         begin
                Clear_Ld = 1'b1;
                Shift = 1'b0;
					 Add = 1'b0;
					 Sub = 1'b0;
		      end			
				
	   	   B,D,F,H,K,M,O:  		//adding state
		      begin 
                Clear_Ld = 1'b0;
                Shift = 1'b0;
					 Sub = 1'b0;
					 if(Check)
						Add = 1'b1;					
					 else 
						Add = 1'b0;
		      end
				
				Q:							//subtract state
				begin 
					 Clear_Ld = 1'b0;
					 Shift = 1'b0;
					 Add = 1'b0;
					 if(Check)
						Sub = 1'b1;
					 else
						Sub = 1'b0;
				end 
					
				C,E,G,I,L,N,P,R:					//shifting states
				begin
					 Clear_Ld = 1'b0;
					 Shift = 1'b1;
					 Add = 1'b0;
					 Sub = 1'b0;
				end 
        endcase
    end

endmodule
