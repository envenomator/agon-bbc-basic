;
; Title: BBC Basic ADL for AGON - Platform BIOS Code
;

    .assume     ADL = 1

    .global     ADVAL
    .global     BYE
    .global     CIRCLE
    .global     CLG
    .global     CLS
    .global     COLOUR
    .global     CSROFF
    .global     CSRON
    .global     DRAW
    .global     ELLIPS
    .global     ENVEL
    .global     ESCSET
    .global     FILL
    .global     GCOL
    .global     GETCSR
    .global     GETEXT
    .global     GETIME
    .global     GETIMS
    .global     GETPTR
    .global     LINE
    .global     LTRAP
    .global     MODE
    .global     MODEFN
    .global     MOUSE
    .global     MOVE
    .global     ORIGIN
    .global     OSBGET
    .global     OSBPUT
    .global     OSBYTE
    .global     OSCLI
    .global     OSCALL
    .global     OSINIT
    .global     OSKEY
    .global     OSLOAD
    .global     OSLINE
    .global     OSOPEN
    .global     OSRDCH
    .global     OSSAVE
    .global     OSSTAT
    .global     OSSHUT
    .global     OSWORD
    .global     OSWRCH
    .global     PLOT
    .global     PLOT_POINT
    .global     POINT
    .global     PROMPT
    .global     PUTCSR
    .global     PUTIME
    .global     PUTIMS
    .global     PUTPTR
    .global     RECTAN
    .global     SOUND
    .global     STAR_VERSION
    .global     SYS
    .global     TINT
    .global     TRAP
    .global     WAIT
    .global     WIDFN

    .include    "macros.inc"
    .include    "mos.inc"
    .include    "equs.inc"

; For Graphics
TBY         .equ    0x0F
TTO         .equ    0xB8
TFILL       .equ    0x03
; For MOUSE
TON         .equ    0xEE
TOFF        .equ    0x87
TRECT       .equ    0x07

; For JOYSTICK
portC       .equ    0x9E
portD       .equ    0xA2

    .text

;OSINIT - Initialise RAM mapping etc.
;If BASIC is entered by BBCBASIC FILENAME then file
;FILENAME.BBC is automatically CHAINed.
;   Outputs: DE = initial value of HIMEM (top of RAM)
;            HL = initial value of PAGE (user program)
;            Z-flag reset indicates AUTO-RUN.
;  Destroys: A,D,E,H,L,F
;
OSINIT:
    CALL        SETUP_KB_HANDLER
    XOR         A
    LD          (FLAGS), A                              ; Clear flags and set F = Z
    LD          HL, bss_end                             ; PAGE will be set to this value
    LD          DE, RAM_END                             ; HIMEM will be set to this value
    LD          E, A                                    ; Page boundary
    LD          A, (ACCS)                               ; Return NZ if there is a file to chain
    OR          A
    RET

;
;CLS    - Clear screen.
;         Destroys: A,D,E,H,L,F
;
CLS:
    VDU         0x0C
    XOR         A
    LD          (COUNT),A
    JP          XEQ

; PROMPT: output the input prompt
;
PROMPT:
    LD          A,'>'                                   ; Falls through to OSWRCH

; OSWRCH: Write a character out to the ESP32 VDU handler via the MOS
; Parameters:
; - A: Character to write
;
OSWRCH:
    PUSH        HL
    LD          HL, LISTON                              ; Fetch the LISTON variable
    BIT         3, (HL)                                 ; Check whether we are in *EDIT mode
    JR          NZ, OSWRCH_BUFFER                       ; Yes, so just output to buffer
;
    LD          HL, (OSWRCHCH)                          ; L: Channel #
    DEC         L                                       ; If it is 1
    JR          Z, OSWRCH_FILE                          ; Then we are outputting to a file
;
    POP         HL                                      ; Otherwise
    RST.LIL     0x10                                    ; Output the character to MOS
    RET
;
OSWRCH_BUFFER:
    LD          HL, (OSWRCHPT)                          ; Fetch the pointer buffer
    CP          0x0A                                    ; Just ignore this
    JR          Z, OSWRCH_BUFFER2
    CP          0x0D                                    ; Is it the end of line?
    JR          NZ, OSWRCH_BUFFER1                      ; No, so carry on
    XOR         A                                       ; Turn it into a NUL character
OSWRCH_BUFFER1:
    LD          (HL), A                                 ; Echo the character into the buffer
    INC         HL                                      ; Increment pointer
    LD          (OSWRCHPT), HL                          ; Write pointer back
OSWRCH_BUFFER2:
    POP         HL
    RET
;
OSWRCH_FILE:
    PUSH        DE
    LD          E, H                                    ; Filehandle to E
    CALL        OSBPUT                                  ; Write the byte out
    POP         DE
    POP         HL
    RET

; OSRDCH
;
OSRDCH:
    CALL        NXT                                     ; Check if we are doing GET$(x,y)
    CP          '('
    JR          Z, 1f                                   ; Yes, so skip to that functionality
    MOSCALL     mos_getkey                              ; Otherwise, read keyboard
    CP          0x1B
    JR          Z, LTRAP1
    RET
;
1:
    INC         IY                                      ; Skip '('
    CALL        EXPRI                                   ; Get the first parameter
    EXX
    PUSH        HL
    CALL        COMMA                                   ; Get the second parameter
    CALL        EXPRI
    EXX
    POP         DE                                      ; DE: X coordinate
    CALL        BRAKET                                  ; Check for trailing bracket
    JP          GETSCHR                                 ; Read the character

; OSLINE: Invoke the line editor
;
OSLINE:
    LD          E, 1                                    ; Default is to clear the buffer

; Entry point to line editor that does not clear the buffer
; Parameters:
; - HL: addresses destination buffer (on page boundary)
; Returns:
; -  A: 0
; NB: Buffer filled, terminated by CR
;
OSLINE1:
    PUSH        IY
    PUSH        HL                                      ; Buffer address
    LD          BC, 256                                 ; Buffer length
    MOSCALL     mos_editline                            ; Call the MOS line editor
    POP         HL                                      ; Pop the address
    POP         IY
    PUSH        AF                                      ; Stack the return value (key pressed)
    CALL        NULLTOCR                                ; Turn the 0 character to a CR
    CALL        CRLF                                    ; Display CRLF
    POP         AF
    CP          0x1B                                    ; Check if ESC terminated the input
    JP          Z, LTRAP1                               ; Yes, so do the ESC thing
    LD          A, (FLAGS)                              ; Otherwise
    RES         7, A                                    ; Clear the escape flag
    LD          (FLAGS), A
    CALL        WAIT_VBLANK                             ; Wait a frame
    XOR         A                                       ; Return A = 0
    LD          (KEYDOWN), A
    LD          (KEYASCII), A
    RET

;
; ESCSET
; Set the escape flag (bit 7 of FLAGS = 1) if escape is enabled (bit 6 of FLAGS = 0)
;
ESCSET:
    PUSH        HL
    LD          HL,FLAGS                                ; Pointer to FLAGS
    BIT         6,(HL)                                  ; If bit 6 is set, then
    JR          NZ,ESCDIS                               ; escape is disabled, so skip
    SET         7,(HL)                                  ; Set bit 7, the escape flag
ESCDIS:
    POP         HL
    RET

;
; ESCTEST
; Test for ESC key
;
ESCTEST:
    CALL        READKEY                                 ; Read the keyboard
    RET         NZ                                      ; Skip if no key is pressed
    CP          0x1B                                    ; If ESC pressed then
    JR          Z,ESCSET                                ; jump to the escape set routine
    RET

; Read the keyboard
; Returns:
; - A: ASCII of the pressed key
; - F: Z if the key is pressed, otherwise NZ
;
READKEY:
    LD          A, (KEYDOWN)                            ; Get key down
    DEC         A                                       ; Set Z flag if keydown is 1
    LD          A, (KEYASCII)                           ; Get key ASCII value
    RET
;
; TRAP
; This is called whenever BASIC needs to check for ESC
;
TRAP:
    CALL        ESCTEST                                 ; Read keyboard, test for ESC, set FLAGS
;
LTRAP:
    LD          A,(FLAGS)                               ; Get FLAGS
    OR          A                                       ; This checks for bit 7; if it is not set then the result will
    RET         P                                       ; be positive (bit 7 is the sign bit in Z80), so return
LTRAP1:
    LD          HL,FLAGS                                ; Escape is pressed at this point, so
    RES         7,(HL)                                  ; Clear the escape pressed flag and
    JP          ESCAPE                                  ; Jump to the ESCAPE error routine in exec.asm

; OSOPEN
; HL: Pointer to path
;  F: C Z
;     x x OPENIN
;       OPENOUT
;     x      OPENUP
; Returns:
;  A: Filehandle, 0 if cannot open
;
OSOPEN:
    LD          C, fa_read
    JR          Z, 1f
    LD          C, fa_write | fa_open_append
    JR          C, 1f
    LD          C, fa_write | fa_create_always
1:
    MOSCALL     mos_fopen
    RET

;OSSHUT - Close disk file(s).
; E = file channel
;  If E=0 all files are closed (except SPOOL)
; Destroys: A,B,C,D,E,H,L,F
;
OSSHUT:
    PUSH        BC
    LD          C, E
    MOSCALL     mos_fclose
    POP         BC
    RET

; OSBGET - Read a byte from a random disk file.
;  E = file channel
; Returns
;  A = byte read
;  Carry set if LAST BYTE of file
; Destroys: A,B,C,F
;
OSBGET:
    PUSH        BC
    LD          C, E
    MOSCALL     mos_fgetc
    POP         BC
    RET

; OSBPUT - Write a byte to a random disk file.
;  E = file channel
;  A = byte to write
; Destroys: A,B,C,F
;
OSBPUT:
    PUSH        BC
    LD          C, E
    LD          B, A
    MOSCALL     mos_fputc
    POP         BC
    RET

; OSSTAT - Read file status
;  E = file channel
; Returns
;  F: Z flag set - EOF
;  A: If Z then A = 0
; Destroys: A,D,E,H,L,F
;
OSSTAT:
    PUSH        BC
    LD          C, E
    MOSCALL     mos_feof
    POP         BC
    CP          1
    RET

; GETPTR - Return file pointer.
;    E = file channel
; Returns:
; DEHL = pointer (0-&7FFFFF)
; Destroys: A,B,C,D,E,H,L,F
;
GETPTR:
    PUSH        IY
    LD          C, E
    MOSCALL     mos_getfil                              ; HLU: Pointer to FIL structure
    PUSH        HL
    POP         IY                                      ; IYU: Pointer to FIL structure
    LD          L, (IY + FIL.fptr + 0)
    LD          H, (IY + FIL.fptr + 1)
    LD          E, (IY + FIL.fptr + 2)
    LD          D, (IY + FIL.fptr + 3)
    POP         IY
    RET

; PUTPTR - Update file pointer.
;    A = file channel
; DEHL = new pointer (0-&7FFFFF)
; Destroys: A,B,C,D,E,H,L,F
;
PUTPTR:
    PUSH        IY
    LD          C, A                                    ; C: Filehandle
    PUSH        HL
    LD          HL, 2
    ADD         HL, SP
    LD          (HL), E                                 ; 3rd byte of DWORD set to E
    POP         HL
    LD          E, D                                    ; 4th byte passed as E
    MOSCALL     mos_flseek
    POP         IY
    RET

