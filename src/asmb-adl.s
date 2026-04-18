;
; Title: BBC Basic ADL for AGON - ADL Assembler
;
; LISTON/OPT BIT 7 determines default ADL mode
;

    .assume     ADL = 1

    .include    "equs.inc"
    .include    "macros.inc"
    .text

    .global     ASSEM
;
; List of token values used in this module
;
TAND  .equ     0x80
TOR   .equ     0x84
ELSE_ .equ     0x8B
TCALL .equ     0xD6
DEF_  .equ     0xDD

DELIM:
    LD      A,(IY) ; Assembler delimiter
    CP      ' '
    RET     Z
    CP      ','
    RET     Z
    CP      ')'
    RET     Z
TERM:
    CP      ';'                      ; Assembler terminator
    RET     Z
    CP      0x5C
    RET     Z
    JR      TERM0
;
TERMQ:
    CALL    NXT
    CP      ELSE_
    RET     NC
TERM0:
    CP      ':' ; Assembler seperator
    RET     NC
    CP      CR
    RET

STORE:
    BIT     0,A
    JR      Z,STOREI
    CP      A                       ; Set the variable to 0
STORE5:
    LD      (IX+4),C
STORE4:
    EXX
    LD      (IX+0),L
    LD      (IX+1),H
    EXX
    LD      (IX+2),L
    LD      (IX+3),H
    RET
STOREI:
    PUSH    AF
    INC     C               ;SPEED - & PRESERVE F'
    DEC     C               ; WHEN CALLED BY FNEND0
    CALL    NZ,SFIX         ;CONVERT TO INTEGER
    POP     AF
    CP      4
    JR      Z,STORE4
    CP      A               ;SET ZERO
STORE1:
    EXX
    LD      (IX+0),L
    EXX
    RET

; ASSEMBLER -------------------------------------------------------------------

; Language independant control section:
;  Outputs: A=delimiter, carry set if syntax error.
;
ASSEM:
    CALL    SKIP
    INC     IY
    CP      ':'
    JR      Z,ASSEM
    CP      ']'
    RET     Z
    CP      CR
    RET     Z
    DEC     IY
    LD      IX,(PC)                  ; Program counter (P% - defined in equs.inc)
    LD      HL,LISTON
    BIT     6,(HL)
    JR      Z,ASSEM0
    LD      IX,(OC)                  ; Code origin (O% - defined in equs.inc)
ASSEM0:
    PUSH    IX
    PUSH    IY
    CALL    ASMB
    POP     BC
    POP     DE
    RET     C
    CALL    SKIP
    SCF
    RET     NZ
    DEC     IY
ASSEM3:
    INC     IY
    LD      A,(IY)
    CALL    TERM0
    JR      NZ,ASSEM3
    LD      A,(LISTON)
    PUSH    IX
    POP     HL
    OR      A
    SBC     HL,DE
    EX      DE,HL                    ; DE: Number of bytes
    PUSH    HL
    LD      HL,(PC)
    PUSH    HL
    ADD     HL,DE
    LD      (PC),HL                  ; Update PC
    BIT     6,A
    JR      Z,ASSEM5
    LD      HL,(OC)
    ADD     HL,DE
    LD      (OC),HL                  ; Update OC
ASSEM5:
    POP     HL ; Old PC
    POP     IX                       ; Code here
    BIT     4,A
    JR      Z,ASSEM
    LD      (R0),HL                  ; Store HL in R0 so we can access the MSB
    LD      A,(R0+2)                 ; Print out the address
    CALL    HEX
    LD      A,H
    CALL    HEX
    LD      A,L
    CALL    HEXSP
    XOR     A
    CP      E
    JR      Z,ASSEM2
;
ASSEM1:
    LD      A,(COUNT)
    CP      20
    LD      A,7
    CALL    NC,TABIT                 ; Next line
    LD      A,(IX)
    CALL    HEXSP
    INC     IX
    DEC     E
    JR      NZ,ASSEM1
;
ASSEM2:
    LD      A,22 ; Tab to the disassembly field
    CALL    TABIT
    PUSH    IY
    POP     HL
    SBC     HL,BC
ASSEM4:
    LD      A,(BC)
    CALL    OUT
    INC     BC
    DEC     L
    JR      NZ,ASSEM4
    CALL    CRLF
    JP      ASSEM
;
HEXSP:
    CALL    HEX
    LD      A,' '
    JR      OUTCH1
HEX:
    PUSH    AF
    RRCA
    RRCA
    RRCA
    RRCA
    CALL    HEXOUT
    POP     AF
HEXOUT:
    AND     0x0F
    ADD     A,0x90
    DAA
    ADC     A,0x40
    DAA
OUTCH1:
    JP      OUT

