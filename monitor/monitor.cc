#include <stdio.h>

#define BUFFER_SIZE 65536

int main() {
	unsigned short buf[BUFFER_SIZE];
	for(;;) {
		int c = fread(buf, 2, BUFFER_SIZE, stdin);
               	printf("%d\n", buf[0]);
	}
}
