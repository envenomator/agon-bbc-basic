;
; Title: BBC Basic ADL for AGON - Initialisation Code
; Initialisation Code
; Author: Dean Belfield
; Created: 12/05/2023
; Last Updated: 02/04/2026
;
; Modinfo:
; 11/07/2023: Fixed *BYE for ADL mode
; 26/11/2023: Moved the ram clear routine into here
; 02/04/2026: Converted to GAS style
;

    .global _start
    .global _end

    .extern START          ; In main.s
    .extern RAM_START      ; In ram.asm
    .extern RAM_SIZE       ; From linker.conf
    .extern MOS_SYSVARS

    .assume ADL = 1
    .include "equs.inc"
    .include "mos.inc"
    .include "macros.inc"

argv_ptrs_max:    .equ 16         ; Maximum number of arguments allowed in argv

    .section .init

    jp      _start                ; Jump to start

_exec_name:
    .asciz  "BBCBASIC.BIN"       ; Executable name (argv[0])

    .align  6                    ; 2^6 = 64 bytes

    .ascii  "MOS"                ; MOS signature
    .byte   0x00                 ; Header version
    .byte   0x01                 ; Run mode (0=Z80, 1=ADL)

_start:
    push    af                   ; Preserve registers
    push    bc
    push    de
    push    ix
    push    iy

    ld      (_sps), sp           ; Save 24-bit stack pointer

    ld      ix, _argv_ptrs       ; argv pointer array
    push    ix
    call    _parse_params
    pop     ix                   ; IX = argv

    ld      b, 0                 ; C = argc
    call    _clear_ram
    call    get_sysvars

    jp      START                ; Enter user code

; Return safely to MOS (called from *BYE)
_end:
    ld      sp, (_sps)           ; Restore stack pointer

    pop     iy
    pop     ix
    pop     de
    pop     bc
    pop     af

    ret
; Get pointer to sysvars
get_sysvars:
    push    bc
    push    de
    push    hl
    push    ix
    push    iy

    MOSCALL mos_sysvars
    ld      (MOS_SYSVARS),IX

    pop     iy
    pop     ix
    pop     hl
    pop     de
    pop     bc

    ret

; Clear application RAM
_clear_ram:
    push    bc

    ld      hl, RAM_START
    ld      de, RAM_START + 1
    ld      bc, RAM_SIZE
    xor     a
    ld      (hl), a
    ldir

    pop     bc
    ret

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
_parse_params:
    ld      bc, _exec_name
    ld      (ix+0), bc           ; argv[0] = executable name

    inc     ix
    inc     ix
    inc     ix

    call    _skip_spaces

    ld      bc, 1                ; argc = 1
    ld      b, argv_ptrs_max-1   ; max remaining entries

_parse_params_1:
    push    bc                   ; save argc
    push    hl                   ; save token start

    call    _get_token

    ld      a, c                 ; token length
    pop     de                   ; token start
    pop     bc                   ; argc

    or      a
    ret     z                    ; no more tokens

    ld      (ix+0), de           ; store pointer

    push    hl
    pop     de

    call    _skip_spaces

    xor     a
    ld      (de), a              ; null terminate

    inc     ix
    inc     ix
    inc     ix

    inc     c                    ; argc++

    ld      a, c
    cp      b
    jr      c, _parse_params_1

    ret

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
_get_token:
    ld      c, 0

1:
    ld      a, (hl)
    or      a
    ret     z

    cp      13                  ; CR
    ret     z

    cp      ' '
    ret     z

    inc     hl
    inc     c
    jr      1b

;
; Skip spaces
;
; In:
;   HL = string
;
; Out:
;   HL = first non-space
;
_skip_spaces:
    ld      a, (hl)
    cp      ' '
    ret     nz

    inc     hl
    jr      _skip_spaces

;
; Storage
;
_sps:
    .space  3                   ; saved stack pointer

_argv_ptrs:
    .space  argv_ptrs_max, 0    ; argv pointer storage