; GETEXT - Find file size.
;    E = file channel
; Returns:
; DEHL = file size (0-&800000)
; Destroys: A,B,C,D,E,H,L,F
;
GETEXT:
    PUSH        IY
    LD          C, E
    MOSCALL     mos_getfil                              ; HLU: Pointer to FIL structure
    PUSH        HL
    POP         IY                                      ; IYU: Pointer to FIL structure
    LD          L, (IY + FIL.obj.objsize + 0)
    LD          H, (IY + FIL.obj.objsize + 1)
    LD          E, (IY + FIL.obj.objsize + 2)
    LD          D, (IY + FIL.obj.objsize + 3)
    POP         IY
    RET

;OSLOAD - Load an area of memory from a file.
;   Inputs: HL addresses filename (CR terminated)
;           DE = address at which to load
;           BC = maximum allowed size (bytes)
;  Outputs: Carry reset indicates no room for file.
; Destroys: A,B,C,D,E,H,L,F
;
OSLOAD:
    PUSH        BC                                      ; Stack the size
    PUSH        DE                                      ; Stack the load address
    LD          DE, ACCS                                ; Buffer address for filename
    CALL        CSTR_FNAME                              ; Fetch filename from MOS into buffer
    LD          HL, ACCS                                ; HL: Filename
    CALL        EXT_DEFAULT                             ; Tack on the extension .BBC if not specified
    CALL        EXT_HANDLER                             ; Get the default handler
    POP         DE                                      ; Restore the load address
    POP         BC                                      ; Restore the size
    OR          A
    JP          Z, OSLOAD_BBC
;
; Load the file in as a text file
;
OSLOAD_TXT:
    XOR         A                                       ; Set file attributes to read
    CALL        OSOPEN                                  ; Open the file
    LD          E, A                                    ; The filehandle
    OR          A
    LD          A, 4                                    ; File not found error
    JP          Z, OSERROR                              ; Jump to error handler
    CALL        NEWIT                                   ; Call NEW to clear the program space
;
OSLOAD_TXT1:
    LD          HL, ACCS                                ; Where the input is going to be stored
;
; First skip any whitespace (indents) at the beginning of the input
;
1:
    CALL        OSBGET                                  ; Read the byte into A
    JR          C, OSLOAD_TXT3                          ; Is it EOF?
    CP          LF                                      ; Is it LF?
    JR          Z, OSLOAD_TXT3                          ; Yes, so skip to the next line
    CP          0x21                                    ; Is it less than or equal to ASCII space?
    JR          C, 1b                                   ; Yes, so keep looping
    LD          (HL), A                                 ; Store the first character
    INC         L
;
; Now read the rest of the line in
;
OSLOAD_TXT2:
    CALL        OSBGET                                  ; Read the byte into A
    JR          C, OSLOAD_TXT4                          ; Is it EOF?
    CP          0x20                                    ; Skip if not an ASCII character
    JR          C, 1f
    LD          (HL), A                                 ; Store in the input buffer
    INC         L                                       ; Increment the buffer pointer
    JP          Z, BAD                                  ; If the buffer is full (wrapped to 0) then jump to Bad Program error
1:
    CP          LF                                      ; Check for LF
    JR          NZ, OSLOAD_TXT2                         ; If not, then loop to read the rest of the characters in
;
; Finally, handle EOL/EOF
;
OSLOAD_TXT3:
    LD          (HL), CR                                ; Store a CR for BBC BASIC
    LD          A, L                                    ; Check for minimum line length
    CP          2                                       ; If it is 2 characters or less (including CR)
    JR          C, 1f                                   ; Then don't bother entering it
    PUSH        DE                                      ; Preserve the filehandle
    CALL        OSEDIT                                  ; Enter the line in memory
    CALL        C,CLEAN                                 ; If a new line has been entered, then call CLEAN to set TOP and write &FFFF end of program marker
    POP         DE
1:
    CALL        OSSTAT                                  ; End of file?
    JR          NZ, OSLOAD_TXT1                         ; No, so loop
    CALL        OSSHUT                                  ; Close the file
    SCF                                                 ; Flag to BASIC that we're good
    RET
;
; Special case for BASIC programs with no blank line at the end
;
OSLOAD_TXT4:
    CP          0x20                                    ; Skip if not an ASCII character
    JR          C, 1f
    LD          (HL), A                                 ; Store the character
    INC         L
    JP          Z, BAD
1:
    JR          OSLOAD_TXT3
;
; This bit enters the line into memory
; Also called from OSLOAD_TXT
; Returns:
; F: C if a new line has been entered (CLEAN will need to be called)
;
OSEDIT:
    XOR         A                                       ; Entry point after *EDIT
    LD          (COUNT),A
    LD          IY,ACCS
    CALL        LINNUM                                  ; HL: The line number from the input buffer
    CALL        NXT                                     ; Skip spaces
    LD          A,H                                     ; HL: The line number will be 0 for immediate mode or when auto line numbering is used
    OR          L
    JR          Z,LNZERO                                ; Skip if there is no line number in the input buffer
;
; This bit does the lexical analysis and tokenisation
;
LNZERO:
    LD          DE,BUFFER
    LD          C,1                                     ; LEFT MODE
    PUSH        HL
    CALL        LEXAN2                                  ; LEXICAL ANALYSIS
    POP         HL
    LD          (DE),A                                  ; TERMINATOR
    LD          BC,0
    LD          C,E                                     ; BC=LINE LENGTH
    INC         DE
    LD          (DE),A                                  ; ZERO NEXT
    LD          A,H
    OR          L
    LD          IY,BUFFER                               ; FOR XEQ
    JP          Z,XEQ                                   ; DIRECT MODE
    PUSH        BC
    CALL        FINDL
    CALL        Z,DEL
    POP         BC
    LD          A,C
    OR          A
    RET         Z
    ADD         A,4
    LD          C,A                                     ; LENGTH INCLUSIVE
    PUSH        DE                                      ; LINE NUMBER
    PUSH        BC                                      ; SAVE LINE LENGTH
    EX          DE,HL
    PUSH        BC
    CALL        GETTOP
    POP         BC
    PUSH        HL
    ADD         HL,BC
    PUSH        HL
    INC         H
    XOR         A
    SBC         HL,SP
    POP         HL
    JP          NC,ERROR                                ; "No room"
    EX          (SP),HL
    PUSH        HL
    INC         HL
    OR          A
    SBC         HL,DE
    LD          B,H                                     ; BC=AMOUNT TO MOVE
    LD          C,L
    POP         HL
    POP         DE
    JR          Z,ATEND
    LDDR                                                ; MAKE SPACE
ATEND:
    POP         BC                                      ; LINE LENGTH
    POP         DE                                      ; LINE NUMBER
    INC         HL
    LD          (HL),C                                  ; STORE LENGTH
    INC         HL
    LD          (HL),E                                  ; STORE LINE NUMBER
    INC         HL
    LD          (HL),D
    INC         HL
    LD          DE,BUFFER
    EX          DE,HL
    DEC         C
    DEC         C
    DEC         C
    LDIR                                                ; ADD LINE
    SCF
    RET
;
; Load the file in as a tokenised binary blob
;
OSLOAD_BBC:
    MOSCALL     mos_load                                ; Call LOAD in MOS
    RET         NC                                      ; If load returns with carry reset - NO ROOM
    OR          A                                       ; If there is no error (A=0)
    SCF                                                 ; Need to set carry indicating there was room
    RET         Z                                       ; Return
;
OSERROR:
    PUSH        AF                                      ; Handle the MOS error
    LD          HL, ACCS                                ; Address of the buffer
    LD          BC, 256                                 ; Length of the buffer
    LD          E, A                                    ; The error code
    MOSCALL     mos_getError                            ; Copy the error message into the buffer
    POP         AF
    PUSH        HL                                      ; Stack the address of the error (now in ACCS)
    ADD         A, 127                                  ; Add 127 to the error code (MOS errors start at 128, and are trappable)
    JP          EXTERR                                  ; Trigger an external error

;OSSAVE - Save an area of memory to a file.
;   Inputs: HL addresses filename (term CR)
;           DE = start address of data to save
;           BC = length of data to save (bytes)
; Destroys: A,B,C,D,E,H,L,F
;
OSSAVE:
    PUSH        BC                                      ; Stack the size
    PUSH        DE                                      ; Stack the save address
    LD          DE, ACCS                                ; Buffer address for filename
    CALL        CSTR_FNAME                              ; Fetch filename from MOS into buffer
    LD          HL, ACCS                                ; HL: Filename
    CALL        EXT_DEFAULT                             ; Tack on the extension .BBC if not specified
    CALL        EXT_HANDLER                             ; Get the default handler
    POP         DE                                      ; Restore the save address
    POP         BC                                      ; Restore the size
    OR          A                                       ; Is the extension .BBC
    JR          Z, OSSAVE_BBC                           ; Yes, so use that
;
; Save the file out as a text file
;
OSSAVE_TXT:
    LD          A, (OSWRCHCH)                           ; Stack the current channel
    PUSH        AF
    XOR         A
    INC         A                                       ; Make sure C is clear, A is 1, for OPENOUT
    LD          (OSWRCHCH), A
    CALL        OSOPEN                                  ; Open the file
    LD          (OSWRCHFH), A                           ; Store the file handle for OSWRCH
    LD          IX, LISTON                              ; Required for LISTIT
    LD          HL, (PAGE)                              ; Get start of program area
    EXX
    LD          DE, 0                                   ; Set the initial indent counters
    EXX
OSSAVE_TXT1:
    LD          A, (HL)                                 ; Check for end of program marker
    OR          A
    JR          Z, OSSAVE_TXT2
    INC         HL                                      ; Skip the length byte
    LD          DE, 0                                   ; ADL - make sure to start with all 0
    LD          E, (HL)                                 ; Get the line number
    INC         HL
    LD          D, (HL)
    INC         HL
    CALL        LISTIT                                  ; List the line
    JR          OSSAVE_TXT1
OSSAVE_TXT2:
    LD          A, (OSWRCHFH)                           ; Get the file handle
    LD          E, A
    CALL        OSSHUT                                  ; Close it
    POP         AF                                      ; Restore the channel
    LD          (OSWRCHCH), A
    RET
;
; Save the file out as a tokenised binary blob
;
OSSAVE_BBC:
    MOSCALL     mos_save                                ; Call SAVE in MOS
    OR          A                                       ; If there is no error (A=0)
    RET         Z                                       ; Just return
    JR          OSERROR                                 ; Trip an error

; Check if an extension is specified in the filename
; Add a default if not specified
; HL: Filename (CSTR format)
;
EXT_DEFAULT:
    PUSH        HL                                      ; Stack the filename pointer
    LD          C, '.'                                  ; Search for dot (marks start of extension)
    CALL        CSTR_FINDCH
    OR          A                                       ; Check for end of string marker
    JR          NZ, 1f                                  ; No, so skip as we have an extension at this point
    LD          DE, EXT_LOOKUP                          ; Get the first (default extension)
    CALL        CSTR_CAT                                ; Concat it to string pointed to by HL
1:
    POP         HL                                      ; Restore the filename pointer
    RET

; Check if an extension is valid and, if so, provide a pointer to a handler
; HL: Filename (CSTR format)
; Returns:
;  A: Filename extension type (0=BBC tokenised, 1=ASCII untokenised)
;
EXT_HANDLER:
    PUSH        HL                                      ; Stack the filename pointer
    LD          C, '.'                                  ; Find the '.'
    CALL        CSTR_FINDCH
    LD          DE, EXT_LOOKUP                          ; The lookup table
