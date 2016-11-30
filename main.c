#define F_CPU 1000000

#include <inttypes.h>
#include <avr/io.h>
//#include <avr/interrupt.h>
//#include <avr/sleep.h>
#include <util/delay.h>



int main (void)
{

  /*DDRA = 0xFF;*/
  DDRB = 0xFF;
  /*DDRC = 0xFF;*/
  DDRD = 0xFF;

  while (1){

    PORTD=0b10001111^0xff; // a 3
    PORTB=0b00000001;
    _delay_ms(350);
    PORTB=0b00000010;
    _delay_ms(350);
    PORTB=0b00000100;
    _delay_ms(350);
    PORTB=0b00001000;
    _delay_ms(350);

    PORTD=0b00011011^0xff; // a 4
    PORTB=0b00000001;
    _delay_ms(350);
    PORTB=0b00000010;
    _delay_ms(350);
    PORTB=0b00000100;
    _delay_ms(350);
    PORTB=0b00001000;
    _delay_ms(350);
  }
}

