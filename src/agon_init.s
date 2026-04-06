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
    .asciz      "BBCBASIC.BIN" ; Executable name (argv[0])
    .balign     64
    .ascii      "MOS"          ; MOS signature
    .byte       0x00           ; Header version
    .byte       0x01           ; Run mode (0=Z80, 1=ADL)

AGON_START:
    PUSH        AF             ; Preserve registers
    PUSH        BC
    PUSH        DE
    PUSH        IX
    PUSH        IY

    LD          (SP_EXIT), SP  ; Save MOS area stack pointer

    LD          IX, _argv_ptrs ; argv pointer array
    PUSH        IX
    CALL        PARSE_PARAMS
    POP         IX             ; IX = argv

    LD          B, 0           ; C = argc
    CALL        CLEAR_RAM
    CALL        GET_SYSVARS

    JP          START          ; Enter user code

; Return safely to MOS (called from *BYE / QUIT)
AGON_END:
    LD          SP, (SP_EXIT) ; Restore stack pointer
    LD          HL, 0          ; Make sure MOS doesn't show an error
    POP         IY
    POP         IX
    POP         DE
    POP         BC
    POP         AF

    RET

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
    PUSH        BC

    LD          HL, RAM_START
    LD          DE, RAM_START + 1
    LD          BC, RAM_SIZE
    XOR         A
    LD          (HL), A
    LDIR

    POP         BC
    RET

;
; Parse parameter string into C-style argv array
;
; In:
;   HL = parameter string
;   IX = argv storage
;
; Out:
;   C  = argc
;
PARSE_PARAMS:
    LD          BC, EXEC_NAME
    LD          (IX+0), BC         ; argv[0] = executable name

    INC         IX
    INC         IX
    INC         ix

    CALL        SKIP_SPACES

    LD          BC, 1              ; argc = 1
    LD          B, ARGV_PTRS_MAX-1 ; max remaining entries

1:
    PUSH        BC                 ; save argc
    PUSH        HL                 ; save token start

    CALL        GET_TOKEN

    LD          A, C               ; token length
    POP         DE                 ; token start
    POP         BC                 ; argc

    OR          A
    RET         Z                  ; no more tokens

    LD          (IX+0), DE         ; store pointer

    PUSH        HL
    POP         DE

    CALL        SKIP_SPACES

    XOR         A
    LD          (DE), A            ; null terminate

    INC         IX
    INC         IX
    INC         IX

    INC         C                  ; argc++

    LD          A, C
    CP          B
    JR          C, 1b

    RET

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

;
; Storage
;
    .section    .data
SP_EXIT:
    .space      3 ; saved stack pointer
_argv_ptrs:
    .space      ARGV_PTRS_MAX*3, 0 ; argv pointer storage
