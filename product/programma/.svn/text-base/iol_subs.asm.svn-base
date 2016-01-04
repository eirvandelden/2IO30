TITLE 'Input/Output Subroutines'
SBTTL 'OGO1.3 group 7, 2006-2007'
;
; This file uses internal memory addresses 76h and 77h
;
;Included DS:
;       _LEDs - saves output value of LEDs
;       _Power - saves output value of 
;
; Included subroutines:
;       Conveyor1 Start, Conveyor1Stop, Conveyor2Stop, Conveyor2Forward, Conveyor2Backward - Routines for starting/stopping conveyor belts
;       LOpenDoor1, LOpenDoor2, LCloseDoor1, LCloseDoor2 - Routines for opening and closing doors
;       IncWaferLEDs, ResetWaferLEDs, NotLostFive - Increase or clear lost wafer status, check how many wafers have been lost.
;       ReadDoor1, ReadDoor2: Returnstatus:	Carry = DoorxClosed = True
;       ReadSensor1, ReadSensor - Routines for checking lightsensors. Returnstatus: Acc = LightBlocked = False
;       SetUVon, SetUVoff - Routines for turning UV on and off.

iol_subs:	

_LEDs    EQU 76h                         ;Define Storage for value of the LEDs (LED output adresses are write-only)
_Power   EQU 77h                         ;Define Storage for value of PWR byte (PWR output adresses are write-only)

  	
;
;       Start of actual subroutines:
;
;       Conveyor1Start - Starts the first conveyor belt. (The one which only moves in one direction)
;       Only changes power outputs for appropiate motor.
Conveyor1Start:
        ;Save A and DPTR:
        MOV    _StrVal, #00000000b
        ACALL   Store
;        
        MOV     A, #128d                ;We want the belt to be running at 50% speed
        ACALL   SetPWM0                 ;Actually set PWR0 on.
;        
        ACALL   Get
        RET
;        
;        
;       Conveyor1Stop - Stops the first conveyor belt. (The one which only moves in one direction)
;       Only changes power outputs for appropiate motor.
Conveyor1Stop:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;
        MOV     A, #0d                  ;We want the belt to be running at 0% speed
        ACALL   SetPWM0
;        
        ;Restore A and DPTR
        ACALL   Get
        RET
;
;        
;       Conveyor2Stop  - Stops the second conveyor belt.
;       Only changes power outputs for appropiate motor.
Conveyor2Stop:   
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR2, put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        CLR     Acc.2
        MOVX    @DPTR, A
        MOV     _Power, A
;
        MOV     A, #0d                  ;We want the belt to be running at 0% speed
        ACALL   SetPWM1
;
        ;Restore A and DPTR
        ACALL   Get
        RET
;
;        
;       Conveyor2Forward - Starts the second conveyor belt, moving forward (ie. towards the UV lens)
;       Only changes power outputs for appropiate motor.
Conveyor2Forward:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR2, put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        CLR     Acc.2
        MOVX    @DPTR, A
        MOV     _Power, A
;
        MOV     A, #128d                  ;We want the belt to be running at 50% speed
        ACALL   SetPWM1
;
        ;Restore A and DPTR        
        ACALL   Get
        RET
;        
;        
;       Conveyor2Backward - Starts the second conveyor belt, moving backwards (ie. away from UV lens)
;       Only changes power outputs for appropiate motor.
Conveyor2Backward:
    ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR2 put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        SETB    Acc.2
        MOVX    @DPTR, A
        MOV     _Power, A
;
        MOV     A, #128d                  ;We want the belt to be running at 50% speed
        ACALL   SetPWM1
;
        ;Restore A and DPTR:
        ACALL   Get
        RET
;
;
;       IncWaferLEDs - Adds one wafer to waferslost leds. (ie, sets the next led from 0..4)
;       Only changes output on LEDs
;TODO: check whether bits are placed correctly :P
IncWaferLEDs:
        ;Store A, DPTR, R0:
        MOV     _StrVal, #00000001b
        ACALL   Store
        
        ;Next block of code calculates value of first 5 LEDs.
        MOV     DPTR, #0FE00h   ;LEDs are accessed through 0FE00h registers.
        MOV     A, _LEDs
        ANL     A, #11111000b
        RL      A
        CLR     Acc.0
        SETB    Acc.3
        MOV     R0, A
        
        ;R0 contains new value for LEDs. Next block gets remaining three bits and sets total 
        MOV     A, _LEDs
        ANL     A, #00000111b
        ORL     A, R0
        MOVX    @DPTR, A
        MOV     _LEDs, A
        
        
        ;Restore R0, Accu and datapointer.
        ACALL   Get
        RET
