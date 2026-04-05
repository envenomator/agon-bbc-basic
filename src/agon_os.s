  .include	"macros.inc"
  .include	"equs.inc"

  .global BYE
  .global WAIT

  .extern VBLANK_STOP
  .extern TERMQ
  .extern XEQ
  .extern EXPRI
  .extern GETIME
  .extern TRAP
  .extern _end

  .assume	ADL = 1
  .text
;
; QUIT
;
BYE:
  call  VBLANK_STOP
  jp    _end

;
;WAIT [n]
;
WAIT:
    call    TERMQ
    jp      z, XEQ
    call    EXPRI
    exx
    ld      b, h
    ld      c, l
    call    GETIME
    add     hl, bc
    ld      bc, 0
    ex      de, hl
    adc     hl, bc
    ex      de, hl

WAIT1:
    call    TRAP
    push    de
    push    hl
    call    GETIME
    pop     bc
    or      a
    sbc     hl, bc
    ld      h, b
    ld      l, c
    ex      de, hl
    pop     bc
    sbc     hl, bc
    jp      nc, XEQ
    ex      de, hl
    ld      d, b
    ld      e, c
    jr      WAIT1
