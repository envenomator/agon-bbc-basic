    .assume     ADL = 1

    .include    "equs.inc"
    .include    "macros.inc"

    .global     STORE5_SPL
    .text
    .include    "bbc-ez80/EXEC.Z80"


; THIS FUNCTION REPLACES STORE5 FOR WHEN IX POINTS TO A STACK FRAME
; CONTAINING 'PUSHED REGISTERS'.

; AS REGISTERS ARE NOW 3 BYTES LONG THE OFFSETS FOR EACH BYTE NEEDS
; TO BE ADJUSTED

STORE5_SPL:
	LD	(IX+6),C
	EXX
	LD	(IX+0),L
	LD	(IX+1),H
	XOR	A
	LD	(IX+2),A
	EXX
	LD	(IX+3),L
	LD	(IX+4),H
	LD	(IX+5),A
	RET

