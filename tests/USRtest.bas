   10 INPUT "Enter a 32bit number:",number%
   20 highbytes% = (number% AND &FFFF0000) >>> 16
   30 lowbytes% = number% AND &FFFF
   40 DIM code 100
   50 P%=code
   60 [ OPT 0
   70 LD HL,highbytes%
   80 EXX
   90 LD HL,lowbytes%
  100 EXX
  110 RET
  120 ]
  130 result% = USR(code)
  140 PRINT "USR returns: ";STR$(result%)
  150 IF result% = number% THEN
  160   PRINT "OK"
  170 ELSE
  180   PRINT "Start the debugger"
  190 ENDIF
