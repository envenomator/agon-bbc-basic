;
; Title:	BBC Basic Interpreter - Z80 version
;		Catch-all for unimplemented functionality
; Author:	Dean Belfield
; Created:	12/05/2023
; Last Updated:	12/05/2023
;
; Modinfo:

			.assume	ADL = 1

			.text
			
			.global	ENVEL
			.global	ADVAL
			.global	PUTIMS
			
			.extern	EXTERR
			
ENVEL:
ADVAL:
PUTIMS:
			XOR     A
			CALL    EXTERR
			.asciz    "Sorry"
