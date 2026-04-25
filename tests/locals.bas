10 REM Local array / DIM / stack regression test
20 ON ERROR PRINT "FAIL at line ";ERL;" : ";REPORT$ : END
30 PRINT "BBC BASIC local array regression test"
40 PROC_basic
50 PROC_manylocals
60 PROC_repeat(200)
70 PROC_nested(20)
80 PROC_afterlocals
90 PRINT "PASS"
100 END

200 DEF PROC_basic
210 LOCAL a(), a%()
220 DIM a(9)
230 DIM a%(9)
240 a(0)=1.25 : a(9)=9.75
250 a%(0)=123 : a%(9)=456
260 IF a(0)<>1.25 OR a(9)<>9.75 THEN ERROR 100,"float array corrupt"
270 IF a%(0)<>123 OR a%(9)<>456 THEN ERROR 101,"int array corrupt"
280 ENDPROC

300 DEF PROC_manylocals
310 LOCAL a(), b(), c%(), d%()
320 DIM a(3)
330 DIM b(4)
340 DIM c%(5)
350 DIM d%(6)
360 a(3)=33 : b(4)=44 : c%(5)=55 : d%(6)=66
370 IF a(3)<>33 OR b(4)<>44 OR c%(5)<>55 OR d%(6)<>66 THEN ERROR 102,"many locals corrupt"
380 ENDPROC

400 DEF PROC_repeat(N%)
410 LOCAL i%
420 FOR i%=1 TO N%
430   PROC_basic
440 NEXT
450 ENDPROC

500 DEF PROC_nested(N%)
510 LOCAL outer(), outer%()
520 DIM outer(N%)
530 DIM outer%(N%)
540 outer(N%)=N%+0.5
550 outer%(N%)=N%
560 PROC_inner(N%)
570 IF outer(N%)<>N%+0.5 THEN ERROR 103,"outer float corrupt"
580 IF outer%(N%)<>N% THEN ERROR 104,"outer int corrupt"
590 ENDPROC

600 DEF PROC_inner(N%)
610 LOCAL inner(), inner%()
620 DIM inner(N%)
630 DIM inner%(N%)
640 inner(N%)=N%+1.5
650 inner%(N%)=N%+1
660 IF inner(N%)<>N%+1.5 THEN ERROR 105,"inner float corrupt"
670 IF inner%(N%)<>N%+1 THEN ERROR 106,"inner int corrupt"
680 ENDPROC

700 DEF PROC_afterlocals
710 REM Make sure FREE/heap still works after local arrays
720 DIM global(20)
730 DIM global%(20)
740 global(20)=123.5
750 global%(20)=321
760 IF global(20)<>123.5 THEN ERROR 107,"global float corrupt"
770 IF global%(20)<>321 THEN ERROR 108,"global int corrupt"
780 ENDPROC
