module controller(input logic CLK, RESET, AES_START, 
						input  logic [127:0] AES_KEY,
						input  logic [127:0] AES_MSG_ENC,
						output logic [127:0] AES_MSG_DEC,
						output logic AES_DONE);
						
						
enum logic (WAIT, DONE, 
always_ff @ (posedge CLK)