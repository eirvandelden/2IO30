TITLE 'Wait subroutines'
SBTTL 'OGO1.3 group 7, 2006-2007'
; This file contains a few subroutines for waiting, namely:
;
; The methods in this file require the use of timers T0 and T1, make sure you're not using
; them anywhere else
; Internal memory addresses 78h-7Bh are used by the routines in this file
;
; WtTime:	Pre: A > 0
;		The A register contains the amount of time this routine should wait,
; 		after that time the subroutine returns.
;
;
; AlrtTime:	Pre: A > 0
;		Sets an alert to occur after the amount of time specified in the A
; 		register. The R0 and R1 registers contain an address in the program memory.
;		In this address, R0 is the MSB.
;
;		If both R0 and R1 are zero, nothing special will happen when the alert occurs
;
;		If at least one of R0 and R1 is nonzero:
;		When the alert occurs the program jumps to the routine at the address which
;		was an argument to AlrtTime. Then the program executes this routine 
;		and then returns to normal program flow.
;
; AlrtStop:	Gives you the possibility to stop an alert from occurring.
;
;	Use the alert mechanism for example to define a time-out for certain actions, 
;	such that something predefined happens when the time-out occurs.
;	If you're done with your action before the time-out occurs,
;	call AlrtStop to disable the alert.
;
;	Wait times are in multiples of 50 milliseconds
;

wt_subs:

; Storage for the Alrt system
AlrtTmr	EQU	78h         ; Address in internal mem for storing the time to wait
AlrtS	EQU	79h         ; Aan overflow flag
AlrtAdL	EQU	7Ah         ; The address of the routine
AlrtAdH	EQU	7Bh         ; that should be executed when the alert occurs



; WtTime, simply does nothing for a certain amount of time
; A contains the time to be waited in multiples of 50 milliseconds
; Pre: A > 0
WtTime:
	PUSH	PSW
	MOV	    _StrVal,#00000000h	; We don't need to backup any Rx
	ACALL	Store			    ; Store some registers we're going to use

	ANL	TCON, #11101111b	    ; Stop timer 0
	ANL	TMOD, #11110001b	    ; Set timer 0 to mode 1, not counter, not gated
	ORL	TMOD, #00000001b
	
	MOV	TL0, #0B0h		        ; Set timer 0 to 50 milliseconds
	MOV	TH0, #3Ch		        ; 65536 - 50000 = 15536 = 0x3CB0

	ORL	IEN0, #10000010b	; Enable interrupt for T0 and the global interrupt
	ANL	IP0, #11111101b		; Set timer 0 to low priority

	ORL	TCON, #00010000b	; Start timer 0

	CLR	C
WtLoop:	
    JNC	WtLoop			; Just wait until everything is done

	ACALL	Get			; Restore everything we've been using
	POP	PSW
	RET				; And we're done

; Helper method for WtTime, this method is the interrupt vector for timer 0
WtDec:	
	DJNZ	ACC, WtNZ			; The waiting isn't done yet, wait once again

					; A is zero, we're done waiting
	ANL	TCON, #11101111b	; Stop timer 0
	SETB	C			; Signal WtTime that we're done
	RETI				; and return

WtNZ:	ANL	TCON, #11101111b	; Stop timer 0
	MOV	TL0, #0B0h		        ; Set timer 0 to 50 milliseconds
	MOV	TH0, #3Ch		        ; 65536 - 50000 = 15536 = 0x3CB0
	ORL	TCON, #00010000b	; Start timer 0
	RETI				; return to WtTime

; End WtTime



; AlrtTime, gives an alert to a predefined location
AlrtTime:
	ACALL	AlrtStop		; First make sure any running alert won't
					; time out during the execution of AlrtTime

	MOV	    _StrVal,#00000000h	; We don't need to backup any Rx
	ACALL	Store			; Store some registers we're going to use

	MOV	AlrtTmr, A			; Store the time to wait in the desinated location

	MOV	AlrtAdH, R0			; Store the address of the routine to be executed
	MOV	AlrtAdL, R1			; when the alert times out

	ANL	TCON, #10111111b	; Stop timer 1
	ANL	TMOD, #00011111b	; Set timer 1 to mode 1, not counter, not gated
	ORL	TMOD, #00010000b
	
	MOV	TL1, #0B0h		; Set timer 1 to 50 milliseconds
	MOV	TH1, #3Ch		

	ORL	IEN0, #10001000b	; Enable interrupt for T1 and the global interrupt
	ANL	IP0, #11110111b		; Set timer 1 to low priority

	ORL	TCON, #01000000b	; Start timer 1

	MOV	AlrtS, #0		; Clear the alert overflow flag

	ACALL	Get			; Restore everything we saved
	RET

; Helper method for AlrtTime, this method is the interrupt vector for timer 1
AlrtDec:
	DJNZ	AlrtTmr, AlrtNZ		; It's not yet time for the alert to occur, wait again
	
					; It's time for the alert to occur now
	MOV _StrVal, #00000001b			; First save some registers
	ACALL	Store

	MOV	A, AlrtAdH
	ORL	A, AlrtAdL
	JZ	AlrtFin			; Don't execute a subroutine if both R0 and R1 are zero

	PUSH	low(AlrtFin)	; First make sure the subroutine to be called returns
	PUSH	high(AlrtFin)	; to the correct address

	PUSH	AlrtAdL			; Then push the address of the subroutine to be called onto the stack
	PUSH	AlrtAdH

	RET				        ; "Return" to the subroutine which handles the alert
AlrtFin:				    ; The subroutine handling the alert has returned or there was none
	ANL	TCON, #10111111b	; Stop timer 1
	MOV	AlrtS, #1		; Set the overflow flag	 
	ACALL	Get
	RETI				; now we return from the interrupt

AlrtNZ:	ANL	TCON, #10111111b	; Stop timer 1
	MOV	TL1, #0B0h		        ; Set timer 1 to 50 milliseconds
	MOV	TH1, #3Ch		        ; 65536 - 50000 = 15536 = 0x3CB0
	ORL	TCON, #01000000b	; Start timer 1
	RETI
; End AlrtTime

; AlrtStop, stops an alert from occurring
AlrtStop:
	ANL	TCON, #10111111b	; Simply stop timer 1
	RET				; And that's all
    
        END wt_subs