;
EXT_HANDLER_1:
    PUSH        HL                                      ; Stack the pointer to the extension
    CALL        CSTR_ENDSWITH                           ; Check whether the string ends with the entry in the lookup
    POP         HL                                      ; Restore the pointer to the extension
    JR          Z, EXT_HANDLER_2                        ; We have a match!
;
1:
    LD          A, (DE)                                 ; Skip to the end of the entry in the lookup
    INC         DE
    OR          A
    JR          NZ, 1b
    INC         DE                                      ; Skip the file extension # byte
;
    LD          A, (DE)                                 ; Are we at the end of the table?
    OR          A
    JR          NZ, EXT_HANDLER_1                       ; No, so loop
;
    ;LD          A,204                                   ; Throw a "Bad name" error
    ;CALL        EXTERR
    ;.asciz      "Bad name"
    LD          A,4
    JP          OSERROR
;
EXT_HANDLER_2:
    INC         DE                                      ; Skip to the file extension # byte
    LD          A, (DE)
    POP         HL                                      ; Restore the filename pointer
    RET

; Extension lookup table
; CSTR, TYPE
;     - 0: BBC (tokenised BBC BASIC for Z80 format)
;     - 1: Human readable plain text
;
EXT_LOOKUP:
    DB          '.BBC', 0, 0                            ; First entry is the default extension
    DB          '.TXT', 0, 1
    DB          '.ASC', 0, 1
    DB          '.BAS', 0, 1
    DB          0                                       ; End of table
; OSWORD
;
OSWORD:
    CP          0x01                                    ; GETIME
    JR          Z, OSWORD_01
    CP          0x02                                    ; PUTIME
    JR          Z, OSWORD_02
    CP          0x0E                                    ; GETIMS
    JR          Z, OSWORD_0E
    CP          0x0F                                    ; PUTIMS
    JR          Z, 1f
    CP          0x07                                    ; SOUND
    JP          Z, OSWORD_07
    CP          0x08                                    ; ENVELOPE
    JR          Z, 1f
    CP          0x09                                    ; POINT
    JR          Z, OSWORD_09
    JP          HUH                                     ; Anything else trips an error
1:
    RET                                                 ; Dummy return for unimplemented functions

; GETIME: return current time in centiseconds
;
OSWORD_01:
    PUSH        IX
    LD          IX, (MOS_SYSVARS)
    LD          B, 4
1:
    LD          A, (IX + sysvar_time)
    LD          (HL), A
    INC         HL
    INC         IX
    DJNZ        1b
    POP         IX
    RET

; PUTIME: set time in centiseconds
;
OSWORD_02:
    PUSH        IX
    LD          IX, (MOS_SYSVARS)
    LD          B, 4
1:
    LD          A, (HL)
    LD          (IX + sysvar_time), A
    INC         HL
    INC         IX
    DJNZ        1b
    POP         IX
    RET

; SOUND channel,volume,pitch,duration
; Parameters:
; - HL: Pointer to data
;   - 0,1: Channel
;   - 2,3: Volume 0 (off) to 15 (full volume)
;   - 4,5: Pitch 0 - 255
;   - 6,7: Duration -1 to 254 (duration in 20ths of a second, -1 = play forever)
;
OSWORD_07: EQU         AGON_SOUND

; OSWORD 0x09: POINT
; Parameters:
; - HL: Address of data
;   - 0,1: X coordinate
;   - 2,3: Y coordinate
;
OSWORD_09:
    LD          DE,(SCRAP+0)
    LD          HL,(SCRAP+2)
    CALL        AGON_POINT
    LD          (SCRAP+4),A
    RET

; GETIMS - Get time from RTC
;
OSWORD_0E:
    PUSH        IY
    MOSCALL     mos_getrtc
    POP         IY
    RET

;
; OSBYTE
; Parameters:
; - A: FX #
; - L: First parameter
; - H: Second parameter
;
OSBYTE:
    CP          0x0B                                    ; Keyboard auto-repeat delay
    JR          Z, OSBYTE_0B
    CP          0x0C                                    ; Keyboard auto-repeat rate
    JR          Z, OSBYTE_0C
    CP          0x13                                    ; Wait for vblank
    JP          Z, OSBYTE_13
    CP          0x76                                    ; Set keyboard LED
    JP          Z, OSBYTE_76
    CP          0x81                                    ; Read the keyboard
    JP          Z, OSBYTE_81
    CP          0x86                                    ; Get cursor coordinates
    JP          Z, OSBYTE_86
    CP          0xA0                                    ; Fetch system variable
    JP          Z, OSBYTE_A0
;
; Anything else trips an error
;
HUH:
    LD          A,254                                   ; Bad command error
    CALL        EXTERR
    .asciz      "Bad command"

; OSBYTE 0x0B (FX 11,n): Keyboard auto-repeat delay
; Parameters:
; - HL: Repeat delay
;
OSBYTE_0B:
    VDU         23
    VDU         0
    VDU         vdp_keystate
    VDU         L
    VDU         H
    VDU         0
    VDU         0
    VDU         255
    RET

; OSBYTE 0x0C (FX 12,n): Keyboard auto-repeat rate
; Parameters:
; - HL: Repeat rate
;
OSBYTE_0C:
    VDU         23
    VDU         0
    VDU         vdp_keystate
    VDU         0
    VDU         0
    VDU         L
    VDU         H
    VDU         255
    RET

; OSBYTE 0x13 (FX 19): Wait for vertical blank interrupt
;
OSBYTE_13:
    CALL        WAIT_VBLANK
    LD          L, 0                                    ; Returns 0
    JP          COUNT0
;
; OSBYTE 0x76 (FX 118,n): Set Keyboard LED
; Parameters:
; - L: LED (Bit 0: Scroll Lock, Bit 1: Caps Lock, Bit 2: Num Lock)
;
OSBYTE_76:
    VDU         23
    VDU         0
    VDU         vdp_keystate
    VDU         0
    VDU         0
    VDU         0
    VDU         0
    VDU         L
    RET

; OSBYTE 0x81: Read the keyboard
; Parameters:
; - HL = Time to wait (centiseconds)
; Returns:
; - F: Carry reset indicates time-out
; - H: NZ if timed out
; - L: The character typed
; Destroys: A,D,E,H,L,F
;
OSBYTE_81:
    EXX
    BIT         7, H                                    ; Check for minus numbers
    EXX
    JR          NZ, OSBYTE_81_1                         ; Yes, so do INKEY(-n)
    CALL        READKEY                                 ; Read the keyboard
    JR          Z,  1f                                  ; Skip if we have a key
    CALL        WAIT_VBLANK                             ; Wait a frame
    LD          A, H                                    ; Check loop counter
    OR          L
    DEC         HL                                      ; Decrement
    JR          NZ, OSBYTE_81                           ; And loop
    RET                                                 ; H: Will be set to 255 to flag timeout
;
1:
    LD          HL, KEYDOWN                             ; We have a key, so
    LD          (HL), 0                                 ; clear the keydown flag
    CP          0x1B                                    ; If we are pressing ESC,
    JP          Z, ESCSET                               ; Then handle ESC
    LD          H, 0                                    ; H: Not timed out
    LD          L, A                                    ; L: The character
    RET
;
;
; Check immediately whether a given key is being pressed
; Result is integer numeric
;
OSBYTE_81_1:
    MOSCALL     mos_getkbmap                            ; Get the base address of the keyboard
    INC         HL                                      ; Index from 0
    LD          A, L                                    ; Negate the LSB of the answer
    NEG
    LD          C, A                                    ;  E: The positive keycode value
    LD          A, 1                                    ; Throw an "Out of range" error
    JP          M, ERROR                                ; if the argument < - 128
;
    LD          HL, BITLOOKUP                           ; HL: The bit lookup table
    LD          DE, 0
    LD          A, C
    AND         0b00000111                              ; Just need the first three bits
    LD          E, A                                    ; DE: The bit number
    ADD         HL, DE
    LD          B, (HL)                                 ;  B: The mask
;
    LD          A, C                                    ; Fetch the keycode again
    AND         0b01111000                              ; And divide by 8
    RRCA
    RRCA
    RRCA
    LD          E, A                                    ; DE: The offset (the MSW has already been cleared previously)
    ADD         IX, DE                                  ; IX: The address
    LD          A, (IX+0)                               ;  A: The keypress
    AND         B                                       ; Check whether the bit is set
    JP          Z, ZERO                                 ; No, so return 0
    JP          TRUE                                    ; Otherwise return -1
;
; A bit lookup table
;
BITLOOKUP:
    .byte       0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80

; OSBYTE 0x86: Fetch cursor coordinates
; Returns:
; - L: X Coordinate (POS)
; - H: Y Coordinate (VPOS)
;
OSBYTE_86:
    PUSH        IX                                      ; Get the system vars in IX
    LD          IX, (MOS_SYSVARS)                       ; Reset the semaphore
    RES         0, (IX+sysvar_vdp_pflags)
    VDU         23
    VDU         0
    VDU         vdp_cursor
1:
    BIT         0, (IX+sysvar_vdp_pflags)
    JR          Z, 1b                                   ; Wait for the result
    LD          L, (IX + sysvar_cursorX)
    LD          H, (IX + sysvar_cursorY)
    POP         IX
    RET

; OSBYTE 0xA0: Fetch system variable
; Parameters:
; - L: The system variable to fetch
;
OSBYTE_A0:
    PUSH        IX
    LD          IX, (MOS_SYSVARS)                       ; Fetch pointer to system variables
    LD          BC, 0
    LD          C, L                                    ; BCU = L
    ADD         IX, BC                                  ; Add to IX
    LD          L, (IX + 0)                             ; Fetch the return value
    POP         IX
    JP          COUNT0

; ------------------------------------------------------------
; GET_NUMBER
;
; Input:
;   HL = pointer to 0-terminated C string
;
; Output on success:
;   DE = parsed value
;   Carry clear
;
; Output on failure:
;   DE = 0
;   Carry set
;
; Accepted:
;   "0"
;   "123"
;   "   123"
;   "123   "
;   "   123   "
;
; Rejected:
;   ""
;   "   "
;   "abc"
;   "12abc"
;   "&12"
;   "-1"
;   "+1"
;
; Notes:
;   - decimal only
;   - uses ASC_TO_NUMBER to do the conversion
;   - assumes ASC_TO_NUMBER leaves A = first non-space char
;     after the parsed number (via its final SKIPSP)
; ------------------------------------------------------------

GET_NUMBER:
    PUSH        HL

    CALL        SKIPSP                                  ; skip leading spaces
    LD          A,(HL)
    OR          A
    JR          Z, NAN_                                 ; empty / spaces only

    CP          '0'
    JR          C, NAN_                                 ; first char < '0'
    CP          '9'+1
    JR          NC, NAN_                                ; first char > '9'

    POP         HL                                      ; restore original pointer for converter
    CALL        ASC_TO_NUMBER

    OR          A
    JR          NZ, NAN_2                               ; trailing junk after number

    OR          A                                       ; clear carry
    RET

NAN_:
    POP         HL
NAN_2:
    LD          DE,0
    SCF
    RET

; OSCLI
;
;
;OSCLI - Process a MOS command
;
OSCLI:
    CALL        SKIPSP
    CP          CR
    RET         Z
    CP          '|'
    RET         Z
    EX          DE,HL
    LD          HL,COMDS
OSCLI0:
    LD          A,(DE)
    CALL        UPPRC
    CP          (HL)
    JR          Z,OSCLI2
    JR          C,OSCLI6
OSCLI1:
    BIT         7,(HL)
    INC         HL
    JR          Z,OSCLI1
    INC         HL
    INC         HL
    INC         HL
    JR          OSCLI0
