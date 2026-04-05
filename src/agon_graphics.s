;
; Title:	BBC Basic for AGON - Graphics stuff
; Author:	Dean Belfield
; Created:	12/05/2023
; Last Updated:	07/06/2023
;
; Modinfo:
; 07/06/2023:	Modified to run in ADL mode
			
			.assume	ADL = 1
				
			.include	"equs.inc"
			.include "macros.inc"
			.include "mos.inc"	 ; In MOS/src
		
			.text
				
			.global	CLG
			.global	CLRSCN
			.global	MODE
			.global	COLOUR
			.global	GCOL
			.global	MOVE
			.global	PLOT
			.global	DRAW
			.global	POINT
			.global	GETSCHR
			
			.extern	OSWRCH
			.extern	ASC_TO_NUMBER
			.extern	EXTERR
			.extern	EXPRI
			.extern	COMMA
			.extern	XEQ
			.extern	NXT
			.extern	BRAKET
			.extern	COUNT0
			.extern	CRTONULL
			.extern	NULLTOCR
			.extern	CRLF
			.extern	EXPR_W2
			.extern	INKEY1
			
; CLG: clears the graphics area
;
CLG:			VDU	0x10
			JP	XEQ

; CLS: clears the text area
;
CLRSCN:			LD	A, 0x0C
			JP	OSWRCH
				
; MODE n: Set video mode
;
MODE:
    PUSH	IX			 ; Get the system vars in IX
    LD  IX, (MOS_SYSVARS)
    RES	4, (IX+sysvar_vdp_pflags)
    CALL    EXPRI
    EXX
    VDU	0x16			 ; Mode change
    VDU	L
    LD  IX, (MOS_SYSVARS)
1:
    BIT	4, (IX+sysvar_vdp_pflags)
    JR	Z, 1b			 ; Wait for the result			
    POP	IX
    JP	XEQ
			
; GET(x,y): Get the ASCII code of a character on screen
;
GETSCHR:		INC	IY
			CALL    EXPRI      		 ; Get X coordinate
			EXX
			LD	(VDU_BUFFER+0), HL
			CALL	COMMA		
			CALL	EXPRI			 ; Get Y coordinate
			EXX 
			LD	(VDU_BUFFER+2), HL
			CALL	BRAKET			 ; Closing bracket		
;
			PUSH	IX			 ; Get the system vars in IX
      LD  IX, (MOS_SYSVARS)
			RES	1, (IX+sysvar_vdp_pflags)
			VDU	23
			VDU	0
			VDU	vdp_scrchar
			VDU	(VDU_BUFFER+0)
			VDU	(VDU_BUFFER+1)
			VDU	(VDU_BUFFER+2)
			VDU	(VDU_BUFFER+3)
1:			BIT	1, (IX+sysvar_vdp_pflags)
			JR	Z, 1b			 ; Wait for the result
			LD	A, (IX+sysvar_scrchar)	 ; Fetch the result in A
			OR	A			 ; Check for 00h
			SCF				 ; C = character map
			JR	NZ, 1f			 ; We have a character, so skip next bit
			XOR	A			 ; Clear carry
			DEC	A			 ; Set A to FFh
1:			POP	IX			
			JP	INKEY1			 ; Jump back to the GET command

; POINT(x,y): Get the pixel colour of a point on screen
;
POINT:			CALL    EXPRI      		 ; Get X coordinate
			EXX
			LD	(VDU_BUFFER+0), HL
			CALL	COMMA		
			CALL	EXPRI			 ; Get Y coordinate
			EXX 
			LD	(VDU_BUFFER+2), HL
			CALL	BRAKET			 ; Closing bracket		
;
			PUSH	IX			 ; Get the system vars in IX
      LD    IX, (MOS_SYSVARS)
			RES	2, (IX+sysvar_vdp_pflags)
			VDU	23
			VDU	0
			VDU	vdp_scrpixel
			VDU	(VDU_BUFFER+0)
			VDU	(VDU_BUFFER+1)
			VDU	(VDU_BUFFER+2)
			VDU	(VDU_BUFFER+3)
1:			BIT	2, (IX+sysvar_vdp_pflags)
			JR	Z, 1b			 ; Wait for the result
;
; Return the data as a 1 byte index
;
			LD	L, (IX+(sysvar_scrpixelIndex))
			POP	IX	
			JP	COUNT0


; COLOUR colour
; COLOUR L,P
; COLOUR L,R,G,B
;
COLOUR:			CALL	EXPRI			 ; The colour / mode
			EXX
			LD	A, L 
			LD	(VDU_BUFFER+0), A	 ; Store first parameter
			CALL	NXT			 ; Are there any more parameters?
			CP	','
			JR	Z, COLOUR_1		 ; Yes, so we're doing a palette change next
;
			VDU	0x11			 ; Just set the colour
			VDU	(VDU_BUFFER+0)
			JP	XEQ			
;
COLOUR_1:		CALL	COMMA
			CALL	EXPRI			 ; Parse R (OR P)
			EXX
			LD	A, L
			LD	(VDU_BUFFER+1), A
			CALL	NXT			 ; Are there any more parameters?
			CP	','
			JR	Z, COLOUR_2		 ; Yes, so we're doing COLOUR L,R,G,B
;
			VDU	0x13			 ; VDU:COLOUR
			VDU	(VDU_BUFFER+0)		 ; Logical Colour
			VDU	(VDU_BUFFER+1)		 ; Palette Colour
			VDU	0			 ; RGB set to 0
			VDU	0
			VDU	0
			JP	XEQ
;
COLOUR_2:		CALL	COMMA
			CALL	EXPRI			 ; Parse G
			EXX
			LD	A, L
			LD	(VDU_BUFFER+2), A
			CALL	COMMA
			CALL	EXPRI			 ; Parse B
			EXX
			LD	A, L
			LD	(VDU_BUFFER+3), A							
			VDU	0x13			 ; VDU:COLOUR
			VDU	(VDU_BUFFER+0)		 ; Logical Colour
			VDU	0xFF			 ; Physical Colour (-1 for RGB mode)
			VDU	(VDU_BUFFER+1)		 ; R
			VDU	(VDU_BUFFER+2)		 ; G
			VDU	(VDU_BUFFER+3)		 ; B
			JP	XEQ

; GCOL mode,colour
;
GCOL:			CALL	EXPRI			 ; Parse MODE
			EXX
			LD	A, L 
			LD	(VDU_BUFFER+0), A	
			CALL	COMMA
;
			CALL	EXPRI			 ; Parse Colour
			EXX
			LD	A, L
			LD	(VDU_BUFFER+1), A
;
			VDU	0x12			 ; VDU:GCOL
			VDU	(VDU_BUFFER+0)		 ; Mode
			VDU	(VDU_BUFFER+1)		 ; Colour
			JP	XEQ
			
; PLOT mode,x,y
;
PLOT:			CALL	EXPRI		 ; Parse mode
			EXX					
			PUSH	HL		 ; Push mode (L) onto stack
			CALL	COMMA 	
			CALL	EXPR_W2		 ; Parse X and Y
			POP	BC		 ; Pop mode (C) off stack
PLOT_1:			VDU	0x19		 ; VDU code for PLOT				
			VDU	C		 ;  C: Mode
			VDU	E		 ; DE: X
			VDU	D
			VDU	L		 ; HL: Y
			VDU	H
			JP	XEQ

; MOVE x,y
;
MOVE:			CALL	EXPR_W2		 ; Parse X and Y
			LD	C, 0x04		 ; Plot mode 04H (Move)
			JR	PLOT_1		 ; Plot

; DRAW x1,y1
; DRAW x1,y1,x2,y2
;
DRAW:			CALL	EXPR_W2		 ; Get X1 and Y1
			CALL	NXT		 ; Are there any more parameters?
			CP	','
			LD	C, 0x05		 ; Code for LINE
			JR	NZ, PLOT_1	 ; No, so just do DRAW x1,y1
			VDU	0x19		 ; Move to the first coordinates
			VDU	0x04
			VDU	E
			VDU	D
			VDU	L
			VDU	H
			CALL	COMMA
			PUSH	BC
			CALL	EXPR_W2		 ; Get X2 and Y2
			POP	BC
			JR	PLOT_1		 ; Now DRAW the line to those positions
			
			
			
