;
; Title:	BBC Basic Interpreter - eZ80 version
;		Catch-all for unimplemented functionality
;
; Author:	Jeroen Venema

			.global	ENVEL
			.global	ADVAL
			.global	PUTIMS
      .global TINT
      .global TINTFN
      .global SYS

			.extern	EXTERR

			.assume	ADL = 1
			.text

SYS:
TINT:
TINTFN:
ENVEL:
ADVAL:
PUTIMS:
			XOR     A
			CALL    EXTERR
			.asciz    "Sorry"
