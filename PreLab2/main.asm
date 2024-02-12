; Universidad del Valle de Guatemala ; IE2023: Programación de Microcontroladores
; PreLab1.asm
; Autor: Diego Duarte 22426
; Proyecto: Pre-Lab 2
; Hardware: ATMEGA328P
; Creado: 07/02/2024
; Última modificación: 07/02/2024

; ENCABEZADO

.include "M328PDEF.inc"
.CSEG
.ORG 0x0000

;Stack Pointer
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R17, HIGH(RAMEND)
	OUT SPH, R17

;SETUP

SETUP:
	LDI R16, (1 << CLKPCE)
	STS CLKPR, R16

	LDI R16, 0b0000_0010   ;Reloj a 4MHz
	STS CLKPR, R16

	LDI R16, 0B0001_1110	;Puertos PB1, 2, 3, 4 como salida
	OUT DDRB, R16

	LDI R16, 0x00
	OUT PORTB, R16			;Bits del puerto B en 0

	CALL INITIALIZE_TIMER0

	LDI R16, 0x00
	STS 0X01FF, R16			;Posición en la que se guarda el numero

	LDI R20, 0
	LDI R21, 0
	LDI R22, 0

LOOP:
	IN R16, TIFR0
	CPI R16, (1 << TOV0)
	BRNE LOOP

	LDI R16, 100
	OUT TCNT0, R16

	SBI TIFR0, TOV0

	INC R20
	CPI R20, 10
	BRNE LOOP

	CLR R20

	/*INC R21
	CPI R21, 200
	BRNE LOOP

	CLR R21

	INC R22
	CPI R22, 200
	BRNE LOOP

	CLR R22*/

	LDS R16, 0x01FF
	INC R16
	STS 0x01FF, R16

	LSL R16
	LDI R17, 0b0001_1110
	AND R16, R17
	OUT PORTB, R16


	RJMP LOOP

INITIALIZE_TIMER0:
	LDI R16, (1 << CS02)	;Configurar prescaler a 256
	OUT TCCR0B, R16

	LDI R16, 100
	OUT TCNT0, R16			;Se carga el valor inicial del contador, el cual cuenta hasta 256

	RET



