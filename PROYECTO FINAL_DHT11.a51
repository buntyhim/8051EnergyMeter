RS        EQU                         P3.5
RW        EQU                         P3.6
E         EQU                         P3.7
DBUS      EQU                         P2
PTR       EQU                       R0//TEXT BUFFER PTR


temp EQU 30H
I   		 EQU r4	
bitFRame 	 EQU 31H
HUMID  		 EQU  32H
cntr1Seg     EQU  33H	
tempDecs  	 EQU 34h
tempUnits 	 EQU 35h
SALTO_LINEA  EQU 36H	
HUMIDDecs  	 EQU 37h
HUMIDUnits   EQU 38h
SALTO_LINEA2  EQU 39H

DHT      EQU P3.0
TEMP_I   EQU 40H
TEMP_D   EQU 41H
HUMID_I  EQU 42H
HUMID_D  EQU 43H	
PARITY   EQU 44H
WAIT_FLAG  EQU 45H
ORG 0000h
	LJMP main
org 000BH;AQUI ESTA EL VECTOR DE INTERRUPCION POR OVERFLOW DEL T0
	ACALL ISR_TIMER0_0VRFLW
	RETI
ORG 0023H; vector para transmition interrupt
	ACALL byteTransmitted
	RETI
ORG 0030H
	main:
	MOV WAIT_FLAG,#0
	MOV TEMP_I,#0
	MOV TEMP_D,#0
    MOV HUMID_I,#0
	MOV temp,#01D
	//ACALL request
	MOV HUMID,#12D
	MOV SALTO_LINEA,#0Dh
	MOV SALTO_LINEA2,#0Dh
	ACALL READ_DHT11
	ACALL DEFAULT_TEXT
	
	ACALL PRINT_TEMP_HUMID
	ACALL INIT_TIMER0
	ACALL serial_init
	MOV PTR,#tempDecs

		
		while1:
			
			
			
		ajmp while1




delay_5ms:
			mov r6,#25D
			cicloDelay1:
				mov r7,#200D
				cicloDelay2:
					DJNZ R7,cicloDelay2
					DJNZ R6,cicloDelay1
			RET      
delay_30us:
/*
  mov TMOD, #01H;		; Timer0 mode1 (16-bit timer mode) 
  mov TH0 , #0FFH;		; Load higher 8-bit in TH0 
  mov TL0 , #0F1H;		; Load lower 8-bit in TL0 
  setb	TR0 		: Start timer0 
  wait_flag: jnb TF0,wait_flag /* Wait until timer0 flag set 
 clr TR0 		 ;Stop timer0 
 clr TF0 ;		 Clear timer0 flag 
 */
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
ret


INIT:           MOV  A,  #38H                         ;2 lineas, matriz
                                                      ;de 5 x 7
                ACALL delay_5ms                          ;espera a que LCD esté libre
                CLR  RS                               ;prepara comando para salida
                ACALL CARGA_DATOS                          ;envíalo
                
                MOV A, #0EH                           ;LCD encendida, cursor encendido
                ACALL delay_5ms                          ;espera a que la LCD este libre
                CLR RS                                ;prepara comando para salida
                ACALL CARGA_DATOS                          ;envíalo
               
NUEVO:          MOV A,  #01H                          ;limpia LCD
                ACALL delay_5ms                          ; espera a que el LCD este libre
                CLR RS                                ;perpara comando para salida
                ACALL CARGA_DATOS                          ;envíalo
				
				MOV A,  #02H                          ;poscicion inicial
                ACALL delay_5ms                          ;espera a que el LCD este libre
                CLR RS                                ;perpara comando para salida
                ACALL CARGA_DATOS                          ;envíalo
                
                MOV A,  #80H                          ;cursor: linea 1, pos. 1
                ACALL delay_5ms                          ;espera a que LCD este libre
                CLR RS                                ;prepara comando de salida
                ACALL CARGA_DATOS                          ;envíalo
                
                RET
                


PRINT:      ACALL delay_5ms                          ;espera a que la LCD este libre
               SETB RS                               ;prepara dato para salida
               ACALL CARGA_DATOS                          ;envíalo
               RET
               

CARGA_DATOS:      MOV DBUS,  A 
             CLR RW
             SETB E 
             NOP
			 NOP
			 CLR E 
             RET 

SET_CURSOR:;//(B) IS THE ARGUMENT FOR CURSOR

clr E
	clr RS//instruccion
	acall delay_5ms
	 acall delay_5ms
	acall delay_5ms
	 mov DBUS,B
	 setb E
	 nop 
	 nop
	 acall delay_5ms
	 clr E
RET

DEFAULT_TEXT:
 acall INIT
	MOV A,#'T'
	ACALL PRINT
	MOV A,#'E'
	ACALL PRINT
	MOV A,#'M'
	ACALL PRINT
	MOV A,#'P'
	ACALL PRINT
	
	MOV B,#0C0H
	ACALL SET_CURSOR
	
	 MOV A,#'H'
	ACALL PRINT
		 MOV A,#'U'
	ACALL PRINT
		 MOV A,#'M'
	ACALL PRINT
		 MOV A,#'I'
	ACALL PRINT
		 MOV A,#'D'
	ACALL PRINT
RET

