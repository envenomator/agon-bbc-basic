   10 REPEAT
   20   INPUT "Enter a positive 32bit number:",number%
   30 UNTIL number% >= 0
   40 highbytes% = (number% AND &FFFF0000) >> 16
   50 lowbytes% = number% AND &FFFF
   60 DIM code 100
   70 P%=code
   80 [ OPT 0
   90 LD HL,highbytes%
  100 EXX
  110 LD HL,lowbytes%
  120 EXX
  130 RET
  140 ]
  150 result% = USR(code)
  160 PRINT "USR returns: ";STR$(result%)
  170 IF result% = number% THEN
  180   PRINT "OK"
  190 ELSE
  200   PRINT "Start the debugger"
  210 ENDIF
