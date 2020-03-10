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
#define channel_indicator_0 r19
#define channel_indicator_1 r20

capture:

eor const00, const00
eor sync, sync
eor sync_count_0, sync_count_0
eor sync_count_1, sync_count_1
eor sync_count_2, sync_count_2
ldi sync_increment, 16
ldi constFF, 0xFF
eor channel_indicator_0, channel_indicator_0
eor channel_indicator_1, channel_indicator_1

#define SAMPLE_PORT PIND
out DDRD, const00 ; input

#define OUTPUT_A PORTB
out DDRB, constFF ; output
out PORTB, constFF ; idle high

#define OUTPUT_B PORTC
out DDRC, constFF ; output
out PORTC, constFF ; idle high

in sample1a, SAMPLE_PORT
nop
nop
nop
in sample1b, SAMPLE_PORT
nop
nop

loop:
adc sync_count_2, const00

in sample2a, SAMPLE_PORT
brcc skip_toggle ; toggle sync on count overflow
eor sync, constFF
skip_toggle:
rol channel_indicator_0

in sample2b, SAMPLE_PORT
out OUTPUT_A, const00 ; start bit
out OUTPUT_B, const00 ; start bit
rol channel_indicator_1
in sample3a, SAMPLE_PORT
out OUTPUT_A, sync
out OUTPUT_B, sync
nop
in sample3b, SAMPLE_PORT
out OUTPUT_A, channel_indicator_0 ; ordering bit
out OUTPUT_B, channel_indicator_1 ; ordering bit
swap sample1a
in sample4a, SAMPLE_PORT
out OUTPUT_A, sample1a
out OUTPUT_B, sample1b
swap sample2a
in sample4b, SAMPLE_PORT
out OUTPUT_A, sample2a
out OUTPUT_B, sample2b
swap sample3a
in sample5a, SAMPLE_PORT
out OUTPUT_A, sample3a
out OUTPUT_B, sample3b
swap sample4a
in sample5b, SAMPLE_PORT
out OUTPUT_A, sample4a
out OUTPUT_B, sample4b
swap sample5a
in sample6a, SAMPLE_PORT
out OUTPUT_A, sample5a
out OUTPUT_B, sample5b
swap sample6a
in sample6b, SAMPLE_PORT
out OUTPUT_A, sample6a
out OUTPUT_B, sample6b
add sync_count_0, sync_increment
in sample1a, SAMPLE_PORT
out OUTPUT_A, constFF ; stop bit
out OUTPUT_B, constFF ; stop bit
adc sync_count_1, const00
in sample1b, SAMPLE_PORT
rjmp loop
