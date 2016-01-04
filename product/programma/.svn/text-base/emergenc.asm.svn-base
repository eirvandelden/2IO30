TITLE 'Emergency button handling'
SBTTL 'OGO1.3 group 7, 2006-2007'

; This file uses intenal memory address 7Fh
; This file contains subroutines for handling emergency situations

; None of the subroutines in this file is to be called directly
; These subroutines will be called by means of an interrupt on the emergency
; button input pin.

Emergency:

_EmTarget   EQU 7Fh ;Defines how an emergency should be handled
                    ;0 is the default handler   


; Delegate the handling of an emergency button press to the correct subroutine according
; to the value of _Em_Target
; This subroutine is the interrupt vector for internal interrupt 1
HandleEm:
        ACALL   ReadEm  ; First check whether this was a real press
        JNC     EmFalse ;If it wasn't, don't do anything

        MOV     _StrVal, #0
        ACALL   Store

        MOV     A, _EmTarget
        CJNE    A, #1, NotEmBurn    ;Check whether the program was busy with actually lighting the wafer
                                    ;This has to be handled in a special way
        
        ANL     TCON, #10101111b    ; Disable the wait timer
        ACALL   SetUVOff            ; Make sure the lamp doesn't get re-enabled when EmDefault returns
        ACALL   EmDefault           ; First wait until the system is allowed to carry on

        MOV     A, #10
        ACALL   MoveForwardT        ; Move the wafer into the dustbin
        ACALL   CloseDoor2          ; Put the doors in their starting state
        JNC     CrashEm             ; Crash if the door is stuck
        ACALL   OpenDoor1
        JNC     CrashEm             ; Same as above

        POP     ACC
        POP     ACC
        
        PUSH    low(BurnFail)       ; Return to a special location which makes Burn return false
        PUSH    high(BurnFail)

        ACALL   Get

        RETI
NotEmBurn:
        CJNE    A, #255, NotEmDummy

        ; This is a dummy, just return to normal program flow
        ACALL   Get
        RETI

NotEmDummy:
        ;Insert any special handlers here
        ACALL   EmDefault           ; None of the special handlers applied, use the default
        ACALL   Get
        RETI

EmFalse:RETI

; Default handler: stops everything, waits for the emergency button to be pressed again and
; goes back to the original state before returning
EmDefault:
        CLR     EX1

        ;Disable all outputs
        MOV     DPTR, #0FD00h
        CLR     A
        MOVX    @DPTR, A
        ; P1 and P3 contain just inputs, so don't modify them
;        PUSH    P1
;        MOV     P1, #0
;        PUSH    P3
;        MOV     P3, #0
        ; The PWM outputs too
        PUSH    CMP2L
        PUSH    CCL2
        CLR     A
        ACALL   SetPWM0
        ACALL   SetPWM1

        ;Disable the timers
        PUSH    TCON
        ANL     TCON, #10101111b

EmD1:   ACALL   ReadEm  ; First wait for the button to be released
        JC      EmD1

        MOV     R0, #200        ; Wait some time for the sensor to settle
EmDO2:  MOV     R1, #200        ; We do busy waiting here because wtTime might be
EmDI2:  DJNZ    R1, EmDI2       ; In a paused state
        DJNZ    R0, EmDO2
        
EmD2:   ACALL   ReadEm  ; Then wait for it to be pressed again
        JNC     EmD2

EmD3:   ACALL   ReadEm  ; Only restart when the button is released
        JC      EmD3

        ; The emergency situation is over now, restore everything

        CLR     IE1     ; Make sure no interrupt request is pending for the emergency button

        ;Restore the running state of the timers
        POP     TCON

        ;Restore the original state of the outputs
        ;First the PWM outputs
        POP     ACC
        ACALL   SetPWM1
        POP     ACC
        ACALL   SetPWM0
        ;Then the others
        ; P1 and P3 contain just inputs, we don't modify their values
;        POP     P3
;        POP     P1
        MOV     A, _Power
        MOV     DPTR, #0FD00h
        MOVX    @DPTR, A

        MOV     R0, #200        ; Wait some time for the sensor to settle
EmDO:   MOV     R1, #200        ; We do busy waiting here because wtTime might be
EmDI:   DJNZ    R1, EmDI        ; In a paused state
        DJNZ    R0, EmDO

        SETB    EX1
        RET

EmBurn:


CrashEm:
        AJMP    CrashEm

        END     Emergency