;
OSCLI2:
    PUSH        DE
OSCLI3:
    INC         DE
    INC         HL
    LD          A,(DE)
    CALL        UPPRC
    CP          '.'                                     ; ABBREVIATED?
    JR          Z,OSCLI4
    XOR         (HL)
    JR          Z,OSCLI3
    CP          0x80
    JR          Z,OSCLI4
    POP         DE
    JR          OSCLI1
;
OSCLI4:
    POP         AF
    INC         DE
OSCLI5:
    BIT         7,(HL)
    INC         HL
    JR          Z,OSCLI5
    PUSH        DE
    POP         IX
    LD          DE,(HL)
    PUSH        DE
    PUSH        IX
    POP         HL
    JP          SKIPSP
;
OSCLI6:
    EX          DE, HL                                  ; HL: Buffer for command
    LD          DE, ACCS                                ; Buffer for command string is ACCS (the string accumulator)
    PUSH        DE                                      ; Store buffer address
    CALL        CSTR_LINE                               ; Fetch the line
    POP         HL                                      ; HL: Pointer to command string in ACCS
    PUSH        IY

    CALL        GET_NUMBER                              ; Check if only number given as *linenumber
    JR          C, OSCLI_MOSCALL                        ; If not, pass as cmd to MOS
    JP          SELECTLINE

OSCLI_MOSCALL:

    MOSCALL     mos_oscli                               ; Returns OSCLI error in A
    POP         IY
    OR          A                                       ; 0 means MOS returned OK
    RET         Z                                       ; So don't do anything
    JP          OSERROR                                 ; Otherwise it's a MOS error

SKIPSP:
    LD          A,(HL)
    CP          ' '
    RET         NZ
    INC         HL
    JR          SKIPSP

UPPRC:
    AND         0x7F
    CP          '`'
    RET         C
    AND         0x5F                                    ; CONVERT TO UPPER CASE
    RET

; Each command has bit 7 of the last character set, and is followed by the address of the handler
; These must be in alphabetical order
;
COMDS:
    DB          'AS','M'+0x80                           ; ASM
    .d24        STAR_ASM
    DB          'BY','E'+0x80                           ; BYE
    .d24        BYE
    DB          'EDI','T'+0x80                          ; EDIT
    .d24        STAR_EDIT
    DB          'F','X'+0x80                            ; FX
    .d24        STAR_FX
    DB          'VERSIO','N'+0x80                       ; VERSION
    .d24        STAR_VERSION
    DB          0xFF

SELECTLINE:
    CALL        wipeline_prepare
1:
    LD          A, 0                                    ; cursor off
    CALL        wipeline
    PUSH        DE
    EX          DE, HL                                  ; HL: Line number
    CALL        FINDL                                   ; HL: Address in RAM of tokenised line
    LD          A, 41                                   ; F:NZ If the line is not found
    JP          NZ, ERROR                               ; Do error 41: No such line in that case

    CALL        PRINTLINE
    MOSCALL     mos_getkey
    POP         DE                                      ; DE: line number
    CP          A, 0x0d
    JR          Z, exit_select
    CP          A, 0x08                                 ; left arrow
    JR          Z, exit_select
    CP          A, 0x7f                                 ; delete key
    JR          Z, exit_select
    CP          A, 'j'                                  ; down key
    JR          Z, checknext
    CP          A, 'J'                                  ; down key
    JR          Z, checknext
    CP          A, 0x0a                                 ; down arrow
    JR          Z, checknext
    CP          A, 'k'                                  ; up key
    JR          Z, checkprevious
    CP          A, 'K'                                  ; up key
    JR          Z, checkprevious
    CP          A, 0x0b                                 ; up arrow
    JR          Z, checkprevious
    CP          A, 0x1b                                 ; escape
    JR          Z, cancel_select
    JR          1b

checkprevious:
    PUSH        DE
    CALL        PREVLINE
    JR          NC, select_newline
    JR          ignore_newline

checknext:
    PUSH        DE
    CALL        NEXT_LINE_AFTER
    JR          NC, select_newline
    JR          ignore_newline

select_newline:
    POP         AF                                      ; discard previous linenumber
    JR          1b
ignore_newline:
    POP         DE                                      ; restore previous linenumber
    LD          A, 7
    RST.LIL     0x10                                    ; beep
    JR          SELECTLINE

exit_select:
    LD          A, 1                                    ; cursor on
    CALL        wipeline
    JP          STAR_EDIT2
cancel_select:
    LD          A, 1                                    ; cursor on
    CALL        wipeline
    JP          CLOOP

; Prepares BUFFER with the requires VDU codes to wipe the entire line, according to the current # of text columns
; After this call, only a RST.LIL 18h is required with HL set to BUFFER, BC/A to 0
;
wipeline_prepare:
    PUSH        DE
    PUSH        BC
    PUSH        HL
    PUSH        IX
    LD          IX, (MOS_SYSVARS)
    LD          A, (IX + sysvar_scrCols)
    DEC         A
    LD          C, A
    LD          HL, BUFFER

    LD          A, 13                                   ; CR / Column 0
    LD          (HL),A
    INC         HL

    LD          A, ' '
1:                                                      ; fill BUFFER with scrCols-1 spaces
    LD          (HL),A
    INC         HL
    DEC         C
    JR          NZ, 1b

    LD          A, 13                                   ; CR / Column 0
    LD          (HL), A
    INC         HL
    LD          A, 0                                    ; terminate string
    LD          (HL), A
    POP         IX
    POP         HL
    POP         BC
    POP         DE
    RET

; Wipes the entire current row line
; Input: A - 0 set cursor OFF
;            1 set cursor ON
;
wipeline:
    PUSH        DE
    PUSH        BC
    PUSH        HL
    CP          A,0
    JR          NZ, cur_on
cur_off:
    LD          HL, CUR_OFF
    LD          BC,0
    LD          A,0xff
    RST.LIL     0x18
    JR          1f
cur_on:
    LD          HL, CUR_ON
    LD          BC,0
    LD          A,0xff
    RST.LIL     0x18
1:
    LD          HL, BUFFER
    LD          BC, 0
    LD          A, 0                                    ; terminator
    RST.LIL     0x18
    POP         HL
    POP         BC
    POP         DE
    RET
CUR_ON:
    .byte       23,1,1,0xff
CUR_OFF:
    .byte       23,1,0,0xff

PRINTLINE:
; PRINT LINE FROM LINEPOINTER IN HL, terminate with special prompt indicating selection
    INC         HL                                      ; Skip the length byte
    LD          E, (HL)                                 ; Fetch the line number
    INC         HL
    LD          D, (HL)
    INC         HL
    LD          IX, ACCS                                ; Pointer to where the copy is to be stored
    LD          (OSWRCHPT), IX
    LD          IX, LISTON                              ; Pointer to LISTON variable in RAM
    LD          A, (IX)                                 ; Store that variable
    PUSH        AF
    LD          (IX), 0x09                              ; Set to echo to buffer
    CALL        LISTIT
    POP         AF
    LD          (IX), A                                 ; Restore the original LISTON variable

    LD          HL, ACCS                                ; HL: ACCS
    PUSH        BC
    PUSH        DE
; Check max column width for printing
    LD          DE,0
1:  LD          A,(HL)
    INC         HL
    INC         DE
    OR          A
    JR          NZ,1b
    DEC         DE                                      ; DE = LINE length

    PUSH        IX
    LD          IX, (MOS_SYSVARS)
    LD          A, (IX + sysvar_scrCols)
    POP         IX
    LD          HL,0
    LD          L,A                                     ; HL = number of columns on screen
    LD          BC,4                                    ; account for spaces and linenumbers on screen
    XOR         A
    SBC         HL, BC                                  ; HL = Maximum usable columns on screen, accounting for line#s and prompt
    PUSH        HL

    PUSH        HL
    PUSH        DE
    POP         HL                                      ; HL is now LINE length
    POP         BC                                      ; BC is now max usable columns on screen
    XOR         A
    SBC         HL, BC
    JR          C, fitting
    JR          Z, fitting
    PUSH        HL
    POP         BC
    POP         BC                                      ; BC is now max usable columns on screen
    JR          1f

fitting:
    POP         HL                                      ; clean up stack
    LD          BC, 0                                   ; no limit to numbers printed, determined by A in MOS call
1:
; Print the current line
    LD          HL, ACCS
;LD          BC,0
    LD          A,0
    RST.LIL     0x18


    LD          HL, printline_prompt
    LD          BC,0
    LD          A,0
    RST.LIL     0x18
    POP         BC
    POP         DE
    RET
printline_prompt:
    .asciz      " <<"

; ------------------------------------------------------------
; PREVLINE
;
; Input:
;   DE = valid existing line number
;
; Output on success:
;   HL = address of previous line record
;   DE = previous line number
;   Carry clear
;
; Output if there is no previous line:
;   Carry set
;
; Destroys:
;   A,B,C,H,L,F
; ------------------------------------------------------------

PREVLINE:
    PUSH        IX

    LD          HL,(PAGE)                               ; HL = current line record
    LD          IX,0                                    ; IX = previous line record (0 = none yet)

.prev_loop:
    LD          A,(HL)                                  ; length byte
    OR          A
    JR          Z,.no_prev                              ; hit end unexpectedly

    PUSH        HL
    INC         HL
    LD          C,(HL)                                  ; current line number low
    INC         HL
    LD          B,(HL)                                  ; current line number high
    POP         HL

    LD          A,C
    CP          E
    JR          NZ,.not_this
    LD          A,B
    CP          D
    JR          NZ,.not_this

; found target line
    LD          A,IXL
    OR          IXH
    JR          Z,.no_prev                              ; target is first line

    PUSH        IX
    POP         HL                                      ; HL = previous line record

    INC         HL
    LD          E,(HL)                                  ; previous line number low
    INC         HL
    LD          D,(HL)                                  ; previous line number high
    DEC         HL
    DEC         HL                                      ; restore HL = previous line record start

    POP         IX
    OR          A                                       ; clear carry
    RET

.not_this:
    PUSH        HL
    POP         IX                                      ; save this as previous line

    LD          C,(HL)                                  ; BC = record length
    LD          B,0
    ADD         HL,BC                                   ; advance to next line
    JR          .prev_loop

.no_prev:
    POP         IX
    SCF
    RET
; ------------------------------------------------------------
; NEXT_LINE_AFTER
;
; Input:
;   DE = line number
;
; Output on success:
;   DE = next existing line number strictly greater than input
;   HL = address of that line record
;   Carry clear
;
; Output if there is no next line:
;   Carry set
; ------------------------------------------------------------

NEXT_LINE_AFTER:
    PUSH        AF

    EX          DE,HL                                   ; HL = requested line
    INC         HL                                      ; search for first line > original
    CALL        FINDL                                   ; HL = first line >= (original+1)

    LD          A,(HL)                                  ; line length
    OR          A
    JR          Z,.none                                 ; length 0 => end of program

    INC         HL
    LD          E,(HL)                                  ; next line number low
    INC         HL
    LD          D,(HL)                                  ; next line number high
    DEC         HL
    DEC         HL                                      ; restore HL = line record start

    POP         AF
    OR          A                                       ; clear carry
    RET

.none:
    POP         AF
    SCF
    RET

; *ASM string
;
STAR_ASM:
    PUSH        IY                                      ; Stack the BASIC pointer
    PUSH        HL                                      ; HL = IY
    POP         IY
    CALL        ASSEM                                   ; Invoke the assembler
    POP         IY
    RET