PRINT_TEMP_HUMID:
	MOV b,#086h//ARGUMENT FOR CURSOR_SET,HERE IS GOING TO BE TEMP DATA
	ACALL SET_CURSOR
	MOV A,TEMP_I
	ACALL GET_BCD// RETURN A DECS B UNITS
	ADD A,#30h
	MOV tempDecs,A//COPY FOR SEND SERIALY TEMP DATA
	ACALL PRINT
	MOV A,B
	ADD A,#30h
	MOV tempUnits,A
	ACALL PRINT
	MOV A,#'.'
	ACALL PRINT
	MOV A,TEMP_D
	ACALL GET_BCD
	
	MOV A,B
	ADD A,#30h
	ACALL PRINT
	
	MOV b,#0C6h//SET CURSOR FOR PRINT HUMID DATA
	ACALL SET_CURSOR
	MOV A,HUMID_I
	ACALL GET_BCD// RETURN A DECS B UNITS
	ADD A,#30h
	MOV HUMIDDecs,A
	ACALL PRINT
	MOV A,B
	ADD A,#30h
	MOV HUMIDUnits,A
	ACALL PRINT
	MOV A,HUMID_D
	
RET

GET_BCD:;(A),numero a comvertir en BCD
	;	CJNE operand1,operand2,reladdr
;The Carry bit (C) is set if operand1 is less than operand2,
;otherwise it is cleared.
CJNE A,#10,	compare;si a es mayor que 9
	compare: JNC mayorque9
	menorque9:
		mov b,a//unides
		mov a,#0//decenas en cero
	
	jmp out
	mayorque9:
	MOV B,#10
	DIV AB;decenas en A, unidades en B
	out:
/*regresa en A decenas y en B unidades*/
RET
INIT_TIMER0:
    orl TMOD,#01h;TIMER 0 COUNTER  A 16 BITS
	SETB EA; habilitamos todas las interrupciones
	SETB TR0;TIMER  0 RUN 
	SETB ET0;HABILITAMOS OVRFLW INTS
	MOV TH0,#00111100B//arrancamos el timer en 15535
	MOV TL0,#10101111B
	orl TCON,#00010000B;// FINALLY TIMER 0 GOES TO RUN 
RET	
ISR_TIMER0_0VRFLW:
      MOV TH0,#00111100B//EL TIMER EMPEZARÁ LA CUENTA SOLO EN CERO
	  MOV TL0,#10101111B//COSA QUE NO DESEAMOS 
	  INC cntr1Seg
	  MOV A,cntr1Seg
	  CJNE A,#60,NADAAA
		CPL P1.4
		// AQUI YA PASO UN SEGUNDO******************************
		ACALL READ_DHT11
		ACALL PRINT_TEMP_HUMID
	    
		cpl tr1
		MOV cntr1Seg,#0
		 
	  NADAAA:
RETI

serial_init:
 
        orl TMOD, #21H 
		MOV TH1, #-26d
		SETB TR1
		MOV SCON, #42H
		
		MOV A, #20H
		orl IE, #90H
RET
byteTransmitted:


SEND:MOV SBUF,@PTR
INC PTR
CJNE PTR,#3Ah,COMPARE_PTR
COMPARE_PTR:JNC RESET_PTR
JMP NO_RESET
RESET_PTR:
MOV PTR,#tempDecs
CLR TR1
NO_RESET:
CLR TI

RET


//RELATIVO A LA HUMEDAD Y LA TEMPERATURA
DELAY_10MS:
			mov r6,#25D
			cicloDelay1_:
				mov r7,#200D
				cicloDelay2_:
					DJNZ R7,cicloDelay2_
					DJNZ R6,cicloDelay1_
			RET    		
REQUEST:
setb DHT
//ACALL DELAY_XMS

CLR DHT
ACALL DELAY_10MS
ACALL DELAY_10MS//TIME FOR REQUESTING DATA>18MS
SETB DHT
ret

WAIT_DATA:
CLR P1.1//LED DE TEST
WAIT1: JB DHT,WAIT1//WAITING FOR DHT11 PULLS DOWN COM LINE, BUT SOMETIMES IT MAY NOT RESPOND
SETB P1.1//LED DE TEST
WAIT2: JNB DHT,WAIT2
WAIT3: JB DHT,WAIT3

RET

GET_DATA:;(A) IS ARGUMENT,AND HERE RETURNS DATA
	MOV A,#0
	MOV I,#8
	LOOP:
		WAIT_BIT:JNB DHT,WAIT_BIT
		ACALL DELAY_30US
		JB  DHT,ONE
		ZERO:
		RL A
		AJMP ZERO_ADDED
		ONE:
		RL A
		ORL A,#01H
		ZERO_ADDED:
		STIL_ONE:JB DHT,STIL_ONE
	DJNZ I,LOOP	
	
RET
READ_DHT11:
			ACALL REQUEST
			ACALL WAIT_DATA
		
			ACALL GET_DATA//RETURN COLLECTED BYTE IN A
			MOV HUMID_I,A
			ACALL GET_DATA//RETURN COLLECTED BYTE IN A
			MOV HUMID_D,A
			ACALL GET_DATA//RETURN COLLECTED BYTE IN A
			MOV TEMP_I,A
			ACALL GET_DATA//RETURN COLLECTED BYTE IN A
			MOV TEMP_D,A
			ACALL GET_DATA//RETURN COLLECTED BYTE IN A
			MOV PARITY,A
			MOV A,TEMP_I
RET
DELAY_XMS:
		mov r5,#20D
		cicloDelay0__:
			mov r6,#255D
			cicloDelay1__:
				mov r7,#255D
				cicloDelay2__:
					DJNZ R7,cicloDelay2__
					DJNZ R6,cicloDelay1__
					DJNZ R5,cicloDelay0__
			RET 
	
ERROR_MESSAGE:
 acall INIT
	MOV A,#'E'
	ACALL PRINT
	MOV A,#'R'
	ACALL PRINT
	MOV A,#'R'
	ACALL PRINT
	MOV A,#'O'
	ACALL PRINT
	MOV A,#'R'
	
	
	
RET
end