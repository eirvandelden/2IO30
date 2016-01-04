TITLE 'Main Program'
SBTTL 'OGO1.3 group 7, 2006-2007'
;
; This is the main module of the waferstepper controller. It implements the following subroutines:
; Crash: A 'subroutine' that will loop to itself forever.
; Labels used are (mostly) equivalent to those in the UPPAAL model.
Bootup:
        ORG     00h
        AJMP    main                    ;Skip reserved memory
        
        
        ;	skip first bytes + includes
		INCL 'int_vect.asm'

		ORG 0080h
		INCL 'mem_subs.asm'
		INCL 'wt_subs.asm'
		INCL 'iol_subs.asm'
		INCL 'ioh_subs.asm'
        INCL 'emergenc.asm'
        INCL 'init.asm'

main:   ;Start of program
        MOV     SP, #8
        ACALL   init                    ;Initialise all components to their desired states.
        
ProgramPaused:
        MOV     DPTR, #0FF00h           ;The adress of the dip-switches, of which switch 0 is the 'ready button'
        MOVX     A, @DPTR
        JNB     Acc.0, ProgramPaused
        
        ;Ready  button has beed enabled.

ReadyToLoadWafer:
        ACALL   LoadWafer               ;Loads a wafer. C = 1: succes, C = 0: Failure
        JNC     ProgramPaused
        
        ;We want to move the wafer forward for 1 second
        MOV     A, #20d
;TODO: check the timing of this!
        ACALL   MoveForwardT
        
        ACALL   CloseDoor1
        JNC     DoorJammed              ;Check whether the door actually closed
        
        ACALL   OpenDoor2
        JNC     DoorJammed              ;Check whether the door actually opened
        
        ACALL   MoveForwardS2           ;Moves the wafer to the sensor
        JNC     WaferLost               ;Check whether wafer has arrived

        MOV     A, #5d
;TODO: check the timing of this!
        ACALL   MoveForwardT            ;move wafer under UV lamp
        ACALL   Burn                    ;burn the wafer
        JNC     ReadyToLoadWafer
        
        ACALL   MoveBackwardS2          ;move wafer back to sensor
        JNC     WaferLost
        
        MOV     A, #20d
;TODO: check the timing of this!
        ACALL   MoveBackwardT
        
        ACALL   CloseDoor2              ;Closes door 2
        JNC     DoorJammed              ;Check whether door has closed
        
        ACALL   OpenDoor1               ;Opens door 1
        JNC     DoorJammed              ;Check whether door has opened
        
        ACALL   MoveBackwardS1          ;Move wafer to sensor 1
        JNC     WaferLost               ;Check whether wafer has arrived
        
        MOV     A, #60d                 
;TODO: check the timing of this!
        ACALL   MoveBackwardT           ;Move burnt wafer off the belt
        
        AJMP    ReadyToLoadWafer
        
;This state is reached when a door is stuck. It moves to Crash.
DoorJammed:
        AJMP    CrashMain
        
CrashMain:
        AJMP    CrashMain               ;Program Crash, restart required.
        
WaferLost:
        ACALL   LostWafer               ;This wafer is lost, prepare for handling the next one
        AJMP    ReadyToLoadWafer        ;And then start handling the next one if possible

        END Bootup