;
; *BYE/QUIT
;
BYE:
    CALL        CLEAR_KB_HANDLER
    JP          AGON_END

; *EDIT linenum
;
STAR_EDIT:
    CALL        ASC_TO_NUMBER                           ; DE: Line number to edit
STAR_EDIT2:
    EX          DE, HL                                  ; HL: Line number
    CALL        FINDL                                   ; HL: Address in RAM of tokenised line
    LD          A, 41                                   ; F:NZ If the line is not found
    JP          NZ, ERROR                               ; Do error 41: No such line in that case
;
; Use LISTIT to output the line to the ACCS buffer
;
    INC         HL                                      ; Skip the length byte
    LD          E, (HL)                                 ; Fetch the line number
    INC         HL
    LD          D, (HL)
    INC         HL
    LD          IX, ACCS                                ; Pointer to where the copy is to be stored
    LD          (OSWRCHPT), IX
    LD          IX, LISTON                              ; Pointer to LISTON variable in RAM
    LD          A, (IX)                                 ; Store that variable
    PUSH        AF
    LD          (IX), 0x09                              ; Set to echo to buffer
    CALL        LISTIT
    POP         AF
    LD          (IX), A                                 ; Restore the original LISTON variable
    LD          HL, ACCS                                ; HL: ACCS
STAR_EDIT3:
    LD          E, L                                    ;  E: 0 - Don't clear the buffer; ACCS is on a page boundary so L is 0
    CALL        OSLINE1                                 ; Invoke the editor
    CALL        OSEDIT
    CALL        C,CLEAN                                 ; Set TOP, write out &FFFF end of program marker
    JP          CLOOP                                   ; Jump back to immediate mode

; *VERSION
;
STAR_VERSION:
    CALL        TELL                                    ; Output the welcome message
    .asciz      "AGON eZ80/ADL release v0.6\n\r"
    RET

; OSCLI FX n [,value]
; *FX n [,value]
;
STAR_FX:
    CALL        ASC_TO_NUMBER
    LD          C, E                                    ; C: Save FX #
    CP          0x0d                                    ; ending terminator from ASC_TO_NUMBER
    JR          NZ, 1f
    LD          HL,0                                    ; no parameter
    JR          star_end
1:  CALL        readcomma
    CALL        SKIPSP                                  ; Skip spaces
    CALL        checknumber
    CALL        ASC_TO_NUMBER                           ; parameter
    CP          0x0d
    JP          NZ, SYNTAX
    PUSH        DE
    POP         HL
star_end:
    LD          A, C                                    ; A: FX #
    JP          OSBYTE                                  ; HL: single parameter

; destroys A
; increments HL to position after the comma
; Jumps to Syntax error if no comma found
readcomma:
    LD          A,(HL)
    CP          0x0d
    JP          Z, SYNTAX
    CP          ','                                     ; read next parameter if comma found
    INC         HL
    RET         Z
    JR          readcomma

; INPUT: character in A
; Jumps immediately to Syntax error if anything but '&' or '0' - '9'
checknumber:
    CP          '&'
    RET         Z
    CP          '0'
    JP          C, SYNTAX
    CP          '9' + 1
    JP          NC, SYNTAX
    RET

; Helper Functions
;
WAIT_VBLANK:
    PUSH        IX                                      ; Wait for VBLANK interrupt
    LD          IX, (MOS_SYSVARS)                       ; Fetch pointer to system variables
    LD          A, (IX + sysvar_time + 0)
1:
    CP          A, (IX + sysvar_time + 0)
    JR          Z, 1b
    POP         IX
    RET

;
;GETIME    - Read elapsed-time clock.
;        Outputs:  DEHL = elapsed time (centiseconds)
;       Destroys: A,B,D,E,H,L,F
;
GETIME:
    LD          A,1
    LD          HL,SCRAP
    CALL        OSWORD
    LD          HL,SCRAP
    LD          E,(HL)
    INC         HL
    LD          D,(HL)
    INC         HL
    LD          A,(HL)
    INC         HL
    LD          H,(HL)
    LD          L,A
    EX          DE,HL
    RET
;
;GETIMS    - Read real-time clock as string.
;        Outputs:  TIME$ in string accumulator
;                   E = string length (25)
;       Destroys: A,B,C,D,E,H,L,F
;
GETIMS:
    LD          A,14
    LD          HL,SCRAP
    LD          (HL),0
    CALL        OSWORD
    LD          HL,SCRAP
    LD          DE,ACCS
    LD          A,(HL)
    CP          E
    RET         Z
    LD          BC,25
    LDIR
    RET
;
;
;PUTIME    - Load elapsed-time clock.
;         Inputs:   DEHL = time to load (centiseconds)
;       Destroys: A,D,E,H,L,F
;
PUTIME:
    PUSH        IX
    LD          IX,SCRAP
    LD          (IX+0),L
    LD          (IX+1),H
    LD          (IX+2),E
    LD          (IX+3),D
    LD          A,2
    LD          HL,SCRAP
    CALL        OSWORD
    POP         IX
    RET
;
;PUTIMS    - Wtite real-time clock as string.
;        Inputs:   string in string accumulator
;                   E = string length
;       Destroys: A,B,C,D,E,H,L,F
;
PUTIMS:
    LD          A,E                                     ;Length
    CP          26
    RET         NC
    LD          B,0
    LD          C,A
    LD          DE,SCRAP+1
    LD          HL,ACCS
    LDIR
    LD          HL,SCRAP
    LD          (HL),A
    LD          A,15
    JP          OSWORD
;
;
;OSKEY    - Sample keyboard with specified wait.
;         Inputs:   HL = Time to wait (centiseconds)
;        Outputs:  Carry reset indicates time-out.
;                   If carry set, A = character typed.
;       Destroys: A,D,E,H,L,F
;
OSKEY:
    LD          A,129
    CALL        OSBYTE
    LD          A,H
    OR          A
    RET         NZ                                      ;TIME-OUT, CARRY RESET
    LD          A,L
    SCF
    RET                                                 ;NORMAL, CARRY SET
;
;PUTCSR    - Move cursor to specified position.
;         Inputs:   DE = horizontal position (LHS=0)
;                   HL = vertical position (TOP=0)
;       Destroys: A,D,E,H,L,F
;
PUTCSR:
    VDU         0x1F
    VDU         E
    VDU         L
    RET
;
;GETCSR    - Return cursor coordinates.
;         Outputs:  DE = X coordinate (POS)
;                   HL = Y coordinate (VPOS)
;        Destroys: A,D,E,H,L,F
;
GETCSR:
    LD          A,134
    CALL        OSBYTE
    LD          E,L
    LD          L,H
    LD          D,0
    LD          H,D
    RET
;
;POINT - var=POINT(x,y)
;
POINT:
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         DE
    CALL        BRAKET
    LD          IX,SCRAP
    LD          (IX+0),E
    LD          (IX+1),D
    LD          (IX+2),L
    LD          (IX+3),H
    LD          HL,SCRAP
    LD          A,9
    CALL        OSWORD
    LD          A,(IX+4)
    LD          L,A
    ADD         A,1
    SBC         A,A
    LD          H,A
RETEXX:
    EXX
    LD          H,A
    LD          L,A
    XOR         A
    LD          C,A
    RET

PLOT_POINT:
	CALL	EXPRI
	EXX
	PUSH	HL
	CALL	CEXPRI

	EXX
	POP	DE

	LD	C, 69		; PLOT POINT
	CALL	VDU25
	JP	XEQ

;
;ADVAL - var=ADVAL(n)
;
ADVAL:
    CALL        EXPRI
    EXX
    PUSH        HL
    EXX
    LD          HL,0
    IN0         A,(portC)
    CPL                                                 ; flip bits
    LD          L,A
    IN0         A,(portD)
    CPL                                                 ; flip bits
    LD          H,A                                     ; HL = 8bit portD + 8bit portC
    POP         BC                                      ; C = n
    LD          A,C
    CP          5
    JR          Z, ADVAL_RET
    JR          C, 1f                                   ; n < 5
;ignore all other 'channels' - return 0
    LD          HL,0
ADVAL_RET:
    EXX
    LD          HL,0
    XOR         A
    LD          C,A
    RET

; n < 5
1:  CP          0
    JR          NZ, joystick_adc
joystick_firebuttons:
    LD          DE,0x100                                ; virtual channel '1' finished ADC 'conversion' always
    BIT         4,H                                     ; joy2 B1
    JR          Z,1f
    SET         1,E
1:  BIT         5,H                                     ; joy1 B1
    JR          Z,1f
    SET         0,E
1:  BIT         6,H                                     ; joy2 B2
    JR          Z,1f
    SET         3,E
1:  BIT         7,H                                     ; joy1 B2
    JR          Z,1f
    SET         2,E
1:  EX          DE, HL
    JR          ADVAL_RET

joystick_adc:
    LD          B,A                                     ; counter ch 1..4
    PUSH        HL
    LD          HL,joystick_adc_table
1:  LD          E,(HL)
    INC         HL
    LD          D,(HL)
    INC         HL
    DJNZ        1b

    POP         HL                                      ; HL = port bits
    LD          C,E
    LD          B,D                                     ; BC = table bits
    EX          DE, HL                                  ; DE = port bits
    LD          HL,0
    LD          A,E
    AND         A,C
    JR          NZ,ADVAL_RET                            ; down or left -> 0 ADC
    LD          A,E
    AND         A,B
    JR          NZ,1f
    LD          H,0x80                                  ; center -> 0x8000 ADC
    JR          ADVAL_RET
1:  LD          HL,0xFFF0                               ; up or right -> 65520 ADC
    JR          ADVAL_RET

joystick_adc_table:
    .byte       0b00100000                              ; joy1 left    - ch1
    .byte       0b10000000                              ; joy1 right
    .byte       0b00001000                              ; joy1 down    - ch2
    .byte       0b00000010                              ; joy1 up
    .byte       0b00010000                              ; joy2 left    - ch3
    .byte       0b01000000                              ; joy2 right
    .byte       0b00000100                              ; joy2 down    - ch4
    .byte       0b00000001                              ; joy2 up

;
;MODEFN - var=MODE
;
MODEFN:
    LD          HL,0
    PUSH        IX
    LD          IX, (MOS_SYSVARS)
    LD          L, (IX+sysvar_scrMode)                  ; L: Screen mode
    POP         IX
    JP          COUNT1                                  ; Just return the lower HL using shared function
;
;WIDFN - var=WIDTH
;
WIDFN:
    LD          HL,0
    LD          A,(WIDTH)
    LD          L,A
    XOR         A
    LD          H,A
    JP          COUNT1                                  ; Just return the lower HL using shared function
;
;ENVEL - ENVELOPE var,var,var,var,var,var,var,
;                 var,var,var,var,var,var,var
;
ENVEL:
    LD          B,0
    LD          IX,SCRAP
    PUSH        BC
    PUSH        IX
ENVEL1:
    CALL        EXPRI
    EXX
    POP         IX
    POP         BC
    LD          (IX),L
    LD          A,B
    CP          13
    JR          Z,ENVEL2
    INC         B
    INC         IX
    PUSH        BC
    PUSH        IX
    CALL        COMMA
    JR          ENVEL1
ENVEL2:
    LD          HL,SCRAP
    LD          A,8
    CALL        OSWORD
    JP          XEQ
;
;SOUND - SOUND var,var,var,var
;
SOUND:
    LD          B,0
    LD          IX,SCRAP
    PUSH        BC
    PUSH        IX
