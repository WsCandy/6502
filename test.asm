;;  1. The iNes Header
    .db "NES", $1a	; iNes identifier
    .db $01			; number of PRG-Rom blocks the game will have
    .db $01			; number of CHR-Rom blocks the game will have
    .db $00, $01	; control bytes    
    .db $00, $00, $00, $00, $00, $00, $00, $00
	
;; 2. Constants and Variables
	
    .enum $0000
    .ende

;; 3. Set the code starting point
	
    .org $C000		; Code starting point at address $C000

;; 4. The RESET routine, fires on game launch and reset button being pressed

RESET:
    SEI				; Ignore interupts for the routine		
    
    LDA: #$00		; Load 0 into the accumulator
    STA: $2000		; Disables the NMI
    STA: $2001		; Disables rendering
    
    STA: $4010		
    STA: $4015
    LDA: #$40		; Loads hex value 40 which is decimal 64
    
    STA: $4017
    
    CLD				; Disables decimal code
    LDX #$FF		; Load value 255
    TXS				; Initialises the stack
    
    bit $2002

vBlankWait1:
    bit $2002
    BPL vBlankWait1
    
    LDA #$00		; loads zero into the accumulator
    LDX #$00		; loads zero into x
    
ClearMemoryLoop:
    STA $0000,x		; Store accumulator (0) into address $0000 + x 
    STA $0100,x		; Store accumulator (0) into address $0100 + x
    STA $0200,x		; Store accumulator (0) into address $0200 + x 
    STA $0300,x		; Store accumulator (0) into address $0300 + x 
    STA $0400,x		; Store accumulator (0) into address $0400 + x 
    STA $0500,x		; Store accumulator (0) into address $0500 + x 
    STA $0600,x		; Store accumulator (0) into address $0600 + x 
    STA $0700,x		; Store accumulator (0) into address $0700 + x 
    INX				; x goes up by one, so all of those +x's at the end that were zero the first time through are increased.
    BNE ClearMemoryLoop
    
vBlankWait2:
    bit $2002
    BPL vBlankWait2
    
    LDA #%10010000	; Loads this binary number to accumulator
    STA $2000		; Storing it here turns back NMI on
    LDA #%00011110	; Loads this binary number to accumulator
    STA $2001		; enables rendering
    
   	JMP MainGameLoop
    
;; 5. The NMI
NMI:
    PHA
    TXA
    PHA
    TYA
    PHA
    
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014
    
    LDA #%10010000
    STA $2000
    LDA #%00011110
    STA $2001
    
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

;; 6. The Main Game Loop
MainGameLoop:
    JMP MainGameLoop
    
;; 7. Sub Routines

;; 8. Includes and data tables

;; 9. The Vectors
    .org $fffa
    .dw NMI
    .dw RESET
    .dw 00