;
;
;       ResetWaferLEDS - Resets the LEDs to zero wafers lost
;       Only changes output on LEDs
ResetWaferLEDs:
	;Save Datapointer, Accu:
        MOV     _StrVal, #00000000b
        ACALL   Store

        ;Move LED adress into DPTR:
        MOV     DPTR, #0FE00h
;        
		;Save upper three leds:
		MOV	A, _LEDs
		ANL		A, #00000111b
;		
		;Put result back into LED registers:
		MOVX	@DPTR, A
        MOV    _LEDs, A
        ;Restore A, DPTR		
		ACALL   Get
        RET
;  
;      
;       ReadDoor1 - Checks whether door 1 (ie. the one furthest from the UV lens) is open. Carry = 0 > Door open, Carry = 1 > Door closed.
;       Changes Carry
ReadDoor1:
		;(Door1Closed <=> Carry= 1)
        MOV     _StrVal, #00000000b
		ACALL   Store

        MOV		C, P1.4         ;Store current sensor status
        MOV     A, #1b
        ACALL   WtTime          ;Wait 50 milliseconds for the sensor to settle
        MOV     Acc.0, C        ;Save old sensor status
        MOV     C, P1.4         ;Get new status
        MOV     Acc.1, C        ;Acc.0 = old, Acc.1 = new, C = new
        
        ;Now check whether Acc.1 and Acc.0 are the same (this takes a lot of instructions):
        ANL     C, Acc.0
        CPL     C
        MOV     Acc.2, C        ;Acc.2 = not (New AND Old)
        MOV     C, Acc.0
        ORL     C, Acc.1        ;C = (New OR Old)
        ANL     C, Acc.2        ;C = (New OR Old) AND NOT (New AND Old) = New XOR Old = (New <> Old)
        CPL     C               ;C = New = Old
        
        JC      ReadDoor1Ok       
        ACALL   ReadDoor1       ;Input was unstable, read again
        ACALL   Get
        RET

ReadDoor1Ok:
        MOV     C, Acc.0
        ACALL   Get
		RET
;
;		
;       ReadDoor2 - Checks whether door 2 (ie. the one closest to the UV lens) is open. Carry = 0 > Door open, Carry = 1 > Door closed.
;       Changes Carry
ReadDoor2:
		;(Door2Closed <=> Carry= 1)
        MOV     _StrVal, #00000000b
		ACALL   Store

        MOV		C, P1.6         ;Store current sensor status
        MOV     A, #1b
        ACALL   WtTime          ;Wait 50 milliseconds for the sensor to settle
        MOV     Acc.0, C        ;Save old sensor status
        MOV     C, P1.6         ;Get new status
        MOV     Acc.1, C        ;Acc.0 = old, Acc.1 = new, C = new
        
        ;Now check whether Acc.1 and Acc.0 are the same (this takes a lot of instructions):
        ANL     C, Acc.0
        CPL     C
        MOV     Acc.2, C        ;Acc.2 = not (New AND Old)
        MOV     C, Acc.0
        ORL     C, Acc.1        ;C = (New OR Old)
        ANL     C, Acc.2        ;C = (New OR Old) AND NOT (New AND Old) = New XOR Old = (New <> Old)
        CPL     C               ;C = New = Old
        
        JC      ReadDoor2Ok       
        ACALL   ReadDoor2       ;Input was unstable, read again
        ACALL   Get
        RET

ReadDoor2Ok:
        MOV     C, Acc.0
        ACALL   Get
		RET

;
;		
;       ReadSensor1 - Checks whether a wafer is in front of sensor 1 (ie, the one next to door 1). Carry = 0 > No wafer, Carry = 1 > Yes wafer.
;       Changes Carry
ReadSensor1:
        MOV     _StrVal, #00000000b
		ACALL   Store

        MOV		C, P3.4         ;Store current sensor status
        MOV     A, #1b
        ACALL   WtTime          ;Wait 50 milliseconds for the sensor to settle
        MOV     Acc.0, C        ;Save old sensor status
        MOV     C, P3.4         ;Get new status
        MOV     Acc.1, C        ;Acc.0 = old, Acc.1 = new, C = new
        
        ;Now check whether Acc.1 and Acc.0 are the same (this takes a lot of instructions):
        ANL     C, Acc.0
        CPL     C
        MOV     Acc.2, C        ;Acc.2 = not (New AND Old)
        MOV     C, Acc.0
        ORL     C, Acc.1        ;C = (New OR Old)
        ANL     C, Acc.2        ;C = (New OR Old) AND NOT (New AND Old) = New XOR Old = (New <> Old)
        CPL     C               ;C = New = Old
        
        JC      ReadSensor1Ok       
        ACALL   ReadSensor1     ;Input was unstable, read again
        ACALL   Get
        RET