; Processor Specific Translation Section:
;
; Register Usage: B: Type of most recent operand (the base value selected from the opcode table)
;                 C: Opcode beig built
;                 D: Flags
;                       Bit 7: Set to 1 if the instruction uses long addressing
;                       Bit 6: Set to 1 if the instruction is an index instruction with offset
;                 E: Offset from IX or IY
;                HL: Numeric operand value
;                IX: Code destination pointer
;                IY: Source text pointer
;    Inputs: A = initial character
;   Outputs: Carry set if syntax error.
;
ASMB:
    CP      '.' ; Check for a dot; this indicates a label
    JR      NZ,ASMB1                 ; No, so just process the instruction
    INC     IY                       ; Skip past the dot to the label name
    PUSH    IX                       ; Store the code destination pointer
    CALL    VAR                      ; Create a variable
    PUSH    AF
    CALL    ZERO                     ; Zero it
    LD      A,(PC+2)
    LD      L,A                      ; The MSB of the 24-bit address
    EXX
    LD      HL,(PC)                  ; The LSW of the 24-bit address (only 16-bits used)
    EXX
    POP     AF
    CALL    STORE                    ; Store the program counter
    POP     IX                       ; Restore the code destination pointer
;
ASMB1:
    LD      A,(LISTON) ; Get the OPT flags
    AND     0x80
    LD      D,A                      ;  D: Clear the flags and set the initial ADL mode (copied from bit 7 of LISTON)
    CALL    SKIP                     ; Skip any whitespace
    RET     Z                        ; And return if there is nothing further to process
    CP      TCALL                    ; Check if it is the token CALL (it will have been tokenised by BASIC)
    LD      C,0x0C4                  ;  A: The base operand
    INC     IY                       ; Skip past the token
    JP      Z,GROUP13_1              ; And jump to GROUP13, which handles CALL
    DEC     IY                       ; Skip back, as we're not doing the above at this point
    LD      HL,OPCODS                ; HL: Pointer to the eZ80 opcodes table
    CALL    FIND                     ; Find the opcode
    RET     C                        ; If not found, then return; carry indicates an error condition
    LD      C,B                      ;  C: A copy of the opcode
;
; GROUP 0: Trivial cases requiring no computation
; GROUP 1: As Group 0, but with "ED" prefix
;
    SUB     68                       ; The number of opcodes in GROUP0 and GROUP1
    JR      NC,GROUP02               ; If not in that range, then check GROUP2
    CP      15-68                    ; Anything between 15 and 68 (neat compare trick here)
    CALL    NC,ED                    ; Needs to be prefixed with ED
    JR      BYTE0                    ; Then write the opcode byte
;
; GROUP 2: BIT, RES, SET
; GROUP 3: RLC, RRC, RL, RR, SLA, SRA, SRL
;
GROUP02:
    SUB     10 ; The number of opcodes in GROUP2 and GROUP3
    JR      NC,GROUP04               ; If not in that range, then check GROUP4
    CP      3-10                     ;
    CALL    C,BIT_
    RET     C
    CALL    REGLO
    RET     C
    CALL    CB
    JR      BYTE0
;
; GROUP 4 - PUSH, POP, EX (SP)
;
GROUP04:
    SUB     3 ; The number of opcodes in GROUP4
    JR      NC,GROUP05               ; If not in that range, then check GROUP5
GROUP04_1:
    CALL    PAIR
    RET     C
    JR      BYTE0
;
; GROUP 5 - SUB, AND, XOR, OR, CP
; GROUP 6 - ADD, ADC, SBC
;
GROUP05:
    SUB     8+2 ; The number of opcodes in GROUP5 and GROUP6
    JR      NC,GROUP07
    CP      5-8
    LD      B,7
    CALL    NC,OPND                  ; Get the first operand
    LD      A,B
    CP      7                        ; Is the operand 'A'?
    JR      NZ,GROUP05_HL            ; No, so check for HL, IX or IY
;
GROUP05_1:
    CALL    REGLO ; Handle ADD A,?
    LD      A,C
    JR      NC,BIND1                 ; If it is a register, then write that out
    XOR     0x46                     ; Handle ADD A,n
    CALL    BIND
DB_:
    CALL    NUMBER
    JP      VAL8
;
GROUP05_HL:
    AND     0x3F
    CP      12
    SCF
    RET     NZ
    LD      A,C
    CP      0x80
    LD      C,9
    JR      Z,GROUP04_1
    XOR     0x1C
    RRCA
    LD      C,A
    CALL    ED
    JR      GROUP04_1
;
; GROUP 7 - INC, DEC
;
GROUP07:
    SUB     2 ; The number of opcodes in GROUP7
    JR      NC,GROUP08
    CALL    REGHI
    LD      A,C
BIND1:
    JP      NC,BIND
    XOR     0x64
    RLCA
    RLCA
    RLCA
    LD      C,A
    CALL    PAIR1
    RET     C
BYTE0:
    LD      A,C
    JP      BYTE_
