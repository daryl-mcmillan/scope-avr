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
#define tmp1 r1
#define tmp2 r2
#define tmp3 r3
#define tmp4 r4
#define tmp5 r5
#define tmp6 r6
#define tmp7 r7
#define sync r9
#define constFF r16
#define count r24
#define count_high r10

capture:

eor const00, const00
ldi constFF, 0xFF

out DDRB, const00 ; input
out DDRD, constFF ; output
out PORTD, constFF ; idle high

loop:

in tmp1, PINB
adiw count, 32
; adiw is 2 cycles
adc count_high, const00
brcc notoggle
eor sync, constFF
notoggle:
nop

in tmp2, PINB
nop
nop
nop
nop
nop
nop
nop

in tmp3, PINB
out PORTD, const00 ; start bit
nop
nop
nop
out PORTD, sync ; data0 - sync
nop
nop

in tmp4, PINB
out PORTD, tmp1 ; data1
nop
nop
nop
out PORTD, tmp2 ; data2
nop
nop

in tmp5, PINB
out PORTD, tmp3 ; data3
nop
nop
nop
out PORTD, tmp4 ; data4
nop
nop

in tmp6, PINB
out PORTD, tmp5 ; data5
nop
nop
nop
out PORTD,tmp6 ; data6
nop
nop

in tmp7, PINB
out PORTD, tmp7 ; data7
nop
nop
nop
out PORTD, constFF ; stop bit
rjmp loop