SOUND1:
    CALL        EXPRI
    EXX
    POP         IX
    POP         BC
    LD          (IX+0),L
    LD          (IX+1),H
    INC         IX
    INC         IX
    INC         B
    INC         B
    LD          A,B
    CP          8
    JR          Z,SOUND2
    PUSH        BC
    PUSH        IX
    CALL        COMMA
    JR          SOUND1
SOUND2:
    LD          HL,SCRAP
    LD          A,7
    CALL        OSWORD
    JP          XEQ

;
; MODE n: Set video mode
;
MODE:
    PUSH        IX
    LD          IX,   (MOS_SYSVARS)
    RES         4,    (IX+sysvar_vdp_pflags)
    CALL        EXPRI
    EXX
    VDU         0x16                                    ; Mode change
    VDU         L
    LD          IX,   (MOS_SYSVARS)
1:  BIT         4, (IX+sysvar_vdp_pflags)
    JR          Z, 1b                                   ; Wait for the result
    POP         IX
    JP          XEQ

;
;CLG
;
CLG:
    VDU         16
    JP          XEQGO1
;
;ORIGIN x,y
;
ORIGIN:
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         DE
    LD          C,29
    CALL        WRCH5
    JP          XEQGO1


; COLOUR colour
; COLOUR L,P
; COLOUR L,R,G,B
;
COLOUR:
    CALL        EXPRI                                   ; The colour / mode
    EXX
    LD          A, L
    LD          (VDU_BUFFER+0), A                       ; Store first parameter
    CALL        NXT                                     ; Are there any more parameters?
    CP          ','
    JR          Z, 1f                                   ; Yes, so we're doing a palette change next
    VDU         0x11                                    ; Just set the colour
    VDU         (VDU_BUFFER+0)
    JP          XEQ
1:
    CALL        COMMA
    CALL        EXPRI                                   ; Parse R (OR P)
    EXX
    LD          A, L
    LD          (VDU_BUFFER+1), A
    CALL        NXT                                     ; Are there any more parameters?
    CP          ','
    JR          Z, 1f                                   ; Yes, so we're doing COLOUR L,R,G,B
    VDU         0x13                                    ; VDU:COLOUR
    VDU         (VDU_BUFFER+0)                          ; Logical Colour
    VDU         (VDU_BUFFER+1)                          ; Palette Colour
    VDU         0                                       ; RGB set to 0
    VDU         0
    VDU         0
    JP          XEQ
1:
    CALL        COMMA
    CALL        EXPRI                                   ; Parse G
    EXX
    LD          A, L
    LD          (VDU_BUFFER+2), A
    CALL        COMMA
    CALL        EXPRI                                   ; Parse B
    EXX
    LD          A, L
    LD          (VDU_BUFFER+3), A
    VDU         0x13                                    ; VDU:COLOUR
    VDU         (VDU_BUFFER+0)                          ; Logical Colour
    VDU         0xFF                                    ; Physical Colour (-1 for RGB mode)
    VDU         (VDU_BUFFER+1)                          ; R
    VDU         (VDU_BUFFER+2)                          ; G
    VDU         (VDU_BUFFER+3)                          ; B
    JP          XEQ

;
;GCOL [a,]b
;
GCOL:
    CALL        EXPRI
    EXX
    LD          E,0
    LD          A,(IY)
    CP          ','
    JR          NZ,GCOL0
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         DE
GCOL0:
    LD          H,L
    LD          L,E
    LD          D,18
    CALL        WRCH3                                   ;DLH
XEQGO1:
    JP          XEQ
;
;CSRON  - Turn caret on
;CSROFF - Turn caret off
;

CSRON:
    VDU   23
    VDU   1
    VDU   1
    JR    XEQGO1

CSROFF:
    VDU   23
    VDU   1
    VDU   0
    JR    XEQGO1

;LINE x1,y1,x2,y2
;
LINE:
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        EXPR3
    EX          (SP),HL                                 ;HL <- x1, (SP) <- y2
    PUSH        BC
    EX          DE,HL
    LD          C,4
    CALL        VDU25
    POP         DE
    POP         HL
    LD          C,5
    JR          PLOT4A
;
;CIRCLE [FILL] x,y,r
;
CIRCLE:
    CP          TFILL
    PUSH        AF
    JR          NZ,CIRCL0
    INC         IY
CIRCL0:
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         BC                                      ;y
    POP         DE                                      ;x
    PUSH        HL
    LD          L,C
    LD          H,B
    LD          C,4                                     ; PLOT 4 = MOVE
    CALL        VDU25
    POP         DE                                      ;r
    LD          HL,0
    POP         AF
    LD          C,145                                   ; PLOT 145 = outline circle
    JR          NZ,PLOT4A
    LD          C,153                                   ; PLOT 153 = filled circle
PLOT4A:
    JR          PLOT4
;
;ELLIPSE [FILL] x,y,a,b
;
ELLIPS:
    CP          TFILL
    PUSH        AF
    JR          NZ,ELLIP0
    INC         IY
ELLIP0:
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        EXPR3
    EX          (SP),HL                                 ;HL <- x, (SP) <- b
    PUSH        BC
    EX          DE,HL
    LD          C,4                                     ; PLOT 4 = Move absolute
    CALL        VDU25
    POP         DE                                      ;a
    PUSH        DE
    LD          HL,0
    LD          C,L                                     ; PLOT 0 - Move relative
    CALL        VDU25
    POP         DE                                      ;a
    XOR         A
    LD          L,A
    LD          H,A
    SBC         HL,DE
    EX          DE,HL
    POP         HL                                      ;b
    POP         AF
    LD          C,193                                   ; PLOT 193 = outline ellipse
    JR          NZ,PLOT4
    LD          C,201                                   ; PLOT 201 = filled ellipse
    JR          PLOT4
;
;MOVE [BY} x,y
;DRAW [BY] x,y
;PLOT [BY] [n,]x,y
;FILL [BY] x,y
;
MOVE:
    LD          C,4
    JR          PLOT1
;
DRAW:
    LD          C,5
    JR          PLOT1
;
FILL:
    LD          C,133
    JR          PLOT1
;
PLOT:
    LD          C,69
    CP          TBY
    JR          Z,PLOT1
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    LD          A,(IY)
    CP          ','
    JR          Z,PLOT3
    POP         DE
    LD          C,69
    JR          PLOT4
;
PLOT1:
    CP          TBY
    JR          NZ,PLOT2
    INC         IY
    RES         2,C                                     ;Change absolute to relative
PLOT2:
    PUSH        BC
    CALL        EXPRI
    EXX
PLOT3:
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         DE
    POP         BC
PLOT4:
    CALL        VDU25
    JP          XEQ
;
;RECTANGLE [FILL] x,y,w[,h] [TO xnew,ynew]
;
RECTAN:
    CP          TFILL
    PUSH        AF
    JR          NZ,RECT0
    INC         IY
RECT0:
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    PUSH        HL
    LD          A,(IY)
    CP          ','
    JR          NZ,RECT1
    CALL        CEXPRI
    EXX
RECT1:
    POP         BC                                      ;w
    POP         DE                                      ;y
    EX          (SP),HL                                 ;HL <- x, (SP) <- h
    PUSH        BC
    EX          DE,HL
    LD          C,4
    CALL        VDU25
    LD          A,(IY)
    CP          TTO
    JR          Z,RECTTO
    POP         DE                                      ;w
    POP         HL                                      ;h
    POP         AF
    JR          NZ,OUTLIN
    LD          C,97
    JR          PLOT4
;
;Block copy / move:
;
RECTTO:
    INC         IY                                      ; Bump over TO
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         BC                                      ;newx
    POP         DE                                      ;w
    EX          (SP),HL                                 ;HL <- h, (SP) <- newy
    PUSH        BC
    LD          C,0
    CALL        VDU25
    POP         DE                                      ;newx
    POP         HL                                      ;newy
    POP         AF
    LD          C,190                                   ; PLOT 190 - Block copy
    JR          NZ,PLOT4B
    DEC         C                                       ; PLOT 189 - Block move
PLOT4B:
    JR          PLOT4
;
;Outline rectangle:
;
OUTLIN:
    LD          C,9                                     ; PLOT 9 - draw relative
    PUSH        HL
    LD          HL,0
    CALL        VDU25                                   ; side 1
    POP         HL
    PUSH        DE
    LD          DE,0
    CALL        VDU25                                   ; side 2
    POP         DE
    PUSH        HL
    XOR         A
    LD          L,A
    LD          H,A
    SBC         HL,DE
    EX          DE,HL
    LD          L,A
    LD          H,A
    CALL        VDU25                                   ; side 3
    POP         DE
    XOR         A
    LD          L,A
    LD          H,A
    SBC         HL,DE
    LD          E,A
    LD          D,A
    JR          PLOT4B
;
;MOUSE x, y, b
;MOUSE ON [n]
;MOUSE OFF
;MOUSE TO x, y
;MOUSE RECTANGLE l,b,w,h
;MOUSE RECTANGLE OFF
;
MOUSE:
    CALL        NXT
    CP          TON
    JR          Z, mouse_on
    CP          TOFF
    JP          Z, mouse_off
    CP          TTO
    JP          Z, mouse_to
    CP          TRECT
    JP          Z, mouse_rect
; MOUSE x,y,b
    PUSH        IX
    LD          IX, (MOS_SYSVARS)
    LD          HL,0
    LD          A, (IX+sysvar_mouseButtons)
    LD          L,A
    LD          A, (IX+sysvar_mouseButtons+1)
    LD          H,A
    PUSH        HL
    LD          HL,0
    LD          A, (IX+sysvar_mouseY)
    LD          L,A
    LD          A, (IX+sysvar_mouseY+1)
    LD          H,A
    PUSH        HL
    LD          HL,0
    LD          A, (IX+sysvar_mouseX)
    LD          L,A
    LD          A, (IX+sysvar_mouseX+1)
    LD          H,A
    PUSH        HL
    CALL        VAR
    POP         HL
    CALL        STOREI
    CALL        COMMA
    CALL        NXT
    CALL        VAR
    POP         HL
    CALL        STOREI
    CALL        COMMA
    CALL        NXT
    CALL        VAR
    POP         HL
    CALL        STOREI
    POP         IX
    JP          XEQ

mouse_on:
    INC         IY
    LD          HL,0                                    ; Standard mouse pointer
    CALL        TERMQ
    JR          Z, 1f
    CALL        EXPRI
    EXX                                                 ; HL = [n] mouse pointer

1:
    PUSH        BC
    PUSH        HL
    LD          BC,0
    LD          A, 0xFF
    LD          HL, mouse_on_msg
    RST.LIL     0x18
    LD          BC,0
    LD          A, 0xFF
    LD          HL, mouse_shape_msg
    RST.LIL     0x18
    POP         HL                                      ; mouse pointer
    VDU         L
    VDU         H
    POP         BC
    JP          XEQ
mouse_on_msg:
    .byte       23,0,0x89,0,0xFF
mouse_shape_msg:
    .byte       23,0,0x89,3,0xFF
mouse_off:
    INC         IY
    PUSH        BC
    LD          BC,0
    LD          A, 0xFF
    LD          HL, mouse_off_msg
    RST.LIL     0x18
    POP         BC
    JP          XEQ
mouse_off_msg:
    .byte       23,0,0x89,1,0xFF
mouse_to:
    INC         IY
    PUSH        BC
    PUSH        DE
    CALL        EXPRI
    EXX
    PUSH        HL                                      ; X
    CALL        COMMA
    CALL        EXPRI
    EXX                                                 ; HL = Y
    POP         DE                                      ; DE = X

