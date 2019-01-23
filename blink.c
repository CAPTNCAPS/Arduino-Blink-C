#include <avr/io.h>
#include <util/delay.h>

//these are the functions you would find in the arduino IDE
void setup();
void loop();

//and that's the program it hides from you
int main(void)
{
    setup();
    
    while(1)
    {
        loop();
    }
}

void setup()
{
    //DDRB |= _BV(DDB5);
    DDRB |= 1 << 5; //set bit 5 of DDRB to "1"
    //this means PORTB5 is output. 0 = in, 1 = out
}

void loop()
{
    //LED on PORTB5 is High-Active
    
    //PORTB |= _BV(PORTB5);
    PORTB |= 1 << 5; //set bit 5 of PORTB to "1" (enable LED)
    
    _delay_ms(100); //wait for 100ms
    
    //PORTB &= ~_BV(PORTB5);
    PORTB &= ~(1 << 5); //set bit 5 of PORTB to "0" (disable LED)
    
    _delay_ms(1000); //wait for 1 second
}

/*
  _BV(bit) converts bit to byte 
  body is:   (1 << (bit))
  origin: sfr_defs.h (included from avr/io.h)
  SFR = Special Function Register
 */

/*
 DDRB == Data Direction Register Port B (#define DDRB 0x04)
 PORTB == Data Register Port B (#define PORTB 0x05)
 DDB5 == Data Direction Bit 5 (#define DDB5 5)
 PORTB5 == Port B, bit 5 (#define PORTB5 5)
 
 NOTE REGARDING PORTS:
        these are defined in avr/iom328p.h (included from avr/io.h)
        they use a macro to add a possible offset of 0x20
        there's also some pointer-magic happening.
        best to just use those predefined constants and not the address directly!
 */

/*
 util/delay.h provides the _delay_ms function 
 seems to calculate amount of CPU ticks from input
 then just while(ticks > 0){ delay_loop2(); ticks--; }
 
 delay_loop2 just counts from 0 to 65536
 */