;
; Group 8: IN0, OUT0
;
GROUP08:
    SUB     2 ; The number of opcodes in GROUP8
    JR      NC,GROUP09
    CP      1-2
    CALL    Z,NUMBER                 ; Fetch number first if OUT
    EX      AF,AF'                  ; Save flags
    CALL    REG                      ; Get the register value regardless
    RET     C                        ; Return if not a register
    EX      AF,AF'                  ; Restore the flags
    CALL    C,NUMBER                 ; Fetch number last if IN
    LD      A,B                      ; Get the register number
    CP      6                        ; Fail on (HL)
    SCF
    RET     Z
    CP      8                        ; Check it is just single pairs only
    CCF
    RET     C                        ; And return if it is an invalid register
    RLCA                             ; Bind with the operand
    RLCA
    RLCA
    ADD     A,C
    LD      C,A
    CALL    ED                       ; Prefix with ED
    LD      A,C
    CALL    BYTE_                    ; Write out the operand
    JP      VAL8                     ; Write out the value
;
; GROUP 9 - IN
; GROUP 10 - OUT
;
GROUP09:
    SUB     2 ; The number of opcodes in GROUP09 amd GROUP10
    JR      NC,GROUP11
    CP      1-2                      ; Check if Group 9 or Group 1
    CALL    Z,CORN                   ; Call CORN if Group 10 (OUT)
    EX      AF,AF'                  ; Save flags
    CALL    REGHI                    ; Get the register value regardless
    RET     C                        ; Return if not a register
    EX      AF,AF'                  ; Restore the flags
    CALL    C,CORN                   ; Call CORN if Group 9 (IN)
    INC     H                        ; If it is IN r,(C) or OUT (C),r then
    JR      Z,BYTE0                  ; Just write the operand out
;
    LD      A,B                      ; Check the register
    CP      7
    SCF
    RET     NZ                       ; If it is not A, then return
;
    LD      A,C                      ; Bind the register with the operand
    XOR     3
    RLCA
    RLCA
    RLCA
    CALL    BYTE_                    ; Write out the operand
    JR      VAL8                     ; And the value
;
; GROUP 11 - JR, DJNZ
;
GROUP11:
    SUB     2 ; The number of opcodes in GROUP11
    JR      NC,GROUP12
    CP      1-2
    CALL    NZ,COND_
    LD      A,C
    JR      NC,1f
    LD      A,0x18
    1:                      CALL    BYTE_
    CALL    NUMBER
    LD      DE,(PC)
    INC     DE
    SCF
    SBC     HL,DE
    LD      A,L
    RLA
    SBC     A,A
    CP      H
TOOFAR:
    LD      A,1
    JP      NZ,ERROR                 ; Throw an "Out of range" error
VAL8:
    LD      A,L
    JP      BYTE_
;
; GROUP 12 - JP
;
GROUP12:
    SUB     1 ; The number of opcodes in GROUP12
    JR      NC,GROUP13
    CALL    EZ80SF_PART              ; Evaluate the suffix (just LIL and SIS)
    RET     C                        ; Exit if an invalid suffix is provided
    CALL    COND_                    ; Evaluate the conditions
    LD      A,C
    JR      NC,GROUP12_1
    LD      A,B
    AND     0x3F
    CP      6
    LD      A,0x0E9
    JP      Z,BYTE_
    LD      A,0x0C3
GROUP12_1:
    CALL    BYTE_ ; Output the opcode (with conditions)
    JP      ADDR_                    ; Output the address
;
; GROUP 13 - CALL
;
GROUP13:
    SUB     1 ; The number of opcodes in GROUP13
    JR      NC,GROUP14
GROUP13_1:
    CALL    EZ80SF_FULL ; Evaluate the suffix
    CALL    GROUP15_1                ; Output the opcode (with conditions)
    JP      ADDR_                    ; Output the address
;
; GROUP 14 - RST
;
GROUP14:
    SUB     1 ; The number of opcodes in GROUP14
    JR      NC,GROUP15
    CALL    EZ80SF_FULL              ; Evaluate the suffix
    RET     C                        ; Exit if an invalid suffix provided
    CALL    NUMBER
    AND     C
    OR      H
    JR      NZ,TOOFAR
    LD      A,L
    OR      C
    JP      BYTE_
;
; GROUP 15 - RET
;
GROUP15:
    SUB     1 ; The number of opcodes in GROUP15
    JR      NC,GROUP16
GROUP15_1:
    CALL    COND_
    LD      A,C
    JP      NC,BYTE_
    OR      9
    JP      BYTE_
