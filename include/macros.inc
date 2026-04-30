; Title: BBC Basic Interpreter - eZ80 version
; Required macros

.macro    LOG param
  ; Empty macro to disable upstream logging
.endm

.macro		EXTRN  addr
	XDEF	\addr
.endm

.macro PTR	addr
	d24	\addr
.endm

.macro EXREG rp1, rp2
    PUSH \rp1
    POP \rp2
.endm

.macro ADD8U_HL
    PUSH    DE
    LD      DE, 0
    LD      E, A
    ADD     HL, DE
    POP     DE
.endm

.macro ADD8U_DE
    PUSH    HL
    EX      DE, HL
    LD      DE, 0
    LD      E, A
    ADD     HL, DE
    EX      DE, HL
    POP     HL
.endm

.macro VDU VAL
    LD A, \VAL
    RST.LIL 0x10
.endm

; convert H'L'HL to uHL
; processed as unsigned int
;
.macro	CONVERT_U32_TO_U24
	LD	A, L
	EXX
	LD	(conversion_store), HL
	LD	(conversion_store + 2), A
	LD	HL, (conversion_store)
.endm

.macro	TST_HL_IS_ZERO
	PUSH	DE

	XOR	A		; ASSIGN DE TO 0
	EX	HL, DE
	SBC	HL, HL
	EX	HL, DE

	SBC	HL, DE
	ADD	HL, DE
	POP	DE
.endm

.macro	TST_DE_IS_ZERO
	PUSH	HL
	XOR	A
	SBC	HL, HL
	SBC	HL, DE
	POP	HL
.endm

.macro	TST_BC_IS_ZERO
	PUSH	HL
	XOR	A
	SBC	HL, HL
	SBC	HL, BC
	POP	HL
.endm

; zero uHL
.macro	UEXT	arg	; arg can only be HL
	OR	A
	SBC	\arg, \arg
.endm

; zero uHL and A
.macro	UEXTA	arg	; arg can only be HL
	XOR	A
	SBC	\arg, \arg
.endm

; Macro for calling the API
; Parameters:
; - function: One of the function numbers listed above
;
.macro  moscall function
  LD	A, \function
  RST.LIL	08h
.endm

