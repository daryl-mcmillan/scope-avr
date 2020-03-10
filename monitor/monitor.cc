#include <stdio.h>

#define BUFFER_SIZE 128*1024

int main() {

	unsigned char buf[BUFFER_SIZE];
	char last = 0x00;
	int channel = 0;
	for(;;) {
		int len = fread(buf, 1, BUFFER_SIZE, stdin);
		for( int i=0; i<len; i++ ) {
			if( ( buf[i] ^ last ) & 0b00000001 ) {
				channel = 0;
				// sync
			}
			if( buf[i] & 0b00000010 ) {
				printf( "channel %d\n", channel );
			}
			channel ++;
			last = buf[i];
		}
               	printf("%d\n", buf[0]);
	}
}
