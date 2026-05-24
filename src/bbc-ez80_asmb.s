;
; Title: BBC Basic ADL for AGON - ADL Assembler
;
; LISTON/OPT BIT 7 determines default ADL mode
;

    .assume     ADL = 1

    .include    "equs.inc"
    .include    "macros.inc"
    .text

    .include    "bbc-ez80/ASMB.Z80"
