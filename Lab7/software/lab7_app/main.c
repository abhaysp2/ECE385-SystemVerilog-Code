// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	//int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x90; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x80;
	volatile unsigned int *KEY2_PIO = (unsigned int*)0x70;
	volatile unsigned int *KEY3_PIO = (unsigned int*)0x60;

	//unsigned int flag = 0;

	*LED_PIO = 0; //clear all LEDs
	*SW_PIO = 0; //clear switches
	*KEY2_PIO = 0; //clear key2
	*KEY3_PIO = 0; //clear key3
	while ( (1+1) != 3) //infinite loop
	{
		if(*KEY2_PIO == 0){
			*LED_PIO = 0;
		}
		while(!(*KEY2_PIO));

		if(*KEY3_PIO == 0){
			*LED_PIO += *SW_PIO;
			if(*LED_PIO > 255){
				*LED_PIO = *LED_PIO - 256;
			}
		}
		while(!(*KEY3_PIO));
	}
	return 1; //never gets here
}