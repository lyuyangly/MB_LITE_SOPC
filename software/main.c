/* MicroBlaze Test */
void delay(unsigned int t)
{
	unsigned int i, j;
	for(i = 0; i < t; i++)
		for(j = 0; j < 500; j++);
}

#define SDRAM_BASE(i) *((volatile unsigned int *)(0x10000000+i))
#define IOWR(base, off, dat) *((volatile unsigned int *)(base + (off<<2))) = dat

/* test sdata in rwdata section */
#define LED_BASE 0x20000000
volatile int num1, num2;

int main(void)
{

	int i, k, temp;
	
	IOWR(LED_BASE, 2, 0xff);
	
	IOWR(LED_BASE, 1, 0x55);


	for(k = 0; k < 100; k++) {
		IOWR(LED_BASE, 1, ~k);
		delay(200);
	}

	for(i = 0; i < 1024; i+=4) {
		SDRAM_BASE(i) = 0xaaaaaaaa;
	}
	
	for(i = 0; i < 1024; i+=4) {
		temp = SDRAM_BASE(i);
		IOWR(LED_BASE, 1, temp);
		delay(200);
	}
	
	for(i = 0; i < 1024; i+=4) {
		SDRAM_BASE(i) = 0x55555555;
	}
	
	for(i = 0; i < 1024; i+=4) {
		temp = SDRAM_BASE(i);
		IOWR(LED_BASE, 1, temp);
		delay(200);
	}

	while(1) {
		num1 = 0xa0a0a055;
		IOWR(LED_BASE, 1, num1);
		delay(200);
		num2 = 0xa0a0a0aa;
		IOWR(LED_BASE, 1, num2);
		delay(200);
	}
	
	return 0;
}
