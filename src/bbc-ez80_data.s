  .assume ADL = 1

  .global FLAGS
  .global OSWRCHPT
  .global OSWRCHCH
  .global OSWRCHFH
  .global KEYDOWN
  .global KEYASCII
  .global KEYCOUNT
  .global R0
  .global R1
  .global RAM_START
  .global RAM_END
  .global conversion_store

  .include "macros.inc"

  .section .data
;
RAM_START:
FLAGS:    .space    1               ; Miscellaneous flags
                                    ; - BIT 7: Set if ESC pressed
                                    ; - BIT 6: Set to disable ESC
OSWRCHPT: .space    3               ; Pointer for *EDIT
OSWRCHCH: .space    1               ; Channel of OSWRCH
                                    ; - 0: Console
                                    ; - 1: File
OSWRCHFH: .space    1               ; File handle for OSWRCHCHN
KEYDOWN:  .space    1               ; Keydown flag
KEYASCII: .space    1               ; ASCII code of pressed key
KEYCOUNT: .space    1               ; Counts every time a key is pressed
R0:       .space    3               ; General purpose storage for 8/16 to 24 bit operations
R1:       .space    3               ;
;
conversion_store:	ds 		4		; Scratch pad to convert integer representations
;
  .balign 256
  .include "bbc-ez80/DATA.Z80"
RAM_END:
