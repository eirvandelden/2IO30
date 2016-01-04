; 
; Included subroutines:
;	MoveForwardT, MoveBackWardT, MoveForwardS1, MoveForwardS2, MoveBackwardS1, MoveBackwardS2, LoadWafer - Routines for moving a wafer
;	OpenDoor1, OpenDoor2, CloseDoor1, CloseDoor2 - Routines for opening and closing doors
;          HandleFalloff: Routine for handling a wafer that has fallen off

ioh_subs:

;       Start of actual subroutines:
;
;	MoveForwardT - Moves the second conveyor belt forward during s/20 seconds
MoveForwardT:
        ACALL	Conveyor2Forward
        ACALL	WtTime              ;WtTime takes exactly the same argument as this subroutine
        ACALL	Conveyor2Stop
        RET


;	MoveBackwardT - Moves the second conveyor belt backward during s/20 seconds
MoveBackwardT:
        ACALL	Conveyor2Backward
        ACALL	WtTime              ;WtTime takes exactly the same argument as this subroutine
        ACALL	Conveyor2Stop
        RET


;	MoveForwardS1 - Moves the second conveyor belt forward until sensor 1 recognizes a wafer(Caary is 1) or 5 seconds have passed(Carry is 0)
MoveForwardS1:
        MOV    _StrVal, #00000111b		;Save A, DPTR, R0, R1, R2
        ACALL   Store
        
        ACALL	Conveyor2Forward		;Start conveyor
        MOV	    A,  #100		    	;Set alert timer to 5 seconds
        MOV 	R0, #0		            ;Clear return adress for alert, we don't use it
        MOV 	R1, #0
        ACALL   AlrtTime		    	;Start alert timer
LoopFS1:MOV     R2,AlrtS
        CJNE    R2,#0,DoneFS1           ;Check for an alert
        ACALL	ReadSensor1			    ;Read sensor
        JNC     LoopFS1                 ;If sensor 1 doesn't read anything wait again
        ACALL	AlrtStop			    ;Stop alert timer if sensor sees wafer
DoneFS1:ACALL	Conveyor2Stop			;Stop conveyor
        ACALL   Get				        ;Restore A, DPTR, R0, R1, R2
        RET             ;n.b. Return value is automatically satisfied through ReadSensor1
        

;	MoveForwardS2 - Moves the second conveyor belt forward until sensor 2 recognizes a wafer(Carry is 1) or 5 seconds have passed(Carry is 0)
MoveForwardS2:
        MOV    _StrVal, #00000111b		;Save A, DPTR, R0, R1, R2
        ACALL   Store
        ACALL	Conveyor2Forward	    ;Start conveyor
        MOV	    A,  #100		    	;Set alert timer to 5 seconds
        MOV 	R0, #0		            ;Clear return adress for alert, we don't use it
        MOV 	R1, #0
        ACALL   AlrtTime			    ;Start alert timer
LoopFS2:MOV     R2,AlrtS
        CJNE    R2,#0,DoneFS2           ;Check for an alert
        ACALL	ReadSensor2			    ;Read sensor
        JNC     LoopFS2                 ;If sensor 2 doesn't read anything wait again
        ACALL	AlrtStop			    ;Stop alert timer if sensor sees wafer
DoneFS2:ACALL	Conveyor2Stop		    ;Stop conveyor
        ACALL   Get				        ;Restore A, DPTR, R0, R1, R2
        RET					;n.b. Return value is automatically satisfied through ReadSensor2
        

;	MoveBackwardS1 - Moves the second conveyor belt backward until sensor 1 recognizes a wafer(Carry is 1) or 5 seconds have passed(Carry is 0)
MoveBackwardS1:
        MOV    _StrVal, #00000111b		;Save A, DPTR, R0, R1, R2
        ACALL   Store
        ACALL	Conveyor2Backward		;Start conveyor
        MOV	    A,  #100		    	;Set alert timer to 5 seconds
        MOV 	R0, #0		            ;Clear return adress for alert, we don't use it
        MOV 	R1, #0
        ACALL   AlrtTime			;Start alert timer
LoopBS1:MOV     R2,AlrtS
        CJNE    R2,#0,DoneBS1     ;Check for an alert
        ACALL	ReadSensor1			;Read sensor
        JNC     LoopBS1             ;If sensor 1 doesn't read anything wait again
        ACALL	AlrtStop			;Stop alert timer if sensor sees wafer
