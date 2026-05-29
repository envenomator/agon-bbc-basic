   10 F%=OPENOUT("test.tmp")
   20 BPUT#F%,1
   30 BPUT#F%,2
   40 CLOSE#F%
   50 F%=OPENUP("test.tmp")
   60 PROC_FILE
   70 CLOSE#F%
   80 F%=OPENUP("test.tmp")
   90 BPUT#F%,5
  100 CLOSE#F%
  110 F%=OPENUP("test.tmp")
  120 PROC_FILE
  130 CLOSE#F%
  140 END
  150 DEF PROC_FILE
  160 PRINT "Pointer position: ";PTR#F%
  170 A% = BGET#F%
  180 PRINT A%
  190 A% = BGET#F%
  200 PRINT A%
  210 PRINT "Pointer position: ";PTR#F%
  220 ENDPROC
