;
; Title:        BBC Basic for AGON - .equs

ARGV_PTRS_MAX:.equ 16 ; Maximum number of arguments parsed in argv

CR:             .equ    0Dh
LF:             .equ    0Ah
ESC:            .equ    1Bh
SINGLE_QUOTE    .equ    27h
BACK_SLASH      .equ    5Ch
STRVAL_SIZE     .equ    5

;
; For GPIO
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

VDU_BUFFER:     .equ    ACCS           ; Storage for VDU commands