DoneBS1:ACALL	Conveyor2Stop			;Stop conveyor
        ACALL   Get				;Restore A, DPTR, R0, R1, R2
        RET					;n.b. Return value is automatically satisfied through ReadSensor1
        

;	MoveBackwardS2 - Moves the second conveyor belt backward until sensor 2 recognizes a wafer(Carry is 1) or 5 seconds have passed(Carry is 0)
MoveBackwardS2:
        MOV    _StrVal, #00000111b		;Save A, DPTR, R0, R1, R2
        ACALL   Store
        ACALL	Conveyor2Backward		;Start conveyor
        MOV	    A,  #100		    	;Set alert timer to 5 seconds
        MOV 	R0, #0		            ;Clear return adress for alert, we don't use it
        MOV 	R1, #0
        ACALL   AlrtTime			;Start alert timer
LoopBS2:MOV     R2,AlrtS
        CJNE    R2,#0,DoneBS2        ;Check for an alert
        ACALL	ReadSensor2			;Read sensor
        JNC     LoopBS2             ;If sensor 2 doesn't read anything wait again
        ACALL	AlrtStop			;Stop alert timer if sensor sees wafer
DoneBS2:ACALL	Conveyor2Stop			;Stop conveyor
        ACALL   Get				;Restore A, DPTR, R0, R1, R2
        RET					;n.b. Return value is automatically satisfied through ReadSensor2
        

;	LoadWafer - Moves the first and second conveyor belt forward until sensor 1 recognizes a wafer(Carry is 1) or 10 seconds have passed(Carry is 0)
LoadWafer:
        MOV    _StrVal, #00000111b		;Save A, DPTR, R0, R1, R2
        ACALL   Store
        ACALL	Conveyor1Start			;Starts conveyors
        ACALL	Conveyor2Forward
        MOV	    A,  #200		    	;Set alert timer to 5 seconds
        MOV 	R0, #0		            ;Clear return adress for alert, we don't use it
        MOV 	R1, #0
        ACALL   AlrtTime		    ;Start alert timer
LoopW:  MOV     R2,AlrtS
        CJNE    R2,#0,DoneW     ;Check for an alert
        ACALL	ReadSensor1			;Read sensor
        JNC     LoopW               ;If sensor 1 doesn't read anything wait again
    	ACALL	AlrtStop			;Stop alert timer if sensor sees wafer
DoneW:	ACALL	Conveyor1Stop		;Stops conveyors
        ACALL	Conveyor2Stop
        ACALL   Get				;Restore A, DPTR, R0, R1, R2
        RET					;n.b. Return value is automatically satisfied through ReadSensor1


;	OpenDoor1 - Check if door 2 is closed, and if it is closed, try(maximum 5 times) to open door 1 and if it succeed Carry is 1, else Carry is 0. If door 2 is open, then keep door 1 closed(Carry is 0).
OpenDoor1:
        MOV    _StrVal, #00001111b		;Save A, DPTR, R0, R1, R2, R3
        ACALL   Store
        ACALL	ReadDoor2
        JNC	    StopD1              ;Just return false if door 2 is open
        MOV	    R3,#5               ;We want to try 5 times

TryAgainOD1:
        ACALL	LOpenDoor1			;Sets air-valves to open door 1
        MOV     A, #20              ;We need to wait 1 second
        ACALL   WtTime
        ACALL   LStopDoor1          ;Close the valves for door 1
        
        ACALL   ReadDoor1           ;Check whether it's open
        JNC     GoodOD1            ;If it's open, return true
        
        DEC     R3
        CJNE    R3,#0,TryAgainOD1   ;If we haven't tried 5 times already, try again
        
        CLR     C                   ;Still bad luck after 5 tries, return false
        AJMP    StopD1 

GoodOD1:SETB	C
StopD1:	ACALL	Get				;Restore A, DPTR, R0, R1, R2, R3
        RET


;	OpenDoor2 - Check if door 1 is closed, and if it is closed, try(maximum 5 times) to open door 2 and if it succeed Carry is 1, else Carry is 0. If door 1 is open, then keep door 2 closed(Carry is 0).
;	OpenDoor1 - Check if door 2 is closed, and if it is closed, try(maximum 5 times) to open door 1 and if it succeed Carry is 1, else Carry is 0. If door 2 is open, then keep door 1 closed(Carry is 0).
OpenDoor2:
        MOV    _StrVal, #00001111b		;Save A, DPTR, R0, R1, R2, R3
        ACALL   Store
        ACALL	ReadDoor1
        JNC	    StopD2              ;Just return false if door 2 is open
        MOV	    R3,#5               ;We want to try 5 times

