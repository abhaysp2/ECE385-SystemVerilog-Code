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
	output logic [31:0] EXPORT_DATA);		// Exported Conduit Signal to LEDs
	
logic [15:0][31:0] REG; //representation of dat
logic [31:0] Change;
assign EXPORT_DATA = {REG[3][31:16], REG[0][15:0]};

always_ff @ (posedge CLK)
    begin
	 
		  if (AVL_BYTE_EN[0] == 1) //selects REGput data selected by SR1_Input 
				Change[7:0] <= AVL_WRITEDATA[7:0];
		  if (AVL_BYTE_EN[1] == 1)
				Change[15:8] <= AVL_WRITEDATA[15:8];
		  if (AVL_BYTE_EN[2] == 1)
				Change[23:16] <= AVL_WRITEDATA[23:16];
		  if (AVL_BYTE_EN[3] == 1)
				Change[31:24] <= AVL_WRITEDATA[31:24];
				
        if (RESET)      //set all 16 registers to 0
            begin
                REG[0] <= 31'h0;
                REG[1] <= 31'h0;
                REG[2] <= 31'h0;
                REG[3] <= 31'h0;
                REG[4] <= 31'h0;
                REG[5] <= 31'h0;
                REG[6] <= 31'h0;
                REG[7] <= 31'h0;
                REG[8] <= 31'h0;
                REG[9] <= 31'h0;
                REG[10] <= 31'h0;
                REG[11] <= 31'h0;
                REG[12] <= 31'h0;
                REG[13] <= 31'h0;
                REG[14] <= 31'h0;
                REG[15] <= 31'h0;
            end    
				
        else if (AVL_WRITE & AVL_CS)            //output register specified by addr
					REG[AVL_ADDR] <= Change;     				
		end
   
endmodule
