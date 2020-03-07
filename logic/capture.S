#define PINB 0x03
#define DDRB 0x04
#define PORTB 0x05

#define PINC 0x06
#define DDRC 0x07
#define PORTC 0x08

#define PIND 0x09
#define DDRD 0x0A
#define PORTD 0x0B

.text

.global capture

#define const00 r0
#define sample1a r1
#define sample1b r2
#define sample2a r3
#define sample2b r4
#define sample3a r5
#define sample3b r6
#define sample4a r7
#define sample4b r8
#define sample5a r9
#define sample5b r10
#define sample6a r11
#define sample6b r12
#define sync r13
#define sync_count_0 r14
#define sync_count_1 r15
#define sync_count_2 r16
#define sync_increment r17
#define constFF r18

capture:

eor const00, const00
eor sync, sync
eor sync_count_0, sync_count_0
eor sync_count_1, sync_count_1
eor sync_count_2, sync_count_2
ldi sync_increment, 32
ldi constFF, 0xFF

#define SAMPLE_PORT PINB
out DDRB, const00 ; input

#define OUTPUT_A PORTC
out DDRC, constFF ; output
out PORTC, constFF ; idle high

#define OUTPUT_B PORTD
out DDRD, constFF ; output
out PORTD, constFF ; idle high

in sample1a, SAMPLE_PORT
nop
nop
nop
in sample1b, SAMPLE_PORT
nop
nop

loop:
adc sync_count_1, const00

in sample2a, SAMPLE_PORT
adc sync_count_2, const00
brcc skip_toggle ; toggle sync on count overflow
eor sync, constFF
skip_toggle:

in sample2b, SAMPLE_PORT
out OUTPUT_A, const00 ; start bit
out OUTPUT_B, const00 ; start bit
nop
in sample3a, SAMPLE_PORT
out OUTPUT_A, sync
out OUTPUT_B, sync
nop
in sample3b, SAMPLE_PORT
out OUTPUT_A, const00 ; ordering bit
out OUTPUT_B, constFF ; ordering bit
nop
in sample4a, SAMPLE_PORT
out OUTPUT_A, sample1a
out OUTPUT_B, sample1b
nop
in sample4b, SAMPLE_PORT
out OUTPUT_A, sample2a
out OUTPUT_B, sample2b
nop
in sample5a, SAMPLE_PORT
out OUTPUT_A, sample3a
out OUTPUT_B, sample3b
nop
in sample5b, SAMPLE_PORT
out OUTPUT_A, sample4a
out OUTPUT_B, sample4b
nop
in sample6a, SAMPLE_PORT
out OUTPUT_A, sample5a
out OUTPUT_B, sample5b
nop
in sample6b, SAMPLE_PORT
out OUTPUT_A, sample6a
out OUTPUT_B, sample6b
nop
in sample1a, SAMPLE_PORT
out OUTPUT_A, constFF ; stop bit
out OUTPUT_B, constFF ; stop bit
add sync_count_0, sync_increment
in sample1b, SAMPLE_PORT
rjmp loop
