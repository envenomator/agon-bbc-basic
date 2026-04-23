10 REM Test program for powers n^x and n^(-x)
20 MODE 7
30 PRINT "Testing powers n^x and n^(-x)"
40 PRINT "--------------------------------"
50
55 errors = 0
60
70 FOR n = 1 TO 5
80   FOR x = 0 TO 4
90     pos = n ^ x
100    neg = n ^ (-x)
110
120    expected = 1 / pos
130
140    PRINT "n=";n;" x=";x;"  n^x=";pos;"  n^(-x)=";neg;
150
160    IF ABS(neg - expected) < 1E-9 THEN
170      PRINT "  OK"
180    ELSE
190      PRINT "  ERROR (expected ";expected;")"
200      errors = errors + 1
210    ENDIF
220
230  NEXT x
240 NEXT n
250
260 PRINT "--------------------------------"
270 IF errors = 0 THEN
280   PRINT "All tests passed. No errors found."
290 ELSE
300   PRINT errors;" error(s) found!"
310 ENDIF
320 PRINT "Done."

