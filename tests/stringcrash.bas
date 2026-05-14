   10 REM CASE string crash repro
   20 sA$="B"
   30 CASE sA$ OF
   40 WHEN "A"
   50   PRINT "A"
   60 WHEN "B"
   70   PRINT "B"
   80 OTHERWISE
   90   PRINT "OTHER"
  100 ENDCASE
  110 PRINT "DONE"
