    .assume     ADL = 1

    .global     COUNT0
    .global     COUNT1
    .global     INKEY1
    .global     EXPR_24BIT_INT
    .global     INT24_TO_32
    .global     ITEMI24
    .global     TRUE
    .global     CONVERT_TO_I24
    .include    "macros.inc"
    .text

EXPR_24BIT_INT:
    CALL        EXPRI ; RESULT IN HLH'L' C SHOULD BE ZERO
; U(HL) = l
; H = H'
; L = L'

CONVERT_TO_I24:
    EXX
    LD          (conversion_store), HL
    EXX
    LD          A, L
    LD          (conversion_store + 2), A
    LD          HL, (conversion_store)
    RET

ITEMI24:
    CALL        ITEM
    OR          A
    JP          M, MISMAT
    CALL        SFIX
    CALL        CONVERT_TO_I24
    RET

; CONVERT UNSIGNED 24 BIT NUMBER IN HL
; TO STANDARD 32BIT NUMBER REPRESENTATION
; INPUT
;   UHL = UNSIGNED 24 BIT NUMBER
; OUTPUT
;   HLH'L', C=0 = 32 BIT NUMBER
;
;INT24_TO_32:
;    LD          (conversion_store), HL ; H'L' - LOW PART
;    EXX
;    LD          A, (conversion_store + 2)
;    LD          L, A ; L = U
;    XOR         A
;    LD          H, A ; H = 0
;    LD          C, A ; C = 0
;    RET

INT24_TO_32:
    LD      (conversion_store),HL      ; store 24-bit address: low, mid, high

    EXX
    LD      HL,(conversion_store)      ; H'L' = low 16 bits (mid:low)
    EXX

    LD      HL,0
    LD      A,(conversion_store+2)     ; high byte
    LD      L,A                        ; HL = 00:high
    XOR     A
    LD      C,A                        ; integer marker
    RET
    .include    "bbc-ez80/EVAL.Z80"