; Send VDU command
    LD          BC,0
    LD          A,0xFF
    PUSH        HL
    PUSH        DE
    LD          HL, mouse_to_msg
    RST.LIL     0x18
    POP         DE
    POP         HL

; Send (X,Y) coordinate
    VDU         E
    VDU         D
    VDU         L
    VDU         H
    POP         DE
    POP         BC
    JP          XEQ
mouse_to_msg:
    .byte       23,0,0x89,4,0xFF
mouse_rect:
    INC         IY
    CALL        NXT
    CP          TOFF
    JR          Z,mouse_rect_off

    PUSH        BC
    PUSH        DE

    CALL        EXPRI
    EXX
    PUSH        HL                                      ; X1
    CALL        COMMA
    CALL        EXPRI
    EXX
    PUSH        HL                                      ; Y1
    CALL        COMMA
    CALL        EXPRI
    EXX
    PUSH        HL                                      ; X2
    CALL        COMMA
    CALL        EXPRI
    EXX
    PUSH        HL                                      ; Y2

    PUSH        BC
    LD          HL, mouse_rect_msg
    LD          BC, 0
    LD          A, 0xFF
    RST.LIL     0x18
    POP         BC

; Change order of parameters
    POP         HL                                      ; Y2
    POP         BC                                      ; X2
    POP         DE                                      ; Y1
    POP         AF                                      ; X1
    PUSH        HL                                      ; Y2
    PUSH        BC                                      ; X2
    PUSH        DE                                      ; Y1
    PUSH        AF                                      ; X1

; Push 4 parameters to VDU
    LD          B, 4
1:  POP         HL
    VDU         L
    VDU         H
    DEC         B
    JR          NZ, 1b

    POP         DE
    POP         BC
    JP          XEQ
mouse_rect_msg:
    .byte       23,0,0x89,5,0xFF                        ; 23,0,89h,5
mouse_rect_off:                                         ; set bounding box to (0,0 - Max X, Max Y)
    PUSH        IX
    PUSH        DE
    PUSH        BC
    LD          IX, (MOS_SYSVARS)
    LD          A, (IX+sysvar_scrWidth)
    LD          C, A
    LD          A, (IX+sysvar_scrWidth+1)
    LD          B, A
    DEC         BC                                      ; BC = max X
    LD          A, (IX+sysvar_scrHeight)
    LD          E, A
    LD          A, (IX+sysvar_scrHeight+1)
    LD          D, A
    DEC         DE                                      ; DE = max Y

    PUSH        BC
    PUSH        DE
    LD          HL, mouse_rect_off_msg
    LD          BC, 0
    LD          A, 0xFF
    RST.LIL     0x18
    POP         DE
    POP         BC

    VDU         C
    VDU         B                                       ; max X
    VDU         E
    VDU         D                                       ; max Y


    POP         BC
    POP         DE
    POP         IX
    JP          XEQ
mouse_rect_off_msg:
    .byte       23,0,0x89,5,0,0,0,0,0xFF                ; 23,0,89h,5,X1,Y1
;
;WAIT [n]
;
WAIT:
    CALL        TERMQ
    JP          NZ, 1f
    CALL        WAIT_VBLANK
    JP          XEQ
1:
    CALL        EXPRI
    PUSH        HL
    EXX
    LD          B,H
    LD          C,L
    PUSH        BC                                      ; GETIME clobbers B
    CALL        GETIME
    POP         BC
    ADD.S       HL,BC                                   ; n low 16bit
    POP         BC                                      ; n high 16bit
    EX          DE,HL
    ADC.S       HL,BC
    EX          DE,HL
WAIT1:
    CALL        TRAP
    PUSH        DE
    PUSH        HL
    CALL        GETIME
    POP         BC
    OR          A
    SBC.S       HL,BC
    LD          H,B
    LD          L,C
    EX          DE,HL
    POP         BC
    SBC.S       HL,BC
    JP          NC,XEQ
    EX          DE,HL
    LD          D,B
    LD          E,C
    JP          WAIT1

;OSCALL - Intercept page &FF calls and provide an alternative address
;
;&FFF7: OSCLI Execute *command.
;&FFF4: OSBYTE Various byte-wide functions.
;&FFF1: OSWORD Various control block functions.
;&FFEE: OSWRCH Write character to output stream.
;&FFE7: OSNEWL Write NewLine to output stream.
;&FFE3: OSASCI Write character or NewLine to output stream.
;&FFE0: OSRDCH Wait for character from input stream.
;&FFDD: OSFILE Perform actions on whole files or directories.
;&FFDA: OSARGS Read and write information on open files or filing systems.
;&FFD7: OSBGET Read a byte from an a channel.
;&FFD4: OSBPUT Write a byte to a channel.
;&FFD1: OSGBPB Read and write blocks of data.
;&FFCE: OSFIND Open or close a file.
;
OSCALL:
    LD          HL, OSCALL_TABLE
1:
    LD          A, (HL)
    INC         HL
    CP          0xFF
    RET         Z
    CP          A, IYL
    JR          Z, 2f
    RET         NC
    INC         HL
    INC         HL
    INC         HL
    JR          1b
2:
    LD          IY,(HL)
    RET
OSCALL_TABLE:
    .byte       0xD4
    .d24        OSBPUT
    .byte       0xD7
    .d24        OSBGET
    .byte       0xEE
    .d24        OSWRCH
    .byte       0xF4
    .d24        OSBYTE
    .byte       0xF7
    .d24        OSCLI
    .byte       0xFF
;

VDU25:
    LD          B,25
WRCH6:
    VDU         B
WRCH5:
    VDU         C
WRCH4:
    VDU         E
WRCH3:
    VDU         D
WRCH2:
    VDU         L
    VDU         H
    RET
;
EXPR3:
    CALL        CEXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         BC                                      ;x2
    POP         DE                                      ;y1
    RET
;
CEXPRI:
    CALL        COMMA
    JP          EXPRI
;
STOREI:
    BIT         7,A
    JR          NZ,EEK
    BIT         6,A
    JR          NZ,EEK
    EXX
    LD          HL,0
    LD          C,L
    JP          STOREN
;
EEK:
    LD          A,50
    CALL        EXTERR
    .byte       0x13                                    ;'Bad '
    .byte       0x04                                    ;'MOUSE'
    .byte       0x20
    .byte       0x15                                    ;'variable'
    .byte       0
;
SYS:
    XOR         A
    CALL        EXTERR
    .asciz      "Sorry"
;

; Read a number and convert to binary
; If prefixed with &, will read as hex, otherwise decimal
;   Inputs: HL: Pointer in string buffer
;  Outputs: HL: Updated text pointer
;           DE: Value
;            A: Terminator (spaces skipped)
; Destroys: A,D,E,H,L,F
;
ASC_TO_NUMBER:
    PUSH        BC                                      ; Preserve BC
    LD          DE, 0                                   ; Initialise DE
    CALL        SKIPSP                                  ; Skip whitespace
    LD          A, (HL)                                 ; Read first character
    CP          '&'                                     ; Is it prefixed with '&' (HEX number)?
    JR          NZ, ASC_TO_NUMBER3                      ; Jump to decimal parser if not
    INC         HL                                      ; Otherwise fall through to ASC_TO_HEX
;
ASC_TO_NUMBER1:
    LD          A, (HL)                                 ; Fetch the character
    CALL        UPPRC                                   ; Convert to uppercase
    SUB         '0'                                     ; Normalise to 0
    JR          C, ASC_TO_NUMBER4                       ; Return if < ASCII '0'
    CP          10                                      ; Check if >= 10
    JR          C,ASC_TO_NUMBER2                        ; No, so skip next bit
    SUB         7                                       ; Adjust ASCII A-F to nibble
    CP          16                                      ; Check for > F
    JR          NC, ASC_TO_NUMBER4                      ; Return if out of range
ASC_TO_NUMBER2:
    EX          DE, HL                                  ; Shift DE left 4 times
    ADD         HL, HL
    ADD         HL, HL
    ADD         HL, HL
    ADD         HL, HL
    EX          DE, HL
    OR          E                                       ; OR the new digit in to the least significant nibble
    LD          E, A
    INC         HL                                      ; Onto the next character
    JR          ASC_TO_NUMBER1                          ; And loop
;
ASC_TO_NUMBER3:
    LD          A, (HL)
    SUB         '0'                                     ; Normalise to 0
    JR          C, ASC_TO_NUMBER4                       ; Return if < ASCII '0'
    CP          10                                      ; Check if >= 10
    JR          NC, ASC_TO_NUMBER4                      ; Return if >= 10
    EX          DE, HL                                  ; Stick DE in HL
    LD          B, H                                    ; And copy HL into BC
    LD          C, L
    ADD         HL, HL                                  ; x 2
    ADD         HL, HL                                  ; x 4
    ADD         HL, BC                                  ; x 5
    ADD         HL, HL                                  ; x 10
    EX          DE, HL
    ADD8U_DE                                            ; Add A to DE (macro)
    INC         HL
    JR          ASC_TO_NUMBER3
ASC_TO_NUMBER4:
    POP         BC
    JP          SKIPSP

; Skip a string
; HL: Pointer in string buffer
;
SKIPNOTSP:
    LD          A, (HL)
    CP          ' '
    RET         Z
    INC         HL
    JR          SKIPNOTSP

; Switch on A - lookup table immediately after call
;  A: Index into lookup table
;
SWITCH_A:
    EX          (SP), HL                                ; HL = return address = table base
    LD          E, A
    LD          D, 0
    ADD         HL, DE                                  ; +A
    ADD         HL, DE                                  ; +A again = *2
    ADD         HL, DE                                  ; +A again = *3

    LD          DE, (HL)                                ; load 24-bit handler/table target
    EX          DE, HL
    EX          (SP), HL
    RET

; Convert the buffer to a null terminated string and back
; HL: Buffer address
;
NULLTOCR:
    PUSH        BC
    LD          B, 0
    LD          C, CR
    JR          CRTONULL0

CRTONULL:
    PUSH        BC
    LD          B, CR
    LD          C, 0
;
CRTONULL0:
    PUSH        HL
CRTONULL1:
    LD          A, (HL)
    CP          B
    JR          Z, CRTONULL2
    INC         HL
    JR          CRTONULL1
CRTONULL2:
    LD          (HL), C
    POP         HL
    POP         BC
    RET

; Copy a filename to DE and zero terminate it
; HL: Source
; DE: Destination (ACCS)
;
CSTR_FNAME:
    LD          A, (HL)                                 ; Get source
    CP          CR                                      ; Or is it CR
    JR          Z, 1f
    LD          (DE), A                                 ; No, so store
    INC         HL                                      ; Increment
    INC         DE
    JR          CSTR_FNAME                              ; And loop
1:
    XOR         A                                       ; Zero terminate the target string
    LD          (DE), A
    INC         DE                                      ; And point to next free address
    RET

; Copy a CR terminated line to DE and zero terminate it
; HL: Source
; DE: Destination (ACCS)
;
CSTR_LINE:
    LD          A, (HL)                                 ; Get source
    CP          CR                                      ; Is it CR
    JR          Z, 1f
    LD          (DE), A                                 ; No, so store
    INC         HL                                      ; Increment
    INC         DE
    JR          CSTR_LINE                               ; And loop
1:
    XOR         A                                       ; Zero terminate the target string
    LD          (DE), A
    INC         DE                                      ; And point to next free address
    RET

