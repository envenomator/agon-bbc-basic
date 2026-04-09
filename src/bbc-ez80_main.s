    .assume     ADL = 1

    .global     CLEAN
    .global     BAD
    .global     NEWIT
    .global     LISTIT
    .global     DEL
    .global     LINNUM

    .include    "equs.inc"
    .include    "macros.inc"
    .text
    .include    "bbc-ez80/MAIN.Z80"
