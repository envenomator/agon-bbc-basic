;
; Title: BBC Basic ADL for AGON - Initialisation Code
;

    .assume     ADL = 1

    .global     AGON_START
    .global     AGON_END

    .include    "equs.inc"
    .include    "mos.inc"
    .include    "macros.inc"

    .section    .init

    JP          AGON_START

EXEC_NAME:
    .asciz      "BBCBASIC.BIN"  ; Executable name (argv[0])
chain_start:
    .asciz      "CHAIN  \x22"   ; Begin part of chain string
chain_end:
    .byte       0x22,0x0d,0     ; End part of chain string
    .balign     64
    .ascii      "MOS"           ; MOS signature
    .byte       0x00            ; Header version
    .byte       0x01            ; Run mode (0=Z80, 1=ADL)

AGON_START:
    PUSH        AF              ; Preserve registers
    PUSH        BC
    PUSH        DE
    PUSH        IX
    PUSH        IY

    LD          (SP_EXIT), SP   ; Save MOS area stack pointer
    LD          SP, STACKTOP    ; Set the new stack pointer for the program (from linker.conf)
    CALL        CLEAR_RAM
    PUSH        HL

    CALL        PARSE_PARAMS
    CALL        GET_SYSVARS
    LD          HL, ACCS        ; Clear the ACCS
    LD          (HL), 0
    POP         HL
    LD          B, 0            ; C = argc
    LD          A, C			
    CP          2
    JR          Z, AUTOLOAD	 	  ; 1 parameters = autoload
    JR          C, STARTBASIC   ; 0 parameter (program name) = normal start
    CALL        STAR_VERSION    ; Output the AGON version
    CALL        TELL
    .ascii      "Usage:\n\r"
    .asciz      "BBCBASIC <filename>\n\r"
    JR          AGON_END
;							
; Copies CHAIN prefix and filename to ACCS, sets boolean STARTUPCMD
AUTOLOAD:
    PUSH        HL              ; save original parameter string
    LD          IX, ACCS
    LD          HL, chain_start ; copy start of string
    CALL        APPEND_CSTR
    POP         HL
    CALL        APPEND_CSTR     ; append filename
    LD          HL, chain_end
    CALL        APPEND_CSTR     ; append string close
    LD          A, 1
    LD          (STARTUPCMD), A ; mark autostart
;
STARTBASIC:
    JP          START           ; Start BASIC

; Return safely to MOS (called from *BYE / QUIT)
AGON_END:
    LD          SP, (SP_EXIT)   ; Restore stack pointer
    LD          HL, 0           ; Make sure MOS doesn't show an error
    POP         IY
    POP         IX
    POP         DE
    POP         BC
    POP         AF

    RET

; Appends C-string to target
;
; In:
;   HL = pointer to string
;   IX = pointer to target
;
; Out:
;   IX points to first ending zero in string
;
APPEND_CSTR:
    LD          A, (HL)
    LD          (IX+0), A
    OR          A
    RET         Z
    INC         HL
    INC         IX 
    JR          APPEND_CSTR

; Store pointer to sysvars for later consumption immediately
GET_SYSVARS:
    PUSH        BC
    PUSH        DE
    PUSH        HL
    PUSH        IX
    PUSH        IY

    MOSCALL     mos_sysvars
    LD          (MOS_SYSVARS),IX

    POP         IY
    POP         IX
    POP         HL
    POP         DE
    POP         BC

    RET

; Clear application RAM
CLEAR_RAM:
    PUSH        HL
    PUSH        DE
    PUSH        BC

    LD          HL, bss_start
    LD          DE, bss_start + 1
    LD          BC, bss_size
    XOR         A
    LD          (HL), A
    LDIR

    POP         BC
    POP         DE
    POP         HL
    RET

;
; Parse parameter string
;
; In:
;   HL = parameter string
;   IX = pointer to empty array of stringpointers
; Out:
;   C  = number of parameters in argc style, counting 'filename' which isn't given by MOS
;   Tokenized in-place parameter string with zeroes
;
PARSE_PARAMS:
    LD          BC, 1              ; Skip checking filename
    LD          B, ARGV_PTRS_MAX-1
1:
    PUSH        BC                 ; save counter
    PUSH        HL                 ; save token start
    CALL        GET_TOKEN
    LD          A, C               ; token length
    POP         DE                 ; token start
    POP         BC                 ; argc
    OR          A
    RET         Z                  ; no more tokens
    PUSH        HL
    POP         DE
    CALL        SKIP_SPACES
    XOR         A
    LD          (DE), A            ; null terminate
    INC         IX
    INC         IX
    INC         IX
    INC         C
    LD          A, C
    CP          B
    JR          C, 1b

;
; Get next token
;
; In:
;   HL = string
;
; Out:
;   HL = first char after token
;   C  = length
;
GET_TOKEN:
    LD          C, 0
1:
    LD          A, (HL)
    OR          A
    RET         Z
    CP          13 ; CR
    RET         z
    CP          ' '
    RET         Z
    INC         HL
    INC         C
    JR          1b

;
; Skip spaces
;
; In:
;   HL = string
;
; Out:
;   HL = first non-space
;
SKIP_SPACES:
    LD          A, (HL)
    CP          ' '
    RET         NZ

    INC         HL
    JR          SKIP_SPACES

