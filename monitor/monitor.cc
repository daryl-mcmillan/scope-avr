#include <stdio.h>

int main() {
	unsigned short buf[65536];
	for(;;) {
		int c = fread(buf, 2, 65536, stdin);
               	printf("%d\n", buf[0]);
	}
}