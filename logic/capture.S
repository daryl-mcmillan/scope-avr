#include <avr/io.h>

.text

.global capture

#define const00 r0
#define sync r1
#define count_l r29
#define count_h r30
#define constFF r28
#define const01 r27
#define tmp1 r5

capture:

; initialize registers
eor tmp1, tmp1
eor sync, sync
eor count_l, count_l
eor count_h, count_h
ldi constFF, 0xFF
ldi const01, 0x01
eor const00, const00

; initialize ports - port C input, ports B and D output
out DDRC, const00
out PORTD, constFF
out DDRD, constFF
out PORTB, constFF
out DDRB, constFF

; idle before first start bit
nop
nop
nop
nop
nop
nop
nop
nop
nop

out PORTD, 0x00 ; port D start bit

in tmp1, PORTC
nop
nop
out PORTD, tmp1 ; port D data0

in tmp1, PORTC
nop
nop
out PORTD, tmp1 ; port D data1

in tmp1, PORTC
nop
nop
out PORTD, tmp1 ; port D data2

in tmp1, PORTC
nop
nop
out PORTD, tmp1 ; port D data3

in tmp1, PORTC
nop
nop

portDbit4:
out PORTD, tmp1 ; port D data4

in tmp1, PORTC
nop
out PORTB, 0x00                 ; port B start bit
out PORTD, tmp1 ; port D data5

in tmp1, PORTC
nop
out PORTB, tmp1                 ; port B data0
out PORTD, const00 ; port D data6 - order

in tmp1, PORTC
nop
out PORTB, tmp1                 ; port B data1
out PORTD, sync ; port D data7 - sync

in tmp1, PORTC
nop
out PORTB, tmp1                 ; port B data2
out PORTD, constFF ; port D stop bit

in tmp1, PORTC
nop
out PORTB, tmp1                 ; port B data3
nop

in tmp1, PORTC
nop
out PORTB, tmp1                 ; port B data4
nop

in tmp1, PORTC
nop
out PORTB, tmp1                 ; port B data5
out PORTD, 0x00 ; port D start bit

in tmp1, PORTC
nop
out PORTB, constFF                 ; port B data6 - order
out PORTD, tmp1 ; port D data0

in tmp1, PORTC
add count_l, const01
out PORTB, sync                 ; port B data7 - sync
out PORTD, tmp1 ; port D data1

in tmp1, PORTC
adc count_h, const00
out PORTB, constFF              ; port B stop bit
out PORTD, tmp1 ; port D data2

in tmp1, PORTC
; toggle sync on counter carry
brcc notoggle
eor sync, constFF
notoggle:
out PORTD, tmp1 ; port D data3

in tmp1, PORTC
rjmp portDbit4
