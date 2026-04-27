    .assume     ADL = 1

    .global     COUNT0
    .global     COUNT1
    .global     INKEY1
    .global     EXPR_24BIT_INT
    .global     ITEMI24
    .global     TRUE
    .global     CONVERT_TO_I24

    .include    "equs.inc"
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

    .include    "bbc-ez80/EVAL.Z80"
