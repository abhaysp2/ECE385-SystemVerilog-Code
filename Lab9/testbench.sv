//testbench shitmodule testbench ();

	
    timeunit 10ns;  // how long one unit of time is

    timeprecision 1ns;

    // inputs
    logic RESET, CLK, AES_START, AES_DONE;
	 logic [127:0] AES_KEY, AES_MSG_ENC, AES_MSG_DEC;
	 
	 //AES test(.*);
	 
	 
	 always begin:
		//CLOCK_GENERATION
			#1 CLK = ~CLK;
		end
		
		initial begin:
		//	TEST_VECTORS
			CLK = 0;
			AES_START = 0;
			AES_KEY = 128'h13111d7fe3944a17f307a78b4d2b30c5;
			AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
			RESET = 1;
			#2
			RESET = 0;
			#2
			AES_START = 1;
			#2
			AES_START = 0;
		end

		