TryAgainOD2:
        ACALL	LOpenDoor2			;Sets air-valves to open door 1
        MOV     A, #20              ;We need to wait 1 second
        ACALL   WtTime
        ACALL   LStopDoor2          ;Close the valves for door 1
        
        ACALL   ReadDoor2           ;Check whether it's open
        JNC     GoodOD2             ;If it's open, return true
        
        DEC     R3
        CJNE    R3,#0,TryAgainOD2   ;If we haven't tried 5 times already, try again
        
        CLR     C                   ;Still bad luck after 5 tries, return false
        AJMP    StopD2 

GoodOD2:SETB	C
StopD2:	ACALL	Get				;Restore A, DPTR, R0, R1, R2, R3
        RET


;	CloseDoor1 - Close door 1 and check if it is closed, if it is still open try again for maximum 5 times. If door 1 is closed, then the Carry is 1, else the Carry is 0.
CloseDoor1:
        MOV    _StrVal, #00001111b		;Save A, DPTR, R0, R1, R2, R3
        ACALL   Store
        MOV	    R3,#5
TryAgainCD1:
        ACALL	LCloseDoor1			;Sets air-valves to close door 1 
        MOV     A, #30              ;We need to wait 1 second
        ACALL   WtTime
        ACALL   LStopDoor1          ;Close the valves for door 1

        ACALL	ReadDoor1			;Check if door 1 has closed
        JC	    GoodCD1             ;If it has, return true
        
        DEC	R3
        CJNE	R3,#0,TryAgainCD1	;If door 1 is still open, try again for a maximum of 5 times
        
        CLR     C                   ;5 tries and still bad luck, return false
        
GoodCD1:ACALL	Get				;Restore A, DPTR, R0, R1, R2, R3
        RET


;	CloseDoor2 - Close door 2 and check if it is closed, if it is still open try again for maximum 5 times. If door 2 is closed, then the Carry is 1, else the Carry is 0.
CloseDoor2:
        MOV    _StrVal, #00001111b		;Save A, DPTR, R0, R1, R2, R3
        ACALL   Store
        MOV	    R3,#5
TryAgainCD2:
        ACALL	LCloseDoor2			;Sets air-valves to close door 1 
        MOV     A, #30              ;We need to wait 1 second
        ACALL   WtTime
        ACALL   LStopDoor2          ;Close the valves for door 1

        ACALL	ReadDoor2			;Check if door 1 has closed
        JC	    GoodCD2             ;If it has, return true
        
        DEC	R3
        CJNE	R3,#0,TryAgainCD2	;If door 1 is still open, try again for a maximum of 5 times
        
        CLR     C                   ;5 tries and still bad luck, return false
        
GoodCD2:ACALL	Get				;Restore A, DPTR, R0, R1, R2, R3
        RET
        

;           HandleFalloff - increase the lostwafercount,checks whether five wafers have fallen off already and Crashes if needed.        
LostWafer:        
        ACALL   IncWaferLeds        ;Increase the lostwafercount.
        
        ACALL   NotLostFive         ;Check whether this is the fifth wafer lost.
        JC      CrashIOH            ;If so, Crash.
        
        ACALL   CloseDoor2          ;Close the second door
        JNC     CrashIOH          ;Crash if unsuccesful
        
        ACALL   OpenDoor1           ;Open second door
        JNC     CrashIOH          ;Crash if unsuccesful
        
        RET

Burn:   MOV     _StrVal, #0
        ACALL   Store
        
        MOV     _EmTarget, #1       ; While burning, we need another emergency handler
        ACALL   SetUVOn             ; Start burning
        
        MOV     A, #40
        ACALL   WtTime              ; Wait for two seconds
        
        ACALL   SetUVOff            ; Stop burning
        MOV     _EmTarget, #0       ; Use the default emergency handler again
        
        ACALL   Get
        SETB    C
        RET
        
BurnFail:
        MOV     _EmTarget, #0
        ACALL   Get
        CLR     C
        RET
        
CrashIOH:
        AJMP    CrashIOH
        
        END     ioh_subs