ReadSensor1Ok:
        MOV     C, ACC.0
        ACALL   Get
		RET
;
;
;       ReadSensor2 - Checks whether a wafer is in front of sensor 2 (ie, the one next to door 2). Carry = 0 > No wafer, Carry = 1 > Yes wafer.
;       Changes Carry
ReadSensor2:
        MOV     _StrVal, #00000000b
		ACALL   Store

        MOV		C, P3.5         ;Store current sensor status
        MOV     A, #1b
        ACALL   WtTime          ;Wait 50 milliseconds for the sensor to settle
        MOV     Acc.0, C        ;Save old sensor status
        MOV     C, P3.5         ;Get new status
        MOV     Acc.1, C        ;Acc.0 = old, Acc.1 = new, C = new
        
        ;Now check whether Acc.1 and Acc.0 are the same (this takes a lot of instructions):
        ANL     C, Acc.0
        CPL     C
        MOV     Acc.2, C        ;Acc.2 = not (New AND Old)
        MOV     C, Acc.0
        ORL     C, Acc.1        ;C = (New OR Old)
        ANL     C, Acc.2        ;C = (New OR Old) AND NOT (New AND Old) = New XOR Old = (New <> Old)
        CPL     C               ;C = New = Old
        
        JC      ReadSensor2Ok       
        ACALL   ReadSensor2     ;Input was unstable, read again
        ACALL   Get
        RET

ReadSensor2Ok:
        MOV     C, ACC.0
        ACALL   Get
		RET
        
;  
;      
;       ReadEm - Checks whether the emergency button is pressed. Carry = 1 = Button pressed
;       Changes Carry
ReadEm:
        MOV     _StrVal, #00000011b
		ACALL   Store

        MOV		DPTR, #0FF00h
        MOVX    A, @DPTR
        MOV     C, ACC.0        ;Store the current button state

        MOV     R0, #200        ; Wait some time for the sensor to settle
RdEmO:  MOV     R1, #200        ; We do busy waiting here because wtTime might be
RdEmI:  DJNZ    R1, RdEmI       ; In a paused state
        DJNZ    R0, RdEmO
        
        MOVX    A, @DPTR
        ANL     A, #00000001b
        RL      A               ; Save a new Readout of IN0 in ACC.1
        MOV     ACC.0, C        ; Store the old readout in ACC.0
        
        ;Now check whether Acc.1 and Acc.0 are the same (this takes a lot of instructions):
        ANL     C, Acc.0
        CPL     C
        MOV     Acc.2, C        ;Acc.2 = not (New AND Old)
        MOV     C, Acc.0
        ORL     C, Acc.1        ;C = (New OR Old)
        ANL     C, Acc.2        ;C = (New OR Old) AND NOT (New AND Old) = New XOR Old = (New <> Old)
        CPL     C               ;C = New = Old
        
        JC      ReadStartOk       
        ACALL   ReadStart       ;Input was unstable, read again
        ACALL   Get
        RET
        
;  
;      
;       ReadEm - Checks whether the emergency button is pressed. Carry = 1 = Button pressed
;       Changes Carry
ReadStart:
        MOV     _StrVal, #00000000b
		ACALL   Store

        MOV		DPTR, #0FF00h
        MOVX    A, @DPTR
        MOV     C, ACC.0        ;Store the current button state
        MOV     A, #1b
        ACALL   WtTime          ;Wait 50 milliseconds for the sensor to settle
        MOVX    A, @DPTR
        ANL     A, #00000001b
        RL      A               ; Save a new Readout of IN0 in ACC.1
        MOV     ACC.0, C        ; Store the old readout in ACC.0
        
        ;Now check whether Acc.1 and Acc.0 are the same (this takes a lot of instructions):
        ANL     C, Acc.0
        CPL     C
        MOV     Acc.2, C        ;Acc.2 = not (New AND Old)
        MOV     C, Acc.0
        ORL     C, Acc.1        ;C = (New OR Old)
        ANL     C, Acc.2        ;C = (New OR Old) AND NOT (New AND Old) = New XOR Old = (New <> Old)
        CPL     C               ;C = New = Old
        
        JC      ReadStartOk       
        ACALL   ReadStart       ;Input was unstable, read again
        ACALL   Get
        RET

ReadStartOk:
        MOV     C, ACC.0
		ACALL   Get
        RET
        
;
;        
;       LOpenDoor1 - Sets air-valves to open door 1, (ie, the one furthest from the UV lens). No acknowledgement as to whether this door has succesfully opened - check with ReadDoor1
;       Only changes corresponding high-power output
LOpenDoor1:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Copy poweroutputs to A, change PWR3, put result back again:
        MOV     DPTR, #0FD00h
        MOV    A, _Power
        SETB    Acc.3
        MOVX    @DPTR, A
        MOV     _Power, A
        ;Restore A and DPTR
        ACALL   Get
        RET