;
; GROUP 16 - LD
;
GROUP16:
    SUB     1 ; The number of opcodes in GROUP16
    JR      NC,GROUP17
    CALL    EZ80SF_FULL              ; Evaluate the suffix
    CALL    LDOP                     ; Check for accumulator loads
    JP      NC,LDA                   ; Yes, so jump here
    CALL    REGHI
    EX      AF,AF'
    CALL    SKIP
    CP      '('                      ; Check for bracket
    JR      Z,LDIN                   ; Yes, so we're doing an indirect load from memory
    EX      AF,AF'
    JP      NC,GROUP05_1             ; Load single register direct; go here
    LD      C,1
    CALL    PAIR1
    RET     C
    LD      A,14
    CP      B
    LD      B,A
    CALL    Z,PAIR
    LD      A,B
    AND     0x3F
    CP      12
    LD      A,C
    JP      NZ,GROUP12_1             ; Load register pair direct; go here
    LD      A,0x0F9
    JP      BYTE_
;
LDIN:
    EX      AF,AF'
    PUSH    BC
    CALL    NC,REGLO
    LD      A,C
    POP     BC
    JP      NC,BIND
    LD      C,0x0A
    CALL    PAIR1
    CALL    LD16
    JP      NC,GROUP12_1
    CALL    NUMBER
    LD      C,2
    CALL    PAIR
    CALL    LD16
    RET     C
    CALL    BYTE_
    BIT     7,D                      ; Check the ADL flag
    JP      NZ,VAL24                 ; If it is set, then use 24-bit addresses
    JP      VAL16                    ; Otherwise use 16-bit addresses
;
; Group 17 - TST
;
GROUP17:
    SUB     1 ; The number of opcodes in GROUP17
    JR      NC,OPTS
    CALL    ED                       ; Needs to be prefixed with ED
    CALL    REG                      ; Fetch the register
    JR      NC,GROUP17_1             ; It's just a register
;
    LD      A,0x64                   ; Opcode for TST n
    CALL    BYTE_                    ; Write out the opcode
    CALL    NUMBER                   ; Get the number
    JP      VAL8                     ; And write that out
;
GROUP17_1:
    LD      A,B ; Check the register rangs
    CP      8
    CCF
    RET     C                        ; Ret with carry flag set for error if out of range
    RLCA                             ; Get the opcode value
    RLCA
    RLCA
    ADD     A,C                      ; Add the opcode base in
    JP      BYTE_

;
; Assembler directives - OPT, ADL
;
OPTS:
    SUB     2
    JR      NC, DEFS
    CP      1-2                      ; Check for ADL opcode
    JR      Z, ADL_
;
OPT:
    CALL    NUMBER ; Fetch the OPT value
    LD      HL,LISTON                ; Address of the LISTON/OPT flag
    AND     7                        ; Only interested in the first three bits
    LD      C,A                      ; Store the new OPT value in C
    RLD                              ; Shift the top nibble of LISTON (OPT) into A
    AND     8                        ; Clear the bottom three bits, preserving the ADL bit
    OR      C                        ; OR in the new value
    RRD                              ; And shift the nibble back in
    RET
;
ADL_:
    CALL    NUMBER ; Fetch the ADL value
    AND     1                        ; Only interested if it is 0 or 1
    RRCA                             ; Rotate to bit 7
    LD      C,A                      ; Store in C
    LD      A,(LISTON)               ; Get the LISTON system variable
    AND     0x7F                     ; Clear bit 7
    OR      C                        ; OR in the ADL value
    LD      (LISTON),A               ; Store
    RET
;
; DEFB, DEFW, DEFL, DEFM
;
DEFS:
    OR      A ; Handle DEFB
    JP      Z, DB_
    DEC     A                        ; Handle DEFW
    JP      Z, ADDR16
    DEC     A                        ; Handle DEFL
    JP      Z, ADDR24
;
    PUSH    IX                       ; Handle DEFM
    CALL    EXPRS
    POP     IX
    LD      HL,ACCS
    1:                      XOR     A
    CP      E
    RET     Z
    LD      A,(HL)
    INC     HL
    CALL    BYTE_
    DEC     E
    JR      1b

;
;SUBROUTINES:
;
EZ80SF_PART:
    LD      A,(IY) ; Check for a dot
    CP      '.'
    JR      Z, 1f                    ; If present, then carry on processing the eZ80 suffix
    OR      A                        ; Reset the carry flag (no error)
    RET                              ; And return
    1:                      INC     IY                       ; Skip the dot
    PUSH    BC                       ; Push the operand
    LD      HL,EZ80SFS_2             ; Check the shorter fully qualified table (just LIL and SIS)
    CALL    FIND                     ; Look up the operand
    JR      NC,EZ80SF_OK
    POP     BC                       ; Not found at this point, so will return with a C (error)
    RET
;
EZ80SF_FULL:
    LD      A,(IY) ; Check for a dot
    CP      '.'
    JR      Z,1f                     ; If present, then carry on processing the eZ80 suffix
    OR      A                        ; Reset the carry flag (no error)
    RET                              ; And return
    1:                      INC     IY                       ; Skip the dot
    PUSH    BC                       ; Push the operand
    LD      HL,EZ80SFS_1             ; First check the fully qualified table
    CALL    FIND                     ; Look up the operand
    JR      NC,EZ80SF_OK             ; Yes, we've found it, so go write it out
    CALL    EZ80SF_TABLE             ; Get the correct shortcut table in HL based upon the ADL mode
    CALL    FIND
    JR      NC,EZ80SF_OK
    POP     BC                       ; Not found at this point, so will return with a C (error)
    RET
