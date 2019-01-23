
blink.elf:     file format elf32-avr


Disassembly of section .text:

; interrupt vector table?
00000000 <__vectors>:
   0:	0c 94 34 00 	jmp	0x68	; 0x68 <__ctors_end>
   4:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
   8:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
   c:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  10:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  14:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  18:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  1c:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  20:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  24:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  28:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  2c:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  30:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  34:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  38:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  3c:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  40:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  44:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  48:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  4c:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  50:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  54:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  58:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  5c:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  60:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>
  64:	0c 94 3e 00 	jmp	0x7c	; 0x7c <__bad_interrupt>

00000068 <__ctors_end>:
  68:	11 24       	eor	r1, r1      ; xor r1,r1 => clear it
  6a:	1f be       	out	0x3f, r1	; output r1 to global status register (flags)
  6c:	cf ef       	ldi	r28, 0xFF	; load r28 with 255
  6e:	d8 e0       	ldi	r29, 0x08	; load r29 with 8
  70:	de bf       	out	0x3e, r29	; init Stackpointer High with r29
  72:	cd bf       	out	0x3d, r28	; init Stackpointer Low with r28
  74:	0e 94 40 00 	call	0x80	; 0x80 <main> (start main program)
  78:	0c 94 56 00 	jmp	0xac	; 0xac <_exit> (after main program finished, goto exit => stops interrupts and loops forever)

  ;maybe the disassembler couldn't read this?
0000007c <__bad_interrupt>:
  7c:	0c 94 00 00 	jmp	0	; 0x0 <__vectors>

  
  ;our program!
; int main() {
00000080 <main>:

  ;void setup() {
  ; DDRB |= 1 << 5;  
  80:	25 9a       	sbi	0x04, 5	;set bit 5 on address 4 to "1"
  ; }
  
  ; void loop() {
  ; PORTB |= 1 << 5;
  82:	2d 9a       	sbi	0x05, 5	;set bit 5 on address 5 to "1"
  
  ; _delay_ms(100);
  ; the i at the end of the command means "immediately"
  84:	2f ef       	ldi	r18, 0xFF	; load 255 into register 18
  86:	81 ee       	ldi	r24, 0xE1	; load 225 into register 24
  88:	94 e0       	ldi	r25, 0x04	; load 4 into register 25
  8a:	21 50       	subi	r18, 0x01	; subtract 1 from register 18
  8c:	80 40       	sbci	r24, 0x00	; subtract 0 (and carry flag) from r24
  8e:	90 40       	sbci	r25, 0x00	; subtract 0 (and carry flag) from r25
  ; this means 1 is subtracted from r24/r25 if the operation before had a carry (eg 0-1 = 255 ; carry)
  ; => 255 * 225 * 4 = 229500 iterations of this loop
  90:	e1 f7       	brne	.-8      	; if r25 is not zero, repeat loop
  ; I feel like these following two operations are not needed...
  92:	00 c0       	rjmp	.+0      	; otherwise jump 1 ahead (nop)
  94:	00 00       	nop                 ; do noting
  
  ;PORTB &= ~(1 << 5);
  96:	2d 98       	cbi	0x05, 5	;clear bit 5 on address 5 (set it to "0")
  
  ; _delay_ms(1000);
  ;explanation see delay above
  98:	2f ef       	ldi	r18, 0xFF	; 255
  9a:	83 ed       	ldi	r24, 0xD3	; 211
  9c:	90 e3       	ldi	r25, 0x30	; 48
  9e:	21 50       	subi	r18, 0x01	; 1
  a0:	80 40       	sbci	r24, 0x00	; 0
  a2:	90 40       	sbci	r25, 0x00	; 0
  a4:	e1 f7       	brne	.-8      	; 0x9e <main+0x1e>
  a6:	00 c0       	rjmp	.+0      	; 0xa8 <main+0x28>
  a8:	00 00       	nop
  ;}
  
  ;while(1){ loop(); }
  aa:	eb cf       	rjmp	.-42     	; 0x82 <main+0x2>

000000ac <_exit>:
  ac:	f8 94       	cli  ;clear interrupt flag (means disable them)

  ; this one just jumps to itself repeatedly (infinite loop doing nothing)
000000ae <__stop_program>:
  ae:	ff cf       	rjmp	.-2      	; 0xae <__stop_program>
