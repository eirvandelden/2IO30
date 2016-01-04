TITLE 'Memory Management Routines'
SBTTL 'OGO1.3 group 7, 2006-2007'

; This file uses internal memory addresses 7Ch to 7Eh

;Included DS:
;       _StrVal - used in Store and Get, to push/pop the right adresses
;       Store, Get - Pushes and Pops certain values, depending on _StrVal
;
;Included subroutines:
;       Store - Will push A and DPTR, according to _StrVal will push Rn (Rn is pushed when _StrVal.n = 1) Also pushes it's own version of _StrVal, 
;               so it _StrVal van be changed afterwards (Store can be usd multiple times)
;       Get - Will pop values pushed by Store. Be careful only to use when something is really Stored!

mem_subs:

_StrVal  EQU    7Ch                 ;Memory address for parameters of Store and Get operations.
_RetToL  EQU    7Dh                 ;Memory address for storing return addresses of these routines
_RetToH  EQU    7Eh

;       Store - Will push A, DPTR and R0 through R7. R0 through R7 are only pushed if _StrVal.n is true. Will also push which Rn's are stored.
;       To summarize: Store pushes A, DPL, DPH. Additionally, it will push Rn if _StrVal.n is 1 (first pushing R0, working its way to R7), then it pushed _StrVal.
;       Changes Stack
Store:
        ;Before we start pushing lots of things on the stack, first take our return address of it
        POP     _RetToH
        POP     _RetToL

        ;First, push A, DPTR.
        PUSH    ACC
        PUSH    DPL
        PUSH    DPH
        
        ;Switch A and _StrVal
        XCH     A, _StrVal
        

        JNB      Acc.0, Store1   ;Check whether R0 should be pushed
        ;if it should be pushed:
        XCH     A, R0
        PUSH    ACC
        XCH     A, R0           ;Effectively R0 is pushed.
;
Store1: JNB      Acc.1, Store2   ;Check whether R1 should be pushed
        ;if it should be pushed:
        XCH     A, R1
        PUSH    ACC
        XCH     A, R1           ;Effectively R1 is pushed
;
Store2: JNB      Acc.2, Store3   ;Check whether R2 should be pushed
        ;if it should be pushed:
        XCH     A, R2
        PUSH    ACC
        XCH     A, R2           ;Effectively R2 is pushed
;
Store3: JNB      Acc.3, Store4   ;Check whether R3 should be pushed
        ;if it should be pushed:
        XCH     A, R3
        PUSH    ACC
        XCH     A, R3           ;Effectively R3 is pushed
;
Store4: JNB      Acc.4, Store5   ;Check whether R4 should be pushed
        ;if it should be pushed:
        XCH     A, R4
        PUSH    ACC
        XCH     A, R4           ;Effectively R4 is pushed
;
Store5: JNB      Acc.5, Store6   ;Check whether R5 should be pushed
        ;if it should be pushed:
        XCH     A, R5
        PUSH    ACC
        XCH     A, R5           ;Effectively R5 is pushed
;
Store6: JNB      Acc.6, Store7   ;Check whether R6 should be pushed
        ;if it should be pushed:
        XCH     A, R6
        PUSH    ACC
        XCH     A, R6           ;Effectively R6 is pushed
;
Store7: JNB      Acc.7, StoreD   ;Check whether R7 should be pushed
        ;if it should be pushed:
        XCH     A, R7
        PUSH    ACC
        XCH     A, R7           ;Effectively R7 is pushed
;
StoreD: ;Right, we're done pushing everything. Now we only need to push _StrVal, which is stored in A for the moment.
        PUSH    ACC
        ;We need to put back the original _StrVal and A values. A simply exchange will take care of this for us:
        XCH     A, _StrVal
        
;To summarize: Pushed (in this order): A, DPL, DPH, R0, R1..., R7, _StrVal.
;R0 - R7 are only stored if the corresponding bit in the pushed _StrVal is 1.

        ;Now push our own return address back on top of the stack before we return
        PUSH    _RetToL
        PUSH    _RetToH
        RET
;
;
;       Get - Will Pop all values stored by Store, returning stack to the state before Store was called. Be sure Store was actually called before this, and nothing else is on top of the stack anymore!
;       Changes Stack., A, DPL, DPH. According to pushed _StrVal, R0 through R7 will be changed. Current _StrVal will stay unchanged.
Get:
        ;Before we start popping everything off the stack, store our return address somewhere safe
        POP     _RetToH
        POP     _RetToL

        ;We need to know which Rn's to pop:
        POP     ACC
;
        JNB      Acc.0, Get1     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R0
        POP     ACC
        XCH     A, R0           ;Effectively, R0 has been popped.
;        
Get1:   JNB      Acc.1, Get2     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R1
        POP     ACC
        XCH     A, R1           ;Effectively, R0 has been popped.
;
Get2:   JNB      Acc.2, Get3     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R2
        POP     ACC
        XCH     A, R2           ;Effectively, R0 has been popped.
;
Get3:   JNB      Acc.3, Get4     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R3
        POP     ACC
        XCH     A, R3           ;Effectively, R0 has been popped.
;
Get4:   JNB      Acc.4, Get5     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R4
        POP     ACC
        XCH     A, R4           ;Effectively, R0 has been popped.
;
Get5:   JNB      Acc.5, Get6     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R5
        POP     ACC
        XCH     A, R5           ;Effectively, R0 has been popped.
;
Get6:   JNB      Acc.6, Get7     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R6
        POP     ACC
        XCH     A, R6           ;Effectively, R0 has been popped.
;
Get7:   JNB      Acc.7, GetD     ;Pop when needed, else skip the next block:
        ;if it should be popped:
        XCH     A, R7
        POP     ACC
        XCH     A, R7           ;Effectively, R0 has been popped.
;
GetD:   ;Ok, we're done popping all Rn's. We should pop DPTR and A.
        POP     DPH
        POP     DPL
        POP     ACC               ;Current value of A is lost - this was only used for checking which Rn's should be popped.
        ;Stack is back to what it was before Store.
        
        ;Push back our return address before we return
        PUSH     _RetToL
        PUSH    _RetToH
        RET

        END     mem_subs