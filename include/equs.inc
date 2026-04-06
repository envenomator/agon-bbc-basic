;
; Title:        BBC Basic for AGON - .equs
; Author:       Dean Belfield
; Created:      12/05/2023
; Last Updated: 02/04/2026
;
; Modinfo:
; 08/06/2023:   Added SIZEW
; 04/04/2026:   Converted to GAS style
;

    .extern        STAVAR
    .extern        ACCS

RAM_Top:       .equ    0B0000h        ; Initial value of HIMEM
SIZEW:          .equ    3              ; Size of a word (3 for ADL mode)

;ESC   .equ	1BH
TBY   .equ	0FH
TTO   .equ	0B8H
TFILL .equ	03H

; For GPIO
; PA not available on eZ80L92
;
PA_DR:          .equ    96h
PA_DDR:         .equ    97h
PA_ALT1:        .equ    98h
PA_ALT2:        .equ    99h
PB_DR:          .equ    9Ah
PB_DDR:         .equ    9Bh
PB_ALT1:        .equ    9Ch
PB_ALT2:        .equ    9Dh
PC_DR:          .equ    9Eh
PC_DDR:         .equ    9Fh
PC_ALT1:        .equ    A0h
PC_ALT2:        .equ    A1h
PD_DR:          .equ    A2h
PD_DDR:         .equ    A3h
PD_ALT1:        .equ    A4h
PD_ALT2:        .equ    A5h

GPIOMODE_OUT:   .equ    0              ; Output
GPIOMODE_IN:    .equ    1              ; Input
GPIOMODE_DIO:   .equ    2              ; Open Drain IO
GPIOMODE_SIO:   .equ    3              ; Open Source IO
GPIOMODE_INTD:  .equ    4              ; Interrupt, Dual Edge
GPIOMODE_ALTF:  .equ    5              ; Alt Function
GPIOMODE_INTAL: .equ    6              ; Interrupt, Active Low
GPIOMODE_INTAH: .equ    7              ; Interrupt, Active High
GPIOMODE_INTFE: .equ    8              ; Interrupt, Falling Edge
GPIOMODE_INTRE: .equ    9              ; Interrupt, Rising Edge

; Originally in ram.asm
;
OC:             .equ    STAVAR+15*4    ; CODE ORIGIN (O%)
PC:             .equ    STAVAR+16*4    ; PROGRAM COUNTER (P%)
VDU_BUFFER:     .equ    ACCS           ; Storage for VDU commands

