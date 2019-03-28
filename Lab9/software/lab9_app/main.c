/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x0000040;


// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

void printlong(unsigned char* input){
	int i;
	printf("the printed data is: ");
	for(i=0; i<16; i++){
    	printf("%x ", input[i]);
	}
	printf("\n");
}
void print(unsigned char* input){
	int i;
	printf("the printed data is: ");
	for(i=0; i<16; i++){
    	printf("%x ", input[i]);
	}
	printf("\n");
}
/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
    	hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
    	hex -= 'A';
    	hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
    	hex -= 'a';
    	hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

void RotWord(unsigned char * temp)
{
	unsigned char rotate;
	rotate = temp[0];
	temp[0] = temp[1];
	temp[1] = temp[2];
	temp[2] = temp[3];
	temp[3] = rotate;
}

void SubWord(unsigned char * temp)
{
	int i;
	for (i = 0; i < 4; i++) {
    	temp[i] = aes_sbox[(uint)temp[i]];
	}
}

void KeyExpansion(unsigned char * key, unsigned char * key_schedule)  // needs to finish
{
	unsigned char temp[4];

    	int i;
    	i = 0;
    	while(i < 16){
        	key_schedule[i] = key[i];
        	i = i + 1;
    	}

    	i = 16;
    	while(i < 176){
        	temp[0] = key_schedule[i-4];
        	temp[1] = key_schedule[i-3];
        	temp[2] = key_schedule[i-2];
        	temp[3] = key_schedule[i-1];
        	if (i % 16 == 0){
            	RotWord(temp);
            	SubWord(temp);

            	temp[0] = temp[0] ^ rcon[i/16];
            	temp[1] = temp[1] ^ rcon[0]; //check if +1
            	temp[2] = temp[2] ^ rcon[0]; //check if +1
            	temp[3] = temp[3] ^ rcon[0]; //check if +3
        	}
        	key_schedule[i+3] = key_schedule[i-13] ^ temp[3];
        	key_schedule[i+2] = key_schedule[i-14] ^ temp[2];
        	key_schedule[i+1] = key_schedule[i-15] ^ temp[1];
        	key_schedule[i] = key_schedule[i-16] ^ temp[0];
        	i = i+4;
    	}

}

void AddRoundKey(unsigned char * state, unsigned char * key_schedule, int start)
{
	int i = 0;
	for(i = 0; i < 16; i++){
    	state[i] = state[i] ^ key_schedule[i+start];
	}
}

void MixColumns(unsigned char * state)
{
	uchar temp[16];
	int i;
	for(i = 0; i < 16; i++){
    	temp[i] = state[i];
	}
	for(i = 0; i < 4; i++){
    	state[4*i] = gf_mul[temp[i*4]][0] ^ gf_mul[temp[i*4+1]][1] ^ temp[i*4+2] ^ temp[i*4+3];
    	state[4*i+1] = temp[i*4] ^ gf_mul[temp[i*4+1]][0] ^ gf_mul[temp[i*4+2]][1] ^ temp[i*4+3];
    	state[4*i+2] = temp[i*4] ^ temp[i*4+1] ^ gf_mul[temp[i*4+2]][0] ^ gf_mul[temp[i*4+3]][1];
    	state[4*i+3] = gf_mul[temp[i*4]][1] ^ temp[i*4+1] ^ temp[i*4+2] ^ gf_mul[temp[i*4+3]][0];
	}
}


void ShiftRows(unsigned char * state)
{
	unsigned char temp[2];

	temp[0] = state[1];
	state[1] = state[5];
	state[5] = state[9];
	state[9] = state[13];
	state[13] = temp[0];

	temp[0] = state[2];
	temp[1] = state[6];
	state[2] = state[10];
	state[6] = state[14];
	state[10] = temp[0];
	state[14] = temp[1];

	temp[0] = state[15];
	state[15] = state[11];
	state[11] = state[7];
	state[7] = state[3];
	state[3] = temp[0];
}

void SubBytes(unsigned char * state)
{
	int i;
	for (i = 0; i < 16; i++) {
    	state[i] = aes_sbox[(uint)state[i]];
	}
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *     	key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *           	key - Pointer to 4x 32-bit int array that contains the input key
 */

void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Ascii to hex conversion and fills in state and key with 16 Hex values in each array
	unsigned char key_schedule[176]; //CHECK size
	unsigned char keys[16];
	unsigned char state[16];
	int i = 0;
	for(i = 0; i < 16; i++){
    	keys[i] = charsToHex(key_ascii[(i*2)],key_ascii[(i*2) + 1]);
    	state[i] = charsToHex(msg_ascii[(i*2)], msg_ascii[(i*2) + 1]);
	}

	KeyExpansion(keys, key_schedule); //CHECK HERE !! if key or k

	AddRoundKey(state, key_schedule, 0);
	for(i = 1; i < 10; i++){
	    int placer = 16 * i;
    	SubBytes(state);
    	ShiftRows(state);
    	MixColumns(state);
    	AddRoundKey(state, key_schedule, placer);
	}
	SubBytes(state);
	ShiftRows(state);
	AddRoundKey(state, key_schedule, 160);
	print(state);
	print(keys);

	for(i = 0; i < 16; i+=4){
  	    key[i/4] = (keys[i]<<24) + (keys[i+1]<<16) + (keys[i+2]<<8) + (keys[i+3]);
	    msg_enc[i/4] = (state[i]<<24) + (state[i+1]<<16) + (state[i+2]<<8) + state[i+3];
	}
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *          	key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
	AES_PTR[0] = key[0];
	AES_PTR[1] = key[1];
	AES_PTR[2] = key[2];
	AES_PTR[3] = key[3];
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
    	// Continuously Perform Encryption and Decryption
    	while (1) {
        	int i = 0;
        	printf("\nEnter Message:\n");
        	scanf("%s", msg_ascii);
        	printf("\n");
        	printf("\nEnter Key:\n");
        	scanf("%s", key_ascii);
        	printf("\n");
        	encrypt(msg_ascii, key_ascii, msg_enc, key);
        	printf("\nEncrypted message is: \n");
        	for(i = 0; i < 4; i++){
            	printf("%08x", msg_enc[i]);
        	}
        	printf("\n");
        	decrypt(msg_enc, msg_dec, key);
        	printf("\nDecrypted message is: \n");
        	for(i = 0; i < 4; i++){
            	printf("%08x", msg_dec[i]);
        	}
        	printf("\n");
    	}
	}
	else {
    	// Run the Benchmark
    	int i = 0;
    	int size_KB = 2;
    	// Choose a random Plaintext and Key
    	for (i = 0; i < 32; i++) {
        	msg_ascii[i] = 'a';
        	key_ascii[i] = 'b';
    	}
    	// Run Encryption
    	clock_t begin = clock();
    	for (i = 0; i < size_KB * 64; i++)
        	encrypt(msg_ascii, key_ascii, msg_enc, key);
    	clock_t end = clock();
    	double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    	double speed = size_KB / time_spent;
    	printf("Software Encryption Speed: %f KB/s \n", speed);
    	// Run Decryption
    	begin = clock();
    	for (i = 0; i < size_KB * 64; i++)
        	decrypt(msg_enc, msg_dec, key);
    	end = clock();
    	time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    	speed = size_KB / time_spent;
    	printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}


