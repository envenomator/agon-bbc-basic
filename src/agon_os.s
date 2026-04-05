  .include	"macros.inc"
  .include	"equs.inc"

  .global BYE

  .extern VBLANK_STOP
  .extern _end

  .assume	ADL = 1
  .text

BYE:
  call  VBLANK_STOP
  jp    _end