;
EZ80SF_OK:
    LD      A,B ; The operand value
    CALL    NC,BYTE_                 ; Write it out if found
    RES     7,D                      ; Clear the default ADL mode from the flags
    AND     2                        ; Check the second half of the suffix (.xxL)
    RRCA                             ; Shift into bit 7
    RRCA
    OR      D                        ; Or into bit 7 of D
    LD      D,A
    POP     BC                       ; Restore the operand
    RET
;
EZ80SF_TABLE:
    LD      HL,EZ80SFS_ADL0 ; Return with the ADL0 lookup table
    BIT     7,D                      ; if bit 7 of D is 0
    RET     Z
    LD      HL,EZ80SFS_ADL1          ; Otherwise return with the ADL1 lookup table
    RET
;
ADDR_:
    BIT     7,D ; Check the ADL flag
    JR      NZ,ADDR24                ; If it is set, then use 24-bit addresses
;
ADDR16:
    CALL    NUMBER ; Fetch an address (16-bit) and fall through to VAL16
VAL16:
    CALL    VAL8 ; Write out a 16-bit value (HL)
    LD      A,H
    JP      BYTE_
;
ADDR24:
    CALL    NUMBER ; Fetch an address (24-bit) and fall through to VAL24
VAL24:
    CALL    VAL16 ; Lower 16-bits are in HL
    EXX
    LD      A,L                      ; Upper 16-bits are in HL', just need L' to make up 24-bit value
    EXX
    JP      BYTE_
;
LDA:
    CP      4
    CALL    C,ED
    LD      A,B
    JP      BYTE_
;
LD16:
    LD      A,B
    JR      C,LD8
    LD      A,B
    AND     0x3F
    CP      12
    LD      A,C
    RET     Z
    CALL    ED
    LD      A,C
    OR      0x43
    RET
;
LD8:
    CP      7
    SCF
    RET     NZ
    LD      A,C
    OR      0x30
    RET
;
; Used in IN and OUT to handle whether the operand is C or a number
;
CORN:
    PUSH    BC
    CALL    OPND                     ; Get the operand
    BIT     5,B
    POP     BC
    JR      Z,NUMBER                 ; If bit 5 is clear, then it's IN A,(N) or OUT (N),A, so fetch the port number
    LD      H,-1                     ; At this point it's IN r,(C) or OUT (C),r, so flag by setting H to &FF
;
ED:
    LD      A,0x0ED ; Write an ED prefix out
    JR      BYTE_
;
CB:
    LD      A,0x0CB
BIND:
    CP      0x76
    SCF
    RET     Z                        ; Reject LD (HL),(HL)
    CALL    BYTE_
    BIT     6,D                      ; Check the index bit in flags
    RET     Z
    LD      A,E                      ; If there is an index, output the offset
    JR      BYTE_
;
; Search through the operand table
; Returns:
; - B: The operand type
; - D: Bit 7: 0 = no prefix, 1 = prefix
; - E: The IX/IY offset
; - F: Carry if not found
;
OPND:
    PUSH    HL ; Preserve HL
    LD      HL,OPRNDS                ; The operands table
    CALL    FIND                     ; Find the operand
    POP     HL
    RET     C                        ; Return if not found
    BIT     7,B                      ; Check if it is an index register (IX, IY)
    RET     Z                        ; Return if it isn't
    SET     6,D                      ; Set flag to indicate we've got an index
    BIT     3,B                      ; Check if an offset is required
    PUSH    HL
    CALL    Z,OFFSET                 ; If bit 3 of B is zero, then get the offset
    LD      E,L                      ; E: The offset
    POP     HL
    LD      A,0xDD                   ; IX prefix
    BIT     6,B                      ; If bit 6 is reset then
    JR      Z,BYTE_                  ; It's an IX instruction, otherwise set
    LD      A,0xFD                   ; IY prefix
;
BYTE_:
    LD      (IX),A ; Write a byte out
    INC     IX
    OR      A
    RET
;
OFFSET:
    LD      A,(IY)
    CP      ')'
    LD      HL,0
    RET     Z
NUMBER:
    CALL    SKIP
    PUSH    BC
    PUSH    DE
    PUSH    IX
    CALL    EXPRI
    POP     IX
    EXX
    POP     DE
    POP     BC
    LD      A,L
    OR      A
    RET
;
REG:
    CALL    OPND
    RET     C
    LD      A,B
    AND     0x3F
    CP      8
    CCF
    RET
;
REGLO:
    CALL    REG
    RET     C
    JR      ORC
