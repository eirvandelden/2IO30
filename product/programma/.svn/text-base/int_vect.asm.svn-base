; Put any interrupt handlers in this file
; Please keep the actions in this file very short,
; like jumping to another location where the real interrupt handler is defined.



ORG	000Bh		; Timer 0 interrupt, for the WtTime subroutine
        AJMP	WtDec		; Just jump to the WtDec routine

ORG 0013h       ; Input P3.3 interrupt, emergency button
        AJMP    HandleEm    ; Just jump to the HandleEm subroutine
        
ORG	001Bh		; Timer 1 interrupt, for the AlrtTime subroutine
        AJMP	AlrtDec		; Just jump to the AlrtDec routine