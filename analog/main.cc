#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

void delay(int ms) {
  for( int i=0; i<ms; i++ ) {
    _delay_ms(1);
  }
}

void writeByte( char b ) {
  while ( !( UCSR0A & (1<<UDRE0) ) );
  UDR0 = b; 
}

int main(void) {

  // uart setup
  UBRR0 = 0; // 0 pause for bits - run full clock/16 rate
  UCSR0A = 1<<U2X0; // double rate - clock/8
  UCSR0B = 1<<TXEN0; // enable transmit
  UCSR0C = (0<<USBS0)|(3<<UCSZ00); // 1 stop bit, 8 data bits

  // adc setup
  DIDR0 = 0b00111111; // digital in disable for all analog pins
  ADMUX = (0b01<<REFS0)|(1<<ADLAR)|(0<<MUX0); // ref=vcc, left aligned, input 0
  ADCSRB = (0<<ADTS0); // free running
  ADCSRA = (1<<ADEN)|(1<<ADSC)|(1<<ADATE)|(0b100<<ADPS0); // enable, start, auto trigger, clock prescale=16

  char count = 0;
  for( ;; ) {

    // read adc
    while ( !(ADCSRA & (1<<ADIF)) );
    int sampleLow = ADCL;
    int sampleHigh = ADCH;
    ADCSRA |= (1<<ADIF);

    writeByte( sampleHigh );
    writeByte( sampleLow );
    // send byte
    //count ++;
  }

}