;
REGHI:
    CALL    REG
    RET     C
    JR      SHL3
;
COND_:
    CALL    OPND
    RET     C
    LD      A,B
    AND     0x1F
    SUB     16
    JR      NC,SHL3
    CP      -15
    SCF
    RET     NZ
    LD      A,3
    JR      SHL3
;
PAIR:
    CALL    OPND
    RET     C
PAIR1:
    LD      A,B
    AND     0x0F
    SUB     8
    RET     C
    JR      SHL3
;
BIT_:
    CALL    NUMBER
    CP      8
    CCF
    RET     C
SHL3:
    RLCA
    RLCA
    RLCA
ORC:
    OR      C
    LD      C,A
    RET
;
LDOP:
    LD      HL,LDOPS

;
; Look up a value in a table
; Parameters:
; - IY: Address of the assembly language line in the BASIC program area
; - HL: Address of the table
; Returns:
; - B: The operand code
; - F: Carry set if not found
;
FIND:
    CALL    SKIP ; Skip delimiters
;
EXIT_:
    LD      B,0 ; Set B to 0
    SCF                              ; Set the carry flag
    RET     Z                        ; Returns if Z
;
    CP      DEF_                     ; Special case for token DEF (used in DEFB, DEFW, DEFL, DEFM)
    JR      Z,FIND0
    CP      TOR+1                    ; Special case for tokens AND and OR
    CCF
    RET     C
FIND0:
    LD      A,(HL) ; Check for the end of the table (0 byte marker)
    OR      A
    JR      Z,EXIT_                  ; Exit
    XOR     (IY)
    AND     0b01011111
    JR      Z,FIND2
FIND1:
    BIT     7,(HL)
    INC     HL
    JR      Z,FIND1
    INC     HL
    INC     B
    JR      FIND0
;
FIND2:
    PUSH    IY
FIND3:
    BIT     7,(HL) ; Is this the end of token marker?
    INC     IY
    INC     HL
    JR      NZ,FIND5                 ; Yes
    CP      (HL)
    CALL    Z,SKIP0
    LD      A,(HL)
    XOR     (IY)
    AND     0b01011111
    JR      Z,FIND3
FIND4:
    POP     IY
    JR      FIND1
;
FIND5:
    CALL    DELIM ; Is it a delimiter?
    CALL    NZ,DOT                   ; No, so also check whether it is a dot character (for suffixes)
    CALL    NZ,SIGN                  ; No, so also check whether it is a SIGN character ('+' or '-')
    JR      NZ,FIND4                 ; If it is not a sign or a delimiter, then loop
;
FIND6:
    LD      A,B ; At this point we have a token
    LD      B,(HL)                   ; Fetch the token type code
    POP     HL                       ; Restore the stack
    RET
;
SKIP0:
    INC     HL
SKIP:
    CALL    DELIM ; Is it a delimiter?
    RET     NZ                       ; No, so return
    CALL    TERM                     ; Is it a terminator?
    RET     Z                        ; Yes, so return
    INC     IY                       ; Increment the basic program counter
    JR      SKIP                     ; And loop
;
SIGN:
    CP      '+' ; Check whether the character is a sign symbol
    RET     Z
    CP      '-'
    RET
;
DOT:
    CP      '.' ; Check if it is a dot character
    RET

; Z80 opcode list
;
; Group 0: (15 opcodes)
; Trivial cases requiring no computation
;
OPCODS:
    .byte   'N','O','P'+0x80,0x00 ; # 00h
    .byte   'R','L','C','A'+0x80,0x07
    .byte   'E','X',0,'A','F',0,'A','F',0x27+0x80,0x08 ; 0x27 == '\''
    .byte   'R','R','C','A'+0x80,0x0F
    .byte   'R','L','A'+0x80,0x17
    .byte   'R','R','A'+0x80,0x1F
    .byte   'D','A','A'+0x80,0x27
    .byte   'C','P','L'+0x80,0x2F
    .byte   'S','C','F'+0x80,0x37
    .byte   'C','C','F'+0x80,0x3F
    .byte   'H','A','L','T'+0x80,0x76
    .byte   'E','X','X'+0x80,0xD9
    .byte   'E','X',0,'D','E',0,'H','L'+0x80,0xEB
    .byte   'D','I'+0x80,0xF3
    .byte   'E','I'+0x80,0xFB
