TITLE 'Init'
SBTTL 'OGO1.3 group 7, 2006-2007'
; 
;
init:
;	This unit initialises all components to the desired state. Is to be called as subroutine at start of main program. Also initialises PWM-status.
;          Stop all belts, set UV lamp off, reset waferleds. Check whether both door are open (if so, Crash), then get door 1 open, door 2 closed.
;         Subroutine: InitialisePWM - initialises PWM status. This is a fairly direct copy from pracprog.doc supplied with the course 2IT20.
;
;
        MOV     _Power, #0
        MOV     DPTR, #0FD00h
        CLR     A
        MOVX    @DPTR, A

        ACALL   InitialiseEmergency ;Init Emergency button
        ACALL   InitialisePWM       ;Init Pulse Width Modulation

        ACALL	Conveyor2Stop		;Stops the second conveyor belt
        ACALL	Conveyor1Stop		;Stops the first conveyor belt
        ACALL	SetUVoff		    ;Sets UV lamp off.
        ACALL   ResetWaferLEDs      ;Resets the wafer LEDs.
;
;          Check whether both doors are open at the same time, if so, Crash.
        ACALL   ReadDoor1
        MOV     Acc.0, C
        ACALL   ReadDoor2
        ORL     C, Acc.0
;        
        ;Carry = (Door 1 is open) and (Door 2 is open)
;
        JNC      CrashInit            ;If both doors were open, Crash.
        
        ; From now on the emergency button has to actually work
        MOV     _EmTarget, #0       ; Enable the default emergency button handler

        ;Close door 2, open door 1 (in that order!), Crash if a door is stuck (ie carry is zero)
        ACALL    CloseDoor2
        JNC      CrashInit
        ACALL    OpenDoor1
        JNC      CrashInit

        RET

;InitialisePWM: initialises PWM status 
InitialisePWM:		                ; call this only once!
        MOV     CCPL,#254	        ; CYCLE for channels 0..2
        ORL     CMSEL1,#02h         ; enable channel 2
        MOV     CT1CON,#2Fh         ; start 0..2 (at 0% power)
        MOV     CP2L,#254	        ; CYCLE for channel 3
        MOV     CT2CON,#6Fh	        ; enable/start 3 (at 0% power)
        RET		                    ; initialisation done!

InitialiseEmergency:
        SETB    IT1                 ; Set edge triggered interrupt
        ANL     ITCON, #11110111b   ; Only enable rising edge
        ORL     ITCON, #00000100b

        MOV     _EmTarget, #255
        SETB    EX1                 ; Enable the interrupt for this pin
        RET

CrashInit:
        AJMP    CrashInit
        
        END     init