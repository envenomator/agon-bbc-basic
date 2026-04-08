   10     PRINT "Running EXIT tests..."
   20     DIM S% LOCAL -1
   30     FOR I% = 1 TO 10
   40       FOR J% = 20 TO 30
   50         IF I% = 5 AND J% = 25 THEN EXIT FOR I%
   60       NEXT
   70     NEXT
   80     IF I%<>5 OR J%<>25 STOP
   90     N = 1
  100     WHILE N < 10
  110       LOCAL DATA : ON ERROR LOCAL STOP
  120       K = 1
  130       WHILE K < 5
  140         LOCAL DATA
  150         ON ERROR LOCAL STOP
  160         FOR M = 1 TO 1 : IF K = 2 THEN EXIT WHILE ELSE NEXT
  170           REM tokens: NEXTUNTILENDWHILE
  180     DATA tokens: NEXTUNTILENDWHILE
  190 A$ = "tokens: íýÎ"
  200 K += 1
  210 ENDWHILE
  220 IF K <> 2 STOP
  230 REPEAT IF N = 5 THEN EXIT WHILE ELSE UNTIL TRUE
  240   N += 1
  250   WHILE K < 10
  260     LOCAL DATA
  270     ON ERROR LOCAL STOP
  280     FOR M = 1 TO 1 : IF K = 7 THEN EXIT WHILE ELSE NEXT
  290       K += 1
  300     ENDWHILE
  310     IF K <> 7 STOP
  320   ENDWHILE
  330   IF K <> 2 OR N <> 5 STOP
  340   :
  350   FOR J% = 1 TO 2
  360     FOR I% = 1 TO 10
  370       LOCAL DATA
  380       ON ERROR LOCAL STOP
  390       FOR K% = 1 TO 5
  400         LOCAL DATA
  410         ON ERROR LOCAL STOP
  420         REPEAT IF K% = 2 THEN EXIT FOR K% ELSE UNTIL TRUE
  430           REM tokens: NEXTUNTILENDWHILE
  440     DATA tokens: NEXTUNTILENDWHILE
  450 A$ = "tokens: íýÎ"
  460 NEXT K%
  470 IF K% <> 2 STOP
  480 REPEAT IF I% = 5 THEN EXIT FOR J% ELSE UNTIL TRUE
  490   FOR K% = 1 TO 5
  500     LOCAL DATA
  510     ON ERROR LOCAL STOP
  520     REPEAT IF K% = 3 THEN EXIT FOR ELSE UNTIL TRUE
  530     NEXT K%
  540     IF K% <> 3 STOP
  550   NEXT I%
  560   STOP
  570 NEXT J%
  580 IF I% <> 5 OR K% <> 2 OR J% <> 1 THEN STOP
  590 :
  600 A = 1
  610 REPEAT
  620   LOCAL DATA
  630   ON ERROR LOCAL STOP
  640   B = 1
  650   REPEAT
  660     LOCAL DATA
  670     ON ERROR LOCAL STOP
  680     FOR C = 1 TO 1 : IF B = 3 THEN EXIT REPEAT ELSE NEXT C
  690       REM tokens: NEXTUNTILENDWHILE
  700 DATA tokens: NEXTUNTILENDWHILE
  710 A$ = "tokens: íýÎ"
  720 B += 1
  730 UNTIL B = 5
  740 IF B <> 3 STOP
  750 FOR C = 1 TO 1 : IF A = 6 THEN EXIT REPEAT ELSE NEXT
  760   A += 1
  770   REPEAT
  780     LOCAL DATA
  790     ON ERROR LOCAL STOP
  800     FOR C = 1 TO 1 : IF B = 8 THEN EXIT REPEAT ELSE NEXT
  810       B += 1
  820     UNTIL ":" = "Œ"
  830     IF B<>8 STOP
  840   UNTIL A = 10
  850   IF A<>6 OR B<>3 THEN COLOUR 9 : STOP
  860   :
  870   DIM T% LOCAL -1
  880   IF T% <> S% COLOUR 9 : STOP
  890   :
  900   PRINT "EXIT tests completed."