;
; Group 1: (53 opcodes)
; As Group 0, but with an ED prefix
;
    .byte   'N','E','G'+0x80,0x44    ; 0Fh
    .byte   'I','M',0,'0'+0x80,0x46
    .byte   'R','E','T','N'+0x80,0x45
    .byte   'M','L','T',0,'B','C'+0x80,0x4C
    .byte   'R','E','T','I'+0x80,0x4D
    .byte   'I','M',0,'1'+0x80,0x56
    .byte   'M','L','T',0,'D','E'+0x80,0x5C
    .byte   'I','M',0,'2'+0x80,0x5E
    .byte   'R','R','D'+0x80,0x67
    .byte   'M','L','T',0,'H','L'+0x80,0x6C
    .byte   'L','D',0,'M','B',0,'A'+0x80,0x6D
    .byte   'L','D',0,'A',0,'M','B'+0x80,0x6E
    .byte   'R','L','D'+0x80,0x6F
    .byte   'S','L','P'+0x80,0x76
    .byte   'M','L','T',0,'S','P'+0x80,0x7C
    .byte   'S','T','M','I','X'+0x80,0x7D
    .byte   'R','S','M','I','X'+0x80,0x7E
    .byte   'I','N','I','M'+0x80,0x82
    .byte   'O','T','I','M'+0x80,0x83
    .byte   'I','N','I','2'+0x80,0x84
    .byte   'I','N','D','M'+0x80,0x8A
    .byte   'O','T','D','M'+0x80,0x8B
    .byte   'I','N','D','2'+0x80,0x8C
    .byte   'I','N','I','M','R'+0x80,0x92
    .byte   'O','T','I','M','R'+0x80,0x93
    .byte   'I','N','I','2','R'+0x80,0x94
    .byte   'I','N','D','M','R'+0x80,0x9A
    .byte   'O','T','D','M','R'+0x80,0x9B
    .byte   'I','N','D','2','R'+0x80,0x9C
    .byte   'L','D','I'+0x80,0xA0
    .byte   'C','P','I'+0x80,0xA1
    .byte   'I','N','I'+0x80,0xA2
    .byte   'O','U','T','I','2'+0x80,0xA4    ; These are swapped round so that FIND will find
    .byte   'O','U','T','I'+0x80,0xA3        ; OUTI2 before OUTI
    .byte   'L','D','D'+0x80,0xA8
    .byte   'C','P','D'+0x80,0xA9
    .byte   'I','N','D'+0x80,0xAA
    .byte   'O','U','T','D','2'+0x80,0xAC    ; Similarly these are swapped round so that FIND
    .byte   'O','U','T','D'+0x80,0xAB        ; will find OUTD2 before OUTD
    .byte   'L','D','I','R'+0x80,0xB0
    .byte   'C','P','I','R'+0x80,0xB1
    .byte   'I','N','I','R'+0x80,0xB2
    .byte   'O','T','I','R'+0x80,0xB3
    .byte   'O','T','I','2','R'+0x80,0xB4
    .byte   'L','D','D','R'+0x80,0xB8
    .byte   'C','P','D','R'+0x80,0xB9
    .byte   'I','N','D','R'+0x80,0xBA
    .byte   'O','T','D','R'+0x80,0xBB
    .byte   'O','T','D','2','R'+0x80,0xBC
    .byte   'I','N','I','R','X'+0x80,0xC2
    .byte   'O','T','I','R','X'+0x80,0xC3
    .byte   'I','N','D','R','X'+0x80,0xCA
    .byte   'O','T','D','R','X'+0x80,0xCB
;
; Group 2: (3 opcodes)
;
    .byte   'B','I','T'+0x80,0x40    ; 44h
    .byte   'R','E','S'+0x80,0x80
    .byte   'S','E','T'+0x80,0xC0
;
; Group 3: (7 opcodes)
;
    .byte   'R','L','C'+0x80,0x00    ; 47h
    .byte   'R','R','C'+0x80,0x08
    .byte   'R','L'+0x80,0x10
    .byte   'R','R'+0x80,0x18
    .byte   'S','L','A'+0x80,0x20
    .byte   'S','R','A'+0x80,0x28
    .byte   'S','R','L'+0x80,0x38
;
; Group 4: (3 opcodes)
;
    .byte   'P','O','P'+0x80,0xC1    ; 4Eh
    .byte   'P','U','S','H'+0x80,0xC5
    .byte   'E','X',0,'(','S','P'+0x80,0xE3
;
; Group 5: (7 opcodes)
;
    .byte   'S','U','B'+0x80,0x90    ; 51h
    .byte   'A','N','D'+0x80,0xA0
    .byte   'X','O','R'+0x80,0xA8
    .byte   'O','R'+0x80,0xB0
    .byte   'C','P'+0x80,0xB8
    .byte   TAND,0xA0                ; 56h TAND: Tokenised AND
    .byte   TOR,0xB0                         ; 57h TOR: Tokenised OR
;
; Group 6 (3 opcodes)
;
    .byte   'A','D','D'+0x80,0x80    ; 58h
    .byte   'A','D','C'+0x80,0x88
    .byte   'S','B','C'+0x80,0x98
;
; Group 7: (2 opcodes)
;
    .byte   'I','N','C'+0x80,0x04    ; 5Bh
    .byte   'D','E','C'+0x80,0x05
;
; Group 8: (2 opcodes)
;
    .byte   'I','N','0'+0x80,0x00    ; 5Dh
    .byte   'O','U','T','0'+0x80,0x01
