/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] REG [16];
	
	logic [127:0] msg_dec;
	logic done;
	
	AES aes (.CLK(CLK), .RESET(RESET), .AES_START(REG[14][0]), .AES_DONE(done),
				.AES_KEY({REG[0], REG[1], REG[2], REG[3]}),
				.AES_MSG_ENC({REG[4], REG[5], REG[6], REG[7]}),
				.AES_MSG_DEC(msg_dec));
				
	always_ff @ (posedge CLK)
	begin
		if(RESET == 1'b1)
		begin
			REG[0] <= 32'b0;
			REG[1] <= 32'b0;
			REG[2] <= 32'b0;
			REG[3] <= 32'b0;
			REG[4] <= 32'b0;
			REG[5] <= 32'b0;
			REG[6] <= 32'b0;
			REG[7] <= 32'b0;	
			REG[8] <= 32'b0;
			REG[9] <= 32'b0;
			REG[10] <= 32'b0;
			REG[11] <= 32'b0;
			REG[12] <= 32'b0;
			REG[13] <= 32'b0;
			REG[14] <= 32'b0;
			REG[15] <= 32'b0;//15 is for done, msg dec is 8 
		end
		
		else if(AVL_WRITE == 1 && AVL_CS == 1)
		begin
			REG[AVL_ADDR] = AVL_WRITEDATA;
		end
		
		else if(done == 1'b1)
		begin
			REG[15] <= 32'b1;
			REG[11] <= msg_dec[31:0];
			REG[10] <= msg_dec[63:32];
			REG[9] <= msg_dec[95:64];
			REG[8] <= msg_dec[127:96];
		end
		
	end
	
	always_comb
	begin
		if(AVL_CS == 1 && AVL_READ == 1)
			AVL_READDATA = REG[AVL_ADDR];
		else AVL_READDATA = 32'b0;
		
		EXPORT_DATA = {REG[3][31:16], REG[0][15:0]};
	end
			
endmodule
