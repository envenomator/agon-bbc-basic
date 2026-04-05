; Title: BBC Basic Interpreter - Z80 version
; Useful macros
; Author: Dean Belfield
; Created: 04/12/2024
; Last Updated: 04/04/2026
;
; Modinfo:

.macro		EXTRN  addr
	XDEF	\addr
.endm

CR:		EQU     0DH
LF:		EQU     0AH
ESC:		EQU     1BH
SINGLE_QUOTE	EQU 	27H
BACK_SLASH	EQU	5Ch
STRVAL_SIZE	EQU	5

.macro PTR	addr
	d24	\addr
.endm

.macro EXREG rp1, rp2
    PUSH \rp1
    POP \rp2
.endm

.macro ADD8U_DE reg
    ADD A, E
    LD E, A
    ADC A, D
    SUB E
    LD D, A
.endm

.macro ADD8U_HL reg
    ADD A, L
    LD L, A
    ADC A, H
    SUB L
    LD H, A
.endm

.macro VDU VAL
    LD A, \VAL
    CALL OSWRCH
.endm

.macro SET_GPIO REG, VAL
    IN0 A,(\REG)
    OR \VAL
    OUT0 (\REG),A
.endm

.macro RES_GPIO REG, VAL
    PUSH BC
    LD A, \VAL
    CPL
    LD C, A
    IN0 A,(\REG)
    AND C
    OUT0 (\REG),A
    POP BC
.endm

; Macro for calling the API
; Parameters:
; - function: One of the function numbers listed above
;
.macro  moscall function
  LD	A, \function
  RST.LIS	08h
.endm