; Find the first occurrence of a character (case sensitive)
; HL: Source
;  C: Character to find
; Returns:
; HL: Pointer to character, or end of string marker
;
CSTR_FINDCH:
    LD          A, (HL)                                 ; Get source
    CP          C                                       ; Is it our character?
    RET         Z                                       ; Yes, so exit
    OR          A                                       ; Is it the end of string?
    RET         Z                                       ; Yes, so exit
    INC         HL
    JR          CSTR_FINDCH

; Check whether a string ends with another string (case insensitive)
; HL: Source
; DE: The substring we want to test with
; Returns:
;  F: Z if HL ends with DE, otherwise NZ
;
CSTR_ENDSWITH:
    LD          A, (HL)                                 ; Get the source string byte
    CALL        UPPRC                                   ; Convert to upper case
    LD          C, A
    LD          A, (DE)                                 ; Get the substring byte
    CP          C
    RET         NZ                                      ; Return NZ if at any point the strings don't match
    OR          C                                       ; Check whether both bytes are zero
    RET         Z                                       ; If so, return, as we have reached the end of both strings
    INC         HL
    INC         DE
    JR          CSTR_ENDSWITH                           ; And loop

; Concatenate a string onto the end of another string
; HL: Source
; DE: Second string
;
CSTR_CAT:
    LD          A, (HL)                                 ; Loop until we find the end of the first string
    OR          A
    JR          Z, CSTR_CAT_1
    INC         HL
    JR          CSTR_CAT
;
CSTR_CAT_1:
    LD          A, (DE)                                 ; Copy the second string onto the end of the first string
    LD          (HL), A
    OR          A                                       ; Check for end of string
    RET         Z                                       ; And return
    INC         HL
    INC         DE
    JR          CSTR_CAT_1                              ; Loop until finished

SETUP_KB_HANDLER:
    LD          HL, ON_KB_EVENT
    LD          C, 0
    MOSCALL     mos_setkbvector
    RET

CLEAR_KB_HANDLER:
    LD          HL, 0
    LD          C, 0
    MOSCALL     mos_setkbvector
    RET

ON_KB_EVENT:
    PUSH        HL
    PUSH        IX

    PUSH        DE
    POP         IX                                      ; Pointer to VDP keyboard packet in IX

    LD          A, (IX+3)                               ; Is key down?
    OR          A
    JR          Z, CLEAR_KB                             ; No:key up - clear values

    LD          (KEYDOWN), A
    LD          A, (IX+0)
    LD          (KEYASCII), A
    CP          0x1B                                    ; Is it escape?
    CALL        Z, ESCSET                               ; Yes, so set the escape flags
    
ON_KB_EXIT:
    POP         IX
    POP         HL
    RET

CLEAR_KB:
    XOR         A
    LD          (KEYASCII), A
    LD          (KEYDOWN), A
    JR          ON_KB_EXIT

;
; Fetch a character from the screen
; - DE: X coordinate
; - HL: Y coordinate
; Returns
; - A: The character or FFh if no match
; - F: C if match, otherwise NC
;
GETSCHR:
    PUSH        IX                                      ; Get the system vars in IX
    LD          IX, (MOS_SYSVARS)
    RES         1, (IX+sysvar_vdp_pflags)
    VDU         23
    VDU         0
    VDU         vdp_scrchar
    VDU         E
    VDU         D
    VDU         L
    VDU         H
1:
    BIT         1, (IX+sysvar_vdp_pflags)
    JR          Z, 1b                                   ; Wait for the result
    LD          A, (IX+sysvar_scrchar)                  ; Fetch the result in A
    OR          A                                       ; Check for 00h
    SCF                                                 ; C = character map
    JR          NZ, 1f                                  ; We have a character, so skip next bit
    XOR         A                                       ; Clear carry
1:
    POP         IX
    RET

;
; TINT - var=TINT(x,y)
;
; Return 32bit integer as HLH'L'
;
TINT:
    CALL        EXPRI
    EXX
    PUSH        HL
    CALL        CEXPRI
    EXX
    POP         DE
    CALL        BRAKET
; Get pixel information
    PUSH        IX                                      ; Get the system vars in IX
    LD          IX, (MOS_SYSVARS)
    RES         2, (IX+sysvar_vdp_pflags)
    VDU         23
    VDU         0
    VDU         vdp_scrpixel
    VDU         E
    VDU         D
    VDU         L
    VDU         H
1:  BIT         2, (IX+sysvar_vdp_pflags)
    JR          Z, 1b                                   ; Wait for the result
    LD          HL, SCRAP
; return low bytes
    LD          A,  (IX+sysvar_scrpixel+0)              ; R
    LD          L, A
    LD          A,  (IX+sysvar_scrpixel+1)              ; G
    LD          H, A
    EXX
; return high bytes
    LD          A,  (IX+sysvar_scrpixel+2)              ; B
    LD          L, A
    XOR         A                                       ; upper byte is always 0
    LD          C, A                                    ; Indicate this is an integer result
    POP         IX
    RET

; AGON_POINT(x,y): Get the pixel colour of a point on screen
; Parameters:
; - DE: X-coordinate
; - HL: Y-coordinate
; Returns:
; -  A: Pixel colour
;
AGON_POINT:
    PUSH        IX                                      ; Get the system vars in IX
    LD          IX, (MOS_SYSVARS)
    RES         2, (IX+sysvar_vdp_pflags)
    VDU         23
    VDU         0
    VDU         vdp_scrpixel
    VDU         E
    VDU         D
    VDU         L
    VDU         H
1:  BIT         2, (IX+sysvar_vdp_pflags)
    JR          Z, 1b                                   ; Wait for the result
    LD          A, (IX+(sysvar_scrpixelIndex))
    POP         IX
    RET

; AGON_SOUND channel,volume,pitch,duration
; Parameters:
; - HL: Pointer to data
;   - 0,1: Channel
;   - 2,3: Volume 0 (off) to 15 (full volume)
;   - 4,5: Pitch 0 - 255
;   - 6,7: Duration -1 to 254 (duration in 20ths of a second, -1 = play forever)
;
AGON_SOUND:
    LD          A, (HL)                                 ; Channel
    LD          (VDU_BUFFER+0), A
    XOR         A                                       ; Waveform
    LD          (VDU_BUFFER+1), A
    INC         HL
    INC         HL
;
; Calculate the volume
;
    LD          BC, 0
    LD          C, (HL)                                 ; Volume
    LD          B, 6                                    ; C already contains the volume
    MLT         BC                                      ; Multiply by 6 (0-15 scales to 0-90)
    LD          A, C
    LD          (VDU_BUFFER+2), A
    INC         HL
    INC         HL
;
; And the frequency
;
    PUSH        HL
    LD          A, (HL)
    LD          HL, 0
    LD          L, A
    LD          DE, SOUND_FREQ_LOOKUP
    ADD         HL, HL
    ADD         HL, DE
    LD          A, (HL)
    LD          (VDU_BUFFER+3), A
    INC         HL
    LD          A, (HL)
    LD          (VDU_BUFFER+4), A
    POP         HL
    INC         HL
    INC         HL
;
; And now the duration - multiply it by 50 to convert from 1/20ths of seconds to milliseconds
;
    LD          BC,0
    LD          C, (HL)
    LD          B, 50                                   ; C contains the duration, so MLT by 50
    MLT         BC
    LD          (VDU_BUFFER+5), BC
;
    PUSH        IX
    LD          IX, (MOS_SYSVARS)
SOUND0:
    RES         3, (IX+sysvar_vdp_pflags)
;
    VDU         23                                      ; Send the sound command
    VDU         0
    VDU         vdp_audio
    VDU         (VDU_BUFFER+0)                          ; 0: Channel
    VDU         (VDU_BUFFER+1)                          ; 1: Waveform (0)
    VDU         (VDU_BUFFER+2)                          ; 2: Volume (0-100)
    VDU         (VDU_BUFFER+3)                          ; 3: Frequency L
    VDU         (VDU_BUFFER+4)                          ; 4: Frequency H
    VDU         (VDU_BUFFER+5)                          ; 5: Duration L
    VDU         (VDU_BUFFER+6)                          ; 6: Duration H
;
; Wait for acknowledgement
;
1:
    BIT         3, (IX+sysvar_vdp_pflags)
    JR          Z, 1b                                   ; Wait for the result
    CALL        LTRAP                                   ; Check for ESC
    LD          A, (IX+sysvar_audioSuccess)
    AND         A                                       ; Check if VDP has queued the note
    JR          Z, SOUND0                               ; No, so loop back and send again
;
    POP         IX
    RET

; Frequency Lookup Table
; Set up to replicate the BBC Micro audio frequencies
;
; Split over 5 complete octaves, with 53 being middle C
; * C4: 262hz
; + A4: 440hz
;
; 2 3 4 5 6 7 8
;
; B 1 49 97 145 193 241
; A# 0 45 93 141 189 237
; A  41 89+ 137 185 233
; G#  37 85 133 181 229
; G  33 81 129 177 225
; F#  29 77 125 173 221
; F  25 73 121 169 217
; E  21 69 117 165 213
; D#  17 65 113 161 209
; D  13 61 109 157 205 253
; C#  9 57 105 153 201 249
; C  5 53* 101 149 197 245
;
SOUND_FREQ_LOOKUP:
    .short      117,  118,  120,  122,  123,  131,  133,  135
    .short      137,  139,  141,  143,  145,  147,  149,  151
    .short      153,  156,  158,  160,  162,  165,  167,  170
    .short      172,  175,  177,  180,  182,  185,  188,  190
    .short      193,  196,  199,  202,  205,  208,  211,  214
    .short      217,  220,  223,  226,  230,  233,  236,  240
    .short      243,  247,  251,  254,  258,  262,  265,  269
    .short      273,  277,  281,  285,  289,  294,  298,  302
    .short      307,  311,  316,  320,  325,  330,  334,  339
    .short      344,  349,  354,  359,  365,  370,  375,  381
    .short      386,  392,  398,  403,  409,  415,  421,  427
    .short      434,  440,  446,  453,  459,  466,  473,  480
    .short      487,  494,  501,  508,  516,  523,  531,  539
    .short      546,  554,  562,  571,  579,  587,  596,  605
    .short      613,  622,  631,  641,  650,  659,  669,  679
    .short      689,  699,  709,  719,  729,  740,  751,  762
    .short      773,  784,  795,  807,  819,  831,  843,  855
    .short      867,  880,  893,  906,  919,  932,  946,  960
    .short      974,  988, 1002, 1017, 1032, 1047, 1062, 1078
    .short      1093, 1109, 1125, 1142, 1158, 1175, 1192, 1210
    .short      1227, 1245, 1263, 1282, 1300, 1319, 1338, 1358
    .short      1378, 1398, 1418, 1439, 1459, 1481, 1502, 1524
    .short      1546, 1569, 1592, 1615, 1638, 1662, 1686, 1711
    .short      1736, 1761, 1786, 1812, 1839, 1866, 1893, 1920
    .short      1948, 1976, 2005, 2034, 2064, 2093, 2123, 2154
    .short      2186, 2217, 2250, 2282, 2316, 2349, 2383, 2418
    .short      2453, 2489, 2525, 2562, 2599, 2637, 2675, 2714
    .short      2754, 2794, 2834, 2876, 2918, 2960, 3003, 3047
    .short      3091, 3136, 3182, 3228, 3275, 3322, 3371, 3420
    .short      3470, 3520, 3571, 3623, 3676, 3729, 3784, 3839
    .short      3894, 3951, 4009, 4067, 4126, 4186, 4247, 4309
    .short      4371, 4435, 4499, 4565, 4631, 4699, 4767, 4836