;
;        
;       LOpenDoor2- Sets air-valves to open door 2, (ie, the one closest to the UV lens). No acknowledgement as to whether this door has succesfully opened - check with ReadDoor2
;       Only changes corresponding high-power output
LOpenDoor2:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR5, put result back again:
        MOV     DPTR, #0FD00h
        MOV    A, _Power
        SETB    Acc.5
        MOVX    @DPTR, A
        MOV    _Power, A
        ;Restore A and DPTR
        ACALL   Get
        RET
;
;        
;       LCloseDoor1 - Sets air-valves to close door 1 (ie, the one furthest from the UV lens). No acknowledgement as to whether this door has succesfully closed - check with ReadDoor1
;       Only changes corresponding high-power output
LCloseDoor1:
        ;Save A and DPTR:
         MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR4, put result back again:
        MOV     DPTR, #0FD00h
        MOV    A, _Power
        SETB    Acc.4
        MOVX    @DPTR, A
        MOV    _Power, A
        ;Restore A and DPTR:
        ACALL   Get
        RET
;
;        
;       LCloseDoor2 - Sets air-valves to close door 2 (ie, the one furthest from the UV lens). No acknowledgement as to whether this door has succesfully closed - check with ReadDoor2
;       Only changes corresponding high-power output
LCloseDoor2:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR6, put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        SETB    Acc.6
        MOVX    @DPTR, A
        MOV    _Power, A
        ;Restore A, DPTR
        ACALL   Get
        RET
;        
;        
;       LStopDoor1  - Stops air from going to door 1
;       Only changes corresponding high-power outputs
LStopDoor1:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR3 and PWR 4, put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        CLR     Acc.3
        CLR     Acc.4
        MOVX    @DPTR, A
        MOV    _Power, A
        ;Restore A, DPTR
        ACALL   Get
        RET
;        
;        
;       LStopDoor2 - Stops air from going to door 2
;       Only changes corresponding high-power outputs
LStopDoor2:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR5 and PWR 6, put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        CLR     Acc.5
        CLR     Acc.6
        MOVX    @DPTR, A
        MOV     _Power, A
        ;Restore A, DPTR
        ACALL   Get
        RET
;
;        
;       SetUVon - Sets UV lamp to burning. (no timing involved)
;       Only changes corresponding high-power output
SetUVon:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR7, put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        SETB    Acc.7
        MOVX    @DPTR, A
        MOV     _Power, A
        ;Restore A, DPTR
        ACALL   Get
        RET
;
;        
;       SetUVoff - Sets UV lamp off (no timing involved)
;       Only changes corresponding high-power output
SetUVoff:
        ;Save A and DPTR:
        MOV     _StrVal, #00000000b
        ACALL   Store
;        
        ;Addres of PWR outputs = 0FD00h, non bitadressable
        ;Copy poweroutputs to A, change PWR7, put result back again:
        MOV     DPTR, #0FD00h
        MOV     A, _Power
        CLR     Acc.7
        MOVX    @DPTR, A
        MOV     _Power, A
        ;Restore A, DPTR
        ACALL   Get
        RET
        
;   Return: Carry = 1 => Lost five wafers. Carry = 0 => not lost five wafers.
NotLostFive:
        MOV     _StrVal, #00000000b
        ACALL   Store
        
        MOV     A, _LEDs                    ;Set C to 0, set A to led-value
        CLR    C
        
        ;When there are NOT five wafers lost, at least one led is off. If there are five wafers lost, all five LEDs are on.
        JNB     Acc.3, NNot
        JNB     Acc.4, NNot
        JNB     Acc.5, NNot
        JNB     Acc.6, NNot
        JNB     Acc.7, NNot
        ;{There are five wafers lost!}
        SETB    C
NNot:   ACALL   GET             
        RET
;

;SetPWM1: Sets power1 on the value defined in A (0..255 = 0%..10%)
SetPWM1:		                    ; power level in A for channel 2:
        MOV	CCL2,A	                ; values 0..255 = 0%..100%
        ORL	CT1CON,#20h	            ; update at end of current cycle
        RET		                    ; output to PWR1, via JP2
        
;SetPWM0: Sets power0 on the value defined in A (0..255 = 0%..10%)        
SetPWM0:		                    ; power level in A for channel 3:
        MOV	CMP2L,A	                ; values 0..255 = 0%..100%
        ORL	CT2CON,#20h	            ; update at end of current cycle
        RET		                    ; output to PWR0, via JP1

        END     iol_subs