;
; Group 9: (1 opcode)
;
    .byte   'I','N'+0x80,0x40                ; 5Fh
;
; Group 10: (1 opcode)
;
    .byte   'O','U','T'+0x80,0x41    ; 60h
;
; Group 11: (2 opcodes)
;
    .byte   'J','R'+0x80,0x20                ; 61h
    .byte   'D','J','N','Z'+0x80,0x10
;
; Group 12: (1 opcode)
;
    .byte   'J','P'+0x80,0xC2                ; 63h
;
; Group 13: (1 opcode)
;
    .byte   'C','A','L','L'+0x80,0xC4        ; 64h
;
; Group 14: (1 opcode)
;
    .byte   'R','S','T'+0x80,0xC7    ; 65h
;
; Group 15: (1 opcode)
;
    .byte   'R','E','T'+0x80,0xC0    ; 66h
;
; Group 16: (1 opcode)
;
    .byte   'L','D'+0x80,0x40                ; 67h
;
; Group 17: (1 opcode)
;
    .byte   'T','S','T'+0x80,0x04    ; 68h

;
; Assembler Directives
;
    .byte   'O','P','T'+0x80,0x00    ; 69h OPT
    .byte   'A','D','L'+0x80,0x00    ; 6Ah ADL
;
    .byte   DEF_ & 0x7F,'B'+0x80,0x00        ; 6Bh Tokenised DEF + B
    .byte   DEF_ & 0x7F,'W'+0x80,0x00        ; 6Ch Tokenised DEF + W
    .byte   DEF_ & 0x7F,'L'+0x80,0x00        ; 6Dh Tokenised DEF + L
    .byte   DEF_ & 0x7F,'M'+0x80,0x00        ; 6Eh Tokenised DEF + M
;
    .byte   0
;
; Operands
;
OPRNDS:
    .byte   'B'+0x80, 0x00
    .byte   'C'+0x80, 0x01
    .byte   'D'+0x80, 0x02
    .byte   'E'+0x80, 0x03
    .byte   'H'+0x80, 0x04
    .byte   'L'+0x80, 0x05
    .byte   '(','H','L'+0x80,0x06
    .byte   'A'+0x80, 0x07
    .byte   '(','I','X'+0x80,0x86
    .byte   '(','I','Y'+0x80,0xC6
;
    .byte   'B','C'+0x80,0x08
    .byte   'D','E'+0x80,0x0A
    .byte   'H','L'+0x80,0x0C
    .byte   'I','X'+0x80,0x8C
    .byte   'I','Y'+0x80,0xCC
    .byte   'A','F'+0x80,0x0E
    .byte   'S','P'+0x80,0x0E
;
    .byte   'N','Z'+0x80,0x10
    .byte   'Z'+0x80,0x11
    .byte   'N','C'+0x80,0x12
    .byte   'P','O'+0x80,0x14
    .byte   'P','E'+0x80,0x15
    .byte   'P'+0x80,0x16
    .byte   'M'+0x80,0x17
;
    .byte   '(','C'+0x80,0x20
;
    .byte   0
;
; Load operations
;
LDOPS:
    .byte   'I',0,'A'+0x80,0x47
    .byte   'R',0,'A'+0x80,0x4F
    .byte   'A',0,'I'+0x80,0x57
    .byte   'A',0,'R'+0x80,0x5F
    .byte   '(','B','C',0,'A'+0x80,0x02
    .byte   '(','D','E',0,'A'+0x80,0x12
    .byte   'A',0,'(','B','C'+0x80,0x0A
    .byte   'A',0,'(','D','E'+0x80,0x1A
;
    .byte   0
;
; eZ80 addressing mode suffixes
;
; Fully qualified suffixes
;
EZ80SFS_1:
    .byte   'L','I','S'+0x80,0x49
    .byte   'S','I','L'+0x80,0x52
EZ80SFS_2:
    .byte   'S','I','S'+0x80,0x40
    .byte   'L','I','L'+0x80,0x5B
;
    .byte   0
;
; Shortcuts when ADL mode is 0
;
EZ80SFS_ADL0:
    .byte   'S'+0x80,0x40 ; Equivalent to .SIS
    .byte   'L'+0x80,0x49            ; Equivalent to .LIS
    .byte   'I','S'+0x80,0x40                ; Equivalent to .SIS
    .byte   'I','L'+0x80,0x52                ; Equivalent to .SIL
;
    .byte   0
;
; Shortcuts when ADL mode is 1
;
EZ80SFS_ADL1:
    .byte   'S'+0x80,0x52 ; Equivalent to .SIL
    .byte   'L'+0x80,0x5B            ; Equivalent to .LIL
    .byte   'I','S'+0x80,0x49                ; Equivalent to .LIS
    .byte   'I','L'+0x80,0x5B                ; Equivalent to .LIL
;
    .byte   0
